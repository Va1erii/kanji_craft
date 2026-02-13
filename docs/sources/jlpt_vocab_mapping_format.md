# JLPT Vocabulary Mapping Format Reference

## Overview

The JLPT vocabulary mapping files provide curated word-to-JLPT-level mappings for the current (post-2010) N1–N5 scale. Like the kanji JLPT lists, no official vocabulary lists exist for the new JLPT levels — this dataset is compiled from community-maintained Anki decks originally derived from Jonathan Waller's [Tanos](https://www.tanos.co.uk/jlpt/) word lists.

**Primary source:** [Jamie Sinclair's Open Anki JLPT Decks](https://github.com/jamsinclair/open-anki-jlpt-decks) (MIT license), based on [chyyran/jlpt-anki-decks](https://github.com/chyyran/jlpt-anki-decks), originally derived from tanos.co.uk.

**Source files:** `sources/jlpt_vocab_mapping/n1.csv` through `n5.csv` (one file per JLPT level).

**Admin asset:** Bundled as mandatory Flutter assets in the admin app. Auto-loaded into the local Drift database on first app launch.

See [attributions.md](../legal/attributions.md) for license details and required credits.

## File Format

Standard CSV with a header row and RFC 4180 quoting (the `meaning` column contains commas).

| Column | Type | Description |
|---|---|---|
| `expression` | Text | The vocabulary word as written (kanji or kana) |
| `reading` | Text | The pronunciation in kana. Empty for some kana-only entries (see §Edge Cases) |
| `meaning` | Text | English meaning(s), comma-separated. **Not consumed by the pipeline** — meanings come from JMdict |
| `tags` | Text | Space-separated tags including JLPT level markers and textbook references |
| `guid` | Text | Anki GUID. **Not consumed by the pipeline** |

**Encoding:** UTF-8, Unix line endings (LF).

**Files and row counts** (header excluded):

| File | Level | Rows |
|---|---|---|
| `n5.csv` | N5 | 718 |
| `n4.csv` | N4 | 668 |
| `n3.csv` | N3 | 2,140 |
| `n2.csv` | N2 | 1,906 |
| `n1.csv` | N1 | 2,699 |
| **Total** | | **8,131** |

After deduplication (same expression + reading across files): **8,034 unique entries**.

### Sample Rows (n5.csv)

```csv
expression,reading,meaning,tags,guid
会う,あう,"to meet, to see",JLPT JLPT_3 JLPT_5 JLPT_N5,kupB!kWE}<
青,あお,blue,JLPT JLPT_5 JLPT_N5,HB)I{+$j.i
開く,あく,"to open, to become open",JLPT JLPT_3 JLPT_5 JLPT_N5,ePBk-uM?*t
```

## Tag Format

Tags are space-separated. The pipeline only cares about JLPT level tags — all others are ignored.

**Two tag formats exist across files:**

| Tag pattern | Files | Meaning |
|---|---|---|
| `JLPT_N5`, `JLPT_N4` | n4.csv, n5.csv | New-style (post-2010) JLPT level |
| `JLPT_1`, `JLPT_2`, `JLPT_3` | n1.csv, n2.csv, n3.csv | Old-style JLPT level (1:1 with new N1–N3) |

**Why the inconsistency:** The old JLPT levels 1–3 mapped directly to new N1–N3 (no split). Level 4 was split into N4 and N5 during the 2010 reform, so those files use the explicit `JLPT_N4`/`JLPT_N5` tags to disambiguate.

**Parsing rule:** The pipeline does **not** parse tags. Since each file already corresponds to a single JLPT level (by filename), the level is derived from the filename, not the tag content:

| Filename | Level value |
|---|---|
| `n5.csv` | 5 |
| `n4.csv` | 4 |
| `n3.csv` | 3 |
| `n2.csv` | 2 |
| `n1.csv` | 1 |

**Other tags present** (ignored by the pipeline):
- `JLPT` — generic JLPT membership marker
- `Genki`, `Genki_Ln.{N}` — Genki textbook chapter references
- `Intermediate_Japanese`, `Intermediate_Japanese_Ln.{N}` — intermediate textbook references

## Consumed Columns

Only two columns are consumed by the pipeline. The rest are ignored:

| CSV Column | Used? | Notes |
|---|---|---|
| `expression` | Yes | Maps to `source_vocab_levels.expression` |
| `reading` | Yes | Maps to `source_vocab_levels.reading` — critical for disambiguating homographs |
| `meaning` | No | Pipeline uses JMdict glosses instead (richer, multilingual) |
| `tags` | No | Level derived from filename |
| `guid` | No | Anki-internal identifier |

## Why `reading` Is Critical

JMdict often has separate entries for the same kanji expression with different readings — and they can be at different JLPT levels:

| Expression | Reading | Level | Meaning |
|---|---|---|---|
| 開く | あく | N5 | To open (intransitive) |
| 開く | ひらく | N3 | To open (transitive/abstract) |

Matching on `expression` alone would produce ambiguous results. The `(expression, reading)` pair uniquely identifies the word and maps it to the correct JMdict entry and JLPT level.

## Mapping to `source_vocab_levels`

| CSV Column | Table Column | Transformation |
|---|---|---|
| `expression` | `expression` | Direct copy |
| `reading` | `reading` | Direct copy; if empty, copy `expression` (kana-only words) |
| (from filename) | `level` | Integer 1–5 derived from the CSV filename |
| — | `source` | Default `'tanos'` |

The table is loaded by truncating all existing rows and bulk-inserting from all five CSV files. This ensures the table always reflects the current file contents exactly.

### Duplicate Resolution

97 entries appear in multiple files (e.g., する in both n5.csv and n2.csv). When loading:

- Use the **easiest level** (highest number) — e.g., する appearing in N5 and N2 gets `level = 5`. The word is available at the earliest JLPT stage where learners need it.
- Deduplicate on `(expression, reading)`.

## Relationship to Vocabulary Extraction

During vocabulary extraction (Phase 2.5), the pipeline matches `raw_jmdict` entries against `source_vocab_levels` to determine `vocabulary.min_jlpt_level`:

1. Get the headword (`keb`) and primary reading (`reb`) from the JMdict entry.
2. Query `source_vocab_levels` matching **both** `expression` and `reading`.
3. If found → use that level (authoritative).
4. If not found → fall back to `MAX(kanji.min_jlpt_level)` across constituent kanji.

This resolves the "Eki Problem" — see [vocabulary_extraction.md §JLPT Level Strategy](../pipeline/vocabulary_extraction.md#jlpt-level-strategy).

## Edge Cases

### Kana-only expressions with empty reading

Two entries in n4.csv have an empty `reading` column: `ごらんになる` and `かまう`. These are kana-only words where the expression is itself the reading. During loading, copy `expression` to `reading` for these entries.

### Kana-only expressions (general)

1,107 of 8,131 entries are kana-only (e.g., すごい, ありがとう). These map normally — the expression is kana, the reading matches, and the vocabulary word has no kanji to gate on.

### Entries not in JMdict

Some entries in the Tanos list may not match any `raw_jmdict` entry (e.g., textbook-specific phrases, set expressions). These `source_vocab_levels` rows are simply unused — no vocabulary row is created for them. This is not an error.

### Duplicate entries across levels

97 entries appear in more than one level file. Use the easiest (highest-numbered) level per §Duplicate Resolution above.

## Versioning

No versioning scheme — these are curated files, not periodically released archives. The folder is `sources/jlpt_vocab_mapping/` (no version suffix). Updates are manual: download fresh CSVs from the source repository and commit to the project.

Unlike KANJIDIC and KanjiVG sources (which use `{source}-{version}/` folders and are tracked in `data_imports`), the JLPT vocabulary mapping has no import lifecycle. It is loaded directly into `source_vocab_levels` via TRUNCATE + INSERT during Phase 1 ingestion.

## Related Docs

- [vocabulary_extraction.md](../pipeline/vocabulary_extraction.md) — How `source_vocab_levels` feeds into `vocabulary.min_jlpt_level`
- [jlpt_mapping_format.md](jlpt_mapping_format.md) — Kanji JLPT mapping (analogous file for `source_jlpt_levels`)
- [pipeline.md](../pipeline/pipeline.md) — Pipeline orchestration (source loading)
- [attributions.md](../legal/attributions.md) — License and credit requirements
