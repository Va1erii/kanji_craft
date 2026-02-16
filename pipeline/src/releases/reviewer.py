"""Generate review.xlsx from batch CSVs and apply edits back.

Usage:
    uv run python -m src.release review <name>   # batch CSVs → review.xlsx
    uv run python -m src.release apply <name>    # review.xlsx → batch CSVs
"""

import logging
from pathlib import Path

import pandas as pd

from src.config import RELEASES_DIR, TARGET_LANGS

log = logging.getLogger(__name__)

LANGS = TARGET_LANGS  # ["en", "es", "ru"]


# ── Public API ───────────────────────────────────────────────────────────────


def generate_review_xlsx(name: str) -> Path:
    """Read batch CSVs and write a wide-format review.xlsx with 4 sheets."""
    batch_dir = RELEASES_DIR / name
    if not batch_dir.is_dir():
        raise FileNotFoundError(f"Batch directory not found: {batch_dir}")

    xlsx_path = batch_dir / "review.xlsx"

    radicals_sheet = _build_radicals_sheet(batch_dir)
    kanji_sheet = _build_kanji_sheet(batch_dir)
    vocab_sheet = _build_vocabulary_sheet(batch_dir)
    sentences_sheet = _build_sentences_sheet(batch_dir)

    with pd.ExcelWriter(xlsx_path, engine="openpyxl") as writer:
        radicals_sheet.to_excel(writer, sheet_name="Radicals", index=False)
        kanji_sheet.to_excel(writer, sheet_name="Kanji", index=False)
        vocab_sheet.to_excel(writer, sheet_name="Vocabulary", index=False)
        sentences_sheet.to_excel(writer, sheet_name="Sentences", index=False)

    log.info(
        "Wrote review.xlsx: %d radicals, %d kanji, %d vocab, %d sentences",
        len(radicals_sheet), len(kanji_sheet), len(vocab_sheet), len(sentences_sheet),
    )
    return xlsx_path


def apply_review_xlsx(name: str) -> None:
    """Read review.xlsx and overwrite batch i18n CSVs with edits."""
    batch_dir = RELEASES_DIR / name
    xlsx_path = batch_dir / "review.xlsx"
    if not xlsx_path.is_file():
        raise FileNotFoundError(f"review.xlsx not found: {xlsx_path}")

    sheets = pd.read_excel(xlsx_path, sheet_name=None, engine="openpyxl", dtype=str)
    # openpyxl reads empty cells as NaN — replace with empty string
    sheets = {k: v.fillna("") for k, v in sheets.items()}

    _apply_radicals(batch_dir, sheets["Radicals"])
    _apply_kanji(batch_dir, sheets["Kanji"])
    _apply_vocabulary(batch_dir, sheets["Vocabulary"])
    _apply_sentences(batch_dir, sheets["Sentences"])

    log.info("Applied review.xlsx edits to batch CSVs in %s", batch_dir)


# ── Sheet builders (CSV → wide) ─────────────────────────────────────────────


def _build_radicals_sheet(batch_dir: Path) -> pd.DataFrame:
    radicals = _read(batch_dir / "radicals.csv")
    i18n = _read(batch_dir / "radical_i18n.csv")
    wide = _pivot_wide(
        entity_df=radicals[["master_symbol"]],
        i18n_df=i18n,
        entity_key="master_symbol",
        i18n_cols=["name", "system_mnemonic", "search_tags", "disambiguation_note"],
    )
    return wide


def _build_kanji_sheet(batch_dir: Path) -> pd.DataFrame:
    kanji = _read(batch_dir / "kanji.csv")
    i18n = _read(batch_dir / "kanji_i18n.csv")
    wide = _pivot_wide(
        entity_df=kanji[["character", "frequency_rank"]],
        i18n_df=i18n,
        entity_key="character",
        i18n_cols=["meanings", "system_mnemonic", "search_tags"],
    )
    return wide


def _build_vocabulary_sheet(batch_dir: Path) -> pd.DataFrame:
    vocab = _read(batch_dir / "vocabulary.csv")
    i18n = _read(batch_dir / "vocabulary_i18n.csv")
    wide = _pivot_wide(
        entity_df=vocab[["id", "word", "furigana", "frequency_rank"]],
        i18n_df=i18n.rename(columns={"vocabulary_id": "id"}),
        entity_key="id",
        i18n_cols=["meanings", "system_mnemonic", "search_tags"],
    )
    return wide


def _build_sentences_sheet(batch_dir: Path) -> pd.DataFrame:
    sentences = _read(batch_dir / "vocabulary_sentences.csv")
    sent_i18n = _read(batch_dir / "vocabulary_sentence_i18n.csv")
    vocab = _read(batch_dir / "vocabulary.csv")

    # Add word context from vocabulary
    context = vocab[["id", "word"]].rename(columns={"id": "vocabulary_id"})
    base = sentences.merge(context, on="vocabulary_id", how="left")

    wide = _pivot_wide(
        entity_df=base[["vocabulary_id", "word", "original_text"]],
        i18n_df=sent_i18n,
        entity_key="vocabulary_id",
        i18n_cols=["sentence_translated"],
    )
    return wide


# ── Apply helpers (wide → CSV) ───────────────────────────────────────────────


def _apply_radicals(batch_dir: Path, sheet: pd.DataFrame) -> None:
    i18n = _unpivot_long(
        wide_df=sheet,
        entity_key="master_symbol",
        i18n_cols=["name", "system_mnemonic", "search_tags", "disambiguation_note"],
    )
    i18n.to_csv(batch_dir / "radical_i18n.csv", index=False)


def _apply_kanji(batch_dir: Path, sheet: pd.DataFrame) -> None:
    i18n = _unpivot_long(
        wide_df=sheet,
        entity_key="character",
        i18n_cols=["meanings", "system_mnemonic", "search_tags"],
    )
    i18n.to_csv(batch_dir / "kanji_i18n.csv", index=False)


def _apply_vocabulary(batch_dir: Path, sheet: pd.DataFrame) -> None:
    i18n = _unpivot_long(
        wide_df=sheet,
        entity_key="id",
        i18n_cols=["meanings", "system_mnemonic", "search_tags"],
    )
    i18n = i18n.rename(columns={"id": "vocabulary_id"})
    i18n.to_csv(batch_dir / "vocabulary_i18n.csv", index=False)


def _apply_sentences(batch_dir: Path, sheet: pd.DataFrame) -> None:
    # Write back original_text edits to vocabulary_sentences.csv
    sentences = sheet[["vocabulary_id", "original_text"]].copy()
    sentences.to_csv(batch_dir / "vocabulary_sentences.csv", index=False)

    # Write back translations to vocabulary_sentence_i18n.csv
    i18n = _unpivot_long(
        wide_df=sheet,
        entity_key="vocabulary_id",
        i18n_cols=["sentence_translated"],
    )
    i18n.to_csv(batch_dir / "vocabulary_sentence_i18n.csv", index=False)


# ── Pivot helpers ────────────────────────────────────────────────────────────


def _pivot_wide(
    entity_df: pd.DataFrame,
    i18n_df: pd.DataFrame,
    entity_key: str,
    i18n_cols: list[str],
) -> pd.DataFrame:
    """Pivot long i18n rows into wide columns: col_en, col_es, col_ru."""
    result = entity_df.copy()
    for lang in LANGS:
        lang_rows = i18n_df[i18n_df["lang_code"] == lang].copy()
        rename = {col: f"{col}_{lang}" for col in i18n_cols}
        lang_rows = lang_rows.rename(columns=rename)
        keep_cols = [entity_key] + list(rename.values())
        lang_rows = lang_rows[keep_cols]
        result = result.merge(lang_rows, on=entity_key, how="left")
    return result.fillna("")


def _unpivot_long(
    wide_df: pd.DataFrame,
    entity_key: str,
    i18n_cols: list[str],
) -> pd.DataFrame:
    """Unpivot wide columns back to long i18n rows."""
    rows = []
    for lang in LANGS:
        lang_df = wide_df[[entity_key]].copy()
        lang_df["lang_code"] = lang
        for col in i18n_cols:
            wide_col = f"{col}_{lang}"
            lang_df[col] = wide_df[wide_col] if wide_col in wide_df.columns else ""
        rows.append(lang_df)
    result = pd.concat(rows, ignore_index=True)
    # Sort by entity key then lang for stable output
    result = result.sort_values([entity_key, "lang_code"]).reset_index(drop=True)
    return result


# ── Utility ──────────────────────────────────────────────────────────────────


def _read(path: Path) -> pd.DataFrame:
    return pd.read_csv(path, dtype=str, keep_default_na=False)
