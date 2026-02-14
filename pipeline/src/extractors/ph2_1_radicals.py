"""Phase 2.1: Radical Extraction — Passes 0–2.

Reads kanjivg.parquet, kanjidic.parquet, jlpt_kanji.parquet to produce
radicals.csv and radical_variants.csv.

Passes 0-2 only: scope set, keep set, radical registration.
Passes 3-4 (component linking + metadata) are Phase 2.3.

Fields left empty for later phases:
- svg_file_name, svg_file_url, svg_hash (Phase 2.4)
- impact_score, min_grade, min_jlpt_level (Phase 2.3/Pass 4)
"""

import json
import logging
from pathlib import Path

import pandas as pd

from src.extractors.shared import (
    flatten_empty_elements,
    load_manual_list,
    map_position,
    merge_split_parts,
    parse_component_tree,
    resolve_effective_children,
    resolve_master_symbol,
    write_csv_atomic,
)

log = logging.getLogger(__name__)

DATA_DIR = Path(__file__).resolve().parent.parent.parent / "data"
MANUAL_KEEP = DATA_DIR / "manual_keep.txt"
MANUAL_FLATTEN = DATA_DIR / "manual_flatten.txt"


def build_scope_set(kanjidic_df: pd.DataFrame, jlpt_kanji_df: pd.DataFrame) -> set[str]:
    """Pass 0: Build scope set of educationally relevant kanji.

    Jōyō grades 1-6 (elementary) + 8 (secondary). Excludes grade 9 (Jinmeiyō)
    and 10 (variants). Union with all JLPT kanji.
    """
    graded = kanjidic_df[kanjidic_df["grade"].notna() & (kanjidic_df["grade"] <= 8)]
    scope = set(graded["literal"]) | set(jlpt_kanji_df["character"])
    log.info("Pass 0: scope set = %d characters", len(scope))
    return scope


def _build_tree_map(kanjivg_df: pd.DataFrame) -> dict[str, dict]:
    """Build lookup map from ALL KanjiVG entries: character → parsed component_tree."""
    tree_map: dict[str, dict] = {}
    for _, row in kanjivg_df.iterrows():
        tree = parse_component_tree(row["component_tree"])
        char = row["character"]
        tree_map[char] = tree
    return tree_map


def _scan_official_recursive(node: dict, official_set: set[str]) -> None:
    """Recursively scan a component tree node for radical='general' markers."""
    if node.get("radical") == "general":
        element = node.get("element")
        if element:
            master = resolve_master_symbol(
                element, node.get("variant", False), node.get("original")
            )
            official_set.add(master)
    for child in node.get("children", []):
        _scan_official_recursive(child, official_set)


def build_official_set(tree_map: dict[str, dict]) -> set[str]:
    """Pass 1a: Build official Kangxi radical set.

    Scans ALL KanjiVG entries (not just in-scope) for radical='general' markers.
    """
    official: set[str] = set()
    for tree in tree_map.values():
        _scan_official_recursive(tree, official)
    log.info("Pass 1a: official set = %d radicals", len(official))
    return official


def _count_direct_children(node: dict) -> list[dict]:
    """Get direct children after structural flattening + part merging."""
    raw_children = node.get("children", [])
    return merge_split_parts(flatten_empty_elements(raw_children))


def count_frequencies(
    kanjivg_df: pd.DataFrame,
    scope_set: set[str],
    tree_map: dict[str, dict],
) -> dict[str, int]:
    """Pass 1b: Count raw frequencies of each element across in-scope kanji.

    Counts BEFORE ghost flattening, after empty-element flattening and part merging.
    """
    freq: dict[str, int] = {}
    for char in scope_set:
        tree = tree_map.get(char)
        if not tree:
            continue
        direct = _count_direct_children(tree)
        for child in direct:
            element = child.get("element")
            if not element:
                continue
            master = resolve_master_symbol(
                element, child.get("variant", False), child.get("original")
            )
            freq[master] = freq.get(master, 0) + 1
    log.info("Pass 1b: counted frequencies for %d unique elements", len(freq))
    return freq


def build_keep_set(
    scope_set: set[str],
    official_set: set[str],
    freq: dict[str, int],
    manual_keep_path: Path = MANUAL_KEEP,
    manual_flatten_path: Path = MANUAL_FLATTEN,
    freq_threshold: int = 5,
) -> tuple[set[str], list[dict]]:
    """Pass 1c: Build keep set.

    keepSet = scopeSet ∪ officialSet ∪ {elem | freq[elem] >= threshold} ∪ manualKeep − manualFlatten

    Returns (keep_set, warnings).
    """
    warnings: list[dict] = []

    manual_keep = load_manual_list(manual_keep_path)
    manual_flatten = load_manual_list(manual_flatten_path)

    # Check for conflicts
    conflicts = manual_keep & manual_flatten
    for char in sorted(conflicts):
        warnings.append({
            "severity": "medium",
            "phase": "2.1",
            "entity": char,
            "message": (
                "Character in both manual_keep and manual_flatten — flatten wins"
            ),
        })

    high_freq = {elem for elem, count in freq.items() if count >= freq_threshold}

    keep = scope_set | official_set | high_freq | manual_keep
    keep -= manual_flatten

    log.info(
        "Pass 1c: keep set = %d (scope=%d, official=%d, high_freq=%d, "
        "manual_keep=%d, manual_flatten=%d)",
        len(keep),
        len(scope_set),
        len(official_set),
        len(high_freq),
        len(manual_keep),
        len(manual_flatten),
    )
    return keep, warnings


def scan_and_register(
    kanjivg_df: pd.DataFrame,
    scope_set: set[str],
    keep_set: set[str],
    tree_map: dict[str, dict],
    freq: dict[str, int],
    freq_threshold: int = 5,
) -> tuple[pd.DataFrame, pd.DataFrame, list[dict]]:
    """Pass 1d + Pass 2: Scan with ghost flattening, then register radicals.

    Returns (radicals_df, radical_variants_df, warnings).
    """
    warnings: list[dict] = []

    # Collect radical candidates: master_symbol → info
    radicals_info: dict[str, dict] = {}
    # Collect variant info: (master_symbol, shape) → set of positions
    variants_info: dict[tuple[str, str], set[str]] = {}

    for char in scope_set:
        tree = tree_map.get(char)
        if not tree:
            continue

        effective = resolve_effective_children(
            tree, keep_set, tree_map, depth=0, warnings=warnings
        )

        for child in effective:
            element = child.get("element")
            if not element:
                continue

            variant = child.get("variant", False)
            original = child.get("original")
            master = resolve_master_symbol(element, variant, original)
            is_official = child.get("radical") == "general"
            position = map_position(child.get("position"))

            # Variant without original — warn
            if variant and not original:
                warnings.append({
                    "severity": "low",
                    "phase": "2.1",
                    "entity": element,
                    "message": "Variant without original — treated as own master symbol",
                })

            # Register or update radical info
            if master not in radicals_info:
                # Look up stroke count from master's own KanjiVG entry first,
                # fall back to the component node's stroke_count (for radicals
                # without their own KanjiVG entry, e.g. CDP codes)
                master_tree = tree_map.get(master)
                stroke_count = master_tree.get("stroke_count", 0) if master_tree else 0
                if stroke_count == 0:
                    stroke_count = child.get("stroke_count", 0)
                radicals_info[master] = {
                    "master_symbol": master,
                    "is_official": is_official,
                    "stroke_count": stroke_count,
                }
            elif is_official:
                radicals_info[master]["is_official"] = True

            # Track variant shapes and positions
            if variant and original:
                # This element is a variant shape of the master
                key = (master, element)
                if key not in variants_info:
                    variants_info[key] = set()
                variants_info[key].add(position)
            else:
                # Track as self-shape positions
                key = (master, master)
                if key not in variants_info:
                    variants_info[key] = set()
                variants_info[key].add(position)

    # Log ghost flattening warnings for near-threshold elements
    ghosts_flattened = set()
    for char in scope_set:
        tree = tree_map.get(char)
        if not tree:
            continue
        direct = _count_direct_children(tree)
        for child in direct:
            element = child.get("element")
            if not element:
                continue
            master = resolve_master_symbol(
                element, child.get("variant", False), child.get("original")
            )
            if master not in keep_set and master not in ghosts_flattened:
                ghosts_flattened.add(master)
                f = freq.get(master, 0)
                if f >= 3 and f < freq_threshold:
                    warnings.append({
                        "severity": "high",
                        "phase": "2.1",
                        "entity": master,
                        "message": (
                            f"Frequent ghost flattened (freq={f}, threshold={freq_threshold})"
                        ),
                    })
                elif f < 2:
                    warnings.append({
                        "severity": "low",
                        "phase": "2.1",
                        "entity": master,
                        "message": f"Rare ghost flattened (freq={f})",
                    })

    # --- Pass 2: Register ---

    # Build radicals DataFrame
    radical_rows: list[dict] = []
    master_to_id: dict[str, int] = {}
    for i, (master, info) in enumerate(sorted(radicals_info.items()), start=1):
        master_to_id[master] = i
        radical_rows.append({
            "id": i,
            "master_symbol": info["master_symbol"],
            "is_official": info["is_official"],
            "stroke_count": info["stroke_count"],
            "svg_file_name": None,
            "svg_file_url": None,
            "svg_hash": None,
            "impact_score": None,
            "min_grade": None,
            "min_jlpt_level": None,
        })

    radicals_df = pd.DataFrame(radical_rows)
    if not radicals_df.empty:
        radicals_df["id"] = radicals_df["id"].astype("int64")
        radicals_df["stroke_count"] = radicals_df["stroke_count"].astype("int64")

    # Build radical_variants DataFrame
    variant_rows: list[dict] = []
    variant_id = 1

    # Track which masters have variant shapes (not self)
    masters_with_variants: set[str] = set()
    for (master, shape), _positions in sorted(variants_info.items()):
        if shape != master:
            masters_with_variants.add(master)

    for (master, shape), positions in sorted(variants_info.items()):
        if master not in master_to_id:
            continue

        radical_id = master_to_id[master]
        sorted_positions = json.dumps(sorted(positions))

        variant_rows.append({
            "id": variant_id,
            "radical_id": radical_id,
            "shape": shape,
            "positions": sorted_positions,
            "svg_file_name": None,
            "svg_file_url": None,
            "svg_hash": None,
        })
        variant_id += 1

    variants_df = pd.DataFrame(variant_rows)
    if not variants_df.empty:
        variants_df["id"] = variants_df["id"].astype("int64")
        variants_df["radical_id"] = variants_df["radical_id"].astype("int64")

    log.info(
        "Pass 2: registered %d radicals, %d variants",
        len(radicals_df),
        len(variants_df),
    )

    return radicals_df, variants_df, warnings


def extract_radicals(
    parquet_dir: Path,
    csv_dir: Path,
    warnings_dir: Path,
) -> dict[str, pd.DataFrame]:
    """Main entry point: run Passes 0–2, write CSVs.

    Returns dict of output DataFrames for inspection/testing.
    """
    log.info("Phase 2.1: Radical extraction starting")

    # Load Parquet files
    kanjivg_df = pd.read_parquet(parquet_dir / "kanjivg.parquet")
    kanjidic_df = pd.read_parquet(parquet_dir / "kanjidic.parquet")
    jlpt_kanji_df = pd.read_parquet(parquet_dir / "jlpt_kanji.parquet")

    log.info(
        "Loaded: %d KanjiVG, %d KANJIDIC, %d JLPT kanji entries",
        len(kanjivg_df),
        len(kanjidic_df),
        len(jlpt_kanji_df),
    )

    # Pass 0: Build scope set
    scope_set = build_scope_set(kanjidic_df, jlpt_kanji_df)

    # Build tree map from ALL KanjiVG entries
    tree_map = _build_tree_map(kanjivg_df)

    # Pass 1a: Build official set
    official_set = build_official_set(tree_map)

    # Pass 1b: Count frequencies
    freq = count_frequencies(kanjivg_df, scope_set, tree_map)

    # Pass 1c: Build keep set
    keep_set, keep_warnings = build_keep_set(scope_set, official_set, freq)

    # Pass 1d + Pass 2: Scan and register
    radicals_df, variants_df, scan_warnings = scan_and_register(
        kanjivg_df, scope_set, keep_set, tree_map, freq
    )

    all_warnings = keep_warnings + scan_warnings

    # Write outputs
    csv_dir.mkdir(parents=True, exist_ok=True)
    write_csv_atomic(radicals_df, csv_dir / "radicals.csv")
    write_csv_atomic(variants_df, csv_dir / "radical_variants.csv")

    # Write warnings
    if all_warnings:
        warnings_dir.mkdir(parents=True, exist_ok=True)
        warnings_df = pd.DataFrame(all_warnings)
        write_csv_atomic(warnings_df, warnings_dir / "ph2_1_warnings.csv")
        log.info("Phase 2.1: %d warnings written", len(all_warnings))
    else:
        log.info("Phase 2.1: no warnings")

    log.info(
        "Phase 2.1 complete: %d radicals, %d variants",
        len(radicals_df),
        len(variants_df),
    )

    return {
        "radicals": radicals_df,
        "radical_variants": variants_df,
        "scope_set": scope_set,
        "keep_set": keep_set,
    }
