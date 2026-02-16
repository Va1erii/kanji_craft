"""Pipeline configuration constants."""

from pathlib import Path

# ── Directories ──────────────────────────────────────────────────────────────

_PIPELINE_ROOT = Path(__file__).resolve().parent.parent

PARQUET_DIR: Path = _PIPELINE_ROOT / "data" / "parquet"
CSV_DIR: Path = _PIPELINE_ROOT / "data" / "csv"
RELEASES_DIR: Path = _PIPELINE_ROOT / "data" / "releases"
SVG_DIR: Path = _PIPELINE_ROOT / "data" / "svg"

# ── Languages ────────────────────────────────────────────────────────────────

# Canonical target languages (ISO 639-1).
# Add a language here to include it in all CSV i18n outputs.
TARGET_LANGS: list[str] = ["en", "es", "ru"]

# JMdict uses ISO 639-2/B 3-letter codes for glosses.
# Map canonical 2-letter → JMdict 3-letter codes.
JMDICT_LANG_MAP: dict[str, str] = {
    "en": "eng",
    "es": "spa",
    "ru": "rus",
    "fr": "fre",
    "pt": "por",
    "de": "ger",
    "nl": "dut",
    "hu": "hun",
    "sv": "swe",
    "sl": "slv",
}

# ── Release / Upload ────────────────────────────────────────────────────────

# Upsert order respects FK dependencies (parents before children).
TABLE_UPLOAD_ORDER: list[str] = [
    "radicals",
    "radical_i18n",
    "kanji",
    "kanji_readings",
    "kanji_i18n",
    "kanji_components",
    "vocabulary",
    "vocabulary_readings",
    "vocabulary_i18n",
    "vocabulary_kanji",
    "vocabulary_sentences",
    "vocabulary_sentence_i18n",
]

# Natural keys used for upsert conflict resolution per table.
TABLE_NATURAL_KEYS: dict[str, str] = {
    "radicals": "master_symbol",
    "radical_i18n": "master_symbol,lang_code",
    "kanji": "character",
    "kanji_readings": "character,reading",
    "kanji_i18n": "character,lang_code",
    "kanji_components": "character,master_symbol,position",
    "vocabulary": "id",
    "vocabulary_readings": "vocabulary_id,reading",
    "vocabulary_i18n": "vocabulary_id,lang_code",
    "vocabulary_kanji": "vocabulary_id,character",
    "vocabulary_sentences": "vocabulary_id",
    "vocabulary_sentence_i18n": "vocabulary_id,lang_code",
}
