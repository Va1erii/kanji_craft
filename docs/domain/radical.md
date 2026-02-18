# Radical

## Overview

A radical is the smallest meaningful building block of a kanji character — the leaf node in the decomposition chain. Most kanji are composed of a mix of radicals and simpler kanji (see [component_model.md](../adr/component_model.md)). For example, 休 ("rest") = 亻 ("person" radical) + 木 ("tree" radical). A single radical concept can have multiple visual forms depending on where it sits inside a kanji: 水 ("water") becomes 氵 when placed on the left side. In the flattened model, each distinct visual form is its own first-class radical row — 水 and 氵 are separate radicals linked by a shared `family_symbol`. Our app teaches radicals first because recognizing them makes learning kanji significantly easier. Radicals are the entry point of the SRS progression: radical → kanji → vocabulary (see srs.md).

## What Qualifies as a Radical

With multi-level kanji decomposition (see [component_model.md](../adr/component_model.md)), kanji can reference both radicals and simpler kanji as components. This means radicals are reserved for true building blocks — not every character that appears inside another kanji:

| Category | Description |
|---|---|
| **Official Kangxi** | The 214 traditional radicals present in our kanji dataset (~150). Non-negotiable — the foundation of the classification system |
| **Radical-only shapes** | Shapes with no standalone kanji form (e.g. 亻, 氵, 忄, 艹). These can only be radicals |
| **Cross-JLPT protectors** | Higher-JLPT kanji used as components in lower-JLPT kanji. Kept as radicals to avoid SRS blocking — a radical card teaches meaning only (quick), while a kanji card requires learning readings |
| **High-frequency non-official** | Non-Kangxi shapes that appear in many kanji. Threshold determined during pipeline classification |

Characters that don't meet these criteria are referenced as kanji components instead, keeping the radical deck focused (~190–250 radicals).

## Design Rationale: Why Flattened Model?

An earlier design used a separate `radical_variants` table — the parent `radicals` row held the abstract concept (e.g. 人 "person") and child `radical_variants` rows held each positional shape (人 standalone, 亻 hen-form). This was replaced with a flattened model where every shape is its own radical row, linked by `family_symbol`.

**Why the change:**

1. **96.5% of radicals had a single variant.** The extra table was almost entirely 1:1 overhead — 750 of 777 radicals had exactly one shape, making the parent/child split pointless for the vast majority of data.

2. **High-frequency shapes deserve first-class status.** Variant shapes like 亻 (person-hen), 氵 (water-hen), and 忄 (heart-hen) appear in dozens of kanji and are visually distinct from their parent. Learners encounter these shapes constantly — they need their own names, mnemonics, SRS cards, and i18n rows, not a secondary position under a parent radical.

3. **Simpler component linking.** In the old model, `kanji_components.master_symbol` referenced the abstract parent, requiring `resolve_master_symbol()` to map a KanjiVG element back to its parent. In the flattened model, the element IS the radical — no resolution step, no ambiguity.

4. **More accurate per-shape metadata.** `impact_score`, `min_jlpt_level`, and `min_grade` are now computed per shape. 亻 appears in far more kanji than 人 used as a standalone radical — the old model averaged these into a single score on the parent, hiding this difference.

5. **Cleaner pipeline.** One table to scan, one CSV to output, one set of SVGs to match. No variant resolution, no parent/child bookkeeping, no two-pass SVG assignment.

The `family_symbol` field preserves the conceptual grouping (人 and 亻 are related forms of the same concept) without the structural overhead of a separate table.

## Entities

### Radical (Entity)

The source of truth for a radical's core identity. Each distinct visual form (e.g. 水, 氵) is its own radical row. Related shapes are linked via `family_symbol`.

| Field | Type | Description |
|---|---|---|
| `id` | `int` | Unique identifier |
| `master_symbol` | `String` | The radical's canonical character — in the flattened model this IS the shape. Unique across all radicals |
| `stroke_count` | `int` | Stroke count of the master symbol |
| `family_symbol` | `String?` | Groups related shapes — e.g. both 人 and 亻 have family_symbol="人". Null for standalone radicals with no family |
| `positions` | `List<Position>` | All positions where this shape appears, e.g. `["hen"]` for 氵 |
| `impact_score` | `int` | 1–10 rating of how many kanji use this radical. 10 = appears everywhere |
| `min_jlpt_level` | `int?` | The easiest JLPT level this radical appears in (5 = N5, 1 = N1). Null if all containing kanji are outside JLPT |
| `min_grade` | `int?` | The earliest Japanese school grade this appears in. 1–6 = elementary (kyouiku), 8 = secondary/junior high (remaining jouyou). KANJIDIC skips 7. Null if all containing kanji are ungraded |
| `svg_file_name` | `String?` | Local asset filename for the SVG, e.g. "06c34.svg". Null if no SVG exists — client should render `master_symbol` as text fallback |
| `svg_file_url` | `String?` | Remote URL to download the SVG if not bundled locally. Null when svg_file_name is null |
| `svg_hash` | `String?` | Hash of the SVG file contents. Used to detect when a cached SVG is outdated. Null when svg_file_name is null |
| `is_official` | `bool` | `true` for official Kangxi radicals (214 traditional set), `false` for custom radicals invented as learning aids. Defaults to `false` |
| `visual_group` | `String?` | Groups visually similar radicals by shared rendered form, e.g. "月" for both 肉 and 月. Null for radicals with no visual twin |
| `created_at` | `DateTime` | Row creation timestamp (auto-set) |
| `updated_at` | `DateTime` | Last modification timestamp. Auto-bumped on direct changes and when child tables change (propagation trigger) |

**Why `visual_group`?**

Some radicals are visually identical inside kanji (肉 and 月 both render as the same shape). This field groups them so the app can show disambiguation UI — highlighting which meaning applies based on position. The value is the shared visual form (e.g. "月", "阝").

**Why `is_official`?**

Many kanji learning systems create custom radicals that aren't part of the 214 Kangxi set — they're useful mnemonics but don't exist in traditional references. This flag lets the UI distinguish them (e.g. badge, filter) and helps users who already know some Japanese trust which radicals are "real."

**Why `master_symbol` instead of storing every shape?**

In the flattened model, `master_symbol` IS the shape. Each distinct visual form (e.g. 人, 亻) is its own radical row. Related shapes are linked via `family_symbol`.

**Why store both `min_jlpt_level` and `min_grade`?**

Users choose their study path — JLPT-based (N5 → N1) or school-grade-based (grade 1 → 8). Both fields are on the radical itself so filtering is a simple query without joins. These are properties of the radical's earliest appearance, not user preferences.

**Why `impact_score`?**

Helps prioritize which radicals to teach first within a level. A radical appearing in 200 kanji is more valuable to learn early than one appearing in 3.

**Why `svg_file_name` + `svg_file_url` instead of inline SVG data or implicit paths?**

Each radical needs a visual SVG for teaching stroke order and shape recognition. The app uses a local-first resolution strategy: (1) look for `svg_file_name` in bundled assets, (2) check device cache, (3) download from `svg_file_url` and cache locally. Storing both fields explicitly in the schema means the data layer controls which file maps to which entity — no filename conventions to guess, no magic path construction. Common radicals ship pre-bundled for instant offline rendering; rare ones are fetched on demand.

### RadicalI18n (Value Object)

Localized name, system mnemonic, and search data for a radical. One row per radical per language.

| Field | Type | Description |
|---|---|---|
| `radical_id` | `int` | FK to the parent Radical |
| `lang_code` | `String` | ISO 639-1 language code, e.g. "en", "es" |
| `name` | `String` | Localized name, e.g. "Water" (en), "Agua" (es) |
| `system_mnemonic` | `String` | The app-provided learning story to help remember the shape (see mnemonic.md) |
| `search_tags` | `List<String>` | Synonyms for search, e.g. ["liquid", "splash", "ocean"] |
| `disambiguation_note` | `String?` | Teaching text explaining how to distinguish this radical from its visual group siblings. Curated in `pipeline/data/visual_rules.json`, not AI-generated. Null when radical has no visual group |

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
| `tarec` | — | Complement of tare — the enclosed content under a hanging radical (e.g. the inner part under 广) |
| `nyoc` | — | Complement of nyo — the enclosed content above a wrapping radical (e.g. the inner part above 辶) |
| `unknown` | — | Fallback for unclassified positions |

| Field | Type | Description |
|---|---|---|
| `description` | `String` | Human-readable label, e.g. "Left Side", "Top Crown" |

## Relationships

```
Radical ──1:N──→ RadicalI18n       (one radical, one row per language)
Radical ──N:M──→ Kanji             (via KanjiComponent; see kanji_component.md)
```

`Position` is a property of `Radical` itself — the `positions` list stores all the positions where this shape is used across kanji.

## Business Rules

1. Every radical must have a non-empty `master_symbol`.
2. `RadicalI18n` must exist for the default language ("en") at minimum.
3. Radicals are reviewed on meaning only (not reading), since radicals don't have independent pronunciations.
4. A radical's SrsCard must reach `stability >= 7.0` days (see srs.md rule #7) before the kanji that contain it are unlocked for lessons.
5. `impact_score` must be in the range 1–10.
6. `min_jlpt_level`, when present, must be in the range 1–5; `min_grade`, when present, must be in the range 1–8. Null if all containing kanji lack the corresponding field.
7. Every `Radical` must have both `svg_file_name` and `svg_file_url` populated.
8. A radical's `master_symbol` may duplicate a kanji's `character`. Both rows must exist independently — the radical serves as a building block in `kanji_components`, the kanji serves as a learnable item with its own readings and SRS card.
9. When `visual_group` is set on a radical, at least one other radical must share the same `visual_group` value.
10. Radicals in a visual group may have overlapping positions. The `disambiguation_note` clarifies meaning by position tendency, not a strict rule.
11. When `family_symbol` is set on a radical, at least one other radical in the same batch must share the same `family_symbol` value.

## Edge Cases

- **Missing translations:** If a user's language has no `RadicalI18n` row, fall back to "en". Never show a blank name or system mnemonic.
- **SVG asset missing:** If the bundled asset for `svg_file_name` is not found, the app falls back to downloading from `svg_file_url` and caching locally. If both fail (network error, broken URL), the app renders the unicode character (`master_symbol`) as a text fallback.
- **Visually identical radicals:** Some distinct radicals render as the same shape inside kanji (e.g. 肉 "flesh" and 月 "moon" both appear as 月). The `visual_group` field groups them, and `disambiguation_note` in RadicalI18n provides the per-language teaching logic (e.g. "left/bottom = flesh, right/top = moon"). Both fields are sourced from the curated `pipeline/data/visual_rules.json` — not AI-generated — because positional disambiguation requires human-verified accuracy. The app should surface this note whenever a kanji contains a radical from a multi-member visual group.
- **Family groups:** Radicals in the same family (same `family_symbol`) represent different visual forms of the same concept — e.g. 人 (standalone) and 亻 (person-hen). Each is a first-class radical with its own i18n, mnemonics, and SRS card.
- **Dual-identity radicals:** Some radicals are also standalone kanji (e.g., 木 is both Kangxi radical #75 and a kanji meaning "Tree"). Both rows exist independently — the radical row in `radicals` serves as a building block in `kanji_components`, the kanji row in `kanji` serves as a learnable item with readings and an SRS card. The SRS progression: learn 木 as radical (meaning only, quick) → unlocks kanji containing 木 → later learn 木 as kanji (adds readings). This dual identity is natural for many Kangxi radicals and for cross-JLPT protectors (see "What Qualifies as a Radical" above).
- **Kanji-only components:** Characters that appear inside kanji but don't qualify as radicals are referenced via `component_type=kanji` in `kanji_components`. For example, 語 (language) = 言 (kanji component) + 吾 (kanji component). See [kanji_component.md](kanji_component.md).
