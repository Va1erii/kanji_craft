"""Phase 3.1: Logic Hint Refinement.

Compares onyomi readings between kanji and their radical components
to refine logic_hint from the Phase 2 default 'semantic' to 'phonetic'
where readings match.

Steps:
  A. Build radical onyomi lookup from kanjidic.parquet + radicals.csv
  B. Build kanji onyomi lookup from kanji_readings.csv
  C. Compare and update kanji_components.csv logic_hint values
  D. Emit position-heuristic warnings for admin review
"""

import json
import logging
from pathlib import Path

import pandas as pd

from src.extractors.shared import write_csv_atomic

log = logging.getLogger(__name__)

# Positions where the semantic role is expected (left, top, enclosure).
# A phonetic match at these positions is noteworthy.
_SEMANTIC_EXPECTED_POSITIONS = frozenset({"hen", "kanmuri", "kamae"})


def _build_radical_onyomi(
    parquet_dir: Path,
    radicals_df: pd.DataFrame,
    warnings: list[dict],
) -> dict[str, set[str]]:
    """Step A: Build {master_symbol: set[onyomi]} from kanjidic + radicals."""
    kanjidic_df = pd.read_parquet(parquet_dir / "kanjidic.parquet")

    master_symbols = set(radicals_df["master_symbol"])

    # Build literal → readings lookup from kanjidic
    literal_to_on: dict[str, set[str]] = {}
    for _, row in kanjidic_df.iterrows():
        literal = row["literal"]
        if literal not in master_symbols:
            continue
        readings_raw = row["readings"]
        if pd.isna(readings_raw):
            literal_to_on[literal] = set()
            continue
        readings = json.loads(readings_raw) if isinstance(readings_raw, str) else readings_raw
        ja_on = readings.get("ja_on", [])
        literal_to_on[literal] = set(ja_on)

    # Map every master_symbol; warn if missing from kanjidic
    result: dict[str, set[str]] = {}
    for ms in sorted(master_symbols):
        if ms in literal_to_on:
            result[ms] = literal_to_on[ms]
        else:
            result[ms] = set()
            warnings.append({
                "severity": "low",
                "phase": "3.1",
                "entity": ms,
                "message": "Radical master_symbol not found in KANJIDIC",
            })

    log.info(
        "Step A: %d radical symbols, %d with onyomi",
        len(result),
        sum(1 for v in result.values() if v),
    )
    return result


def _build_kanji_onyomi(csv_dir: Path) -> dict[int, set[str]]:
    """Step B: Build {kanji_id: set[onyomi]} from kanji_readings.csv."""
    readings_df = pd.read_csv(csv_dir / "kanji_readings.csv")
    on_df = readings_df[readings_df["reading_type"] == "onyomi"]

    result: dict[int, set[str]] = {}
    for _, row in on_df.iterrows():
        kid = int(row["kanji_id"])
        reading = str(row["reading"])
        if kid not in result:
            result[kid] = set()
        result[kid].add(reading)

    log.info("Step B: %d kanji with onyomi readings", len(result))
    return result


def _compare_and_update(
    components_df: pd.DataFrame,
    radical_onyomi: dict[str, set[str]],
    kanji_onyomi: dict[int, set[str]],
    rid_to_master: dict[int, str],
    warnings: list[dict],
) -> pd.DataFrame:
    """Steps C+D: Compare onyomi, update logic_hint, emit position warnings."""
    hints = components_df["logic_hint"].copy()

    for idx, row in components_df.iterrows():
        kanji_id = int(row["kanji_id"])
        radical_id = int(row["radical_id"])
        position = row["position"]

        k_on = kanji_onyomi.get(kanji_id, set())
        if not k_on:
            continue

        master = rid_to_master.get(radical_id)
        if master is None:
            continue

        r_on = radical_onyomi.get(master, set())
        if not r_on:
            continue

        # Step C: any intersection → phonetic
        if k_on & r_on:
            hints.at[idx] = "phonetic"

            # Step D: position heuristic warning
            if position in _SEMANTIC_EXPECTED_POSITIONS:
                warnings.append({
                    "severity": "medium",
                    "phase": "3.1",
                    "entity": f"kanji_id={kanji_id}",
                    "message": (
                        f"Onyomi match suggests phonetic but position "
                        f"'{position}' typically semantic "
                        f"(radical={master}, radical_id={radical_id})"
                    ),
                })

    result = components_df.copy()
    result["logic_hint"] = hints
    return result


def refine_logic_hints(
    parquet_dir: Path,
    csv_dir: Path,
    warnings_dir: Path,
) -> dict[str, pd.DataFrame]:
    """Refine logic_hint on kanji_components from semantic to phonetic.

    Returns {"kanji_components": updated_df}.
    Writes warnings to warnings_dir/ph3_warnings.csv.
    """
    log.info("Phase 3.1: Logic hint refinement starting")
    warnings: list[dict] = []

    # Load CSVs
    radicals_df = pd.read_csv(csv_dir / "radicals.csv")
    components_df = pd.read_csv(csv_dir / "kanji_components.csv")

    # Build lookups
    rid_to_master: dict[int, str] = dict(
        zip(radicals_df["id"], radicals_df["master_symbol"], strict=True)
    )

    # Step A: radical onyomi
    radical_onyomi = _build_radical_onyomi(parquet_dir, radicals_df, warnings)

    # Step B: kanji onyomi
    kanji_onyomi = _build_kanji_onyomi(csv_dir)

    # Steps C+D: compare and update
    updated_df = _compare_and_update(
        components_df, radical_onyomi, kanji_onyomi, rid_to_master, warnings,
    )

    # Write updated CSV
    write_csv_atomic(updated_df, csv_dir / "kanji_components.csv")

    phonetic_count = (updated_df["logic_hint"] == "phonetic").sum()
    log.info(
        "Phase 3.1 complete: %d/%d components marked phonetic",
        phonetic_count,
        len(updated_df),
    )

    # Write warnings
    if warnings:
        warnings_dir.mkdir(parents=True, exist_ok=True)
        warnings.sort(key=lambda w: (w["severity"], w["entity"], w["message"]))
        warnings_df = pd.DataFrame(warnings)
        write_csv_atomic(warnings_df, warnings_dir / "ph3_warnings.csv")
        log.info("Phase 3.1: %d warnings written", len(warnings))
    else:
        log.info("Phase 3.1: no warnings")

    return {"kanji_components": updated_df}
