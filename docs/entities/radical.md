# Radical

## Overview

A radical is the smallest meaningful building block of a kanji character. Most kanji are composed of one or more radicals — for example, the kanji 休 ("rest") combines the radicals 亻 ("person") and 木 ("tree"). A single radical can appear in many different visual forms depending on where it sits inside a kanji: 水 ("water") becomes 氵 when placed on the left side. Our app teaches radicals first because recognizing them — in all their shapes — makes learning kanji significantly easier. Radicals are the entry point of the SRS progression: radical → kanji → vocabulary (see srs.md).

## Entities

### Radical (Entity)

The source of truth for a radical's core identity. Uses the master symbol (the simplest full form) as the anchor. All variants, translations, and examples link back here.

| Field | Type | Description |
|---|---|---|
| `id` | `int` | Unique identifier |
| `master_symbol` | `String` | The base kanji form, e.g. "水". Unique across all radicals |
| `stroke_count` | `int` | Stroke count of the master symbol |
| `impact_score` | `int` | 1–10 rating of how many kanji use this radical. 10 = appears everywhere |
| `min_jlpt_level` | `int` | The easiest JLPT level this radical appears in (5 = N5, 1 = N1) |
| `min_grade` | `int` | The earliest Japanese school grade this appears in (1–6) |
| `svg_file_name` | `String` | Local asset filename for the master symbol SVG, e.g. "06c34.svg" |
| `svg_file_url` | `String` | Remote URL to download the SVG if not bundled locally |

**Why `master_symbol` instead of storing every shape?**

A radical can look different depending on position (水 → 氵), but its identity is always the same. The master symbol is the canonical form; visual variants live in `RadicalVariant`.

**Why store both `min_jlpt_level` and `min_grade`?**

Users choose their study path — JLPT-based (N5 → N1) or school-grade-based (grade 1 → 6). Both fields are on the radical itself so filtering is a simple query without joins. These are properties of the radical's earliest appearance, not user preferences.

**Why `impact_score`?**

Helps prioritize which radicals to teach first within a level. A radical appearing in 200 kanji is more valuable to learn early than one appearing in 3.

**Why `svg_file_name` + `svg_file_url` instead of inline SVG data or implicit paths?**

Each radical and variant needs a visual SVG for teaching stroke order and shape recognition. The app uses a local-first resolution strategy: (1) look for `svg_file_name` in bundled assets, (2) check device cache, (3) download from `svg_file_url` and cache locally. Storing both fields explicitly in the schema means the data layer controls which file maps to which entity — no filename conventions to guess, no magic path construction. Common radicals ship pre-bundled for instant offline rendering; rare ones are fetched on demand.

### RadicalI18n (Value Object)

Localized name, system mnemonic, and search data for a radical. One row per radical per language.

| Field | Type | Description |
|---|---|---|
| `radical_id` | `int` | FK to the parent Radical |
| `lang_code` | `String` | ISO 639-1 language code, e.g. "en", "es", "fr" |
| `name` | `String` | Localized name, e.g. "Water" (en), "Agua" (es) |
| `system_mnemonic` | `String` | The app-provided learning story to help remember the shape (see mnemonic.md) |
| `search_tags` | `List<String>` | Synonyms for search, e.g. ["liquid", "splash", "ocean"] |

**Why separate from Radical?**

The master symbol and shape never change across languages. Only the human-readable text grows as languages are added. This keeps the content pipeline clean — translators work in `RadicalI18n` without touching core data.

### Position (Enum)

The spatial position a radical occupies within a kanji character. Uses traditional Japanese naming conventions. Each value carries a human-readable `description`.

| Value | Japanese Name | Description |
|---|---|---|
| `hen` | 偏 | Left side (e.g. 亻 in 休) |
| `tsukuri` | 旁 | Right side (e.g. 力 in 助) |
| `kanmuri` | 冠 | Top crown (e.g. 宀 in 家) |
| `ashi` | 脚 | Bottom legs (e.g. 灬 in 点) |
| `kamae` | 構 | Enclosure (e.g. 囗 in 国) |
| `tare` | 垂 | Hanging top-left (e.g. 广 in 店) |
| `nyo` | 繞 | Wrapping bottom-left (e.g. 辶 in 道) |
| `unknown` | — | Fallback for unclassified positions |

| Field | Type | Description |
|---|---|---|
| `description` | `String` | Human-readable label, e.g. "Left Side", "Top Crown" |

### RadicalVariant (Entity)

A specific visual form a radical takes when placed in a particular position inside a kanji. One radical can have multiple variants.

| Field | Type | Description |
|---|---|---|
| `id` | `int` | Unique identifier |
| `radical_id` | `int` | FK to the parent Radical |
| `shape` | `String` | The specific form, e.g. "氵" |
| `position` | `Position` | Where this shape appears |
| `is_locked` | `bool` | If `true`, this shape never moves to another position (e.g. 氵 is always left) |
| `svg_file_name` | `String` | Local asset filename for the variant SVG, e.g. "06c35.svg" |
| `svg_file_url` | `String` | Remote URL to download the SVG if not bundled locally |

**Why `is_locked`?**

Some variants are structurally fixed — 氵 only ever appears on the left. Knowing this simplifies teaching ("this shape = this position, always") and lets the UI skip position-selection for locked variants.

## Relationships

```
Radical ──1:N──→ RadicalI18n       (one radical, one row per language)
Radical ──1:N──→ RadicalVariant    (one radical, many visual forms)
Radical ──N:M──→ Kanji             (via KanjiComponent; see kanji_component.md)
```

`Position` is a property of `RadicalVariant`, not of the radical itself — the same radical (e.g. 水/氵) can appear in different positions in different kanji.

## Business Rules

1. Every radical must have a non-empty `master_symbol`.
2. Every radical must have at least one `RadicalVariant`.
3. `RadicalI18n` must exist for the default language ("en") at minimum.
4. `position` + `radical_id` should be unique in `RadicalVariant` — a radical doesn't have two different shapes for the same position.
5. Radicals are reviewed on meaning only (not reading), since radicals don't have independent pronunciations.
6. A radical's SrsCard must reach `stability >= 7.0` days (see srs.md rule #7) before the kanji that contain it are unlocked for lessons.
7. `impact_score` must be in the range 1–10.
8. `min_jlpt_level` must be in the range 1–5; `min_grade` must be in the range 1–6.
9. Every `Radical` and `RadicalVariant` must have both `svg_file_name` and `svg_file_url` populated.

## Edge Cases

- **Radical with a single variant:** Some radicals look the same in every position (e.g. 口). They still get one `RadicalVariant` row — the model is consistent regardless of variant count.
- **Locked vs unlocked variants:** A locked variant (e.g. 氵, always left) means the UI can skip position context. An unlocked variant means the app should show "this shape can appear here or here."
- **Missing translations:** If a user's language has no `RadicalI18n` row, fall back to "en". Never show a blank name or system mnemonic.
- **Radical reuse across positions:** The same radical (e.g. 口) can appear as `left` in one kanji and `enclosure` in another. This is modeled through separate `RadicalVariant` rows, not special-cased.
- **Radicals with no kanji:** During early content seeding, a radical may exist before any kanji reference it (see kanji_component.md). The radical is still reviewable; the composition section in the UI should show an empty state.
- **SVG asset missing:** If the bundled asset for `svg_file_name` is not found, the app falls back to downloading from `svg_file_url` and caching locally. If both fail (network error, broken URL), the app renders the unicode character (`master_symbol` or variant `shape`) as a text fallback.
