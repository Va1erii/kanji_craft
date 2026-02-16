"""Batch validator — check completeness and referential integrity before push.

Reads all CSVs in a batch directory and produces a list of validation errors.
A batch must pass validation (zero errors) before it can be pushed to Supabase.
"""

import json
import logging
import re
from dataclasses import dataclass
from pathlib import Path

import pandas as pd

from src.config import RELEASES_DIR, TARGET_LANGS

log = logging.getLogger(__name__)

# Regex: at least one CJK Unified Ideograph (basic block)
_HAS_KANJI_RE = re.compile(r"[\u4e00-\u9fff]")
# Regex: furigana notation {X|Y}
_HAS_FURIGANA_RE = re.compile(r"\{[^}]+\|[^}]+\}")


@dataclass
class ValidationError:
    """Single validation failure."""

    table: str
    row: str  # human-readable row reference (e.g. "character=日" or "row 3")
    message: str

    def __str__(self) -> str:
        return f"[{self.table}] {self.row}: {self.message}"


# ── Helpers ──────────────────────────────────────────────────────────────────


def _read_csv(path: Path) -> pd.DataFrame:
    """Read CSV with string dtype to prevent NaN coercion."""
    if not path.exists():
        return pd.DataFrame()
    return pd.read_csv(path, dtype=str, keep_default_na=False)


def _is_empty(value: str) -> bool:
    """Check if a string value is empty or only whitespace."""
    return not value or not value.strip()


def _is_empty_json_array(value: str) -> bool:
    """Check if a value is an empty JSON array '[]' or empty string."""
    if _is_empty(value):
        return True
    try:
        parsed = json.loads(value)
        return isinstance(parsed, list) and len(parsed) == 0
    except (json.JSONDecodeError, TypeError):
        return False


def _check_all_columns_nonempty(
    df: pd.DataFrame,
    table: str,
    key_col: str,
    errors: list[ValidationError],
) -> None:
    """Check that all columns in a DataFrame have non-empty values."""
    for _, row in df.iterrows():
        key = row.get(key_col, "?")
        for col in df.columns:
            if _is_empty(row[col]):
                errors.append(ValidationError(table, f"{key_col}={key}", f"empty '{col}'"))


def _check_i18n_coverage(
    df: pd.DataFrame,
    table: str,
    entity_key_col: str,
    entity_keys: set[str],
    errors: list[ValidationError],
) -> None:
    """Check that every entity has exactly len(TARGET_LANGS) i18n rows."""
    expected = len(TARGET_LANGS)
    if df.empty:
        for key in sorted(entity_keys):
            errors.append(ValidationError(
                table, f"{entity_key_col}={key}", f"missing all {expected} i18n rows",
            ))
        return

    for key in sorted(entity_keys):
        rows = df[df[entity_key_col] == str(key)]
        langs = set(rows["lang_code"])
        missing = set(TARGET_LANGS) - langs
        for lang in sorted(missing):
            errors.append(ValidationError(
                table, f"{entity_key_col}={key}", f"missing lang_code='{lang}'",
            ))


def _get_pushed_kanji_from_other_batches(current_batch: str) -> set[str]:
    """Collect kanji characters from previously-pushed batches.

    A batch is considered pushed if it has a manifest.json with at least one push entry.
    """
    pushed_kanji: set[str] = set()
    if not RELEASES_DIR.exists():
        return pushed_kanji

    for batch_dir in sorted(RELEASES_DIR.iterdir()):
        if not batch_dir.is_dir() or batch_dir.name == current_batch:
            continue
        manifest_path = batch_dir / "manifest.json"
        if not manifest_path.exists():
            continue
        try:
            manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
            if not manifest.get("pushes"):
                continue
        except (json.JSONDecodeError, OSError):
            continue
        # This batch has been pushed — read its kanji
        kanji_path = batch_dir / "kanji.csv"
        if kanji_path.exists():
            kdf = pd.read_csv(kanji_path, dtype=str, keep_default_na=False)
            if "character" in kdf.columns:
                pushed_kanji.update(kdf["character"])

    return pushed_kanji


# ── Main entry point ─────────────────────────────────────────────────────────


def validate_batch(name: str) -> list[ValidationError]:
    """Validate a release batch for completeness and integrity.

    Args:
        name: Batch directory name (e.g. "n5_kanji_1").

    Returns:
        List of validation errors. Empty list means the batch is ready to push.
    """
    batch_dir = RELEASES_DIR / name
    if not batch_dir.exists():
        return [ValidationError("batch", name, "batch directory does not exist")]

    errors: list[ValidationError] = []

    # Load all tables
    radicals = _read_csv(batch_dir / "radicals.csv")
    radical_i18n = _read_csv(batch_dir / "radical_i18n.csv")
    radical_variants = _read_csv(batch_dir / "radical_variants.csv")
    kanji = _read_csv(batch_dir / "kanji.csv")
    kanji_readings = _read_csv(batch_dir / "kanji_readings.csv")
    kanji_i18n = _read_csv(batch_dir / "kanji_i18n.csv")
    kanji_components = _read_csv(batch_dir / "kanji_components.csv")
    vocabulary = _read_csv(batch_dir / "vocabulary.csv")
    vocabulary_readings = _read_csv(batch_dir / "vocabulary_readings.csv")
    vocabulary_i18n = _read_csv(batch_dir / "vocabulary_i18n.csv")
    vocabulary_kanji = _read_csv(batch_dir / "vocabulary_kanji.csv")
    vocabulary_sentences = _read_csv(batch_dir / "vocabulary_sentences.csv")
    vocabulary_sentence_i18n = _read_csv(batch_dir / "vocabulary_sentence_i18n.csv")

    # ── radicals: all columns non-empty ──────────────────────────────────

    _check_all_columns_nonempty(radicals, "radicals", "master_symbol", errors)

    # ── radical_variants: all columns non-empty ──────────────────────────

    _check_all_columns_nonempty(radical_variants, "radical_variants", "master_symbol", errors)

    # ── radical_i18n: name, system_mnemonic, search_tags required ────────

    radical_symbols = set(radicals["master_symbol"]) if not radicals.empty else set()
    _check_i18n_coverage(radical_i18n, "radical_i18n", "master_symbol", radical_symbols, errors)

    for _, row in radical_i18n.iterrows():
        ref = f"master_symbol={row.get('master_symbol', '?')},lang={row.get('lang_code', '?')}"
        if _is_empty(row.get("name", "")):
            errors.append(ValidationError("radical_i18n", ref, "empty 'name'"))
        if _is_empty(row.get("system_mnemonic", "")):
            errors.append(ValidationError("radical_i18n", ref, "empty 'system_mnemonic'"))
        if _is_empty_json_array(row.get("search_tags", "")):
            errors.append(ValidationError("radical_i18n", ref, "empty 'search_tags'"))

    # ── kanji: all columns non-empty ─────────────────────────────────────

    _check_all_columns_nonempty(kanji, "kanji", "character", errors)

    # ── kanji_readings: all columns non-empty ────────────────────────────

    _check_all_columns_nonempty(kanji_readings, "kanji_readings", "character", errors)

    # ── kanji_i18n: meanings, system_mnemonic, search_tags required ──────

    kanji_chars = set(kanji["character"]) if not kanji.empty else set()
    _check_i18n_coverage(kanji_i18n, "kanji_i18n", "character", kanji_chars, errors)

    for _, row in kanji_i18n.iterrows():
        ref = f"character={row.get('character', '?')},lang={row.get('lang_code', '?')}"
        if _is_empty_json_array(row.get("meanings", "")):
            errors.append(ValidationError("kanji_i18n", ref, "empty 'meanings'"))
        if _is_empty(row.get("system_mnemonic", "")):
            errors.append(ValidationError("kanji_i18n", ref, "empty 'system_mnemonic'"))
        if _is_empty_json_array(row.get("search_tags", "")):
            errors.append(ValidationError("kanji_i18n", ref, "empty 'search_tags'"))

    # ── kanji_components: all columns non-empty ──────────────────────────

    _check_all_columns_nonempty(kanji_components, "kanji_components", "character", errors)

    # ── vocabulary: all columns non-empty ────────────────────────────────

    _check_all_columns_nonempty(vocabulary, "vocabulary", "id", errors)

    # ── vocabulary_readings: all columns non-empty ───────────────────────

    _check_all_columns_nonempty(vocabulary_readings, "vocabulary_readings", "vocabulary_id", errors)

    # ── vocabulary_i18n: meanings, search_tags required; system_mnemonic nullable ─

    vocab_ids = set(vocabulary["id"]) if not vocabulary.empty else set()
    _check_i18n_coverage(vocabulary_i18n, "vocabulary_i18n", "vocabulary_id", vocab_ids, errors)

    for _, row in vocabulary_i18n.iterrows():
        ref = f"vocab_id={row.get('vocabulary_id', '?')},lang={row.get('lang_code', '?')}"
        if _is_empty_json_array(row.get("meanings", "")):
            errors.append(ValidationError("vocabulary_i18n", ref, "empty 'meanings'"))
        if _is_empty_json_array(row.get("search_tags", "")):
            errors.append(ValidationError("vocabulary_i18n", ref, "empty 'search_tags'"))
        # system_mnemonic is nullable for vocabulary (per mnemonic.md)

    # ── vocabulary_kanji: all columns non-empty ──────────────────────────

    _check_all_columns_nonempty(vocabulary_kanji, "vocabulary_kanji", "vocabulary_id", errors)

    # ── vocabulary_sentences: furigana check ─────────────────────────────

    for _, row in vocabulary_sentences.iterrows():
        ref = f"vocab_id={row.get('vocabulary_id', '?')}"
        text = row.get("original_text", "")
        if _is_empty(text):
            errors.append(ValidationError("vocabulary_sentences", ref, "empty 'original_text'"))
        elif _HAS_KANJI_RE.search(text) and not _HAS_FURIGANA_RE.search(text):
            errors.append(ValidationError(
                "vocabulary_sentences", ref,
                "original_text contains kanji but no furigana notation {X|Y}",
            ))

    # ── vocabulary_sentence_i18n: 3 langs per sentence ───────────────────

    sentence_vocab_ids = (
        set(vocabulary_sentences["vocabulary_id"]) if not vocabulary_sentences.empty else set()
    )
    _check_i18n_coverage(
        vocabulary_sentence_i18n, "vocabulary_sentence_i18n",
        "vocabulary_id", sentence_vocab_ids, errors,
    )

    for _, row in vocabulary_sentence_i18n.iterrows():
        ref = f"vocab_id={row.get('vocabulary_id', '?')},lang={row.get('lang_code', '?')}"
        if _is_empty(row.get("sentence_translated", "")):
            errors.append(ValidationError(
                "vocabulary_sentence_i18n", ref, "empty 'sentence_translated'",
            ))

    # ── Cross-checks ─────────────────────────────────────────────────────

    # Every master_symbol in kanji_components must exist in radicals
    if not kanji_components.empty and not radicals.empty:
        comp_symbols = set(kanji_components["master_symbol"])
        missing = comp_symbols - radical_symbols
        for sym in sorted(missing):
            errors.append(ValidationError(
                "kanji_components", f"master_symbol={sym}",
                "references radical not in batch radicals.csv",
            ))

    # Every character in vocabulary_kanji must exist in kanji (batch or pushed)
    if not vocabulary_kanji.empty:
        pushed_kanji = _get_pushed_kanji_from_other_batches(name)
        all_available_kanji = kanji_chars | pushed_kanji
        vocab_kanji_chars = set(vocabulary_kanji["character"])
        missing_kanji = vocab_kanji_chars - all_available_kanji
        for ch in sorted(missing_kanji):
            errors.append(ValidationError(
                "vocabulary_kanji", f"character={ch}",
                "references kanji not in this batch or any previously-pushed batch",
            ))

    # Log summary
    if errors:
        log.warning("Validation found %d errors in batch '%s'", len(errors), name)
    else:
        log.info("Batch '%s' passed validation", name)

    return errors
