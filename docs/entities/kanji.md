# Kanji

## Overview

A kanji is a logographic character used in the Japanese writing system, originally borrowed from Chinese. Each kanji carries one or more meanings and multiple pronunciations split across two systems: *onyomi* (Sino-Japanese, derived from Chinese) and *kunyomi* (native Japanese). For example, the kanji 日 means "day/sun" and has onyomi ニチ・ジツ plus kunyomi ひ・か. Our app teaches kanji through spaced repetition after the user has mastered the radicals that compose each character — the progression is radical → kanji → vocabulary (see srs.md).

## Entities

### ReadingPriority (Enum)

Indicates whether a reading is a primary or secondary pronunciation for the kanji.

| Value | Description |
|---|---|
| `primary` | A core reading taught during initial lessons. A kanji can have multiple primary readings per type (e.g. ニチ and ジツ are both primary onyomi for 日) |
| `secondary` | A less common reading shown for reference but not tested during early SRS stages |

### Kanji (Entity)

The core identity of a single kanji character. Holds language-independent data: the character itself, structural metadata, and level classifications.

| Field | Type | Description |
|---|---|---|
| `id` | `int` | Unique identifier |
| `character` | `String` | The kanji character, e.g. "日", "人", "大". Unique across all kanji |
| `stroke_count` | `int` | Number of strokes to write the character |
| `min_jlpt_level` | `int?` | The easiest JLPT level this kanji appears in (5 = N5, 1 = N1). Null for kanji outside the JLPT set |
| `min_grade` | `int?` | The earliest Japanese school grade this kanji is taught (1–6). Null for kanji outside the jouyou set |
| `frequency_rank` | `int` | Frequency rank based on newspaper corpus (1 = most common). Used for ordering within a level |
| `svg_file_name` | `String` | Local asset filename for the kanji SVG, e.g. "065e5.svg" |
| `svg_file_url` | `String` | Remote URL to download the SVG if not bundled locally |

**Why `min_jlpt_level` and `min_grade` are nullable here but not on Radical?**

Every radical in our dataset is tied to at least one JLPT level and grade because it appears inside graded kanji. But some valid kanji exist outside both the JLPT test set and the jouyou (school) set — rare or literary characters that users on either path would never encounter unless explicitly searching.

**Why `frequency_rank` in addition to level/grade?**

JLPT level and school grade define *which* kanji to teach but not the order within a level. `frequency_rank` lets the app prioritize common kanji first: within N5, 日 (rank ~1) should come before 右 (rank ~602). This is the kanji equivalent of Radical's `impact_score`.

### KanjiReading (Entity)

A single pronunciation of a kanji. Each kanji has one or more readings, categorized by type (onyomi or kunyomi) and priority.

| Field | Type | Description |
|---|---|---|
| `id` | `int` | Unique identifier |
| `kanji_id` | `int` | FK to the parent Kanji |
| `reading` | `String` | The pronunciation in kana, e.g. "ニチ", "ひ" |
| `reading_type` | `ReadingType` | `onyomi` or `kunyomi` (see reading_type.dart) |
| `priority` | `ReadingPriority` | `primary` or `secondary` |

**Why a separate entity instead of a list on Kanji?**

A kanji like 日 has four readings across two types and two priority levels. Normalizing into its own entity avoids JSON arrays in the schema, makes querying by reading type trivial, and lets SRS logic target individual readings.

**Why `priority` instead of `sort_order`?**

Sort order implies a strict linear ranking, but multiple readings can be equally important. 日 has two primary onyomi (ニチ and ジツ) — neither is "first". A priority enum captures this cleanly: both are `primary`, both are tested early.

### KanjiI18n (Value Object)

Localized meanings, mnemonic, and search data for a kanji. One row per kanji per language.

| Field | Type | Description |
|---|---|---|
| `kanji_id` | `int` | FK to the parent Kanji |
| `lang_code` | `String` | ISO 639-1 language code, e.g. "en", "es" |
| `meanings` | `List<String>` | Localized meanings in priority order, e.g. ["day", "sun", "Japan"] |
| `mnemonic` | `String` | A learning story to help remember the character's shape and meaning |
| `search_tags` | `List<String>` | Synonyms and related terms for search, e.g. ["solar", "daily", "date"] |

**Why `meanings` is a list, not a single string?**

Kanji are inherently polysemous. 日 means "day", "sun", and (in compounds) "Japan". Storing meanings as an ordered list maps naturally to how dictionaries present kanji and lets the app show the primary meaning first while keeping alternatives accessible.

## Relationships

```
Kanji  ──1:N──→ KanjiReading      (one kanji, many pronunciations)
Kanji  ──1:N──→ KanjiI18n         (one kanji, one row per language)
Kanji  ──1:N──→ KanjiComponent    (one kanji, many radical components; see kanji_component.md)
Kanji  ──N:M──→ Radical           (via KanjiComponent; see radical.md)
```

`ReadingType` and `ReadingPriority` are properties of `KanjiReading`, not of the kanji itself.

## Business Rules

1. Every kanji must have a non-empty `character` (single Unicode code point).
2. Every kanji must have at least one `KanjiReading`.
3. Every kanji must have at least one `primary` reading.
4. `KanjiI18n` must exist for the default language ("en") at minimum.
5. `meanings` in `KanjiI18n` must have at least one entry.
6. A kanji cannot enter `lesson` status until all its radicals (via `KanjiComponent`) have reached `guru1` SRS stage (see srs.md).
7. Kanji are reviewed on both meaning and reading — unlike radicals, which are meaning-only.
8. `frequency_rank` must be a positive integer (1 = most common).
9. `min_jlpt_level`, when present, must be in the range 1–5; `min_grade`, when present, must be in the range 1–6.
10. Every `Kanji` must have both `svg_file_name` and `svg_file_url` populated.
11. `kanji_id` + `reading` + `reading_type` must be unique in `KanjiReading` — no duplicate readings.

## Edge Cases

- **Kanji with no JLPT level:** Some valid jouyou kanji are not assigned a JLPT level. These are invisible to users on the JLPT path but appear for grade-path users. Filter queries must handle null `min_jlpt_level`.
- **Kanji with no grade:** Non-jouyou kanji have no school grade assignment. Same filtering concern as above.
- **Multiple primary readings per type:** This is normal, not an error. 日 has two primary onyomi (ニチ, ジツ). SRS should test all primary readings, not just the first.
- **SVG asset missing:** Same local-first fallback as radicals (see radical.md): bundled asset → remote download → unicode character text fallback.
- **Missing translations:** If a user's language has no `KanjiI18n` row, fall back to "en". Never show blank meanings or mnemonic.
- **Kanji with no components:** Should not happen in production — every kanji is composed of at least one radical. Flag in content validation tooling (see kanji_component.md).
- **Rare kanji outside both JLPT and grade:** These have null `min_jlpt_level` and null `min_grade`. They should only surface via explicit search, never in the default lesson queue.
