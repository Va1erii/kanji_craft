# Radical Extraction

## Overview

Radical extraction turns the nested KanjiVG component trees (stored in `raw_kanjivg.components`) into flat, queryable rows in `radicals`, `radical_variants`, and `kanji_components`. The result is a **Lego-style learning graph** — every kanji is built from a small set of pieces, and the learner masters each piece before assembling the next character.

**Core principle:** Each kanji decomposes into its **direct children only** — never flattened to all leaves. Children that are themselves compound characters get their own decomposition from their own `raw_kanjivg` entry, creating a multi-level learning chain.

## Progressive Decomposition

Consider the kanji 語 (Language). In KanjiVG it decomposes as:

```
語 (root)
├── 言 (Speech) — hen (left)
└── 吾 (Myself) — tsukuri (right)
    ├── 五 (Five)  — kanmuri (top)
    └── 口 (Mouth) — ashi (bottom)
```

A flat approach would record 語 → [言, 五, 口] — three atomic radicals. But this loses the intermediate structure that makes kanji memorable: "語 is 言 + 吾" and "吾 is 五 + 口" are two easy steps; "語 is 言 + 五 + 口" is one confusing step.

The **progressive** approach records only direct children:

| Kanji | Components (direct children) | Source |
|---|---|---|
| 語 | 言 (hen) + 吾 (tsukuri) | 語's own `raw_kanjivg` entry |
| 吾 | 五 (kanmuri) + 口 (ashi) | 吾's own `raw_kanjivg` entry |

Each decomposition is **one level deep**. The multi-level chain emerges from the dataset: 吾 appears as both a radical (component of 語) and a kanji (with its own components). The SRS unlocking rule (`stability >= 7.0 days` on all component radicals) enforces the learning order:

```
Step 1: Learn radicals 五, 口
Step 2: Unlock kanji 吾 (requires 五 + 口 mastered)
Step 3: Learn radical 言 (+ learn kanji 吾)
Step 4: Unlock kanji 語 (requires 言 + 吾 mastered)
```

### Dual Identity

A character that appears as a component of another kanji exists in **two tables**:

- `radicals` row — its identity as a building block (referenced by `kanji_components.radical_id`)
- `kanji` row — its identity as a learnable item with readings, meanings, and its own SRS card

This dual identity is by design (see [radical.md rule #10](../entities/radical.md)). `kanji_components` always references `radicals.id`, never `kanji.id`.

Examples: 言, 吾, 木, 金, 山, 口, 五 — all are both radicals and kanji.

## Algorithm

The extraction runs in four passes over the active `raw_kanjivg` import. Each pass is idempotent — re-running with the same data produces the same result.

### Pass 1: Scan — Collect Radical Candidates

Walk every `raw_kanjivg` entry's component tree. For each kanji's root node, collect its **direct children** (one level deep). Build a global set of unique elements.

```
Input:  raw_kanjivg rows for the active import_id
Output: Set<RadicalCandidate>
```

For each `raw_kanjivg` row:
1. Get the root node's `children` array.
2. **Flatten structural groups:** If a direct child has an empty `element` (a structural `<g>` used only for stroke grouping), skip it and promote its children to direct children of the root. Repeat until all direct children have a non-empty `element` or are leaves.
3. For each direct child node with a non-empty `element`:
   - Record the `element` as a radical candidate.
   - If `variant == true` and `original` is present, record the variant relationship: `element` is a shape of `original`.
   - If `radical == 'general'`, mark as official Kangxi radical.
   - Record any `position` values seen for this element across all kanji trees.
4. **Merge split parts:** If multiple children share the same `element` with different `part` values (e.g. 辶 part=1 and 辶 part=2 in 道), treat them as a **single component**. Merge their `stroke_indices` and use the `position` from the first part (or the part that carries the `position` attribute).

**Important:** Only process direct children of the root (after flattening) — do not recurse deeper. Sub-components of a child (e.g. 五 and 口 inside 吾) are handled when that child's own `raw_kanjivg` entry is processed.

### Pass 2: Register — Create Radical Rows

Upsert `radicals` and `radical_variants` from the candidate set.

**Radical registration:**

For each unique element from Pass 1:

1. **Determine `master_symbol`:**
   - If the element was seen with `variant == true` and an `original` value, the `master_symbol` is the `original` (e.g. for 亻 → master is 人).
   - Otherwise, the `master_symbol` is the element itself (e.g. 木 → master is 木).

2. **Upsert `radicals`:**
   - `master_symbol` — as determined above.
   - `is_official` — `true` if any occurrence had `radical == 'general'` (Kangxi marker). Default `false`.
   - `stroke_count` — looked up from `raw_kanjivg` where `character == master_symbol` (the master's own entry).
   - `svg_file_name`, `svg_file_url`, `svg_hash` — from SVG Processing (pipeline Phase 2.4).
   - `min_grade`, `min_jlpt_level`, `impact_score` — from Pass 4 (metadata derivation).

3. **Upsert `radical_variants`:**
   - For every element seen with `variant == true`:
     - `radical_id` — FK to the radical with `master_symbol == original`.
     - `shape` — the variant element (e.g. 氵).
     - `position` — the most common `position` value seen for this variant across all trees.
     - `is_locked` — `true` if this variant was **only** ever seen in a single position across all kanji trees.
     - SVG fields — from SVG Processing (Phase 2.4).
   - For every radical whose `master_symbol` was NOT seen as a variant of anything (it is its own canonical form):
     - Create a self-variant row: `shape == master_symbol`, `position` from the most common occurrence, `is_locked` accordingly. (See [radical.md rule #2](../entities/radical.md): every radical has at least one variant.)

### Pass 3: Link — Create KanjiComponent Rows

For each `raw_kanjivg` entry, create `kanji_components` linking the kanji to its direct child radicals. The full algorithm — including structural group flattening, split part merging, variant resolution, position mapping, radical_type determination, and worked examples — is documented in [component_linking.md](component_linking.md).

**Summary:** For each kanji, parse its component tree one level deep, resolve each child to its master radical, map position and radical_type from KanjiVG attributes, and upsert a `kanji_components` row. Default `logic_hint = semantic` (refined later by AI Heuristics in Phase 2.5). Upsert key: `(kanji_id, radical_id, position)`.

### Pass 4: Derive — Compute Radical Metadata

After all kanji and components are linked, compute derived fields on each radical: `impact_score`, `min_grade`, `min_jlpt_level`. The full algorithm — including impact score bucketing, the MIN/MAX queries, and edge cases for radicals with no graded kanji — is documented in [component_linking.md Step 3](component_linking.md#step-3-derive-radical-metadata).

## Worked Examples

### Simple: 休 (Rest) = 亻 + 木

KanjiVG tree:
```
休 (root)
├── 亻 — position: hen, variant: true, original: 人, radical: 'general'
└── 木 — position: tsukuri
```

**Pass 1** collects: `{亻 (variant of 人), 木}`

**Pass 2** creates:
- `radicals`: (master_symbol=人, is_official=true), (master_symbol=木, is_official=false)
- `radical_variants`: (radical=人, shape=亻, position=hen, is_locked=true), (radical=人, shape=人, position=...), (radical=木, shape=木, position=...)

**Pass 3** creates:
- `kanji_components`: (kanji=休, radical=人, position=hen), (kanji=休, radical=木, position=tsukuri)

### Progressive: 語 (Language) = 言 + 吾

KanjiVG tree for 語:
```
語 (root)
├── 言 — position: hen
└── 吾 — position: tsukuri
    ├── 五 — position: kanmuri
    └── 口 — position: ashi
```

Processing 語's entry (one level deep):
- `kanji_components`: **(kanji=語, radical=言, position=hen)**, **(kanji=語, radical=吾, position=tsukuri)**
- 五 and 口 inside 吾 are **ignored here** — they come from 吾's own entry.

KanjiVG tree for 吾 (separate entry):
```
吾 (root)
├── 五 — position: kanmuri
└── 口 — position: ashi
```

Processing 吾's entry:
- `kanji_components`: **(kanji=吾, radical=五, position=kanmuri)**, **(kanji=吾, radical=口, position=ashi)**

**Result:** The learning graph is:
```
五 ──┐
     ├──→ 吾 ──┐
口 ──┘          ├──→ 語
           言 ──┘
```

### Variant: 清 (Pure) = 氵 + 青

KanjiVG tree:
```
清 (root)
├── 氵 — position: hen, variant: true, original: 水
└── 青 — position: tsukuri
```

**Pass 2:**
- `radicals`: (master_symbol=水), (master_symbol=青)
- `radical_variants`: (radical=水, shape=氵, position=hen, is_locked=true)

**Pass 3:**
- `kanji_components`: (kanji=清, **radical=水**, position=hen), (kanji=清, radical=青, position=tsukuri)

Note: the component points to radical **水** (the master), not 氵. The variant shape is captured in `radical_variants` and determines which SVG to show for water-in-left-position.

### Split Part: 道 (Way) = 辶 + 首

KanjiVG tree:
```
道 (root)
├── 辶 — part: 1
├── 首 — (no part)
└── 辶 — part: 2
```

**Part merging:** The two 辶 nodes are merged into one component. Stroke indices are combined. The position is taken from whichever part carries the `position` attribute (or the first one).

**Pass 3:**
- `kanji_components`: (kanji=道, radical=辶, position=nyo), (kanji=道, radical=首, position=...)

### Leaf Kanji: 一 (One)

KanjiVG tree:
```
一 (root, no children)
```

一 has no sub-components — it is itself a leaf. No `kanji_components` rows are created for it. 一 is registered as a radical (it appears as a component of other kanji like 二, 三) but its own decomposition is empty.

In the SRS progression, 一 is a pure radical — learnable directly with no prerequisites.

## Edge Cases

### Component element missing from `raw_kanjivg`

A child's `element` may not have its own `raw_kanjivg` entry (e.g. a rare sub-component). This is fine — it becomes a radical without its own kanji decomposition. It's an atomic building block with no further breakdown. Log for review if the element has children in the parent's tree (a compound without its own entry suggests missing data).

### Empty `element` on a child node

Some KanjiVG `<g>` groups are structural (stroke groupings) without a meaningful `element`. Skip these nodes and process their children as if they were direct children of the parent. This "flattening" ensures structural-only groups don't create phantom radicals.

### Component appears in both Kangxi and Nelson systems

A single kanji may have two children with `radical` markers — one `'general'` (Kangxi) and one `'nelson'` (Nelson). Both are preserved during scanning. A radical is marked `is_official: true` if **any** occurrence carries `radical == 'general'`. The Nelson marker is informational and doesn't affect the extraction.

### Variant without `original`

If a node has `variant == true` but `original` is null ([raw_kanjivg.md edge case](../entities/raw_kanjivg.md)), log a warning. Treat the element as its own master symbol (non-variant). The admin can manually link it during review.

### Kanji with no children (leaf kanji)

Characters like 一, 丨, 丶 have flat component trees — the root with an empty `children` array. No `kanji_components` rows are created. These characters serve as atomic radicals for other kanji. They have no SRS prerequisites and are immediately available for lessons.

### Self-referential radical

A kanji's `master_symbol` in `radicals` may equal its `character` in `kanji`. For example, 木 is both a radical and a kanji. The `kanji_components` for kanji 木 are empty (it's a leaf), but `kanji_components` for 休 reference radical 木. Both rows exist independently.

### Duplicate component positions

If the same radical appears at the same position in the same kanji (after part merging), the unique constraint `(kanji_id, radical_id, position)` prevents duplicates. The upsert is a no-op.

### Radical with no graded kanji

If all kanji containing a radical have `null` for `min_grade` or `min_jlpt_level` (e.g. the radical only appears in rare, ungraded kanji), the Pass 4 queries return `null`. These fields stay `null` on the radical — it won't appear in JLPT-based or grade-based study paths. The Release Builder accepts null metadata fields; the client app filters these radicals out of structured study paths but they remain accessible via search/browse.

### Component not in KANJIDIC

A radical extracted from KanjiVG may not have a corresponding entry in `raw_kanjidic` (e.g. rare components, non-standard decompositions). The radical row is still created — it just won't have readings or KANJIDIC-sourced metadata. This is expected for custom radicals (`is_official: false`).

## Output Summary

| Table | What gets created | Source |
|---|---|---|
| `radicals` | One row per unique component element (by master symbol) | Pass 2 |
| `radical_variants` | One row per visual shape per radical | Pass 2 |
| `kanji_components` | One row per direct-child component per kanji | Pass 3 |

Tables populated by **later phases** (not this algorithm):
- `radical_i18n` — names and mnemonics (Phase 2.3, KANJIDIC meanings + AI)
- `kanji_component_reviews` — verification state (Phase 2.5, AI Heuristics)
- SVG fields on `radicals` and `radical_variants` — (Phase 2.4, SVG Processing)

## Ordering Constraint

Passes 1–2 (radical and variant creation) have **no dependency** on the `kanji` table and can run independently. Pass 3 (component linking) must run **after** kanji creation from KANJIDIC ([pipeline.md §2.3](pipeline.md#23-kanji--component-composition)), because `kanji_components.kanji_id` references the `kanji` table. Pass 4 (metadata derivation) must run after Pass 3. The full Phase 2 order is:

1. **Radical extraction Passes 1–2** from `raw_kanjivg` → populates `radicals`, `radical_variants` (pipeline §2.2)
2. **Kanji creation** from `raw_kanjidic` → populates `kanji`, `kanji_i18n`, `kanji_readings` (pipeline §2.3)
3. **Radical extraction Passes 3–4** → populates `kanji_components`, derives radical metadata (pipeline §2.3)
4. **SVG processing** from KanjiVG ZIP → populates SVG fields on `radicals`, `radical_variants`, `kanji` (pipeline §2.4)
5. **AI heuristics** → populates `kanji_components.logic_hint`, creates `kanji_component_reviews` (pipeline §2.5)

## Related Docs

- [radical.md](../entities/radical.md) — Radical entity spec
- [kanji.md](../entities/kanji.md) — Kanji entity spec
- [kanji_component.md](../entities/kanji_component.md) — KanjiComponent entity and review state
- [raw_kanjivg.md](../entities/raw_kanjivg.md) — KanjiVG staging table and component tree shape
- [component_linking.md](component_linking.md) — Component linking and radical metadata derivation (Passes 3–4)
- [pipeline.md](pipeline.md) — Full pipeline orchestration (Phases 1–4)
- [ingestion.md](ingestion.md) — Phase 1 correctness invariants
