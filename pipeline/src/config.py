"""Pipeline configuration constants."""

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
