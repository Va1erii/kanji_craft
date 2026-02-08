# KanjiComponent

## Overview

A kanji component is the connection between a radical and a kanji — it records the fact that a specific radical appears inside a specific kanji, and what role it plays there. This is the bridge table that makes it possible to look up all radicals inside a kanji, or all kanji that use a given radical. It also carries metadata that belongs to neither side alone, most importantly the `logic_hint` that explains whether the radical contributes meaning or sound.

## Entities

### LogicHint (Enum)

Describes the role a radical plays inside a specific kanji.

| Value | Description |
|---|---|
| `semantic` | The radical contributes to the kanji's meaning. e.g. 氵 (Water) + 目 (Eye) = 涙 (Tear) |
| `phonetic` | The radical contributes to the kanji's reading (pronunciation), not its meaning. e.g. 亡 (BOU) in 忙 (BOU) |

### KanjiComponent (Entity)

Each row represents one radical appearing inside one kanji. It carries metadata that belongs to neither the radical nor the kanji individually.

| Field | Type | Description |
|---|---|---|
| `id` | `int` | Unique identifier |
| `kanji_id` | `int` | FK to the Kanji (see kanji.md) |
| `radical_id` | `int` | FK to the Radical (see radical.md) |
| `position` | `Position` | Where this radical sits inside this kanji (see radical.md Position enum) |
| `logic_hint` | `LogicHint` | Whether this radical contributes meaning or sound in this specific kanji |

**Why `position` on KanjiComponent, not just on RadicalVariant?**

`RadicalVariant` records what shapes a radical *can* take at each position. `KanjiComponent.position` records where the radical *actually sits* in a specific kanji. For example, 口 can appear as `hen` (left), `ashi` (bottom), or `kamae` (enclosure) depending on the kanji. The position per kanji is what the decomposition tree view needs to show the spatial layout.

**Why `logic_hint` on KanjiComponent, not on Radical?**

The same radical can play different roles in different kanji. For example, 亡 is **phonetic** in 忙 (busy) — it's only there because its Chinese reading BOU matches the kanji's reading. But 亡 is **semantic** in 死 (death) — it directly contributes to the meaning. Placing `logic_hint` per radical-kanji pair captures this accurately.

This field is critical for teaching. Without it, a user sees 忄 (Heart) + 亡 (Death) = 忙 (Busy) and thinks the system is broken. With a phonetic hint, the app can explain: "亡 is here for its sound (BOU), not its meaning."

## Relationships

```
Radical ──1:N──→ KanjiComponent    (one radical appears in many kanji; see radical.md)
Kanji  ──1:N──→ KanjiComponent    (one kanji is composed of many radicals; see kanji.md)
```

## Business Rules

1. `kanji_id` + `radical_id` + `position` must be unique — a radical appears at a given position in a given kanji exactly once.
2. Every `KanjiComponent` must have a `logic_hint` value. Default to `semantic` if unknown during content seeding.
3. Deleting a Radical or Kanji must cascade-delete its `KanjiComponent` rows.

## Edge Cases

- **Radical with no kanji:** During early content seeding, a radical may exist before any `KanjiComponent` rows link it to kanji. The radical is still reviewable on its own (see radical.md).
- **Kanji with no components:** Should not happen in production. Every kanji is composed of at least one radical. Flag in content validation tooling.
- **Ambiguous logic_hint:** Some radicals arguably contribute both meaning and sound. Pick the dominant role and document the ambiguity in the content pipeline, not in the data model.
- **Radical duplicates a kanji character:** Some `radical_id` entries in `kanji_components` point to radicals whose `master_symbol` matches a kanji `character` (e.g., 木 as radical and kanji). This is by design — see radical.md. The `kanji_components` FK always points to `radicals.id`, never to `kanji.id`.
