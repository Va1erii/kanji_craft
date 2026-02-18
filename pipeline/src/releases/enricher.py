"""Batch enricher — generate AI template CSVs for a release batch.

Scaffolds template CSVs with read-only context columns and empty fill columns.
The user fills these templates (manually or with AI assistance), then runs
``release merge`` to validate and apply the content into batch CSVs.

Templates are written to ``<batch_dir>/ai/templates/``.
"""

import logging
from pathlib import Path

import pandas as pd

from src.config import PARQUET_DIR, RELEASES_DIR, TARGET_LANGS
from src.enrichers.ph3_2_radical_i18n import _build_en_name_seeds
from src.extractors.shared import write_csv_atomic

log = logging.getLogger(__name__)

# ── Template column definitions ───────────────────────────────────────────────

RADICAL_TEMPLATE_COLS = [
    "master_symbol",
    "en_name_seed",
    "lang_code",
    "name",
    "system_mnemonic",
    "search_tags",
]

KANJI_TEMPLATE_COLS = [
    "character",
    "meanings_en",
    "components",
    "readings",
    "lang_code",
    "system_mnemonic",
    "search_tags",
]

VOCAB_TEMPLATE_COLS = [
    "vocabulary_id",
    "word",
    "furigana",
    "meanings_en",
    "lang_code",
    "system_mnemonic",
    "search_tags",
]

SENTENCE_TEMPLATE_COLS = [
    "vocabulary_id",
    "word",
    "lang_code",
    "original_text",
    "sentence_translated",
]


# ── Helpers ───────────────────────────────────────────────────────────────────


def _read_csv(path: Path) -> pd.DataFrame:
    """Read CSV with string dtype to prevent NaN coercion."""
    return pd.read_csv(path, dtype=str, keep_default_na=False)


def _templates_dir(batch_dir: Path) -> Path:
    """Return the ai/templates/ directory for a batch, creating it if needed."""
    d = batch_dir / "ai" / "templates"
    d.mkdir(parents=True, exist_ok=True)
    return d


# ── Entity scaffolders ────────────────────────────────────────────────────────


def _scaffold_radical(batch_dir: Path) -> Path:
    """Generate radical_i18n_ai.csv template."""
    radicals_df = _read_csv(batch_dir / "radicals.csv")
    master_symbols = set(radicals_df["master_symbol"])

    # Get EN name seeds from KANJIDIC
    warnings: list[dict] = []
    en_names = _build_en_name_seeds(PARQUET_DIR, master_symbols, warnings)
    if warnings:
        for w in warnings:
            log.warning("  %s: %s", w["entity"], w["message"])

    rows: list[dict] = []
    for _, rad in radicals_df.iterrows():
        ms = rad["master_symbol"]
        en_seed = en_names.get(ms, "")
        for lang in TARGET_LANGS:
            rows.append({
                "master_symbol": ms,
                "en_name_seed": en_seed,
                "lang_code": lang,
                "name": "",
                "system_mnemonic": "",
                "search_tags": "",
            })

    df = pd.DataFrame(rows, columns=RADICAL_TEMPLATE_COLS)
    out = _templates_dir(batch_dir) / "radical_i18n_ai.csv"
    write_csv_atomic(df, out)
    log.info(
        "Radical template: %d rows (%d radicals × %d langs)",
        len(df), len(radicals_df), len(TARGET_LANGS),
    )
    return out


def _scaffold_kanji(batch_dir: Path) -> Path:
    """Generate kanji_i18n_ai.csv template."""
    kanji_df = _read_csv(batch_dir / "kanji.csv")
    readings_df = _read_csv(batch_dir / "kanji_readings.csv")
    components_df = _read_csv(batch_dir / "kanji_components.csv")

    # Check if radical names are available (warn if not)
    radical_i18n_path = batch_dir / "radical_i18n.csv"
    radical_names: dict[tuple[str, str], str] = {}
    if radical_i18n_path.exists():
        ri18n = _read_csv(radical_i18n_path)
        empty_names = 0
        for _, row in ri18n.iterrows():
            name = str(row.get("name", "")).strip()
            if name:
                radical_names[(row["master_symbol"], row["lang_code"])] = name
            else:
                empty_names += 1
        if empty_names > 0:
            log.warning(
                "  radical_i18n.csv has %d rows with empty names — "
                "consider merging radical i18n first",
                empty_names,
            )

    # Build onyomi lookup: character → comma-joined onyomi
    onyomi_map: dict[str, str] = {}
    if not readings_df.empty:
        onyomi = readings_df[readings_df["reading_type"] == "onyomi"]
        for char, group in onyomi.groupby("character"):
            onyomi_map[str(char)] = ", ".join(group["reading"])

    # Build component description: character → formatted string
    comp_map: dict[str, str] = {}
    if not components_df.empty:
        for char, group in components_df.groupby("character"):
            parts = []
            for _, c in group.iterrows():
                ms = c["master_symbol"]
                pos = c.get("position", "?")
                hint = c.get("logic_hint", "?")
                parts.append(f"{ms}({pos},{hint})")
            comp_map[str(char)] = " + ".join(parts)

    # Build EN meanings lookup from kanji_i18n
    kanji_i18n_path = batch_dir / "kanji_i18n.csv"
    meanings_map: dict[str, str] = {}
    if kanji_i18n_path.exists():
        ki18n = _read_csv(kanji_i18n_path)
        en_rows = ki18n[ki18n["lang_code"] == "en"]
        for _, row in en_rows.iterrows():
            meanings_map[row["character"]] = row.get("meanings", "[]")

    rows: list[dict] = []
    for _, k in kanji_df.iterrows():
        char = k["character"]
        meanings_en = meanings_map.get(char, "[]")
        components = comp_map.get(char, "")
        readings = onyomi_map.get(char, "")
        for lang in TARGET_LANGS:
            rows.append({
                "character": char,
                "meanings_en": meanings_en,
                "components": components,
                "readings": readings,
                "lang_code": lang,
                "system_mnemonic": "",
                "search_tags": "",
            })

    df = pd.DataFrame(rows, columns=KANJI_TEMPLATE_COLS)
    out = _templates_dir(batch_dir) / "kanji_i18n_ai.csv"
    write_csv_atomic(df, out)
    log.info(
        "Kanji template: %d rows (%d kanji × %d langs)",
        len(df), len(kanji_df), len(TARGET_LANGS),
    )
    return out


def _scaffold_vocab(batch_dir: Path) -> Path:
    """Generate vocab_i18n_ai.csv template."""
    vocab_df = _read_csv(batch_dir / "vocabulary.csv")

    # Build EN meanings from vocab_i18n
    vocab_i18n_path = batch_dir / "vocabulary_i18n.csv"
    meanings_map: dict[str, str] = {}
    if vocab_i18n_path.exists():
        vi18n = _read_csv(vocab_i18n_path)
        en_rows = vi18n[vi18n["lang_code"] == "en"]
        for _, row in en_rows.iterrows():
            meanings_map[str(row["vocabulary_id"])] = row.get("meanings", "[]")

    rows: list[dict] = []
    for _, v in vocab_df.iterrows():
        vid = str(v["id"])
        word = v["word"]
        furigana = v.get("furigana", "")
        meanings_en = meanings_map.get(vid, "[]")
        for lang in TARGET_LANGS:
            rows.append({
                "vocabulary_id": vid,
                "word": word,
                "furigana": furigana,
                "meanings_en": meanings_en,
                "lang_code": lang,
                "system_mnemonic": "",
                "search_tags": "",
            })

    df = pd.DataFrame(rows, columns=VOCAB_TEMPLATE_COLS)
    out = _templates_dir(batch_dir) / "vocab_i18n_ai.csv"
    write_csv_atomic(df, out)
    log.info(
        "Vocab template: %d rows (%d vocab × %d langs)",
        len(df), len(vocab_df), len(TARGET_LANGS),
    )
    return out


def _scaffold_sentence(batch_dir: Path) -> Path:
    """Generate sentence_ai.csv template."""
    vocab_df = _read_csv(batch_dir / "vocabulary.csv")

    rows: list[dict] = []
    for _, v in vocab_df.iterrows():
        vid = str(v["id"])
        word = v["word"]
        for lang in TARGET_LANGS:
            rows.append({
                "vocabulary_id": vid,
                "word": word,
                "lang_code": lang,
                "original_text": "",
                "sentence_translated": "",
            })

    df = pd.DataFrame(rows, columns=SENTENCE_TEMPLATE_COLS)
    out = _templates_dir(batch_dir) / "sentence_ai.csv"
    write_csv_atomic(df, out)
    log.info(
        "Sentence template: %d rows (%d vocab × %d langs)",
        len(df), len(vocab_df), len(TARGET_LANGS),
    )
    return out


# ── Scaffolder dispatch ───────────────────────────────────────────────────────

_SCAFFOLDERS = {
    "radical": _scaffold_radical,
    "kanji": _scaffold_kanji,
    "vocab": _scaffold_vocab,
    "sentence": _scaffold_sentence,
}


# ── Public API ────────────────────────────────────────────────────────────────


def enrich_batch(name: str, entity: str = "all") -> Path:
    """Generate AI template CSVs for a release batch.

    Args:
        name: Batch directory name (e.g. "n5_kanji_1").
        entity: Which entity to scaffold ("radical", "kanji", "vocab",
                "sentence", or "all").

    Returns:
        Path to the batch's ai/templates/ directory.
    """
    batch_dir = RELEASES_DIR / name
    if not batch_dir.exists():
        raise FileNotFoundError(f"Batch directory not found: {batch_dir}")

    if entity == "all":
        targets = list(_SCAFFOLDERS.keys())
    else:
        if entity not in _SCAFFOLDERS:
            valid = list(_SCAFFOLDERS.keys())
            raise ValueError(f"Unknown entity: {entity!r} (choose from {valid})")
        targets = [entity]

    log.info("Enriching batch '%s' — entities: %s", name, ", ".join(targets))

    for target in targets:
        _SCAFFOLDERS[target](batch_dir)

    templates = _templates_dir(batch_dir)
    log.info("Templates written to %s", templates)
    return templates
