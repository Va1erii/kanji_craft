# Multi-Level Kanji Decomposition

## Status

**Proposed** — February 2026

## Context

The current model decomposes every kanji exclusively into radicals. The `kanji_components` table has a strict FK to `radicals.id` — if a shape appears inside a kanji, it must be registered as a radical. This led to 791 radicals, 750 of which are also standalone kanji characters. The result is significant redundancy: learners encounter the same character twice (as a radical for meaning, then as a kanji for readings), and the radical table is bloated with entries that are really just simpler kanji.

In reality, kanji decompose into other kanji:

```
語 (language) = 言 (say) + 五 (five) + 口 (mouth)
          ↑ complex    ↑ simpler kanji   ↑ radical
```

The kanji 五 and 言 are standalone learnable characters. Forcing them into the radical table just to satisfy the FK constraint creates artificial duplication and inflates the radical deck without pedagogical benefit.

## Decision

Allow `kanji_components` to reference **both radicals and kanji** as building blocks. A kanji decomposes into a mix of:

- **Radicals** — true bottom-layer building blocks (no further decomposition)
- **Kanji** — simpler characters that the learner already knows or will learn

This creates a multi-level decomposition chain:

```
Complex kanji → simpler kanji → radicals
    清 (pure) → 氵 (water radical) + 青 (blue kanji)
    青 (blue) → 月 (moon radical) + 龶 (stand radical)
```

### Component Type Discriminator

`kanji_components` gains a `component_type` field — a polymorphic discriminator mirroring the existing `srs_cards.item_type` pattern:

| Field | Type | Description |
|---|---|---|
| `component_type` | `ComponentType` | `radical` or `kanji` — identifies which table `component_id` references |
| `component_id` | `int` | Polymorphic FK: `radicals.id` when type=radical, `kanji.id` when type=kanji |

The existing `radical_id` column is renamed to `component_id`. All other fields (`position`, `logic_hint`, `radical_type`) remain unchanged — they describe the role of the component within the parent kanji regardless of whether the component is a radical or a kanji.

### What Qualifies as a Radical

With kanji-to-kanji links available, the radical table shrinks to true building blocks:

| Category | Count (est.) | Rationale |
|---|---|---|
| **Official Kangxi** | ~150 | The 214 traditional radicals (those present in our kanji dataset). Non-negotiable — they are the foundation of the classification system |
| **Radical-only shapes** | ~41 | Shapes with no standalone kanji form (e.g. 亻, 氵, 忄, 艹). These can only be radicals — there's no kanji to reference |
| **Cross-JLPT protectors** | varies | Higher-JLPT kanji used as components in lower-JLPT kanji. Kept as radicals to avoid SRS blocking (see below) |
| **High-frequency non-official** | varies | Non-Kangxi shapes that appear in many kanji. Threshold TBD during implementation |

**Estimated total: ~190–250 radicals** (down from 791).

### Cross-JLPT Protection

A critical constraint: if an N1 kanji (e.g. 青) is used as a component in an N5 kanji (e.g. 清), requiring the N1 kanji to be learned first would block the N5 kanji indefinitely. The solution:

- **Same or lower JLPT**: Reference as kanji component. The learner will encounter the simpler kanji before or alongside the complex one.
- **Higher JLPT (or no JLPT)**: Keep as radical. The radical version teaches only the meaning (quick card), avoiding the full kanji learning burden. The learner later encounters the full kanji at the appropriate JLPT level.

Example:
- 清 (N3) uses 青 (N3, same level) → 青 is a **kanji component** ✓
- 語 (N5) uses 言 (N4, lower level) → 言 is a **kanji component** ✓
- 想 (N3) uses 相 (N3) → 相 is a **kanji component** ✓
- If a hypothetical N5 kanji used an N1 component → component stays as **radical** to avoid blocking

### Dual Identity

A character can exist as both a radical and a kanji simultaneously. This is normal for Kangxi radicals (木, 金, 山, etc.) and for cross-JLPT protectors:

- **As radical**: Teaches meaning only (quick SRS card). Unlocks kanji that contain this component.
- **As kanji**: Teaches meaning + readings (full SRS card). Unlocked when its own radical components reach stability.

The SRS progression:
1. Learn 青 as radical → meaning: "blue" ✓ (quick)
2. 清 is unlocked (青-radical has stability >= 7.0 days)
3. Later, learn 青 as kanji → readings: セイ, ショウ, あお (full card)

## Schema Changes

### New Enum: ComponentType

```
component_type: radical | kanji
```

### Modified Table: kanji_components

| Field | Change |
|---|---|
| `radical_id` | **Renamed** to `component_id` |
| `component_type` | **Added** — `ComponentType` enum, default `radical` |

Unique constraint changes from `(kanji_id, radical_id, position)` to `(kanji_id, component_type, component_id, position)`.

### Cascade Rules

- Deleting a radical cascades to `kanji_components WHERE component_type='radical' AND component_id=radical_id`
- Deleting a kanji cascades to `kanji_components WHERE component_type='kanji' AND component_id=kanji_id`
- Application-level cascade (no DB FK on polymorphic `component_id`)

### SRS Unlock Gate Update

Current rule (srs.md rule #7):
> A radical's SrsCard must reach stability >= 7.0 days before any kanji containing that radical can enter the lesson queue.

New rule:
> **All components** of a kanji must reach stability >= 7.0 days before the kanji can enter the lesson queue. For radical components, check `srs_cards WHERE item_type='radical'`. For kanji components, check `srs_cards WHERE item_type='kanji'`.

This means a kanji with mixed components (e.g. 清 = 氵 radical + 青 kanji) requires both the 氵 radical card AND the 青 kanji card to be stable.

## Consequences

### Benefits

1. **Fewer radicals to learn.** ~190–250 instead of 791. The radical deck becomes manageable — learners aren't overwhelmed by hundreds of "radicals" that are really just kanji.

2. **Natural decomposition chain.** Complex kanji → simpler kanji → radicals mirrors how Japanese is actually structured. 語 = 言 + 吾 makes more sense than 語 = 言-radical + 五-radical + 口-radical.

3. **Better SRS ordering.** Kanji components create natural prerequisites. Learn 言 before 語 — the SRS gate ensures this automatically.

4. **Richer phonetic teaching.** When a kanji component carries the reading (phonetic role), the app can show: "You already know 青 reads セイ. 清 inherits that reading." This is stronger than referencing a radical that has no readings.

5. **Accurate per-shape metadata.** Impact scores, JLPT levels, and grades are more meaningful on ~200 true radicals than on 791 that include redundant kanji duplicates.

### Trade-offs

1. **Polymorphic FK.** No database-level foreign key on `component_id` (same trade-off as `srs_cards`). Application-level validation required.

2. **Pipeline complexity.** Component linking must decide radical vs kanji for each element. Requires JLPT-aware logic.

3. **Circular decomposition risk.** Kanji A → kanji B → kanji A is invalid. Pipeline must detect and break cycles (DAG enforcement).

4. **Migration.** Existing `kanji_components` rows all have `component_type='radical'`. Migration needs to reclassify appropriate rows to `component_type='kanji'` and remove corresponding radical entries.

## Implementation Notes

This ADR captures the architectural decision. Implementation phases:

1. **Analysis pass** — Classify all 791 radicals: keep as radical, convert to kanji reference, or dual identity. Output a classification CSV.
2. **Schema migration** — Add `component_type` to `kanji_components`, rename `radical_id` → `component_id`.
3. **Pipeline update** — Modify `ph2_3_components.py` to emit kanji components where appropriate (JLPT-aware logic).
4. **Radical pruning** — Remove radicals that are fully converted to kanji references. Keep dual-identity ones.
5. **SRS unlock update** — Modify unlock gate to check both radical and kanji component stability.
6. **Client update** — Dart entities, decomposition tree UI, lesson queue logic.
