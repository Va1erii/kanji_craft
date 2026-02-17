# Phase 4: Release Bundles

Phase 4 pushes content to Supabase in small, fully-reviewed batches. Each batch must be complete (all fields NOT NULL) before pushing.

**Entry point:** `pipeline/src/release.py` (CLI)
**Modules:** `pipeline/src/releases/` (slicer, validator, uploader)

## Commands

```bash
# Slice: create a batch from main CSVs
uv run python -m src.release slice n5_kanji_1 --jlpt 5 --kanji 30 --vocab 60

# Review: generate review.xlsx for side-by-side editing
uv run python -m src.release review n5_kanji_1

# Apply: write review.xlsx edits back to batch CSVs
uv run python -m src.release apply n5_kanji_1

# Validate: check completeness before push
uv run python -m src.release validate n5_kanji_1

# Push: validate + upload to Supabase
uv run python -m src.release push n5_kanji_1
```

## Batch Structure

Each batch lives in `data/releases/<name>/`:

```
data/releases/n5_kanji_1/
  batch.toml                # Batch definition (auto-generated, editable)
  manifest.json             # Push history (auto-generated after push)
  radicals.csv              # Auto-resolved from kanji components
  radical_i18n.csv          # COMPLETE (all 3 langs)
  kanji.csv
  kanji_i18n.csv            # ← review: fill mnemonics, search_tags, add ru
  kanji_readings.csv
  kanji_components.csv
  vocabulary.csv
  vocabulary_i18n.csv       # ← review: fill mnemonics, search_tags
  vocabulary_readings.csv
  vocabulary_kanji.csv
  vocabulary_sentences.csv  # ← review: add furigana to original_text
  vocabulary_sentence_i18n.csv  # ← review: add es/ru translations
```

### batch.toml

```toml
name = "n5_kanji_1"
jlpt_level = 5
version = 1

kanji = [
    "日",
    "一",
    "人",
]

vocab_ids = [
    1156800,
    1160820,
]
```

Editable: you can manually add/remove kanji or vocab IDs before re-slicing.

### manifest.json

Auto-generated after push. Tracks version and push history:

```json
{
  "name": "n5_kanji_1",
  "jlpt_level": 5,
  "current_version": 1,
  "pushes": [
    {
      "version": 1,
      "pushed_at": "2026-02-16T12:00:00+00:00",
      "checksum": "abc123...",
      "rows": {"radicals": 45, "kanji": 30, "vocabulary": 60, ...}
    }
  ]
}
```

## Slice

`src/releases/slicer.py` — `slice_batch(name, jlpt_level, kanji_count, vocab_count)`

### Selection logic

1. **Kanji:** Filter `kanji.csv` by `min_jlpt_level == jlpt_level`, sort by `frequency_rank` ASC, take first `kanji_count`. Auto-excludes kanji already allocated in other batches at the same JLPT level.

2. **Radicals:** Auto-resolved from `kanji_components.csv` — all `master_symbol` values for the selected kanji.

3. **Vocabulary:** Filter `vocabulary.csv` by `min_jlpt_level == jlpt_level`, sort by `frequency_rank` ASC, take first `vocab_count`. Auto-excludes already-allocated vocab IDs.

4. **Related tables:** Each child table is filtered to the selected parent entities.

5. **i18n scaffolding:** For each entity × lang_code combination, if no i18n row exists, a placeholder row with empty fields is created so the reviewer has a CSV row to fill in.

### Auto-exclusion

When creating batch 2 at the same JLPT level, the slicer reads `batch.toml` from all existing batch directories and skips items already allocated. This means sequential slicing works naturally:

```bash
uv run python -m src.release slice n5_kanji_1 --jlpt 5 --kanji 30 --vocab 60  # first 30
uv run python -m src.release slice n5_kanji_2 --jlpt 5 --kanji 30 --vocab 60  # next 30
```

## Review

`src/releases/reviewer.py` — `generate_review_xlsx(name) -> Path`

Generates `review.xlsx` in the batch directory with 4 sheets for side-by-side multilingual editing:

| Sheet | Entity key | Columns | i18n columns (per lang) |
|-------|-----------|---------|------------------------|
| Radicals | `master_symbol` | — | `name`, `system_mnemonic`, `search_tags`, `disambiguation_note` |
| Kanji | `character` | `frequency_rank`, `components` | `meanings`, `system_mnemonic`, `search_tags` |
| Vocabulary | `id` | `word`, `furigana`, `frequency_rank` | `meanings`, `system_mnemonic`, `search_tags` |
| Sentences | `vocabulary_id` | `word`, `original_text` | `sentence_translated` |

The **Kanji** sheet includes a `components` column showing the kanji's decomposition from the batch's `kanji_components.csv`, formatted as `田(top,semantic) + 力(bottom,semantic)`.

i18n columns are pivoted wide: `name_en`, `name_es`, `name_ru`, etc. — one column per language per field.

### Apply

`apply_review_xlsx(name)` reads the edited `review.xlsx` and writes changes back to the batch i18n CSVs.

## Validate

`src/releases/validator.py` — `validate_batch(name) -> list[ValidationError]`

### Per-table checks

| Table | Required non-empty fields |
|-------|--------------------------|
| `radicals` | all columns |
| `radical_i18n` | `name`, `system_mnemonic`, `search_tags` (3 langs per radical) |
| `radical_variants` | all columns |
| `kanji` | all columns |
| `kanji_i18n` | `meanings`, `system_mnemonic`, `search_tags` (3 langs per kanji) |
| `kanji_readings` | all columns |
| `kanji_components` | all columns |
| `vocabulary` | all columns |
| `vocabulary_i18n` | `meanings`, `search_tags` (3 langs). `system_mnemonic` **nullable** (per mnemonic.md) |
| `vocabulary_readings` | all columns |
| `vocabulary_kanji` | all columns |
| `vocabulary_sentences` | `original_text` must contain `{X\|Y}` furigana (unless pure kana) |
| `vocabulary_sentence_i18n` | `sentence_translated` (3 langs per sentence) |

### Cross-checks

- Every `kanji_components.master_symbol` exists in batch `radicals.csv`
- Every `vocabulary_kanji.character` exists in batch kanji OR in previously-pushed batches (checked via `manifest.json` files in other batch directories)
- i18n row count = entity_count x 3 for each i18n table

## Push

`src/releases/uploader.py` — `push_batch(name)`

### Steps

1. **Validate** — runs `validate_batch()`, aborts on any errors.
2. **SVG upload** — for each radical/kanji with `svg_file_name`, reads the file from `data/svg/`, lists remote files in Supabase Storage, uploads missing files.
3. **Upsert tables** — uploads all 13 tables in FK order using Supabase `table.upsert(rows, on_conflict=natural_key)`. Batched in chunks of 500.
4. **URL rewrite** — replaces `localhost:54321` SVG URLs with production `SVG_BASE_URL` from env.
5. **Manifest update** — records push timestamp, row counts, CSV checksum, and version.

### Upload order (FK dependencies)

```
radicals → radical_variants → radical_i18n →
kanji → kanji_readings → kanji_i18n → kanji_components →
vocabulary → vocabulary_readings → vocabulary_i18n →
vocabulary_kanji → vocabulary_sentences → vocabulary_sentence_i18n
```

### Natural keys for upsert

| Table | on_conflict |
|-------|-------------|
| `radicals` | `master_symbol` |
| `radical_variants` | `master_symbol, shape` |
| `radical_i18n` | `master_symbol, lang_code` |
| `kanji` | `character` |
| `kanji_readings` | `character, reading` |
| `kanji_i18n` | `character, lang_code` |
| `kanji_components` | `character, master_symbol, position` |
| `vocabulary` | `id` |
| `vocabulary_readings` | `vocabulary_id, reading` |
| `vocabulary_i18n` | `vocabulary_id, lang_code` |
| `vocabulary_kanji` | `vocabulary_id, character` |
| `vocabulary_sentences` | `vocabulary_id` |
| `vocabulary_sentence_i18n` | `vocabulary_id, lang_code` |

### Version tracking

- First push → version 1
- Re-push with same CSV content → same version (no increment)
- Re-push after editing CSVs → version increments (detected via SHA-256 checksum of all batch CSVs)

### Environment variables

| Variable | Required | Purpose |
|----------|----------|---------|
| `SUPABASE_URL` | push only | Supabase project URL |
| `SUPABASE_SERVICE_ROLE_KEY` | push only | Service role key (bypasses RLS) |
| `SVG_BASE_URL` | push only | Production storage base URL for SVG rewriting |

## Known Data Gaps (at slice time)

These gaps are expected in freshly-sliced batches and must be filled during review:

| Table | Gap | Action |
|-------|-----|--------|
| `kanji_i18n` | `system_mnemonic` empty | Fill with mnemonic story |
| `kanji_i18n` | `search_tags` = `[]` | Fill with search keywords |
| `kanji_i18n` | `ru` rows missing | Fill meanings + mnemonic + tags |
| `vocabulary_i18n` | `search_tags` = `[]` | Fill with search keywords |
| `vocabulary_sentences` | `original_text` plain text | Add `{kanji\|reading}` furigana |
| `vocabulary_sentence_i18n` | ES/RU rows missing | Fill translations |
| `radical_i18n` | COMPLETE | No action needed |
