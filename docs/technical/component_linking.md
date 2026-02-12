# Component Linking

## Overview

Component linking creates the bridge between kanji and their constituent radicals. For each kanji, the pipeline parses its KanjiVG component tree to identify the **direct child** radicals, then upserts `kanji_components` rows recording each radical's position, dictionary classification, and initial mnemonic role. A subsequent pass computes aggregate metadata on each radical from its kanji associations.

This phase corresponds to:
- **Radical extraction Passes 3–4** in [radical_extraction.md](radical_extraction.md)
- **Kanji composition Steps 4–5** in [kanji_composition.md](kanji_composition.md)
- **Pipeline Phase 2.3 (latter half)** in [pipeline.md](pipeline.md)

**What this phase does NOT do:** Radical/variant registration (Passes 1–2), kanji row creation (Steps 1–3), SVG processing (Phase 2.4), or logic_hint refinement via AI (Phase 2.6). Those are documented separately and merely referenced here for sequencing.

## Source Data

| Source | Used in | Purpose |
|---|---|---|
| `raw_kanjivg.components` | Step 1–2 | Component tree for each kanji |
| `radicals` table | Step 2 | Resolve `master_symbol` → `radical_id` |
| `kanji` table | Step 2 | Resolve `character` → `kanji_id` |
| `kanji.min_grade` | Step 3 | Aggregate to compute `radicals.min_grade` |
| `kanji.min_jlpt_level` | Step 3 | Aggregate to compute `radicals.min_jlpt_level` |
| `kanji_components` | Step 3 | Count kanji per radical for `impact_score` |

## Prerequisites

Both conditions must hold before this phase runs:

1. **Radical extraction Passes 1–2 complete** — `radicals` and `radical_variants` tables are populated. Every element that will appear as a direct child in any KanjiVG tree has a corresponding `radicals` row with a known `master_symbol`.
2. **Kanji composition Steps 1–3 complete** — `kanji`, `kanji_readings`, and `kanji_i18n` tables are populated. Every `raw_kanjivg.character` has a corresponding `kanji` row so that `kanji_components.kanji_id` can resolve.

## Algorithm

The phase runs in three steps over the active `raw_kanjivg` import. Each step is idempotent — re-running with the same data produces the same result.

### Step 1: Parse Direct Children

For each `raw_kanjivg` row in the active import:

1. Get the root node's `children` array.
2. **Flatten structural groups:** If a direct child has an empty `element` (a structural `<g>` used only for stroke grouping), skip it and promote its children to direct children of the root. Repeat until all direct children have a non-empty `element`.
3. **Merge split parts:** If multiple children share the same `element` with different `part` values (e.g. 辶 part=1 and 辶 part=2 in 道), treat them as a **single component**. Merge their `stroke_indices` and use the `position` from the first part (or the part that carries the `position` attribute).

**Important:** Only process direct children of the root (after flattening) — do not recurse deeper. Sub-components of a child (e.g. 五 and 口 inside 吾) are handled when that child's own `raw_kanjivg` entry is processed. This is the **progressive decomposition** principle — each kanji records only its immediate components, and the multi-level learning chain emerges from the dataset.

### Step 2: Create KanjiComponent Rows

For each direct child identified in Step 1:

1. **Look up kanji_id:** Find the `kanji` row matching `raw_kanjivg.character`. If not found, log a warning and skip this entry (should not happen if prerequisites are met).

2. **Resolve the radical:** If the child has `variant == true` and `original` is present, look up the radical by `master_symbol == original`. Otherwise, look up by `master_symbol == element`. Component linking always points to the **master radical**, not the variant shape.

3. **Map position:** Convert the child's KanjiVG `position` attribute to a `position_type` enum value (see §Position Mapping below).

4. **Determine radical_type:** Convert the child's `radical` attribute to a `RadicalType` enum value (see §Radical Type Classification below).

5. **Upsert `kanji_components`:**

   | Field | Value | Notes |
   |---|---|---|
   | `kanji_id` | From step 1 | FK to `kanji` |
   | `radical_id` | From step 2 | FK to `radicals` (always the master, not the variant) |
   | `position` | From step 3 | Where this radical sits inside this kanji |
   | `logic_hint` | `semantic` | Default; refined by AI Heuristics in Phase 2.6 |
   | `radical_type` | From step 4 | Dictionary classification role in this kanji |
   | `is_primary` | Computed | `true` only when `radical_type == general` (generated column in Postgres, getter in Dart) |

   **Upsert key:** `(kanji_id, radical_id, position)` — a radical appears at a given position in a given kanji exactly once.

**Skip condition:** If a child's `element` cannot be resolved to a radical (e.g. it was filtered out during Pass 1 or the element is empty), log a warning and skip. This should not happen if Passes 1–2 ran correctly.

### Step 3: Derive Radical Metadata

After all kanji–radical links are created, compute derived fields on each radical. These fields enable level-based filtering and priority ordering in the client app.

**3a. `impact_score`**

Count distinct `kanji_id` values in `kanji_components` for each `radical_id`. Map the count to a 1–10 scale:

| Kanji count | Score |
|---|---|
| 1–5 | 1 |
| 6–15 | 2 |
| 16–30 | 3 |
| 31–50 | 4 |
| 51–80 | 5 |
| 81–120 | 6 |
| 121–180 | 7 |
| 181–260 | 8 |
| 261–400 | 9 |
| 401+ | 10 |

The buckets are approximate and may need tuning after processing real data. Score 10 radicals (like 口, 木) appear in hundreds of kanji; score 1 radicals appear in a handful.

**3b. `min_grade`**

```sql
SELECT MIN(k.min_grade)
FROM kanji k
JOIN kanji_components kc ON k.id = kc.kanji_id
WHERE kc.radical_id = ?
```

The earliest school grade any kanji containing this radical appears in. Returns `null` if all containing kanji have `null` grade.

**3c. `min_jlpt_level`**

```sql
SELECT MAX(k.min_jlpt_level)
FROM kanji k
JOIN kanji_components kc ON k.id = kc.kanji_id
WHERE kc.radical_id = ?
```

Note: `MAX` because JLPT 5 is easiest, 1 is hardest — `MAX` returns the **easiest** level at which any kanji containing this radical appears. Returns `null` if all containing kanji have `null` JLPT level.

## Position Mapping

KanjiVG uses string values for the `position` attribute. The pipeline maps them to the `position_type` enum:

| KanjiVG value | `position_type` | Japanese name | Description |
|---|---|---|---|
| `left` | `hen` | 偏 | Left side |
| `right` | `tsukuri` | 旁 | Right side |
| `top` | `kanmuri` | 冠 | Top crown |
| `bottom` | `ashi` | 脚 | Bottom legs |
| `kamae` | `kamae` | 構 | Enclosure |
| `tare` | `tare` | 垂 | Left and above (hanging top-left) |
| `nyo` | `nyo` | 繞 | Left and under (wrapping bottom-left) |
| `tarec` | `unknown` | — | Complement of tare (enclosed portion) |
| `nyoc` | `unknown` | — | Complement of nyo (enclosed portion) |
| `null` / absent | `unknown` | — | Fallback for unclassified positions |

**Why `tarec` and `nyoc` map to `unknown`:** These KanjiVG values mark the "other half" of a tare or nyo structure — the enclosed content rather than the enclosing radical. They don't correspond to traditional radical position terminology and are rare in practice.

## Radical Type Classification

KanjiVG's `kvg:radical` attribute classifies the dictionary role of a component within a specific kanji. The pipeline maps it to the `RadicalType` enum:

| KanjiVG `radical` | `RadicalType` | Description |
|---|---|---|
| `"general"` | `general` | Generally accepted dictionary radical for this kanji |
| `"tradit"` | `tradit` | Traditional Kangxi radical (when it differs from general) |
| `"nelson"` | `nelson` | Nelson dictionary radical |
| `"jis"` | `jis` | JIS Kanji Jiten radical (used by KANJIDIC) |
| `null` / absent | `component` | Normal building block, no dictionary radical designation |

**Key distinction:** `RadicalType` on `KanjiComponent` is a **per-kanji contextual role** — the same radical can be `general` in one kanji and `component` in another. This is distinct from `is_official` on `Radical`, which is a **static property** of the radical itself (whether it's one of the 214 Kangxi radicals).

**`is_primary` derivation:** `true` only when `radical_type == general`. Implemented as a generated column in PostgreSQL (`GENERATED ALWAYS AS (radical_type = 'general') STORED`) and a getter in Dart. Used to filter components in dictionary/reference mode.

## Structural Group Flattening

KanjiVG uses nested `<g>` groups for two purposes: (1) meaningful component boundaries and (2) stroke grouping for animation. Groups used purely for stroke grouping have an **empty `element`** — no character is assigned.

The pipeline must flatten these structural-only groups to avoid creating phantom radicals:

```
Before flattening:            After flattening:
root                          root
├── <g> (empty element)       ├── 亻 (direct child)
│   └── 亻                    └── 木 (direct child)
└── 木
```

**Rule:** If a direct child of the root has an empty `element`, replace it with its own children and discard the empty group. Repeat until all direct children have non-empty elements. Children deeper than one level below the root are never promoted — only root's immediate children undergo flattening.

## Split Part Merging

Some radicals span non-contiguous stroke groups in a kanji. KanjiVG represents these as multiple `<g>` nodes sharing the same `element` but with different `part` numbers. For example, 辶 in 道:

```
道 (root)
├── 辶 — part: 1, position: nyo
├── 首 — (no part)
└── 辶 — part: 2
```

The pipeline merges these into a single component:

1. Identify groups with the same `element` and different `part` values. If `number` is present, also group by `number` (disambiguates when the same element is split into parts multiple times).
2. Combine `stroke_indices` from all parts.
3. Use `position` from the part that carries the `position` attribute (or the first part if multiple carry it).
4. Create **one** `kanji_components` row for the merged component.

## Variant Resolution

When a component is a visual variant of another radical, KanjiVG marks it with `variant="true"` and `original="X"`. For example:

```
亻 — variant: true, original: 人
```

**Resolution rule:** The `kanji_components.radical_id` always points to the **master radical** (the one whose `master_symbol` matches `original`). The variant shape is captured in the `radical_variants` table and determines which SVG to display for that radical-at-position, but the component link itself points to the canonical radical identity.

This means: 休 = 亻 + 木, but `kanji_components` records 休 → radical **人** (at position hen) + radical **木** (at position tsukuri). The rendering layer looks up `radical_variants` where `radical_id = 人 AND position = hen` to find the 亻 shape.

## Worked Examples

### 休 (Rest) — Simple Two-Component Kanji

KanjiVG tree:
```
休 (root)
├── 亻 — position: left, variant: true, original: 人, radical: 'general'
└── 木 — position: right
```

**Step 1:** Two direct children, no structural groups to flatten, no split parts.

**Step 2:**
- 亻 → variant of 人 → resolve to radical with `master_symbol = 人`. Position: `hen`. Radical type: `general`.
- 木 → not a variant → resolve to radical with `master_symbol = 木`. Position: `tsukuri`. Radical type: `component`.

**Result — `kanji_components` rows:**

| `kanji_id` | `radical_id` | `position` | `logic_hint` | `radical_type` | `is_primary` |
|---|---|---|---|---|---|
| 休 | 人 | `hen` | `semantic` | `general` | `true` |
| 休 | 木 | `tsukuri` | `semantic` | `component` | `false` |

### 語 (Language) — Progressive Decomposition

KanjiVG tree for 語:
```
語 (root)
├── 言 — position: left
└── 吾 — position: right
    ├── 五 — position: top
    └── 口 — position: bottom
```

**Step 1:** Two direct children: 言 and 吾. The sub-components of 吾 (五 and 口) are **not processed** — they belong to 吾's own entry.

**Step 2:**
- 言 → radical `言`, position `hen`.
- 吾 → radical `吾`, position `tsukuri`.

**Result for 語:**

| `kanji_id` | `radical_id` | `position` | `radical_type` |
|---|---|---|---|
| 語 | 言 | `hen` | `component` |
| 語 | 吾 | `tsukuri` | `component` |

KanjiVG tree for 吾 (separate entry):
```
吾 (root)
├── 五 — position: top
└── 口 — position: bottom
```

**Result for 吾:**

| `kanji_id` | `radical_id` | `position` | `radical_type` |
|---|---|---|---|
| 吾 | 五 | `kanmuri` | `component` |
| 吾 | 口 | `ashi` | `component` |

**Learning chain that emerges:**
```
五 ──┐
     ├──→ 吾 ──┐
口 ──┘          ├──→ 語
           言 ──┘
```

### 道 (Way) — Split Part Merging

KanjiVG tree:
```
道 (root)
├── 辶 — part: 1, position: nyo
├── 首 — (no part)
└── 辶 — part: 2
```

**Step 1:** Three child nodes, but the two 辶 nodes share the same `element` with different `part` values. Merge into one component. 首 stands alone.

**Step 2:**
- 辶 (merged) → position `nyo` (from part 1 which carries the position).
- 首 → position `unknown` (no position attribute).

**Result:**

| `kanji_id` | `radical_id` | `position` | `radical_type` |
|---|---|---|---|
| 道 | 辶 | `nyo` | `component` |
| 道 | 首 | `unknown` | `component` |

### 清 (Pure) — Variant Resolution

KanjiVG tree:
```
清 (root)
├── 氵 — position: left, variant: true, original: 水
└── 青 — position: right
```

**Step 2:**
- 氵 → variant of 水 → `radical_id` points to radical **水**, position `hen`.
- 青 → `radical_id` points to radical **青**, position `tsukuri`.

**Result:**

| `kanji_id` | `radical_id` | `position` | Notes |
|---|---|---|---|
| 清 | 水 | `hen` | Radical is 水; rendering uses variant 氵 at hen position |
| 清 | 青 | `tsukuri` | |

### 一 (One) — Leaf Kanji

KanjiVG tree:
```
一 (root, no children)
```

No sub-components. **No `kanji_components` rows created.** 一 is a leaf — it has no prerequisites in the SRS progression. It is itself registered as a radical (appears as a component of 二, 三, etc.) but its own decomposition is empty.

### Step 3 — Metadata Derivation Example

After linking, radical 口 appears in kanji: 語 (grade 2, N4), 吾 (no grade, no JLPT), 右 (grade 1, N5), ...

- `impact_score`: 口 appears in ~180 kanji → score 7.
- `min_grade`: `MIN(2, null, 1, ...) = 1`.
- `min_jlpt_level`: `MAX(4, null, 5, ...) = 5` (N5 is the easiest level containing this radical).

## Edge Cases

### Kanji in `raw_kanjivg` but not in `kanji` table

Should not happen if prerequisites are enforced. If it does, log a warning and skip — no `kanji_components` rows can be created without a `kanji_id`.

### Component element missing from `radicals`

A child's `element` may not resolve to any radical (e.g. filtered out during Pass 1 or rare sub-component). Log a warning and skip this component. This indicates a gap in the radical registration pass.

### Empty `element` on a child node

Structural-only `<g>` group — handled by flattening (see §Structural Group Flattening). After flattening, if a child still has an empty element, skip it.

### Variant without `original`

If a node has `variant == true` but `original` is null, log a warning. Treat the element as its own master symbol (non-variant). See [raw_kanjivg.md](../entities/raw_kanjivg.md) edge case.

### Kanji with no children (leaf kanji)

Characters like 一, 丨, 丶 have no sub-components. No `kanji_components` rows are created. These are atomic radicals with no SRS prerequisites.

### Self-referential radical

A kanji's `master_symbol` in `radicals` may equal its `character` in `kanji` (e.g. 木). The `kanji_components` for kanji 木 are empty (leaf), but `kanji_components` for 休 reference radical 木. Both rows exist independently — see [radical.md rule #10](../entities/radical.md).

### Duplicate component positions

If the same radical appears at the same position in the same kanji after part merging, the unique constraint `(kanji_id, radical_id, position)` prevents duplicates. The upsert is a no-op.

### Multiple radical classifications in one kanji

KanjiVG may mark one component as `general` and another as `nelson` in the same kanji (when references disagree on which component is "the" radical). Both are stored with their respective `radical_type`. `is_primary` only matches `general`.

### No `general` radical in a kanji

Some kanji in KanjiVG have no component marked with `kvg:radical="general"`. All components default to `component`. The app's dictionary mode falls back to showing no radical rather than guessing.

### Radical with no graded kanji

If all kanji containing a radical have `null` for `min_grade` or `min_jlpt_level` (e.g. the radical only appears in rare, ungraded kanji), the Step 3 queries return `null`. These fields stay `null` on the radical — it won't appear in JLPT-based or grade-based study paths. The Release Builder accepts null metadata fields; the client filters these radicals out of structured study paths but they remain accessible via search/browse.

### Component not in KANJIDIC

A radical extracted from KanjiVG may not have a corresponding entry in `raw_kanjidic` (e.g. rare components, non-standard decompositions). The radical row exists (from Pass 2) but won't have its own kanji row with readings or KANJIDIC-sourced metadata. This is expected for custom radicals (`is_official: false`).

## Warnings

The phase uses the `Warning` class with `WarningSeverity` (see [pipeline.md §Warning Pattern](pipeline.md#warning-pattern)).

| Condition | Severity | Rationale |
|---|---|---|
| Kanji in `raw_kanjivg` not found in `kanji` table | high | Prerequisite violation — kanji composition should have created this row; indicates a pipeline ordering bug |
| Child element not resolved to a radical | high | Prerequisite violation — radical extraction Passes 1–2 should have registered this element |
| Variant without `original` (`variant == true` but `original` is null) | low | Data quality issue — element treated as its own master symbol (same handling as radical extraction) |

The first two conditions are non-blocking per row (the affected kanji/component is skipped) but indicate a pipeline correctness issue that the admin should investigate.

## Business Rules

1. `kanji_id` + `radical_id` + `position` must be unique — a radical appears at a given position in a given kanji exactly once.
2. Every `kanji_components` row must have a `logic_hint` value. Default to `semantic` during this phase; refined by AI Heuristics (Phase 2.6).
3. Every `kanji_components` row must have a `radical_type` value. Default to `component` when the KanjiVG node has no `kvg:radical` attribute.
4. `is_primary` is computed, not stored explicitly: `true` only when `radical_type == general`.
5. A kanji should have at most one component with `radical_type = general`.
6. Component linking always references `radicals.id`, never `kanji.id` — even when the radical's `master_symbol` matches a kanji `character`.
7. Only direct children of the root node are processed (after flattening). Sub-components are handled by their own `raw_kanjivg` entry.
8. Re-processing the same `raw_kanjivg` data produces the same result (idempotent upserts).
9. `impact_score` must be in range 1–10 after derivation.
10. `min_grade`, when present after derivation, must be in range 1–8.
11. `min_jlpt_level`, when present after derivation, must be in range 1–5.

## Output Summary

| Table | What gets created/updated | Step |
|---|---|---|
| `kanji_components` | One row per direct-child component per kanji | Step 2 |
| `radicals.impact_score` | Updated from kanji count | Step 3a |
| `radicals.min_grade` | Updated from MIN across containing kanji | Step 3b |
| `radicals.min_jlpt_level` | Updated from MAX across containing kanji | Step 3c |

Tables populated by **later phases** (not this algorithm):
- `kanji_components.logic_hint` refinement — AI Heuristics (Phase 2.6)
- `kanji_component_reviews` — AI Heuristics (Phase 2.6)

## Subsequent Phase: AI Heuristics (Phase 2.6)

After component linking and SVG processing are complete, Phase 2.6 refines the `logic_hint` on each `kanji_components` row and creates the corresponding review entries. This is documented in [pipeline.md §2.6](pipeline.md#26-ai-heuristics-logic-hint-estimation) and summarized here for context:

1. For each `kanji_components` row, fetch onyomi for the kanji and for the radical's `master_symbol` (looked up in `raw_kanjidic`).
2. If onyomi match → set `logic_hint = phonetic`. If no match → keep `logic_hint = semantic`.
3. Create a `kanji_component_reviews` row with `verification_status = draft` and an `ai_confidence` score (0.0–1.0) reflecting match quality.
4. The review queue (Phase 3) surfaces draft reviews ordered by `ai_confidence ASC` (lowest confidence first).

## Schema Status

The Supabase schema for `kanji_components` is complete. All columns from the entity spec are present:

| Column | Migration |
|---|---|
| `kanji_id` | Initial schema `20260207095218` |
| `radical_id` | Initial schema `20260207095218` |
| `logic_hint` | Initial schema `20260207095218` |
| `position` | `20260208071813_staging_enums_and_tables` |
| `radical_type` | `20260210123515_add_radical_type_to_kanji_components` |
| `is_primary` | `20260210123515_add_radical_type_to_kanji_components` (generated column) |

**Unique constraint:** `(kanji_id, radical_id, position)` — added in `20260208071813`, replacing the original `(kanji_id, radical_id)` constraint.

## Ordering Constraints

The full Phase 2 execution order, showing where component linking fits:

```
Phase 2.2 Passes 1-2: Radical extraction (populates radicals, radical_variants)
    |
Phase 2.3 Steps 1-3: Kanji composition (populates kanji, kanji_readings, kanji_i18n)
    |
Phase 2.3 Steps 4-5: Component linking + metadata derivation  <-- THIS DOC
    |
Phase 2.4: SVG Processing (populates svg fields on radicals, radical_variants, kanji)
    |
Phase 2.5: Vocabulary extraction (needs kanji table for vocabulary_kanji)
    |
Phase 2.6: AI Heuristics (refines logic_hint, creates kanji_component_reviews)
```

Steps 1–2 (linking) depend on both the `kanji` rows from kanji composition and the `radicals` rows from radical extraction. Step 3 (metadata derivation) depends on Step 2 (all links must exist before aggregation).

## Related Docs

- [kanji_component.md](../entities/kanji_component.md) — KanjiComponent entity spec (target schema, business rules, edge cases)
- [radical.md](../entities/radical.md) — Radical entity spec (master_symbol, variants, metadata fields)
- [kanji.md](../entities/kanji.md) — Kanji entity spec (min_grade, min_jlpt_level used in metadata derivation)
- [raw_kanjivg.md](../entities/raw_kanjivg.md) — Source staging table (component tree shape, KanjiVG attributes)
- [kanjivg_format.md](../sources/kanjivg_format.md) — KanjiVG SVG format (position values, radical markers, split parts)
- [radical_extraction.md](radical_extraction.md) — Passes 1–2 (radical registration) and full worked examples
- [kanji_composition.md](kanji_composition.md) — Steps 1–3 (kanji creation) and JLPT level mapping
- [pipeline.md](pipeline.md) — Full pipeline orchestration (Phases 1–4)
