"""Phase 2.2: Kanji Composition — Steps 1–3.

Reads kanjidic.parquet and jlpt_kanji.parquet to produce
kanji.csv, kanji_readings.csv, and kanji_i18n.csv.

Fields left empty for later phases:
- svg_file_name, svg_file_url, svg_hash (Phase 2.4)
- system_mnemonic, search_tags in kanji_i18n (Phase 3)
"""

import json
import logging
from pathlib import Path

import pandas as pd

from src.config import TARGET_LANGS
from src.extractors.shared import severity_sort_key, write_csv_atomic

log = logging.getLogger(__name__)


def _build_jlpt_lookup(jlpt_kanji_df: pd.DataFrame) -> dict[str, int]:
    """Build character → JLPT level lookup from jlpt_kanji.parquet."""
    return dict(zip(jlpt_kanji_df["character"], jlpt_kanji_df["level"], strict=True))


def _step1_kanji_rows(
    kanjidic_df: pd.DataFrame,
    jlpt_lookup: dict[str, int],
) -> pd.DataFrame:
    """Step 1: Create kanji rows from kanjidic.parquet.

    Sorted by character codepoint for determinism.
    Unranked kanji get synthetic frequency starting at 10001.
    """
    rows: list[dict] = []
    for _, row in kanjidic_df.iterrows():
        char = row["literal"]
        grade = row["grade"]
        frequency = row["frequency"]
        rows.append({
            "character": char,
            "stroke_count": int(row["stroke_count"]),
            "min_grade": None if pd.isna(grade) else int(grade),
            "min_jlpt_level": jlpt_lookup.get(char),
            "frequency_rank": None if pd.isna(frequency) else int(frequency),
            "svg_file_name": None,
            "svg_file_url": None,
            "svg_hash": None,
        })

    # Sort by codepoint for deterministic ordering
    rows.sort(key=lambda r: ord(r["character"]))

    # Assign synthetic frequency to unranked kanji
    synthetic = 10001
    for r in rows:
        if r["frequency_rank"] is None:
            r["frequency_rank"] = synthetic
            synthetic += 1

    df = pd.DataFrame(rows)
    if not df.empty:
        df["stroke_count"] = df["stroke_count"].astype("int64")
        df["frequency_rank"] = df["frequency_rank"].astype("int64")
        cols = ["character", "stroke_count", "min_grade", "min_jlpt_level",
                "frequency_rank", "svg_file_name", "svg_file_url", "svg_hash"]
        df = df[cols]
    return df


def _step2_reading_rows(
    kanjidic_df: pd.DataFrame,
    kanji_chars: set[str],
) -> pd.DataFrame:
    """Step 2: Create reading rows from kanjidic readings + nanori."""
    rows: list[dict] = []

    for _, kd_row in kanjidic_df.iterrows():
        char = kd_row["literal"]
        if char not in kanji_chars:
            continue

        # Parse readings JSON
        readings = kd_row.get("readings")
        if isinstance(readings, str):
            readings = json.loads(readings)
        elif pd.isna(readings) if not isinstance(readings, dict) else False:
            readings = {}

        ja_on = readings.get("ja_on", []) if isinstance(readings, dict) else []
        ja_kun = readings.get("ja_kun", []) if isinstance(readings, dict) else []

        # Parse nanori JSON
        nanori = kd_row.get("nanori")
        if isinstance(nanori, str):
            nanori = json.loads(nanori)
        elif pd.isna(nanori) if not isinstance(nanori, list) else False:
            nanori = []
        if not isinstance(nanori, list):
            nanori = []

        for reading in ja_on:
            rows.append({
                "character": char,
                "reading": reading,
                "reading_type": "onyomi",
                "priority": "primary",
            })

        for reading in ja_kun:
            rows.append({
                "character": char,
                "reading": reading,
                "reading_type": "kunyomi",
                "priority": "primary",
            })

        for reading in nanori:
            rows.append({
                "character": char,
                "reading": reading,
                "reading_type": "nanori",
                "priority": "primary",
            })

    df = pd.DataFrame(rows)
    if not df.empty:
        df = df[["character", "reading", "reading_type", "priority"]]
    return df


def _step3_i18n_rows(
    kanjidic_df: pd.DataFrame,
    kanji_chars: set[str],
) -> pd.DataFrame:
    """Step 3: Create i18n rows for all languages with non-empty meanings."""
    rows: list[dict] = []

    for _, kd_row in kanjidic_df.iterrows():
        char = kd_row["literal"]
        if char not in kanji_chars:
            continue

        # Parse meanings JSON
        meanings = kd_row.get("meanings")
        if isinstance(meanings, str):
            meanings = json.loads(meanings)
        elif pd.isna(meanings) if not isinstance(meanings, dict) else False:
            meanings = {}
        if not isinstance(meanings, dict):
            meanings = {}

        for lang_code in sorted(meanings.keys()):
            if lang_code not in TARGET_LANGS:
                continue
            lang_meanings = meanings[lang_code]
            if not lang_meanings:
                continue
            rows.append({
                "character": char,
                "lang_code": lang_code,
                "meanings": json.dumps(lang_meanings, ensure_ascii=False),
                "system_mnemonic": "",
                "search_tags": "[]",
            })

    df = pd.DataFrame(rows)
    return df


def _is_high_severity(
    is_jlpt: bool,
    grade: int | None,
) -> bool:
    """High severity if JLPT-mapped or grades 1-7 (jouyou + jinmeiyou)."""
    return is_jlpt or (grade is not None and 1 <= grade <= 7)


def _collect_warnings(
    kanji_df: pd.DataFrame,
    readings_df: pd.DataFrame,
    i18n_df: pd.DataFrame,
    jlpt_lookup: dict[str, int],
) -> list[dict]:
    """Collect warnings: JLPT-aware and grade-aware severity."""
    warnings: list[dict] = []

    # JLPT-mapped kanji missing from kanjidic
    kanjidic_chars = set(kanji_df["character"]) if not kanji_df.empty else set()
    for char in sorted(jlpt_lookup.keys()):
        if char not in kanjidic_chars:
            warnings.append({
                "severity": "high",
                "phase": "2.2",
                "entity": char,
                "message": "JLPT-mapped kanji missing from KANJIDIC data",
            })

    if kanji_df.empty:
        return warnings

    # Per-kanji checks
    chars_with_readings = (
        set(readings_df["character"]) if not readings_df.empty else set()
    )
    chars_with_en = set()
    if not i18n_df.empty:
        en_rows = i18n_df[i18n_df["lang_code"] == "en"]
        chars_with_en = set(en_rows["character"])

    for _, row in kanji_df.iterrows():
        char = row["character"]
        is_jlpt = char in jlpt_lookup
        grade = row.get("min_grade")
        grade = None if pd.isna(grade) else int(grade)
        high = _is_high_severity(is_jlpt, grade)

        # No readings
        if char not in chars_with_readings:
            severity = "high" if high else "low"
            warnings.append({
                "severity": severity,
                "phase": "2.2",
                "entity": char,
                "message": "Kanji with no readings",
            })

        # Missing English meanings
        if char not in chars_with_en:
            severity = "high" if high else "low"
            warnings.append({
                "severity": severity,
                "phase": "2.2",
                "entity": char,
                "message": "Missing English (en) meanings",
            })

    return warnings


def extract_kanji(
    parquet_dir: Path,
    csv_dir: Path,
    warnings_dir: Path,
) -> dict[str, pd.DataFrame]:
    """Main entry point: run Steps 1–3, write CSVs.

    Returns dict of output DataFrames for inspection/testing.
    """
    log.info("Phase 2.2: Kanji composition starting")

    # Load Parquet files
    kanjidic_df = pd.read_parquet(parquet_dir / "kanjidic.parquet")
    jlpt_kanji_df = pd.read_parquet(parquet_dir / "jlpt_kanji.parquet")

    log.info(
        "Loaded: %d KANJIDIC, %d JLPT kanji entries",
        len(kanjidic_df),
        len(jlpt_kanji_df),
    )

    # Build JLPT lookup
    jlpt_lookup = _build_jlpt_lookup(jlpt_kanji_df)

    # Step 1: Kanji rows
    kanji_df = _step1_kanji_rows(kanjidic_df, jlpt_lookup)
    kanji_chars = set(kanji_df["character"]) if not kanji_df.empty else set()
    log.info("Step 1: %d kanji rows", len(kanji_df))

    # Step 2: Reading rows
    readings_df = _step2_reading_rows(kanjidic_df, kanji_chars)
    log.info("Step 2: %d reading rows", len(readings_df))

    # Step 3: I18n rows
    i18n_df = _step3_i18n_rows(kanjidic_df, kanji_chars)
    log.info("Step 3: %d i18n rows", len(i18n_df))

    # Collect warnings
    all_warnings = _collect_warnings(
        kanji_df, readings_df, i18n_df, jlpt_lookup,
    )

    # Write outputs
    csv_dir.mkdir(parents=True, exist_ok=True)
    write_csv_atomic(kanji_df, csv_dir / "kanji.csv")
    write_csv_atomic(readings_df, csv_dir / "kanji_readings.csv")
    write_csv_atomic(i18n_df, csv_dir / "kanji_i18n.csv")

    # Write warnings
    if all_warnings:
        warnings_dir.mkdir(parents=True, exist_ok=True)
        all_warnings.sort(key=severity_sort_key)
        warnings_df = pd.DataFrame(all_warnings)
        write_csv_atomic(warnings_df, warnings_dir / "ph2_2_warnings.csv")
        log.info("Phase 2.2: %d warnings written", len(all_warnings))
    else:
        log.info("Phase 2.2: no warnings")

    log.info(
        "Phase 2.2 complete: %d kanji, %d readings, %d i18n",
        len(kanji_df),
        len(readings_df),
        len(i18n_df),
    )

    return {
        "kanji": kanji_df,
        "kanji_readings": readings_df,
        "kanji_i18n": i18n_df,
    }
