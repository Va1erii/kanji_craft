# JmdictFurigana Format Reference

## Overview

JmdictFurigana provides pre-computed per-character furigana mappings for every entry in JMdict. Instead of algorithmically splitting a word's reading across its kanji at runtime, this dataset gives an authoritative breakdown: which characters correspond to which kana. The pipeline uses it to construct the `segments` JSONB field on vocabulary rows, enabling Ghost Kanji rendering in the client.

**Primary source:** [Doublevil's JmdictFurigana](https://github.com/Doublevil/JmdictFurigana) — auto-rebuilt monthly from the latest JMdict and KANJIDIC releases via GitHub Actions.

**License:** The data output is CC BY-SA (same as JMdict, since it is derived from JMdict/KANJIDIC). The generator code is MIT. See [attributions.md](../legal/attributions.md).

**Source file:** `sources/jmdictfurigana-{semver}+{date}/JmdictFurigana.json.tar.gz`

## File Format

A gzipped tarball containing a single JSON file: `JmdictFurigana.json`.

**Encoding:** UTF-8 with BOM (`\xEF\xBB\xBF`). The parser must strip the BOM before JSON parsing.

**Structure:** A JSON array of entry objects. Each entry maps one `(text, reading)` pair to a list of furigana segments.

### Entry Schema

```json
{
  "text": "食べる",
  "reading": "たべる",
  "furigana": [
    {"ruby": "食", "rt": "た"},
    {"ruby": "べる"}
  ]
}
```

| Field | Type | Description |
|---|---|---|
| `text` | String | The word as written (matches a JMdict `keb` or `reb`) |
| `reading` | String | The full pronunciation in kana (matches a JMdict `reb`) |
| `furigana` | Array | Ordered list of segments covering the entire word |

### Segment Schema

Each segment in the `furigana` array:

| Field | Type | Required | Description |
|---|---|---|---|
| `ruby` | String | Yes | The character(s) this segment covers |
| `rt` | String | No | The kana reading for this segment. Absent for kana-only segments |

**Segment type determination:**
- `rt` present → the `ruby` contains kanji (or other non-kana characters) that need a reading annotation
- `rt` absent → the `ruby` is already kana and needs no annotation

**Invariant:** Concatenating all `ruby` values in order reproduces the `text` field exactly.

### Dataset Statistics

| Metric | Value |
|---|---|
| Total entries | 230,371 |
| Unique `text` values | 216,374 |
| Texts with multiple readings | 11,651 |
| Jukujikun entries (multi-kanji `ruby`) | 6,550 |

**Segment count distribution:**

| Segments per entry | Count |
|---|---|
| 1 | 7,762 |
| 2 | 91,829 |
| 3 | 64,357 |
| 4 | 43,902 |
| 5 | 12,194 |
| 6+ | 10,327 |
| Max | 19 |

## Segment Types by Example

### Regular Kanji — 冷蔵庫 (Refrigerator)

Each kanji maps to its own reading:

```json
{
  "text": "冷蔵庫",
  "reading": "れいぞうこ",
  "furigana": [
    {"ruby": "冷", "rt": "れい"},
    {"ruby": "蔵", "rt": "ぞう"},
    {"ruby": "庫", "rt": "こ"}
  ]
}
```

### Mixed Kanji/Kana — 食べる (To Eat)

Kanji segments have `rt`; kana segments do not:

```json
{
  "text": "食べる",
  "reading": "たべる",
  "furigana": [
    {"ruby": "食", "rt": "た"},
    {"ruby": "べる"}
  ]
}
```

### Jukujikun — 大人 (Adult)

The reading `おとな` cannot be split per-character. The entire compound is one segment:

```json
{
  "text": "大人",
  "reading": "おとな",
  "furigana": [
    {"ruby": "大人", "rt": "おとな"}
  ]
}
```

**Detection rule:** A segment is jukujikun when `ruby` contains multiple kanji characters and has `rt`. The pipeline creates a jukujikun segment with `kanji_ids` (list) instead of `kanji_id` (single).

### Mixed with Kana Particle — 阿吽の呼吸 (Tacit Understanding)

Interleaved kanji and kana segments:

```json
{
  "text": "阿吽の呼吸",
  "reading": "あうんのこきゅう",
  "furigana": [
    {"ruby": "阿", "rt": "あ"},
    {"ruby": "吽", "rt": "うん"},
    {"ruby": "の"},
    {"ruby": "呼", "rt": "こ"},
    {"ruby": "吸", "rt": "きゅう"}
  ]
}
```

## Mapping to Vocabulary Segments

The pipeline transforms JmdictFurigana entries into the `VocabularySegment` format (see [vocabulary.md §Segments Format](../domain/vocabulary.md#segments-format)):

| JmdictFurigana | VocabularySegment | Transformation |
|---|---|---|
| `ruby` (single kanji, has `rt`) | `{"text", "reading", "kanji_id"}` | Look up `kanji.id` by character |
| `ruby` (multi-kanji, has `rt`) | `{"text", "reading", "kanji_ids"}` | Jukujikun — look up each kanji's ID |
| `ruby` (no `rt`) | `{"text"}` | Kana segment — no reading or kanji reference |

**Key differences from source format:**
- JmdictFurigana uses `ruby`/`rt` naming. VocabularySegment uses `text`/`reading`.
- VocabularySegment adds `kanji_id` or `kanji_ids` (FK to `kanji` table). These are resolved during vocabulary extraction by looking up each kanji character.
- VocabularySegment has no `is_kanji` flag. Segment type is inferred from the presence of `kanji_id`/`kanji_ids`.

## Consumed Fields

| Field | Used? | Notes |
|---|---|---|
| `text` | Yes | Matches against `raw_jmdict` headword (`keb`) or reading (`reb`) |
| `reading` | Yes | Disambiguates entries with multiple readings |
| `furigana[].ruby` | Yes | Becomes `VocabularySegment.text` |
| `furigana[].rt` | Yes | Becomes `VocabularySegment.reading` (when present) |

## Versioning

JmdictFurigana uses **semantic versioning with a build date suffix**: `{semver}+{YYYYMMDD}`.

**Folder naming:** `jmdictfurigana-{semver}+{date}/`

**Example:** `jmdictfurigana-2.3.1+20260125/`

The semver tracks the generator algorithm version. The date suffix tracks which JMdict snapshot was used to generate the data. The dataset auto-rebuilds monthly on the 25th, so the date typically reflects the most recent monthly build.

JmdictFurigana is tracked in `data_imports` (source = `jmdict_furigana`) because the dataset is tightly coupled with JMdict — both are derived from the same dictionary snapshot and should be updated in lockstep. The `source_version` uses the full `{semver}+{date}` string (e.g. `2.3.1+20260125`).

**Required folder contents:**

| File | Description |
|---|---|
| `JmdictFurigana.json.tar.gz` | Gzipped tarball containing `JmdictFurigana.json` |

## Edge Cases

### BOM in JSON
The file starts with a UTF-8 BOM (`\xEF\xBB\xBF`). The parser must strip this before JSON decoding.

### Entries not in our JMdict import
JmdictFurigana covers every JMdict entry (~230k), but the pipeline only imports common words (~8k–15k). Unmatched furigana entries are simply unused.

### Multiple readings for same text
11,651 words have multiple `(text, reading)` entries (e.g., 明白 has readings めいはく and あからさま). The pipeline matches on **both** `text` and `reading` to select the correct furigana mapping.

### Jukujikun detection
When `ruby` contains more than one kanji character, the reading applies to the group as a whole. The pipeline must detect this (multi-character `ruby` with `rt` present) and create a jukujikun segment with `kanji_ids` instead of `kanji_id`.

### Words missing from JmdictFurigana
In rare cases, a vocabulary word may not have a matching entry. The pipeline falls back to heuristic segmentation (see [vocabulary_extraction.md §Segmentation](../technical/vocabulary_extraction.md#segmentation-ghost-kanji-support)).

## Related Docs

- [vocabulary_extraction.md](../technical/vocabulary_extraction.md) — How furigana data feeds into vocabulary segments
- [vocabulary.md](../domain/vocabulary.md) — VocabularySegment format (target schema)
- [jmdict_format.md](jmdict_format.md) — JMdict XML format (the dictionary this dataset is derived from)
- [pipeline.md](../technical/pipeline.md) — Pipeline orchestration (source loading)
- [attributions.md](../legal/attributions.md) — License and credit requirements
