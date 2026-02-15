"""Phase 2.3: Component Linking + Radical Metadata.

Reads kanjivg.parquet, radicals.csv, and kanji.csv to produce
kanji_components.csv and update radicals.csv with derived metadata
(impact_score, min_grade, min_jlpt_level).

Steps:
  1. Resolve effective children (ghost flattening) for each in-scope kanji
  2. Create kanji_components rows linking kanji to radicals
  3. Derive radical metadata from kanji associations
"""

import logging
from pathlib import Path

import pandas as pd

from src.extractors.shared import (
    load_manual_list,
    map_position,
    map_radical_type,
    parse_component_tree,
    resolve_effective_children,
    resolve_master_symbol,
    write_csv_atomic,
)

log = logging.getLogger(__name__)

DATA_DIR = Path(__file__).resolve().parent.parent.parent / "data"
MANUAL_FLATTEN = DATA_DIR / "manual_flatten.txt"

# impact_score frequency buckets: (upper_bound_inclusive, base_score)
_IMPACT_BUCKETS: list[tuple[int, int]] = [
    (5, 1),
    (15, 2),
    (30, 3),
    (50, 4),
    (80, 5),
    (120, 6),
    (180, 7),
    (260, 8),
    (400, 9),
]
_IMPACT_MAX_SCORE = 10


def _base_score_from_count(kanji_count: int) -> int:
    """Map kanji count to base impact score via bucket table."""
    for upper, score in _IMPACT_BUCKETS:
        if kanji_count <= upper:
            return score
    return _IMPACT_MAX_SCORE


def _complexity_bonus(stroke_count: int) -> int:
    """Stroke-based complexity bonus for impact_score."""
    if stroke_count >= 12:
        return 2
    if stroke_count >= 8:
        return 1
    return 0


def _build_tree_map(kanjivg_df: pd.DataFrame) -> dict[str, dict]:
    """Build lookup map from ALL KanjiVG entries: character → parsed component_tree."""
    tree_map: dict[str, dict] = {}
    for _, row in kanjivg_df.iterrows():
        tree = parse_component_tree(row["component_tree"])
        tree_map[row["character"]] = tree
    return tree_map


def extract_components(
    parquet_dir: Path,
    csv_dir: Path,
    warnings_dir: Path,
    scope_set: set[str],
    keep_set: set[str],
) -> dict:
    """Main entry point: Steps 1-3 — link components, derive metadata.

    Returns dict with output DataFrames for inspection/testing.
    """
    log.info("Phase 2.3: Component linking starting")
    warnings: list[dict] = []
    warned: set[tuple[str, str]] = set()

    # --- Load prerequisites ---
    kanjivg_df = pd.read_parquet(parquet_dir / "kanjivg.parquet")
    tree_map = _build_tree_map(kanjivg_df)

    radicals_df = pd.read_csv(csv_dir / "radicals.csv")
    kanji_df = pd.read_csv(csv_dir / "kanji.csv")

    manual_flatten = load_manual_list(MANUAL_FLATTEN)

    # Build lookups
    registered_masters: set[str] = set(radicals_df["master_symbol"])
    kanji_chars: set[str] = set(kanji_df["character"])
    # kanji grade/jlpt lookups
    char_to_grade: dict[str, int | None] = {}
    char_to_jlpt: dict[str, int | None] = {}
    for _, row in kanji_df.iterrows():
        char = row["character"]
        char_to_grade[char] = None if pd.isna(row["min_grade"]) else int(row["min_grade"])
        char_to_jlpt[char] = (
            None if pd.isna(row["min_jlpt_level"]) else int(row["min_jlpt_level"])
        )

    # radical stroke counts for complexity bonus
    ms_to_strokes: dict[str, int] = dict(
        zip(radicals_df["master_symbol"], radicals_df["stroke_count"], strict=True)
    )

    log.info(
        "Loaded: %d KanjiVG, %d radicals, %d kanji",
        len(kanjivg_df),
        len(radicals_df),
        len(kanji_df),
    )

    # --- Steps 1+2: Resolve children & create component rows ---
    component_rows: list[dict] = []
    seen_keys: set[tuple[str, str, str]] = set()  # (character, master_symbol, position)

    for char in sorted(scope_set):
        tree = tree_map.get(char)
        if not tree:
            continue

        if char not in kanji_chars:
            wkey = (char, "missing_kanji")
            if wkey not in warned:
                warned.add(wkey)
                warnings.append({
                    "severity": "high",
                    "phase": "2.3",
                    "entity": char,
                    "message": "Kanji in scope set not found in kanji.csv",
                })
            continue

        effective = resolve_effective_children(
            tree,
            keep_set,
            tree_map,
            depth=0,
            warnings=warnings,
            force_drop=manual_flatten,
        )

        for child in effective:
            element = child.get("element")
            if not element:
                continue

            variant = child.get("variant", False)
            original = child.get("original")

            # Warn on variant without original
            if variant and not original:
                wkey = (element, "variant_no_original")
                if wkey not in warned:
                    warned.add(wkey)
                    warnings.append({
                        "severity": "low",
                        "phase": "2.3",
                        "entity": element,
                        "message": "Variant without original — treated as own master symbol",
                    })

            master = resolve_master_symbol(element, variant, original)
            if master not in registered_masters:
                wkey = (master, "missing_radical")
                if wkey not in warned:
                    warned.add(wkey)
                    warnings.append({
                        "severity": "high",
                        "phase": "2.3",
                        "entity": master,
                        "message": "Child element not resolved to a radical",
                    })
                continue

            position = map_position(child.get("position"))
            radical_type = map_radical_type(child.get("radical"))
            is_primary = radical_type == "general"

            # Deduplicate on (character, master_symbol, position)
            key = (char, master, position)
            if key in seen_keys:
                continue
            seen_keys.add(key)

            component_rows.append({
                "character": char,
                "master_symbol": master,
                "position": position,
                "logic_hint": "semantic",
                "radical_type": radical_type,
                "is_primary": is_primary,
            })

    # Sort for determinism
    component_rows.sort(key=lambda r: (r["character"], r["master_symbol"], r["position"]))

    components_df = pd.DataFrame(component_rows)
    if not components_df.empty:
        components_df = components_df[
            ["character", "master_symbol", "position", "logic_hint",
             "radical_type", "is_primary"]
        ]

    log.info("Steps 1-2: %d component rows", len(components_df))

    # --- Step 3: Derive radical metadata ---
    if not components_df.empty:
        # 3a. impact_score — count distinct kanji per radical
        kanji_counts = components_df.groupby("master_symbol")["character"].nunique()

        # 3b/3c. min_grade and min_jlpt_level from kanji data
        # Group component rows by master_symbol → list of characters
        rad_kanji_map: dict[str, list[str]] = {}
        for _, row in components_df.iterrows():
            ms = row["master_symbol"]
            ch = row["character"]
            if ms not in rad_kanji_map:
                rad_kanji_map[ms] = []
            rad_kanji_map[ms].append(ch)

        # Compute metadata per radical
        impact_scores: dict[str, int] = {}
        min_grades: dict[str, int | None] = {}
        min_jlpt_levels: dict[str, int | None] = {}

        for ms in radicals_df["master_symbol"]:
            count = int(kanji_counts.get(ms, 0))
            if count == 0:
                # Radical not used in any component — leave metadata null
                impact_scores[ms] = None
                min_grades[ms] = None
                min_jlpt_levels[ms] = None
                continue

            base = _base_score_from_count(count)
            bonus = _complexity_bonus(int(ms_to_strokes.get(ms, 0)))
            impact_scores[ms] = min(base + bonus, _IMPACT_MAX_SCORE)

            # min_grade: MIN of non-null grades
            chars = rad_kanji_map.get(ms, [])
            grades = [char_to_grade[c] for c in chars if char_to_grade.get(c) is not None]
            min_grades[ms] = min(grades) if grades else None

            # min_jlpt_level: MAX of non-null levels (N5=5 easiest, MAX = earliest encounter)
            jlpt_levels = [char_to_jlpt[c] for c in chars if char_to_jlpt.get(c) is not None]
            min_jlpt_levels[ms] = max(jlpt_levels) if jlpt_levels else None

        # Update radicals_df
        radicals_df["impact_score"] = radicals_df["master_symbol"].map(impact_scores)
        radicals_df["min_grade"] = radicals_df["master_symbol"].map(min_grades)
        radicals_df["min_jlpt_level"] = radicals_df["master_symbol"].map(min_jlpt_levels)

        updated_count = radicals_df["impact_score"].notna().sum()
        log.info("Step 3: updated metadata for %d radicals", updated_count)
    else:
        log.info("Step 3: no components — metadata unchanged")

    # --- Write outputs ---
    csv_dir.mkdir(parents=True, exist_ok=True)
    write_csv_atomic(components_df, csv_dir / "kanji_components.csv")
    write_csv_atomic(radicals_df, csv_dir / "radicals.csv")

    # Write warnings
    # Deduplicate warnings by (severity, entity, message)
    seen_warnings: set[tuple[str, str, str]] = set()
    unique_warnings: list[dict] = []
    for w in warnings:
        key = (w["severity"], w["entity"], w["message"])
        if key not in seen_warnings:
            seen_warnings.add(key)
            unique_warnings.append(w)

    if unique_warnings:
        warnings_dir.mkdir(parents=True, exist_ok=True)
        unique_warnings.sort(key=lambda w: (w["severity"], w["entity"], w["message"]))
        warnings_df = pd.DataFrame(unique_warnings)
        write_csv_atomic(warnings_df, warnings_dir / "ph2_3_warnings.csv")
        log.info("Phase 2.3: %d warnings written", len(unique_warnings))
    else:
        log.info("Phase 2.3: no warnings")

    log.info(
        "Phase 2.3 complete: %d components, %d radicals updated",
        len(components_df),
        radicals_df["impact_score"].notna().sum() if not radicals_df.empty else 0,
    )

    return {
        "kanji_components": components_df,
        "radicals": radicals_df,
    }
