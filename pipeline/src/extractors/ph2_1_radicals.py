"""Phase 2.1: Radical Extraction — Passes 0–2.

Reads kanjivg.parquet, kanjidic.parquet, jlpt_kanji.parquet to produce
radicals.csv (flattened: each shape is its own radical row).

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
    load_manual_srs_delegates,
    load_manual_strokes,
    load_visual_rules,
    map_position,
    merge_split_parts,
    parse_component_tree,
    resolve_effective_children,
    resolve_master_symbol,
    severity_sort_key,
    write_csv_atomic,
)

log = logging.getLogger(__name__)

DATA_DIR = Path(__file__).resolve().parent.parent.parent / "data"
MANUAL_KEEP = DATA_DIR / "manual_keep.txt"
MANUAL_FLATTEN = DATA_DIR / "manual_flatten.txt"
MANUAL_STROKES = DATA_DIR / "manual_strokes.txt"
MANUAL_SRS_DELEGATES = DATA_DIR / "manual_srs_delegates.csv"
VISUAL_RULES = DATA_DIR / "visual_rules.json"


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
    for char in sorted(scope_set):
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
    manual_strokes: dict[str, int],
    visual_rules: dict[str, dict] | None = None,
    manual_flatten: set[str] | None = None,
    freq_threshold: int = 5,
    srs_delegates: dict[str, str] | None = None,
) -> tuple[pd.DataFrame, pd.DataFrame, pd.DataFrame, list[dict]]:
    """Pass 1d + Pass 2: Scan with ghost flattening, then register radicals.

    Flattened model: each shape becomes its own radical row.
    family_symbol groups related shapes (e.g. 人 ↔ 亻).

    Returns (radicals_df, visual_groups_df, srs_delegates_df, warnings).
    """
    warnings: list[dict] = []
    warned: set[tuple[str, str]] = set()  # (entity, message_key) → dedup warnings

    # Collect shape info: shape → {old_master, is_official, positions}
    shape_info: dict[str, dict] = {}

    for char in sorted(scope_set):
        tree = tree_map.get(char)
        if not tree:
            continue

        effective = resolve_effective_children(
            tree, keep_set, tree_map, depth=0, warnings=warnings,
            force_drop=manual_flatten,
        )

        for child in effective:
            element = child.get("element")
            if not element:
                continue

            variant = child.get("variant", False)
            original = child.get("original")
            old_master = resolve_master_symbol(element, variant, original)
            is_official = child.get("radical") == "general"
            position = map_position(child.get("position"))

            # Variant without original — warn once per element
            if variant and not original:
                wkey = (element, "variant_no_original")
                if wkey not in warned:
                    warned.add(wkey)
                    warnings.append({
                        "severity": "low",
                        "phase": "2.1",
                        "entity": element,
                        "message": "Variant without original — treated as own master symbol",
                    })

            # Register or update shape info — keyed by actual element (shape)
            if element not in shape_info:
                # Stroke count from shape's own KanjiVG entry
                shape_tree = tree_map.get(element)
                stroke_count = shape_tree.get("stroke_count", 0) if shape_tree else 0
                shape_info[element] = {
                    "shape": element,
                    "old_master": old_master,
                    "is_official": is_official,
                    "stroke_count": stroke_count,
                    "positions": set(),
                }
            elif is_official:
                shape_info[element]["is_official"] = True

            shape_info[element]["positions"].add(position)

    # Log ghost flattening warnings for near-threshold elements
    ghosts_flattened = set()
    for char in sorted(scope_set):
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

    # --- Apply manual stroke overrides + warn on missing ---
    for shape, info in sorted(shape_info.items()):
        if shape in manual_strokes:
            info["stroke_count"] = manual_strokes[shape]
        elif info["stroke_count"] == 0:
            warnings.append({
                "severity": "high",
                "phase": "2.1",
                "entity": shape,
                "message": "Missing stroke count (add to manual_strokes.txt)",
            })

    # --- Compute family_symbol from old-master grouping ---
    # Group shapes by their old_master
    master_to_shapes: dict[str, set[str]] = {}
    for shape, info in shape_info.items():
        om = info["old_master"]
        if om not in master_to_shapes:
            master_to_shapes[om] = set()
        master_to_shapes[om].add(shape)

    # Determine family_symbol per shape
    family_map: dict[str, str | None] = {}
    for old_master, shapes in master_to_shapes.items():
        if len(shapes) == 1:
            shape = next(iter(shapes))
            if shape == old_master:
                # Single-form radical: shape matches old master → null
                family_map[shape] = None
            else:
                # Discrepancy radical: shape ≠ old master (e.g. 攴→攵)
                family_map[shape] = old_master
        else:
            # Multi-variant family: all members get family_symbol = canonical form
            for shape in shapes:
                family_map[shape] = old_master

    # --- Pass 2: Register ---

    vr = visual_rules or {}
    radical_rows: list[dict] = []
    registered_masters: set[str] = set()
    for shape, info in sorted(shape_info.items()):
        registered_masters.add(shape)
        # is_official: only for shapes where shape == old_master AND old_master was official
        is_official_for_shape = info["is_official"] and shape == info["old_master"]
        radical_rows.append({
            "master_symbol": shape,
            "family_symbol": family_map.get(shape),
            "positions": json.dumps(sorted(info["positions"])),
            "is_official": is_official_for_shape,
            "stroke_count": info["stroke_count"],
            "svg_file_name": None,
            "svg_file_url": None,
            "svg_hash": None,
            "impact_score": None,
            "min_grade": None,
            "min_jlpt_level": None,
        })

    # --- Build SRS delegates table ---
    delegate_rows: list[dict] = []
    if srs_delegates:
        for ms, delegate in sorted(srs_delegates.items()):
            if ms not in registered_masters:
                continue  # source radical not in set — skip silently
            if delegate in registered_masters:
                delegate_rows.append({
                    "master_symbol": ms,
                    "delegate_symbol": delegate,
                })
            else:
                warnings.append({
                    "severity": "high",
                    "phase": "2.1",
                    "entity": ms,
                    "message": (
                        f"srs_delegate target '{delegate}' not found in radical set"
                    ),
                })
    srs_delegates_df = pd.DataFrame(
        delegate_rows, columns=["master_symbol", "delegate_symbol"]
    )

    radicals_df = pd.DataFrame(radical_rows)
    if not radicals_df.empty:
        radicals_df["stroke_count"] = radicals_df["stroke_count"].astype("int64")

    # --- Build visual groups table ---
    visual_group_rows: list[dict] = []
    group_members: dict[str, list[str]] = {}
    for shape in sorted(registered_masters):
        if shape in vr:
            vg = vr[shape]["visual_group"]
            visual_group_rows.append({
                "master_symbol": shape,
                "visual_group": vg,
            })
            if vg not in group_members:
                group_members[vg] = []
            group_members[vg].append(shape)
    visual_groups_df = pd.DataFrame(
        visual_group_rows, columns=["master_symbol", "visual_group"],
    )

    for vg, members in sorted(group_members.items()):
        if len(members) < 2:
            warnings.append({
                "severity": "high",
                "phase": "2.1",
                "entity": members[0],
                "message": (
                    f"visual_group '{vg}' has only 1 member — "
                    f"typo in visual_rules.json?"
                ),
            })

    # Warn about visual_rules entries that don't match any registered radical
    for symbol in sorted(vr):
        if symbol not in registered_masters:
            warnings.append({
                "severity": "medium",
                "phase": "2.1",
                "entity": symbol,
                "message": "Entry in visual_rules.json but not a registered radical",
            })

    log.info(
        "Pass 2: registered %d radicals, %d visual groups, %d SRS delegates",
        len(radicals_df),
        len(visual_groups_df),
        len(srs_delegates_df),
    )

    return radicals_df, visual_groups_df, srs_delegates_df, warnings


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

    # Load manual overrides and visual rules
    manual_strokes = load_manual_strokes(MANUAL_STROKES)
    manual_flatten = load_manual_list(MANUAL_FLATTEN)
    visual_rules = load_visual_rules(VISUAL_RULES)
    srs_delegates = load_manual_srs_delegates(MANUAL_SRS_DELEGATES)

    # Pass 1d + Pass 2: Scan and register
    radicals_df, visual_groups_df, srs_delegates_df, scan_warnings = scan_and_register(
        kanjivg_df, scope_set, keep_set, tree_map, freq, manual_strokes,
        visual_rules, manual_flatten, srs_delegates=srs_delegates,
    )

    # Deduplicate warnings by (severity, entity, message)
    all_warnings = keep_warnings + scan_warnings
    seen_warnings: set[tuple[str, str, str]] = set()
    unique_warnings: list[dict] = []
    for w in all_warnings:
        key = (w["severity"], w["entity"], w["message"])
        if key not in seen_warnings:
            seen_warnings.add(key)
            unique_warnings.append(w)
    all_warnings = unique_warnings

    # Write outputs
    csv_dir.mkdir(parents=True, exist_ok=True)
    write_csv_atomic(radicals_df, csv_dir / "radicals.csv")
    write_csv_atomic(visual_groups_df, csv_dir / "radical_visual_groups.csv")
    write_csv_atomic(srs_delegates_df, csv_dir / "radical_srs_delegates.csv")

    # Write warnings (sorted for deterministic output)
    if all_warnings:
        warnings_dir.mkdir(parents=True, exist_ok=True)
        all_warnings.sort(key=severity_sort_key)
        warnings_df = pd.DataFrame(all_warnings)
        write_csv_atomic(warnings_df, warnings_dir / "ph2_1_warnings.csv")
        log.info("Phase 2.1: %d warnings written", len(all_warnings))
    else:
        log.info("Phase 2.1: no warnings")

    log.info(
        "Phase 2.1 complete: %d radicals, %d visual groups, %d SRS delegates",
        len(radicals_df),
        len(visual_groups_df),
        len(srs_delegates_df),
    )

    return {
        "radicals": radicals_df,
        "radical_visual_groups": visual_groups_df,
        "radical_srs_delegates": srs_delegates_df,
        "scope_set": scope_set,
        "keep_set": keep_set,
    }
