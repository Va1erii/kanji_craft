# Source Vocab Levels

## Overview

Local reference table mapping vocabulary words to their JLPT N1–N5 levels. Populated from the [Open Anki JLPT Decks](https://github.com/jamsinclair/open-anki-jlpt-decks) CSV files during Phase 1 ingestion. The pipeline uses this table during vocabulary extraction (Phase 2.6) to resolve `vocabulary.min_jlpt_level` — taking precedence over kanji-derived levels.

This table solves the "Eki Problem": some words are tested at a JLPT level that differs from their constituent kanji levels (e.g., 駅 is an N5 vocabulary word but uses an N4 kanji). See [vocabulary_extraction.md §JLPT Level Strategy](../technical/vocabulary_extraction.md#jlpt-level-strategy).

This is a **local-only reference table** — not synced to Remote, not tracked in `data_imports`. It follows the same pattern as `source_jlpt_levels`: TRUNCATE + INSERT on each load, no version lifecycle. Access is restricted to the `service_role` key (which bypasses RLS).

See [jlpt_vocab_mapping_format.md](../sources/jlpt_vocab_mapping_format.md) for the source file format.

## Entity

### SourceVocabLevel (Entity)

One row per unique `(expression, reading)` pair. The `(expression, reading)` composite key is critical for disambiguating homographs — the same kanji expression can appear at different JLPT levels depending on its reading.

| Field | Type | Description |
|---|---|---|
| `expression` | `String` | The vocabulary word as written (kanji or kana). Matches a JMdict `keb` or `reb` |
| `reading` | `String` | The pronunciation in kana. Required for homograph disambiguation (e.g., 開く read as あく vs ひらく) |
| `level` | `int` | JLPT level (5 = N5 easiest, 1 = N1 hardest) |
| `source` | `String` | Data provenance. Default `'tanos'` |

**Composite PK:** `(expression, reading)` — a word with a given reading appears exactly once.

## Relationships

```
source_vocab_levels  ─used by─→  vocabulary.min_jlpt_level  (lookup during Phase 2.6)
```

No FK relationships — this is a standalone reference table consumed by the extraction algorithm.

## Business Rules

1. `(expression, reading)` must be unique.
2. `expression` must be non-empty.
3. `reading` must be non-empty. For kana-only entries where the source CSV has an empty reading, copy `expression` to `reading` during loading.
4. `level` must be between 1 and 5.
5. `source` must be non-empty. Default `'tanos'`.
6. When the same `(expression, reading)` appears in multiple source files (97 duplicates across n1–n5), keep the **easiest level** (highest number). The word is available at the earliest JLPT stage where learners need it.
7. The table is loaded via TRUNCATE + INSERT — always reflects the current source files exactly.

## Edge Cases

### Homographs at different levels
The same kanji expression can have different JLPT levels depending on reading:

| Expression | Reading | Level | Meaning |
|---|---|---|---|
| 開く | あく | 5 (N5) | To open (intransitive) |
| 開く | ひらく | 3 (N3) | To open (transitive/abstract) |

The vocabulary extraction phase matches on **both** `expression` and `reading` against `raw_jmdict` headword/reading pairs.

### Kana-only entries with empty reading
Two entries in the source CSV (`ごらんになる` and `かまう` in n4.csv) have empty `reading` columns. During loading, copy `expression` to `reading` — these are kana-only words where the expression is itself the reading.

### Entries not in JMdict
Some entries may not match any `raw_jmdict` entry (e.g., textbook-specific phrases). These rows are simply unused during extraction — no vocabulary row is created for them.

### Cross-file duplicates
97 entries appear in multiple level files (e.g., する in both n5.csv and n2.csv). Resolved during loading by keeping the easiest level (see rule #6).

## Level Distribution

| Level | Label | Count |
|---|---|---|
| N1 | 1 | ~2,699 |
| N2 | 2 | ~1,906 |
| N3 | 3 | ~2,140 |
| N4 | 4 | ~668 |
| N5 | 5 | ~718 |
| **Total (after dedup)** | | **~8,034** |

## Schema Status

This table does not yet exist in the Supabase schema. The entity spec is documented here ahead of implementation (docs-first design). A migration will be needed to:

1. Create the `source_vocab_levels` table with composite PK `(expression, reading)`.
2. Add CHECK constraint on `level` (1–5).
3. Add RLS (admin-only, zero policies).

The table mirrors the pattern of `source_jlpt_levels` (see [migration 20260211015427](../../supabase/migrations/20260211015427_source_jlpt_levels.sql)).

## Related Docs

- [jlpt_vocab_mapping_format.md](../sources/jlpt_vocab_mapping_format.md) — Source CSV format (tag parsing, duplicate resolution, edge cases)
- [vocabulary_extraction.md](../technical/vocabulary_extraction.md) — How `source_vocab_levels` feeds into `vocabulary.min_jlpt_level` (Phase 2.6)
- [vocabulary.md](vocabulary.md) — Vocabulary entity spec (target schema)
- [pipeline.md](../technical/pipeline.md) — Pipeline orchestration (Phase 1 loading)
- [attributions.md](../legal/attributions.md) — License and credit requirements
