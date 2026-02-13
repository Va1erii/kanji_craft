# JmdictFurigana

## Overview

Staging table for pre-computed furigana mappings imported from the [JmdictFurigana](https://github.com/Doublevil/JmdictFurigana) dataset. Each row stores the furigana breakdown for a single `(text, reading)` pair — mapping a word and its pronunciation to an ordered list of `ruby`/`rt` segments that split the reading across individual characters.

The pipeline uses this table during vocabulary extraction (Phase 2.5) to construct the `vocabulary.segments` JSONB field, which powers Ghost Kanji rendering in the client app.

See [jmdict_furigana_format.md](../sources/jmdict_furigana_format.md) for the source file format and [vocabulary_extraction.md](../technical/vocabulary_extraction.md) for how segments are constructed.

This is an **admin-only table** — not used by the client app. This table lives in the **Local Supabase** instance (Postgres). Unlike static reference tables (`source_jlpt_levels`, `source_vocab_levels`), this table is tracked in `data_imports` because the dataset is tightly coupled with JMdict and must be updated in lockstep. Access is restricted to the `service_role` key (which bypasses RLS). See [pipeline.md](../technical/pipeline.md) for the stateless admin architecture.

## Entity

### JmdictFurigana (Entity)

One row per unique `(text, reading)` pair in the source dataset. The `furigana` column stores the per-character breakdown as JSONB.

| Field | Type | Description |
|---|---|---|
| `import_id` | `int` | FK to `data_imports`. Part of composite PK with `text` + `reading`. Each re-import creates new rows under a new `import_id` |
| `text` | `String` | The word as written (kanji or kana). Matches a JMdict `keb` or `reb` |
| `reading` | `String` | The full pronunciation in kana. Matches a JMdict `reb` |
| `furigana` | `JSONB` | Ordered array of segment objects (see Furigana Segment Shape below) |
| `created_at` | `DateTime` | Row creation timestamp (auto-set) |

**Composite PK:** `(import_id, text, reading)` — a word with a given reading appears exactly once per import.

### Furigana Segment Shape

Each element in the `furigana` JSONB array:

| Field | Type | Required | Description |
|---|---|---|---|
| `ruby` | `String` | Yes | The character(s) this segment covers |
| `rt` | `String` | No | The kana reading for this segment. Absent for kana-only segments |

**Segment type determination:**
- `rt` present → the `ruby` contains kanji or other non-kana characters that need a reading annotation
- `rt` absent → the `ruby` is already kana and needs no annotation

**Invariant:** Concatenating all `ruby` values in order reproduces the `text` field exactly.

**Example** — 食べる (to eat):

```json
[
  {"ruby": "食", "rt": "た"},
  {"ruby": "べる"}
]
```

**Example** — 大人 (adult, jukujikun):

```json
[
  {"ruby": "大人", "rt": "おとな"}
]
```

## Relationships

```
data_imports  ──1:N──→  jmdict_furigana   (one import, many furigana entries)
jmdict_furigana  ─used by─→  vocabulary.segments  (furigana → VocabularySegment during Phase 2.5)
```

No direct FK to `vocabulary` or `kanji` — the link is resolved at extraction time by matching `text` against JMdict headwords and looking up kanji characters in the `kanji` table.

## Business Rules

1. `(import_id, text, reading)` must be unique — one furigana mapping per word-reading pair per import.
2. `text` must be non-empty.
3. `reading` must be non-empty.
4. `furigana` must be a non-empty JSON array.
5. Concatenating all `ruby` values in the `furigana` array must exactly reproduce `text`.
6. Each `furigana` segment must have a non-empty `ruby` field.
7. When `rt` is present, it must be non-empty.
8. Re-importing the same dataset version produces the same rows (idempotent).
9. Old import versions are preserved for diffing — not deleted on re-import.

## Edge Cases

### BOM in source file
The source JSON file starts with a UTF-8 BOM (`\xEF\xBB\xBF`). The ingestion parser must strip this before JSON decoding.

### Multiple readings for same text
11,651 words have multiple entries with the same `text` but different `reading` values (e.g., 明白 → めいはく and 明白 → あからさま). Each gets its own row. The vocabulary extraction phase matches on **both** `text` and `reading` to select the correct furigana mapping.

### Jukujikun entries
6,550 entries have segments where `ruby` contains multiple kanji characters with a single `rt` reading (e.g., `{"ruby": "大人", "rt": "おとな"}`). The vocabulary extraction phase detects these (multi-character `ruby` with `rt` present) and creates jukujikun segments with `kanji_ids` (list) instead of `kanji_id` (single).

### Entries not consumed by vocabulary extraction
JmdictFurigana covers ~230,000 JMdict entries, but the vocabulary pipeline only imports common words (~8k–15k). Unmatched rows remain in the table but are unused. This is not an error.

### Dataset coupled with JMdict
The furigana mappings are generated from a specific JMdict snapshot. If a new JMdict version adds or modifies entries, the JmdictFurigana dataset should be updated to match. Both sources should use the same or compatible release dates.

## Schema Status

This table does not yet exist in the Supabase schema. The entity spec is documented here ahead of implementation (docs-first design). A migration will be needed to:

1. Add `jmdict_furigana` to the `import_source` enum.
2. Create the `jmdict_furigana` table with composite PK `(import_id, text, reading)`.
3. Add RLS (admin-only, zero policies).

## Related Docs

- [jmdict_furigana_format.md](../sources/jmdict_furigana_format.md) — Source file format (JSON structure, segment types, statistics)
- [vocabulary_extraction.md](../technical/vocabulary_extraction.md) — How furigana data feeds into vocabulary segments (Phase 2.5)
- [vocabulary.md](vocabulary.md) — VocabularySegment format (target of the transformation)
- [raw_jmdict.md](raw_jmdict.md) — JMdict staging table (the dictionary this dataset complements)
- [data_import.md](data_import.md) — Import tracking entity
- [pipeline.md](../technical/pipeline.md) — Pipeline orchestration
