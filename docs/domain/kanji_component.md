# KanjiComponent

## Overview

A kanji component is the connection between a radical and a kanji — it records the fact that a specific radical appears inside a specific kanji, and what role it plays there. This is the bridge table that makes it possible to look up all radicals inside a kanji, or all kanji that use a given radical. It also carries metadata that belongs to neither side alone, most importantly the `logic_hint` that explains whether the radical contributes meaning or sound.

## Entities

### LogicHint (Enum)

Describes the role a radical plays inside a specific kanji. About 80% of Jōyō kanji are phono-semantic compounds (形声文字, keisei moji) — they combine a meaning radical with a sound radical in predictable positions.

| Value | Description |
|---|---|
| `semantic` | The radical contributes to the kanji's meaning. e.g. 氵 (Water) in 清 (Pure) — water categorizes the concept |
| `phonetic` | The radical contributes to the kanji's reading (pronunciation), not its meaning. e.g. 青 (SEI) in 清 (SEI) — the reading carries over |

**Position-based prediction patterns:**

| Structure | Semantic (meaning) | Phonetic (sound) | Example |
|---|---|---|---|
| Left-Right (⿰) | Left | Right | 江 (River): 氵 Water + 工 KOU → reading KOU |
| Top-Bottom (⿱) | Top | Bottom | 花 (Flower): 艹 Grass + 化 KA → reading KA |
| Enclosure (⿴) | Outside | Inside | 聞 (Hear): 門 Gate + 耳 ear → reading MON/BUN |

The left-right pattern is by far the most common. When a kanji has a recognized radical on the left (hen position), it almost always provides the meaning category, while the right side (tsukuri) provides the sound.

**Phonetic families:** Radicals that act as phonetic components create "sound families" — groups of kanji that share the same reading. e.g. 青 (SEI) → 清 (SEI), 晴 (SEI), 精 (SEI). Recognizing the phonetic component lets learners predict readings for unfamiliar kanji.

See [teaching.md](teaching.md) for how the app uses these patterns in lessons (color coding, sound match indicators, card types).

### RadicalType (Enum)

Classifies the role a component plays within a specific kanji, based on KanjiVG's `kvg:radical` attribute. This is a **per-component-per-kanji** property — the same radical can be `general` in one kanji and `component` in another.

| Value | Description |
|---|---|
| `general` | The generally accepted dictionary radical for this kanji. This is "the boss" — the one used to look up the character in a dictionary |
| `tradit` | The traditional Kangxi radical, when it differs from the general consensus |
| `nelson` | The Nelson dictionary radical, when it differs from the general/tradit assignment |
| `jis` | The JIS Kanji Jiten radical (used by KANJIDIC), when it differs from other references |
| `component` | A normal building block with no radical designation. Default value |

**Note:** `RadicalType` on KanjiComponent is distinct from `is_official` on Radical. `is_official` is a **static property** of the radical itself ("Is 亻 one of the 214 Kangxi radicals?" — always true). `radical_type` is a **contextual role** ("Is 亻 the dictionary radical *for this specific kanji*?" — varies per kanji).

### KanjiComponent (Entity)

Each row represents one radical appearing inside one kanji. It carries metadata that belongs to neither the radical nor the kanji individually.

| Field | Type | Description |
|---|---|---|
| `id` | `int` | Unique identifier |
| `kanji_id` | `int` | FK to the Kanji (see kanji.md) |
| `radical_id` | `int` | FK to the Radical (see radical.md) |
| `position` | `Position` | Where this radical sits inside this kanji (see radical.md Position enum) |
| `logic_hint` | `LogicHint` | Whether this radical contributes meaning or sound in this specific kanji |
| `radical_type` | `RadicalType` | The dictionary classification role of this component within this kanji. Defaults to `component` |
| `is_primary` | `bool` | Computed. `true` only when `radical_type == general`. Used for dictionary/reference mode lookups |
| `created_at` | `DateTime` | Row creation timestamp (auto-set) |
| `updated_at` | `DateTime` | Last modification timestamp (auto-set) |

**Why `position` on KanjiComponent, not just on RadicalVariant?**

`RadicalVariant` records what shapes a radical *can* take at each position. `KanjiComponent.position` records where the radical *actually sits* in a specific kanji. For example, 口 can appear as `hen` (left), `ashi` (bottom), or `kamae` (enclosure) depending on the kanji. The position per kanji is what the decomposition tree view needs to show the spatial layout.

**Why `logic_hint` on KanjiComponent, not on Radical?**

The same radical can play different roles in different kanji. For example, 亡 is **phonetic** in 忙 (busy) — it's only there because its Chinese reading BOU matches the kanji's reading. But 亡 is **semantic** in 死 (death) — it directly contributes to the meaning. Placing `logic_hint` per radical-kanji pair captures this accurately.

This field is critical for teaching. Without it, a user sees 忄 (Heart) + 亡 (Death) = 忙 (Busy) and thinks the system is broken. With a phonetic hint, the app can explain: "亡 is here for its sound (BOU), not its meaning."

**Why `radical_type` on KanjiComponent, not on Radical?**

The same radical can be the dictionary radical in one kanji and just a building block in another. For example, 心 (Heart) is `general` in 想 (Thought) — it's the radical you'd use to look up 想 in a dictionary. But in 忙 (Busy), 心 appears as 忄 and is still `general`. Meanwhile 木 (Tree) is `component` in 想 — it's essential for the mnemonic decomposition but not the dictionary index.

The app uses this distinction in two modes:
- **Lesson mode (Lego):** Shows all components regardless of `radical_type`. "Build 想 from 木 + 目 + 心."
- **Dictionary mode:** Filters to `is_primary == true`. "Radical: 心 (Heart)."

## Relationships

```
Radical ──1:N──→ KanjiComponent    (one radical appears in many kanji; see radical.md)
Kanji  ──1:N──→ KanjiComponent    (one kanji is composed of many radicals; see kanji.md)
```

## Business Rules

1. `kanji_id` + `radical_id` + `position` must be unique — a radical appears at a given position in a given kanji exactly once.
2. Every `KanjiComponent` must have a `logic_hint` value. Default to `semantic` if unknown during content seeding.
3. Every `KanjiComponent` must have a `radical_type` value. Default to `component`.
4. `radical_type` is sourced from the KanjiVG `kvg:radical` attribute during extraction. Components without a `kvg:radical` attribute receive `component`.
5. `is_primary` is a computed property: `true` only when `radical_type == general`. It is not stored as a separate column — in PostgreSQL it is a generated column; in Dart it is a getter.
6. A kanji should have at most one component with `radical_type = general`. Multiple `tradit` or `nelson` entries are possible when references disagree.
7. Deleting a Radical or Kanji must cascade-delete its `KanjiComponent` rows.

## Edge Cases

- **Kanji with no components:** Should not happen in production. Every kanji is composed of at least one radical. Flag in content validation tooling.
- **Ambiguous logic_hint:** Some radicals arguably contribute both meaning and sound. Pick the dominant role — the position-based patterns above resolve most ambiguity. Remaining cases are handled in the content pipeline, not in the data model.
- **Radical duplicates a kanji character:** Some `radical_id` entries in `kanji_components` point to radicals whose `master_symbol` matches a kanji `character` (e.g., 木 as radical and kanji). This is by design — see radical.md. The `kanji_components` FK always points to `radicals.id`, never to `kanji.id`.
- **Multiple radical classifications in one kanji:** KanjiVG may mark one component as `general` and another as `nelson` in the same kanji (when references disagree on which component is "the" radical). Both are stored. `is_primary` only matches `general`.
- **No `general` radical in a kanji:** Some kanji in KanjiVG have no component marked with `kvg:radical="general"`. All components default to `component`. The app's dictionary mode falls back to showing no radical rather than guessing.
