"""Phase 3.2: Radical I18n Creation.

Creates radical_i18n.csv — localized names, mnemonics, search tags, and
disambiguation notes for all radicals × 3 languages (EN/ES/RU).

Steps:
  A. Build deterministic scaffold from radicals.csv + kanjidic.parquet + visual_rules.json
  B. Merge AI-generated content from data/ai/radical_i18n_ai.csv
  C. Emit warnings for missing names, mnemonic gaps, AI overrides
  D. Consistency check: radical EN name vs kanji primary meaning
"""

import json
import logging
from pathlib import Path

import pandas as pd

from src.config import TARGET_LANGS
from src.extractors.shared import load_visual_rules, severity_sort_key, write_csv_atomic

log = logging.getLogger(__name__)

_AI_FILENAME = "radical_i18n_ai.csv"

# Output columns in canonical order
_OUTPUT_COLUMNS = [
    "master_symbol",
    "lang_code",
    "name",
    "system_mnemonic",
    "search_tags",
    "disambiguation_note",
]


def _build_en_name_seeds(
    parquet_dir: Path,
    master_symbols: set[str],
    warnings: list[dict],
) -> dict[str, str]:
    """Step A.2: Extract first English meaning from KANJIDIC for each radical.

    Returns {master_symbol: en_name}. Symbols not in KANJIDIC get a warning.
    """
    kanjidic_df = pd.read_parquet(parquet_dir / "kanjidic.parquet")

    literal_to_en: dict[str, str] = {}
    for _, row in kanjidic_df.iterrows():
        literal = row["literal"]
        if literal not in master_symbols:
            continue
        meanings_raw = row["meanings"]
        if pd.isna(meanings_raw):
            literal_to_en[literal] = ""
            continue
        meanings = json.loads(meanings_raw) if isinstance(meanings_raw, str) else meanings_raw
        en_list = meanings.get("en", [])
        literal_to_en[literal] = en_list[0] if en_list else ""

    # Warn for missing entries
    for ms in sorted(master_symbols):
        if ms not in literal_to_en:
            warnings.append({
                "severity": "low",
                "phase": "3.2",
                "entity": ms,
                "message": "Radical master_symbol not found in KANJIDIC (no EN name seed)",
            })

    found = sum(1 for v in literal_to_en.values() if v)
    log.info(
        "Step A.2: %d/%d radicals have EN name from KANJIDIC",
        found,
        len(master_symbols),
    )
    return literal_to_en


def _build_scaffold(
    radicals_df: pd.DataFrame,
    en_names: dict[str, str],
    visual_rules: dict[str, dict],
) -> pd.DataFrame:
    """Step A: Build scaffold rows — all radicals × all languages."""
    rows: list[dict] = []
    for _, rad in radicals_df.iterrows():
        ms = rad["master_symbol"]
        for lang in TARGET_LANGS:
            # EN name from KANJIDIC; ES/RU empty
            name = en_names.get(ms, "") if lang == "en" else ""

            # Disambiguation note from visual_rules per lang
            note = ""
            rule = visual_rules.get(ms)
            if rule:
                notes_dict = rule.get("disambiguation_note", {})
                note = notes_dict.get(lang, "")

            rows.append({
                "master_symbol": ms,
                "lang_code": lang,
                "name": name,
                "system_mnemonic": "",
                "search_tags": "[]",
                "disambiguation_note": note,
            })

    df = pd.DataFrame(rows, columns=_OUTPUT_COLUMNS)
    log.info("Step A: scaffold created with %d rows", len(df))
    return df


def _merge_ai_content(
    scaffold_df: pd.DataFrame,
    ai_dir: Path,
    en_names: dict[str, str],
    warnings: list[dict],
) -> pd.DataFrame:
    """Step B: Merge AI-generated content from radical_i18n_ai.csv.

    Non-empty AI fields override scaffold values for name, system_mnemonic,
    search_tags. disambiguation_note is NEVER overridden.
    """
    ai_path = ai_dir / _AI_FILENAME
    if not ai_path.exists():
        log.info("Step B: no AI file found at %s — scaffold only", ai_path)
        return scaffold_df

    ai_df = pd.read_csv(ai_path, dtype=str, keep_default_na=False)
    if ai_df.empty:
        log.info("Step B: AI file is empty — scaffold only")
        return scaffold_df

    # Key AI rows by (master_symbol, lang_code)
    ai_lookup: dict[tuple[str, str], dict] = {}
    for _, row in ai_df.iterrows():
        ms = str(row.get("master_symbol", "")).strip()
        lang = str(row.get("lang_code", "")).strip()
        if ms and lang:
            ai_lookup[(ms, lang)] = dict(row)

    result = scaffold_df.copy()
    overrides = 0

    for idx, row in result.iterrows():
        ms = row["master_symbol"]
        lang = row["lang_code"]
        ai_row = ai_lookup.get((ms, lang))
        if ai_row is None:
            continue

        # Override name if AI provides non-empty value
        ai_name = str(ai_row.get("name", "")).strip()
        if ai_name:
            # Warn if EN name differs from KANJIDIC seed
            if lang == "en" and ms in en_names and en_names[ms]:
                kanjidic_name = en_names[ms]
                if ai_name.lower() != kanjidic_name.lower():
                    warnings.append({
                        "severity": "medium",
                        "phase": "3.2",
                        "entity": ms,
                        "message": (
                            f"AI EN name '{ai_name}' differs from "
                            f"KANJIDIC meaning '{kanjidic_name}'"
                        ),
                    })
            result.at[idx, "name"] = ai_name
            overrides += 1

        # Override system_mnemonic if AI provides non-empty value
        ai_mnemonic = str(ai_row.get("system_mnemonic", "")).strip()
        if ai_mnemonic:
            result.at[idx, "system_mnemonic"] = ai_mnemonic
            overrides += 1

        # Override search_tags if AI provides non-empty value
        ai_tags = str(ai_row.get("search_tags", "")).strip()
        if ai_tags and ai_tags != "[]":
            result.at[idx, "search_tags"] = ai_tags
            overrides += 1

    log.info("Step B: %d AI overrides applied from %d AI rows", overrides, len(ai_df))
    return result


def _emit_gap_warnings(df: pd.DataFrame, warnings: list[dict]) -> None:
    """Step C: Warn about rows with empty name or system_mnemonic after merge."""
    for _, row in df.iterrows():
        ms = row["master_symbol"]
        lang = row["lang_code"]

        if not str(row["name"]).strip():
            warnings.append({
                "severity": "low",
                "phase": "3.2",
                "entity": f"{ms} ({lang})",
                "message": "Empty name after merge",
            })
        if not str(row["system_mnemonic"]).strip():
            warnings.append({
                "severity": "low",
                "phase": "3.2",
                "entity": f"{ms} ({lang})",
                "message": "Empty system_mnemonic after merge",
            })


def _check_radical_kanji_consistency(
    df: pd.DataFrame,
    csv_dir: Path,
    warnings: list[dict],
) -> None:
    """Step D: Compare radical EN name with kanji primary meaning.

    For radicals whose master_symbol also exists as a kanji.character,
    compare the radical's EN name with the kanji's first EN meaning.
    Mismatch → high warning.
    """
    kanji_path = csv_dir / "kanji.csv"
    kanji_i18n_path = csv_dir / "kanji_i18n.csv"
    if not kanji_path.exists() or not kanji_i18n_path.exists():
        log.info("Step D: kanji.csv or kanji_i18n.csv not found — skipping consistency check")
        return

    kanji_df = pd.read_csv(kanji_path, dtype=str, keep_default_na=False)
    kanji_i18n_df = pd.read_csv(kanji_i18n_path, dtype=str, keep_default_na=False)

    # Build set of known kanji characters
    kanji_chars: set[str] = set(kanji_df["character"])

    # Build (character, lang_code) → first meaning
    char_lang_to_meaning: dict[tuple[str, str], str] = {}
    for _, row in kanji_i18n_df.iterrows():
        char = str(row["character"])
        lang = str(row["lang_code"])
        meanings_raw = str(row.get("meanings", "[]")).strip()
        try:
            meanings_list = json.loads(meanings_raw) if meanings_raw else []
        except (json.JSONDecodeError, TypeError):
            meanings_list = []
        if meanings_list:
            char_lang_to_meaning[(char, lang)] = meanings_list[0]

    # Check EN rows only
    en_rows = df[df["lang_code"] == "en"]
    for _, row in en_rows.iterrows():
        ms = row["master_symbol"]
        radical_name = str(row["name"]).strip()
        if not radical_name or not ms:
            continue

        if ms not in kanji_chars:
            continue

        kanji_meaning = char_lang_to_meaning.get((ms, "en"), "")
        if not kanji_meaning:
            continue

        if radical_name.lower() != kanji_meaning.lower():
            warnings.append({
                "severity": "high",
                "phase": "3.2",
                "entity": ms,
                "message": (
                    f"Radical EN name '{radical_name}' differs from "
                    f"kanji primary EN meaning '{kanji_meaning}'"
                ),
            })


def create_radical_i18n(
    parquet_dir: Path,
    csv_dir: Path,
    warnings_dir: Path,
    ai_dir: Path,
) -> dict[str, pd.DataFrame]:
    """Create radical_i18n.csv from scratch.

    Returns {"radical_i18n": df}.
    Appends warnings to warnings_dir/ph3_warnings.csv.
    """
    log.info("Phase 3.2: Radical i18n creation starting")
    warnings: list[dict] = []

    # Load radicals
    radicals_df = pd.read_csv(csv_dir / "radicals.csv")
    master_symbols = set(radicals_df["master_symbol"])

    # Load visual rules
    data_dir = csv_dir.parent
    visual_rules = load_visual_rules(data_dir / "visual_rules.json")

    # Step A: scaffold
    en_names = _build_en_name_seeds(parquet_dir, master_symbols, warnings)
    scaffold_df = _build_scaffold(radicals_df, en_names, visual_rules)

    # Step B: AI merge
    result_df = _merge_ai_content(scaffold_df, ai_dir, en_names, warnings)

    # Step C: gap warnings
    _emit_gap_warnings(result_df, warnings)

    # Step D: radical-kanji consistency
    _check_radical_kanji_consistency(result_df, csv_dir, warnings)

    # Write output CSV
    write_csv_atomic(result_df, csv_dir / "radical_i18n.csv")

    log.info(
        "Phase 3.2 complete: %d rows (%d radicals × %d langs)",
        len(result_df),
        len(radicals_df),
        len(TARGET_LANGS),
    )

    # Append warnings to ph3_warnings.csv (merge with existing)
    if warnings:
        warnings.sort(key=severity_sort_key)
        new_warnings_df = pd.DataFrame(warnings)
        existing_path = warnings_dir / "ph3_warnings.csv"
        if existing_path.exists():
            existing_df = pd.read_csv(existing_path, dtype=str, keep_default_na=False)
            combined_df = pd.concat([existing_df, new_warnings_df], ignore_index=True)
        else:
            combined_df = new_warnings_df
        warnings_dir.mkdir(parents=True, exist_ok=True)
        write_csv_atomic(combined_df, existing_path)
        log.info("Phase 3.2: %d warnings written", len(warnings))
    else:
        log.info("Phase 3.2: no warnings")

    return {"radical_i18n": result_df}
