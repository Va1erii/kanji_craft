"""Phase 3.0: Radical Classification for Multi-Level Decomposition.

Deterministic analysis pass that classifies every radical as either
kept (as a radical) or convertible to a kanji component reference.
Outputs radical_classification.csv for human review.

Classification rules (first match wins):
  0. keep_manual       — listed in manual_keep.txt
  1. keep_kangxi       — is_official == True
  2. keep_radical_only  — master_symbol not in kanji.csv characters
  3. keep_cross_jlpt    — radical is kanji, used in parents with easier JLPT
  4. keep_high_freq     — usage_count >= HIGH_FREQ_THRESHOLD
  5. convert_to_kanji   — everything else
"""

import logging
from pathlib import Path

import pandas as pd

from src.extractors.shared import load_manual_list, severity_sort_key, write_csv_atomic

log = logging.getLogger(__name__)

HIGH_FREQ_THRESHOLD = 15

DATA_DIR = Path(__file__).resolve().parent.parent.parent / "data"
MANUAL_KEEP = DATA_DIR / "manual_keep.txt"


def _build_kanji_jlpt_lookup(csv_dir: Path) -> dict[str, int | None]:
    """Build {character: min_jlpt_level} from kanji.csv."""
    kanji_df = pd.read_csv(csv_dir / "kanji.csv")
    result: dict[str, int | None] = {}
    for _, row in kanji_df.iterrows():
        char = str(row["character"])
        jlpt = row["min_jlpt_level"]
        result[char] = None if pd.isna(jlpt) else int(jlpt)
    return result


def _build_usage_stats(
    csv_dir: Path,
    kanji_jlpt: dict[str, int | None],
) -> dict[str, tuple[int, int | None]]:
    """Build {master_symbol: (usage_count, min_parent_jlpt)} from kanji_components.csv.

    min_parent_jlpt follows project convention: MAX of parent JLPT numbers
    (N5=5 easiest, higher number = earlier encounter = minimum difficulty).
    """
    components_df = pd.read_csv(csv_dir / "kanji_components.csv")

    usage_count: dict[str, int] = {}
    parent_jlpts: dict[str, list[int]] = {}

    for _, row in components_df.iterrows():
        ms = str(row["master_symbol"])
        parent = str(row["character"])

        usage_count[ms] = usage_count.get(ms, 0) + 1

        parent_jlpt = kanji_jlpt.get(parent)
        if parent_jlpt is not None:
            if ms not in parent_jlpts:
                parent_jlpts[ms] = []
            parent_jlpts[ms].append(parent_jlpt)

    result: dict[str, tuple[int, int | None]] = {}
    for ms in usage_count:
        count = usage_count[ms]
        jlpts = parent_jlpts.get(ms, [])
        # MAX of parent JLPTs = easiest parent (project convention for "min_*_jlpt")
        min_parent = max(jlpts) if jlpts else None
        result[ms] = (count, min_parent)

    return result


def _classify_one(
    row: pd.Series,
    kanji_chars: set[str],
    kanji_jlpt: dict[str, int | None],
    usage_count: int,
    min_parent_jlpt: int | None,
    manual_keep: set[str],
) -> tuple[str, str]:
    """Classify a single radical. Returns (classification, reason)."""
    ms = str(row["master_symbol"])

    # 0. Manual keep list (phonetic anchors, structural primitives)
    if ms in manual_keep:
        return "keep_manual", "Listed in manual_keep.txt"

    # 1. Kangxi official radicals are always kept
    if row["is_official"]:
        return "keep_kangxi", "Official Kangxi radical"

    # 2. Not a kanji → must stay as radical
    if ms not in kanji_chars:
        return "keep_radical_only", "No kanji form exists"

    # 3. Cross-JLPT: component appears in parents at an easier JLPT level
    component_jlpt = kanji_jlpt.get(ms)
    if component_jlpt is not None and min_parent_jlpt is not None:
        if min_parent_jlpt > component_jlpt:
            return (
                "keep_cross_jlpt",
                f"N{component_jlpt} component in N{min_parent_jlpt} parent",
            )
    elif component_jlpt is None and min_parent_jlpt is not None:
        # Null-JLPT component used in JLPT-assigned parent → play safe
        return (
            "keep_cross_jlpt",
            f"Null-JLPT component in N{min_parent_jlpt} parent",
        )
    # Both null → fall through (not cross-JLPT)

    # 4. High frequency
    if usage_count >= HIGH_FREQ_THRESHOLD:
        return "keep_high_freq", f"Usage count {usage_count} >= {HIGH_FREQ_THRESHOLD}"

    # 5. Everything else → convertible to kanji reference
    return "convert_to_kanji", f"Usage count {usage_count}, same or harder JLPT"


def classify_radicals(
    csv_dir: Path,
    warnings_dir: Path,
    manual_keep_path: Path = MANUAL_KEEP,
) -> dict[str, pd.DataFrame]:
    """Classify all radicals for multi-level decomposition.

    Returns {"radical_classification": df}. Writes radical_classification.csv.
    """
    log.info("Phase 3.0: Radical classification starting")
    warnings: list[dict] = []

    # Load inputs
    radicals_df = pd.read_csv(csv_dir / "radicals.csv")
    kanji_jlpt = _build_kanji_jlpt_lookup(csv_dir)
    kanji_chars = set(kanji_jlpt.keys())
    usage_stats = _build_usage_stats(csv_dir, kanji_jlpt)
    manual_keep = load_manual_list(manual_keep_path)

    log.info(
        "Loaded %d radicals, %d kanji, %d symbols with usage stats, %d manual keep",
        len(radicals_df),
        len(kanji_chars),
        len(usage_stats),
        len(manual_keep),
    )

    # Classify each radical
    rows: list[dict] = []
    for _, rad_row in radicals_df.iterrows():
        ms = str(rad_row["master_symbol"])
        count, min_parent = usage_stats.get(ms, (0, None))

        classification, reason = _classify_one(
            rad_row, kanji_chars, kanji_jlpt, count, min_parent, manual_keep,
        )

        is_kanji = ms in kanji_chars
        component_jlpt = kanji_jlpt.get(ms)

        rows.append({
            "master_symbol": ms,
            "family_symbol": rad_row["family_symbol"],
            "is_official": rad_row["is_official"],
            "is_kanji": is_kanji,
            "kanji_jlpt": component_jlpt,
            "min_parent_jlpt": min_parent,
            "usage_count": count,
            "impact_score": rad_row["impact_score"],
            "classification": classification,
            "reason": reason,
        })

        # Warnings
        if count == 0:
            warnings.append({
                "severity": "low",
                "phase": "3.0",
                "entity": ms,
                "message": "Radical not used in any kanji component",
            })
        elif (
            classification == "keep_cross_jlpt"
            and component_jlpt is None
            and count >= HIGH_FREQ_THRESHOLD
        ):
            warnings.append({
                "severity": "medium",
                "phase": "3.0",
                "entity": ms,
                "message": (
                    f"Null-JLPT component with high usage ({count}) "
                    f"classified as cross-JLPT"
                ),
            })

    # Build output DataFrame, sorted by classification then master_symbol
    result_df = pd.DataFrame(rows)
    result_df = result_df.sort_values(
        ["classification", "master_symbol"], ignore_index=True,
    )

    # Write output CSV
    write_csv_atomic(result_df, csv_dir / "radical_classification.csv")

    # Summary
    counts = result_df["classification"].value_counts()
    kept = len(result_df) - counts.get("convert_to_kanji", 0)
    log.info(
        "Phase 3.0 complete: %d radicals classified (%d kept, %d convertible)",
        len(result_df),
        kept,
        counts.get("convert_to_kanji", 0),
    )

    # Append warnings to existing ph3_warnings.csv
    if warnings:
        warnings_dir.mkdir(parents=True, exist_ok=True)
        warnings_path = warnings_dir / "ph3_warnings.csv"

        # Read existing warnings if present (from other enrichment steps)
        if warnings_path.exists():
            existing_df = pd.read_csv(warnings_path)
            existing_warnings = existing_df.to_dict("records")
        else:
            existing_warnings = []

        all_warnings = existing_warnings + warnings
        all_warnings.sort(key=severity_sort_key)
        write_csv_atomic(pd.DataFrame(all_warnings), warnings_path)
        log.info("Phase 3.0: %d warnings written", len(warnings))
    else:
        log.info("Phase 3.0: no warnings")

    return {"radical_classification": result_df}
