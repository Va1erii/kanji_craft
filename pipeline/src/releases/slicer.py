"""Batch slicer — create a release batch from main CSVs.

Selects kanji and vocabulary by JLPT level, auto-resolves radicals from
kanji components, slices all related tables, scaffolds missing i18n rows,
and writes everything to a batch directory under data/releases/<name>/.
"""

import logging
import tomllib
from pathlib import Path

import pandas as pd

from src.config import CSV_DIR, PARQUET_DIR, RELEASES_DIR, TARGET_LANGS
from src.extractors.shared import write_csv_atomic

log = logging.getLogger(__name__)


# ── Helpers ──────────────────────────────────────────────────────────────────


def _read_csv(path: Path) -> pd.DataFrame:
    """Read CSV with string dtype to prevent NaN coercion."""
    return pd.read_csv(path, dtype=str, keep_default_na=False)


def _load_jlpt_vocab_words(jlpt_level: int) -> set[str]:
    """Load Tanos JLPT vocab expressions for a given level.

    Returns the set of 'expression' values from jlpt_vocab.parquet
    that match the target level. Only these words should be included
    in release batches (excludes kanji-derived JLPT assignments).
    """
    pq_path = PARQUET_DIR / "jlpt_vocab.parquet"
    if not pq_path.exists():
        log.warning("jlpt_vocab.parquet not found — no vocab filtering applied")
        return set()
    df = pd.read_parquet(pq_path)
    return set(df[df["level"] == jlpt_level]["expression"])


def _find_already_allocated(
    jlpt_level: int,
    exclude_name: str | None = None,
) -> tuple[set[str], set[int]]:
    """Scan existing batch directories for already-allocated items at this JLPT level.

    Returns (allocated_kanji_set, allocated_vocab_id_set).
    Skips the batch named `exclude_name` (so re-slicing doesn't conflict with itself).
    """
    allocated_kanji: set[str] = set()
    allocated_vocab: set[int] = set()

    if not RELEASES_DIR.exists():
        return allocated_kanji, allocated_vocab

    for batch_dir in sorted(RELEASES_DIR.iterdir()):
        if not batch_dir.is_dir():
            continue
        if exclude_name and batch_dir.name == exclude_name:
            continue
        toml_path = batch_dir / "batch.toml"
        if not toml_path.exists():
            continue
        try:
            with open(toml_path, "rb") as f:
                batch = tomllib.load(f)
        except Exception:
            log.warning("Skipping unreadable %s", toml_path)
            continue
        if batch.get("jlpt_level") != jlpt_level:
            continue
        allocated_kanji.update(batch.get("kanji", []))
        allocated_vocab.update(batch.get("vocab_ids", []))

    return allocated_kanji, allocated_vocab


def _write_batch_toml(path: Path, data: dict) -> None:
    """Write batch.toml in a simple TOML format."""
    lines = [
        f'name = "{data["name"]}"',
        f'jlpt_level = {data["jlpt_level"]}',
        f'version = {data["version"]}',
        "",
        "kanji = [",
    ]
    for ch in data["kanji"]:
        lines.append(f'    "{ch}",')
    lines.append("]")
    lines.append("")
    lines.append("vocab_ids = [")
    for vid in data["vocab_ids"]:
        lines.append(f"    {vid},")
    lines.append("]")
    lines.append("")
    path.write_text("\n".join(lines), encoding="utf-8")
    log.info("Wrote %s", path.name)


def _scaffold_i18n(
    df: pd.DataFrame,
    entity_key_col: str,
    entity_keys: list[str],
    columns: list[str],
) -> pd.DataFrame:
    """Ensure every entity × lang_code has a row. Add placeholders for missing combos."""
    existing = set()
    for _, row in df.iterrows():
        existing.add((str(row[entity_key_col]), row["lang_code"]))

    new_rows = []
    for key in entity_keys:
        for lang in TARGET_LANGS:
            if (str(key), lang) not in existing:
                placeholder = {col: "" for col in columns}
                placeholder[entity_key_col] = key
                placeholder["lang_code"] = lang
                # Default empty JSON arrays for list-type fields
                for col in columns:
                    if col in ("search_tags", "meanings"):
                        placeholder[col] = "[]"
                new_rows.append(placeholder)

    if new_rows:
        new_df = pd.DataFrame(new_rows, columns=columns)
        df = pd.concat([df, new_df], ignore_index=True)
        log.info("Scaffolded %d missing i18n rows for %s", len(new_rows), entity_key_col)

    return df


# ── Main entry point ─────────────────────────────────────────────────────────


def slice_batch(
    name: str,
    jlpt_level: int,
    kanji_count: int,
    vocab_count: int,
) -> Path:
    """Create a release batch by slicing main CSVs.

    Args:
        name: Batch directory name (e.g. "n5_kanji_1").
        jlpt_level: JLPT level to filter by (1-5).
        kanji_count: Number of kanji to include.
        vocab_count: Number of vocabulary items to include.

    Returns:
        Path to the created batch directory.
    """
    batch_dir = RELEASES_DIR / name
    batch_dir.mkdir(parents=True, exist_ok=True)

    log.info(
        "Slicing batch '%s' — JLPT %d, %d kanji, %d vocab",
        name, jlpt_level, kanji_count, vocab_count,
    )

    # Find already-allocated items at this JLPT level (from other batches)
    allocated_kanji, allocated_vocab = _find_already_allocated(jlpt_level, exclude_name=name)
    if allocated_kanji:
        log.info("Excluding %d already-allocated kanji from other batches", len(allocated_kanji))
    if allocated_vocab:
        log.info("Excluding %d already-allocated vocab from other batches", len(allocated_vocab))

    # ── 1. Select kanji ──────────────────────────────────────────────────

    kanji_df = _read_csv(CSV_DIR / "kanji.csv")
    kanji_df["min_jlpt_level"] = pd.to_numeric(kanji_df["min_jlpt_level"])
    kanji_df["frequency_rank"] = pd.to_numeric(kanji_df["frequency_rank"])

    kanji_at_level = kanji_df[kanji_df["min_jlpt_level"] == jlpt_level]
    kanji_available = kanji_at_level[~kanji_at_level["character"].isin(allocated_kanji)]
    kanji_pool = kanji_available.sort_values("frequency_rank").head(kanji_count).copy()
    selected_kanji = set(kanji_pool["character"])
    total_kanji_at_level = len(kanji_at_level)
    remaining_kanji = len(kanji_available) - len(selected_kanji)

    # ── 2. Resolve radicals from kanji_components ────────────────────────

    components_df = _read_csv(CSV_DIR / "kanji_components.csv")
    batch_components = components_df[components_df["character"].isin(selected_kanji)]
    resolved_radicals = set(batch_components["master_symbol"])

    radicals_df = _read_csv(CSV_DIR / "radicals.csv")
    batch_radicals = radicals_df[radicals_df["master_symbol"].isin(resolved_radicals)]
    log.info("Resolved %d radicals from kanji components", len(batch_radicals))

    # ── 3. Select vocabulary ─────────────────────────────────────────────
    # Only include vocab with a direct JLPT mapping (Tanos word list),
    # excluding kanji-derived fallback assignments.

    jlpt_vocab_words = _load_jlpt_vocab_words(jlpt_level)

    vocab_df = _read_csv(CSV_DIR / "vocabulary.csv")
    vocab_df["min_jlpt_level"] = pd.to_numeric(vocab_df["min_jlpt_level"])
    vocab_df["frequency_rank"] = pd.to_numeric(vocab_df["frequency_rank"])
    vocab_df["id"] = pd.to_numeric(vocab_df["id"])

    vocab_at_level = vocab_df[
        (vocab_df["min_jlpt_level"] == jlpt_level)
        & (vocab_df["word"].isin(jlpt_vocab_words))
    ]
    vocab_available = vocab_at_level[~vocab_at_level["id"].isin(allocated_vocab)]
    vocab_pool = vocab_available.sort_values("frequency_rank").head(vocab_count).copy()
    selected_vocab_ids = set(vocab_pool["id"].astype(int))
    total_vocab_at_level = len(vocab_at_level)
    remaining_vocab = len(vocab_available) - len(selected_vocab_ids)

    # ── 4. Slice related tables ──────────────────────────────────────────

    radical_variants_df = _read_csv(CSV_DIR / "radical_variants.csv")
    batch_variants = radical_variants_df[
        radical_variants_df["master_symbol"].isin(resolved_radicals)
    ]

    radical_i18n_df = _read_csv(CSV_DIR / "radical_i18n.csv")
    batch_radical_i18n = radical_i18n_df[
        radical_i18n_df["master_symbol"].isin(resolved_radicals)
    ]

    kanji_readings_df = _read_csv(CSV_DIR / "kanji_readings.csv")
    batch_kanji_readings = kanji_readings_df[
        kanji_readings_df["character"].isin(selected_kanji)
    ]

    kanji_i18n_df = _read_csv(CSV_DIR / "kanji_i18n.csv")
    batch_kanji_i18n = kanji_i18n_df[kanji_i18n_df["character"].isin(selected_kanji)]

    vocab_readings_df = _read_csv(CSV_DIR / "vocabulary_readings.csv")
    vocab_readings_df["vocabulary_id"] = pd.to_numeric(vocab_readings_df["vocabulary_id"])
    batch_vocab_readings = vocab_readings_df[
        vocab_readings_df["vocabulary_id"].isin(selected_vocab_ids)
    ]

    vocab_i18n_df = _read_csv(CSV_DIR / "vocabulary_i18n.csv")
    vocab_i18n_df["vocabulary_id"] = pd.to_numeric(vocab_i18n_df["vocabulary_id"])
    batch_vocab_i18n = vocab_i18n_df[vocab_i18n_df["vocabulary_id"].isin(selected_vocab_ids)]

    vocab_kanji_df = _read_csv(CSV_DIR / "vocabulary_kanji.csv")
    vocab_kanji_df["vocabulary_id"] = pd.to_numeric(vocab_kanji_df["vocabulary_id"])
    batch_vocab_kanji = vocab_kanji_df[
        vocab_kanji_df["vocabulary_id"].isin(selected_vocab_ids)
    ]

    vocab_sentences_df = _read_csv(CSV_DIR / "vocabulary_sentences.csv")
    vocab_sentences_df["vocabulary_id"] = pd.to_numeric(vocab_sentences_df["vocabulary_id"])
    batch_vocab_sentences = vocab_sentences_df[
        vocab_sentences_df["vocabulary_id"].isin(selected_vocab_ids)
    ]

    vocab_sentence_i18n_df = _read_csv(CSV_DIR / "vocabulary_sentence_i18n.csv")
    vocab_sentence_i18n_df["vocabulary_id"] = pd.to_numeric(
        vocab_sentence_i18n_df["vocabulary_id"]
    )
    batch_vocab_sentence_i18n = vocab_sentence_i18n_df[
        vocab_sentence_i18n_df["vocabulary_id"].isin(selected_vocab_ids)
    ]

    # ── 5. Scaffold missing i18n rows ────────────────────────────────────

    batch_radical_i18n = _scaffold_i18n(
        batch_radical_i18n.copy(),
        "master_symbol",
        sorted(resolved_radicals),
        list(radical_i18n_df.columns),
    )

    batch_kanji_i18n = _scaffold_i18n(
        batch_kanji_i18n.copy(),
        "character",
        sorted(selected_kanji),
        list(kanji_i18n_df.columns),
    )

    batch_vocab_i18n = _scaffold_i18n(
        batch_vocab_i18n.copy(),
        "vocabulary_id",
        sorted(selected_vocab_ids),
        list(vocab_i18n_df.columns),
    )

    # Scaffold vocabulary_sentence_i18n for sentences that exist in this batch
    sentence_vocab_ids = sorted(batch_vocab_sentences["vocabulary_id"].unique())
    batch_vocab_sentence_i18n = _scaffold_i18n(
        batch_vocab_sentence_i18n.copy(),
        "vocabulary_id",
        sentence_vocab_ids,
        list(vocab_sentence_i18n_df.columns),
    )

    # ── 6. Write batch.toml ──────────────────────────────────────────────

    # Determine version: keep existing if re-slicing, else 1
    toml_path = batch_dir / "batch.toml"
    version = 1
    if toml_path.exists():
        try:
            with open(toml_path, "rb") as f:
                old = tomllib.load(f)
            version = old.get("version", 1)
        except Exception:
            pass

    # Sort kanji by frequency rank order from the pool
    freq_rank = dict(zip(
        kanji_pool["character"], kanji_pool["frequency_rank"], strict=False,
    ))
    sorted_kanji = sorted(selected_kanji, key=lambda c: freq_rank.get(c, 0))

    _write_batch_toml(toml_path, {
        "name": name,
        "jlpt_level": jlpt_level,
        "version": version,
        "kanji": sorted_kanji,
        "vocab_ids": sorted(selected_vocab_ids),
    })

    # ── 7. Write all CSVs ────────────────────────────────────────────────

    def _w(df: pd.DataFrame, filename: str) -> None:
        write_csv_atomic(df.reset_index(drop=True), batch_dir / filename)

    _w(batch_radicals, "radicals.csv")
    _w(batch_variants, "radical_variants.csv")
    _w(batch_radical_i18n, "radical_i18n.csv")
    _w(kanji_pool, "kanji.csv")
    _w(batch_kanji_readings, "kanji_readings.csv")
    _w(batch_kanji_i18n, "kanji_i18n.csv")
    _w(batch_components, "kanji_components.csv")
    _w(vocab_pool, "vocabulary.csv")
    _w(batch_vocab_readings, "vocabulary_readings.csv")
    _w(batch_vocab_i18n, "vocabulary_i18n.csv")
    _w(batch_vocab_kanji, "vocabulary_kanji.csv")
    _w(batch_vocab_sentences, "vocabulary_sentences.csv")
    _w(batch_vocab_sentence_i18n, "vocabulary_sentence_i18n.csv")

    # ── Summary ────────────────────────────────────────────────────────

    log.info("─── Batch '%s' sliced → %s", name, batch_dir)
    log.info("  Kanji:      %d selected  (N%d total: %d, remaining: %d%s)",
             len(selected_kanji), jlpt_level, total_kanji_at_level,
             remaining_kanji, " ✓ all done" if remaining_kanji == 0 else "")
    log.info("  Radicals:   %d auto-resolved", len(resolved_radicals))
    log.info("  Vocabulary: %d selected  (N%d total: %d, remaining: %d%s)",
             len(selected_vocab_ids), jlpt_level, total_vocab_at_level,
             remaining_vocab, " ✓ all done" if remaining_vocab == 0 else "")

    return batch_dir
