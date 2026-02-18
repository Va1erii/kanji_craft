"""Batch merger — validate AI-filled template CSVs and merge into batch CSVs.

Validates format (column count, headers, key integrity, JSON arrays) then
merges non-empty fill columns into the corresponding batch CSVs. Filled
template CSVs persist in ``ai/templates/`` as the record of what AI produced.

Usage:
    merge_batch("n5_kanji_1", entity="radical")
    merge_batch("n5_kanji_1", entity="all", dry_run=True)
"""

import json
import logging
from pathlib import Path

import pandas as pd

from src.config import RELEASES_DIR, TARGET_LANGS
from src.extractors.shared import write_csv_atomic

log = logging.getLogger(__name__)


# ── Helpers ───────────────────────────────────────────────────────────────────


def _read_csv(path: Path) -> pd.DataFrame:
    """Read CSV with string dtype to prevent NaN coercion."""
    return pd.read_csv(path, dtype=str, keep_default_na=False)


def _is_valid_json_array(value: str) -> bool:
    """Check if a string is a valid non-empty JSON array."""
    value = value.strip()
    if not value:
        return False
    try:
        parsed = json.loads(value)
        return isinstance(parsed, list) and len(parsed) > 0
    except (json.JSONDecodeError, TypeError):
        return False


def _validate_headers(
    ai_df: pd.DataFrame,
    expected_cols: list[str],
    template_name: str,
    errors: list[str],
) -> bool:
    """Check that AI CSV has exactly the expected columns in order."""
    actual = list(ai_df.columns)
    if actual != expected_cols:
        errors.append(
            f"{template_name}: expected columns {expected_cols}, got {actual}"
        )
        return False
    return True


def _validate_key_coverage(
    ai_df: pd.DataFrame,
    batch_df: pd.DataFrame,
    key_cols: list[str],
    template_name: str,
    errors: list[str],
) -> bool:
    """Check that AI CSV has all key combinations from batch CSV."""
    ok = True

    # Build sets of key tuples
    def _key_set(df: pd.DataFrame) -> set[tuple[str, ...]]:
        return {tuple(str(row[c]) for c in key_cols) for _, row in df.iterrows()}

    batch_keys = _key_set(batch_df)
    ai_keys = _key_set(ai_df)

    missing = batch_keys - ai_keys
    if missing:
        sample = sorted(missing)[:5]
        errors.append(
            f"{template_name}: {len(missing)} missing key(s) — "
            f"e.g. {sample}"
        )
        ok = False

    extra = ai_keys - batch_keys
    if extra:
        sample = sorted(extra)[:5]
        errors.append(
            f"{template_name}: {len(extra)} extra key(s) not in batch — "
            f"e.g. {sample}"
        )
        ok = False

    return ok


def _validate_lang_coverage(
    ai_df: pd.DataFrame,
    template_name: str,
    errors: list[str],
) -> bool:
    """Check that all target languages are present."""
    ok = True
    langs = set(ai_df["lang_code"].unique())
    missing = set(TARGET_LANGS) - langs
    if missing:
        errors.append(f"{template_name}: missing lang_code(s): {sorted(missing)}")
        ok = False
    return ok


def _validate_json_array_col(
    ai_df: pd.DataFrame,
    col: str,
    template_name: str,
    errors: list[str],
) -> None:
    """Warn about non-empty values that aren't valid JSON arrays."""
    for idx, row in ai_df.iterrows():
        val = str(row[col]).strip()
        if not val:
            continue
        try:
            parsed = json.loads(val)
            if not isinstance(parsed, list):
                errors.append(
                    f"{template_name} row {idx}: '{col}' is not a JSON array: {val[:80]}"
                )
        except (json.JSONDecodeError, TypeError):
            errors.append(
                f"{template_name} row {idx}: '{col}' is invalid JSON: {val[:80]}"
            )


# ── Entity mergers ────────────────────────────────────────────────────────────


def _merge_radical(batch_dir: Path, dry_run: bool) -> int:
    """Validate and merge radical_i18n_ai.csv into radical_i18n.csv."""
    template_name = "radical_i18n_ai.csv"
    ai_path = batch_dir / "ai" / "templates" / template_name
    batch_path = batch_dir / "radical_i18n.csv"

    if not ai_path.exists():
        log.info("  %s not found — skipping radical merge", template_name)
        return 0

    ai_df = _read_csv(ai_path)
    batch_df = _read_csv(batch_path)
    errors: list[str] = []

    expected_cols = [
        "master_symbol", "en_name_seed", "lang_code",
        "name", "system_mnemonic", "search_tags",
    ]
    if not _validate_headers(ai_df, expected_cols, template_name, errors):
        raise ValueError("\n".join(errors))

    _validate_key_coverage(
        ai_df, batch_df, ["master_symbol", "lang_code"], template_name, errors,
    )
    _validate_lang_coverage(ai_df, template_name, errors)
    _validate_json_array_col(ai_df, "search_tags", template_name, errors)

    if errors:
        raise ValueError("\n".join(errors))

    # Build AI lookup
    ai_lookup: dict[tuple[str, str], dict] = {}
    for _, row in ai_df.iterrows():
        key = (str(row["master_symbol"]).strip(), str(row["lang_code"]).strip())
        ai_lookup[key] = dict(row)

    # Merge fill columns
    fill_cols = ["name", "system_mnemonic", "search_tags"]
    changes = 0
    result = batch_df.copy()

    for idx, row in result.iterrows():
        key = (str(row["master_symbol"]).strip(), str(row["lang_code"]).strip())
        ai_row = ai_lookup.get(key)
        if ai_row is None:
            continue
        for col in fill_cols:
            ai_val = str(ai_row.get(col, "")).strip()
            if ai_val:
                old_val = str(row[col]).strip()
                if ai_val != old_val:
                    if dry_run:
                        log.info(
                            "  [dry-run] %s %s.%s: %r → %r",
                            key, template_name, col, old_val[:40], ai_val[:40],
                        )
                    else:
                        result.at[idx, col] = ai_val
                    changes += 1

    if not dry_run and changes > 0:
        write_csv_atomic(result, batch_path)

    return changes


def _merge_kanji(batch_dir: Path, dry_run: bool) -> int:
    """Validate and merge kanji_i18n_ai.csv into kanji_i18n.csv."""
    template_name = "kanji_i18n_ai.csv"
    ai_path = batch_dir / "ai" / "templates" / template_name
    batch_path = batch_dir / "kanji_i18n.csv"

    if not ai_path.exists():
        log.info("  %s not found — skipping kanji merge", template_name)
        return 0

    ai_df = _read_csv(ai_path)
    batch_df = _read_csv(batch_path)
    errors: list[str] = []

    expected_cols = [
        "character", "meanings_en", "components", "readings",
        "lang_code", "system_mnemonic", "search_tags",
    ]
    if not _validate_headers(ai_df, expected_cols, template_name, errors):
        raise ValueError("\n".join(errors))

    _validate_key_coverage(
        ai_df, batch_df, ["character", "lang_code"], template_name, errors,
    )
    _validate_lang_coverage(ai_df, template_name, errors)
    _validate_json_array_col(ai_df, "search_tags", template_name, errors)

    if errors:
        raise ValueError("\n".join(errors))

    # Build AI lookup
    ai_lookup: dict[tuple[str, str], dict] = {}
    for _, row in ai_df.iterrows():
        key = (str(row["character"]).strip(), str(row["lang_code"]).strip())
        ai_lookup[key] = dict(row)

    # Merge fill columns
    fill_cols = ["system_mnemonic", "search_tags"]
    changes = 0
    result = batch_df.copy()

    for idx, row in result.iterrows():
        key = (str(row["character"]).strip(), str(row["lang_code"]).strip())
        ai_row = ai_lookup.get(key)
        if ai_row is None:
            continue
        for col in fill_cols:
            ai_val = str(ai_row.get(col, "")).strip()
            if ai_val:
                old_val = str(row[col]).strip()
                if ai_val != old_val:
                    if dry_run:
                        log.info(
                            "  [dry-run] %s %s.%s: %r → %r",
                            key, template_name, col, old_val[:40], ai_val[:40],
                        )
                    else:
                        result.at[idx, col] = ai_val
                    changes += 1

    if not dry_run and changes > 0:
        write_csv_atomic(result, batch_path)

    return changes


def _merge_vocab(batch_dir: Path, dry_run: bool) -> int:
    """Validate and merge vocab_i18n_ai.csv into vocabulary_i18n.csv."""
    template_name = "vocab_i18n_ai.csv"
    ai_path = batch_dir / "ai" / "templates" / template_name
    batch_path = batch_dir / "vocabulary_i18n.csv"

    if not ai_path.exists():
        log.info("  %s not found — skipping vocab merge", template_name)
        return 0

    ai_df = _read_csv(ai_path)
    batch_df = _read_csv(batch_path)
    errors: list[str] = []

    expected_cols = [
        "vocabulary_id", "word", "furigana", "meanings_en",
        "lang_code", "system_mnemonic", "search_tags",
    ]
    if not _validate_headers(ai_df, expected_cols, template_name, errors):
        raise ValueError("\n".join(errors))

    _validate_key_coverage(
        ai_df, batch_df, ["vocabulary_id", "lang_code"], template_name, errors,
    )
    _validate_lang_coverage(ai_df, template_name, errors)
    _validate_json_array_col(ai_df, "search_tags", template_name, errors)

    if errors:
        raise ValueError("\n".join(errors))

    # Build AI lookup
    ai_lookup: dict[tuple[str, str], dict] = {}
    for _, row in ai_df.iterrows():
        key = (str(row["vocabulary_id"]).strip(), str(row["lang_code"]).strip())
        ai_lookup[key] = dict(row)

    # Merge fill columns
    fill_cols = ["system_mnemonic", "search_tags"]
    changes = 0
    result = batch_df.copy()

    for idx, row in result.iterrows():
        key = (str(row["vocabulary_id"]).strip(), str(row["lang_code"]).strip())
        ai_row = ai_lookup.get(key)
        if ai_row is None:
            continue
        for col in fill_cols:
            ai_val = str(ai_row.get(col, "")).strip()
            if ai_val:
                old_val = str(row[col]).strip()
                if ai_val != old_val:
                    if dry_run:
                        log.info(
                            "  [dry-run] %s %s.%s: %r → %r",
                            key, template_name, col, old_val[:40], ai_val[:40],
                        )
                    else:
                        result.at[idx, col] = ai_val
                    changes += 1

    if not dry_run and changes > 0:
        write_csv_atomic(result, batch_path)

    return changes


def _merge_sentence(batch_dir: Path, dry_run: bool) -> int:
    """Validate and merge sentence_ai.csv into batch sentence CSVs."""
    template_name = "sentence_ai.csv"
    ai_path = batch_dir / "ai" / "templates" / template_name
    sentences_path = batch_dir / "vocabulary_sentences.csv"
    sentence_i18n_path = batch_dir / "vocabulary_sentence_i18n.csv"

    if not ai_path.exists():
        log.info("  %s not found — skipping sentence merge", template_name)
        return 0

    ai_df = _read_csv(ai_path)
    errors: list[str] = []

    expected_cols = [
        "vocabulary_id", "word", "lang_code",
        "original_text", "sentence_translated",
    ]
    if not _validate_headers(ai_df, expected_cols, template_name, errors):
        raise ValueError("\n".join(errors))

    _validate_lang_coverage(ai_df, template_name, errors)

    if errors:
        raise ValueError("\n".join(errors))

    # Merge original_text into vocabulary_sentences.csv
    sentences_df = _read_csv(sentences_path) if sentences_path.exists() else pd.DataFrame()
    sentence_i18n_df = (
        _read_csv(sentence_i18n_path)
        if sentence_i18n_path.exists() else pd.DataFrame()
    )

    # Build AI lookup by (vocabulary_id, lang_code)
    ai_lookup: dict[tuple[str, str], dict] = {}
    for _, row in ai_df.iterrows():
        key = (str(row["vocabulary_id"]).strip(), str(row["lang_code"]).strip())
        ai_lookup[key] = dict(row)

    changes = 0

    # Update original_text in vocabulary_sentences.csv
    # Use EN row's original_text (Japanese is the same for all langs)
    if not sentences_df.empty:
        result_sentences = sentences_df.copy()
        for idx, row in result_sentences.iterrows():
            vid = str(row["vocabulary_id"]).strip()
            # Prefer EN row for original_text
            ai_row = ai_lookup.get((vid, "en"))
            if ai_row is None:
                continue
            ai_text = str(ai_row.get("original_text", "")).strip()
            if ai_text:
                old_text = str(row["original_text"]).strip()
                if ai_text != old_text:
                    if dry_run:
                        log.info(
                            "  [dry-run] vocab_id=%s sentences.original_text: %r → %r",
                            vid, old_text[:40], ai_text[:40],
                        )
                    else:
                        result_sentences.at[idx, "original_text"] = ai_text
                    changes += 1

        if not dry_run and changes > 0:
            write_csv_atomic(result_sentences, sentences_path)
    else:
        # No existing sentences — create from AI template
        new_rows = []
        seen_vids: set[str] = set()
        for (vid, _lang), ai_row in sorted(ai_lookup.items()):
            if vid in seen_vids:
                continue
            ai_text = str(ai_row.get("original_text", "")).strip()
            if ai_text:
                new_rows.append({"vocabulary_id": vid, "original_text": ai_text})
                seen_vids.add(vid)
                changes += 1
        if new_rows and not dry_run:
            new_df = pd.DataFrame(new_rows, columns=["vocabulary_id", "original_text"])
            write_csv_atomic(new_df, sentences_path)

    # Update sentence_translated in vocabulary_sentence_i18n.csv
    i18n_changes = 0
    if not sentence_i18n_df.empty:
        result_i18n = sentence_i18n_df.copy()
        for idx, row in result_i18n.iterrows():
            vid = str(row["vocabulary_id"]).strip()
            lang = str(row["lang_code"]).strip()
            ai_row = ai_lookup.get((vid, lang))
            if ai_row is None:
                continue
            ai_trans = str(ai_row.get("sentence_translated", "")).strip()
            if ai_trans:
                old_trans = str(row.get("sentence_translated", "")).strip()
                if ai_trans != old_trans:
                    if dry_run:
                        log.info(
                            "  [dry-run] vocab_id=%s,lang=%s i18n.sentence_translated: %r → %r",
                            vid, lang, old_trans[:40], ai_trans[:40],
                        )
                    else:
                        result_i18n.at[idx, "sentence_translated"] = ai_trans
                    i18n_changes += 1

        if not dry_run and i18n_changes > 0:
            write_csv_atomic(result_i18n, sentence_i18n_path)
    else:
        # No existing i18n — create from AI template
        new_rows = []
        for (vid, lang), ai_row in sorted(ai_lookup.items()):
            ai_trans = str(ai_row.get("sentence_translated", "")).strip()
            if ai_trans:
                new_rows.append({
                    "vocabulary_id": vid,
                    "lang_code": lang,
                    "sentence_translated": ai_trans,
                })
                i18n_changes += 1
        if new_rows and not dry_run:
            new_df = pd.DataFrame(
                new_rows,
                columns=["vocabulary_id", "lang_code", "sentence_translated"],
            )
            write_csv_atomic(new_df, sentence_i18n_path)

    return changes + i18n_changes


# ── Merger dispatch ───────────────────────────────────────────────────────────

_MERGERS: dict[str, callable] = {
    "radical": _merge_radical,
    "kanji": _merge_kanji,
    "vocab": _merge_vocab,
    "sentence": _merge_sentence,
}


# ── Public API ────────────────────────────────────────────────────────────────


def merge_batch(name: str, entity: str = "all", dry_run: bool = False) -> int:
    """Validate and merge AI-filled template CSVs into batch CSVs.

    Args:
        name: Batch directory name (e.g. "n5_kanji_1").
        entity: Which entity to merge ("radical", "kanji", "vocab",
                "sentence", or "all").
        dry_run: If True, validate only and log what would change.

    Returns:
        Total number of field changes applied (or that would be applied).

    Raises:
        FileNotFoundError: If batch directory doesn't exist.
        ValueError: If template CSV validation fails.
    """
    batch_dir = RELEASES_DIR / name
    if not batch_dir.exists():
        raise FileNotFoundError(f"Batch directory not found: {batch_dir}")

    if entity == "all":
        targets = list(_MERGERS.keys())
    else:
        if entity not in _MERGERS:
            raise ValueError(f"Unknown entity: {entity!r} (choose from {list(_MERGERS.keys())})")
        targets = [entity]

    mode = "dry-run" if dry_run else "merge"
    log.info("Merging batch '%s' (%s) — entities: %s", name, mode, ", ".join(targets))

    total = 0
    for target in targets:
        count = _MERGERS[target](batch_dir, dry_run)
        if count:
            log.info("  %s: %d field change(s)%s", target, count, " (dry-run)" if dry_run else "")
        else:
            log.info("  %s: no changes", target)
        total += count

    log.info("Total: %d field change(s)%s", total, " (dry-run)" if dry_run else "")
    return total
