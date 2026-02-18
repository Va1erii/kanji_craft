# Component Linking

## Overview

Component linking creates the bridge between kanji and their constituent radicals. For each kanji, the pipeline resolves its **effective children** — the meaningful building blocks remaining after ghost radical flattening — then writes `kanji_components` rows recording each radical's position, dictionary classification, and initial mnemonic role. A subsequent pass computes aggregate metadata on each radical from its kanji associations.

This phase corresponds to:
- **Radical extraction Passes 3–4** in [ph2_1_radical_extraction.md](ph2_1_radical_extraction.md)
- **Kanji composition Steps 4–5** in [ph2_2_kanji_composition.md](ph2_2_kanji_composition.md)
- **Pipeline Phase 2.3** in [pipeline.md](pipeline.md)

**What this phase does NOT do:** Radical/variant registration (Passes 1–2), kanji row creation (Steps 1–3), SVG processing (Phase 2.4), or logic_hint refinement via AI (Phase 3). Those are documented separately and merely referenced here for sequencing.

## Source Data

| Source | Used in | Purpose |
|---|---|---|
| `kanjivg.parquet` component trees | Step 1–2 | Component tree for each kanji |
| `radicals.csv` | Step 2 | Resolve `master_symbol` → `radical_id` |
| `kanji.csv` | Step 2 | Resolve `character` → `kanji_id` |
| `kanji.csv` `min_grade` | Step 3 | Aggregate to compute `radicals.min_grade` |
| `kanji.csv` `min_jlpt_level` | Step 3 | Aggregate to compute `radicals.min_jlpt_level` |
| `kanji_components.csv` | Step 3 | Count kanji per radical for `impact_score` |

## Prerequisites

All four conditions must hold before this phase runs:

1. **JLPT/grade scope set computed** — The same scope set used by radical extraction Pass 0 (see [ph2_1_radical_extraction.md §Scope](ph2_1_radical_extraction.md#scope-jlptgrade-kanji-only)). Only KanjiVG entries whose character is in this set are processed.
2. **Keep set available** — The same keep set built during radical extraction Pass 1 (see [ph2_1_radical_extraction.md §Keep Set](ph2_1_radical_extraction.md#keep-set-what-becomes-a-radical)). Ghost flattening in Step 1 uses this set to determine which intermediates to flatten.
3. **Radical extraction Passes 1–2 complete** — `radicals.csv` and `radical_variants.csv` are written. Every element that will appear as an **effective child** (after ghost flattening) of any in-scope kanji has a corresponding radical row with a known `master_symbol`.
4. **Kanji composition Steps 1–3 complete** — `kanji.csv`, `kanji_readings.csv`, and `kanji_i18n.csv` are written. Every in-scope KanjiVG character has a corresponding kanji row so that `kanji_components.kanji_id` can resolve.

## Algorithm

The phase runs in three steps over the KanjiVG Parquet data. Each step is idempotent — re-running with the same data produces the same output.

### Step 1: Resolve Effective Children

For each KanjiVG entry **whose character is in the JLPT/grade scope set**:

1. Get the root node's `children` array.
2. **Flatten structural groups:** If a direct child has an empty `element` (a structural `<g>` used only for stroke grouping), skip it and promote its children to direct children of the root. Repeat until all direct children have a non-empty `element`.
3. **Merge split parts:** If multiple children share the same `element` with different `part` values (e.g. 辶 part=1 and 辶 part=2 in 道), treat them as a **single component**. Merge their `stroke_indices` and use the `position` from the first part (or the part that carries the `position` attribute).
4. **Ghost flattening:** For each child after steps 2–3, resolve the master symbol (`original` if variant, else `element`). If the master symbol is NOT in the keep set, the child is a **ghost radical** — replace it with its own effective children from its KanjiVG entry (recursive, depth-limited to 10, warning at depth > 5). See [ph2_1_radical_extraction.md §Ghost Radical Flattening](ph2_1_radical_extraction.md#ghost-radical-flattening) for the full algorithm and pseudocode.

**Important:** The same keep set and ghost flattening algorithm used in radical extraction Pass 1 must be applied here to ensure consistency — every effective child produced in this step has a corresponding radical row from Pass 2. Sub-components of a keep-set child (e.g. 五 and 口 inside 吾) are handled when that child's own entry is processed. This is the **progressive decomposition** principle — multi-level learning chains emerge from the dataset, but only through meaningful components.

### Step 2: Create KanjiComponent Rows

For each effective child identified in Step 1:

1. **Look up kanji_id:** Find the kanji row matching the KanjiVG character. If not found, log a warning and skip this entry (should not happen if prerequisites are met).

2. **Resolve the radical:** If the child has `variant == true` and `original` is present, look up the radical by `master_symbol == original`. Otherwise, look up by `master_symbol == element`. Component linking always points to the **master radical**, not the variant shape.

3. **Map position:** Convert the child's KanjiVG `position` attribute to a `position_type` enum value (see §Position Mapping below).

4. **Determine radical_type:** Convert the child's `radical` attribute to a `RadicalType` enum value (see §Radical Type Classification below).

5. **Write `kanji_components` row:**

   | Field | Value | Notes |
   |---|---|---|
   | `kanji_id` | From step 1 | FK to `kanji` |
   | `radical_id` | From step 2 | FK to `radicals` (always the master, not the variant) |
   | `position` | From step 3 | Where this radical sits inside this kanji |
   | `logic_hint` | `semantic` | Default; refined by AI enrichment in Phase 3 |
   | `radical_type` | From step 4 | Dictionary classification role in this kanji |
   | `is_primary` | Computed | `true` only when `radical_type == general` (generated column in Postgres, getter in Dart) |

   **Unique key:** `(kanji_id, radical_id, position)` — a radical appears at a given position in a given kanji exactly once.

**Skip condition:** If an effective child's `element` cannot be resolved to a radical (e.g. it was filtered out during Pass 1 or the element is empty), log a warning and skip. This should not happen if Passes 1–2 ran correctly with the same keep set.

### Step 3: Derive Radical Metadata

After all kanji–radical links are created, compute derived fields on each radical. These fields enable level-based filtering and priority ordering in the client app.

**3a. `impact_score`**

The impact score reflects how valuable it is for a learner to master a radical. It combines **frequency** (how many kanji reuse it) with a **complexity bonus** (high-stroke radicals save more memorization effort per kanji). The score ranges from 1–10.

**Base score from frequency:** Count distinct `kanji_id` values in `kanji_components` for each `radical_id`, then map:

| Kanji count | Base score |
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

**Complexity bonus:** A simple 2-stroke radical appearing in 5 kanji is easy to absorb inline — low impact. A 12-stroke radical appearing in 5 kanji saves the learner from memorizing 12 random strokes each time — high impact. To account for this:

| `stroke_count` | Bonus |
|---|---|
| < 8 | +0 |
| 8–11 | +1 |
| 12+ | +2 |

**Final score:** `min(base + bonus, 10)`.

**Examples:**
- 口 (3 strokes, ~180 kanji): base 7 + 0 = **7**
- 木 (4 strokes, ~150 kanji): base 7 + 0 = **7**
- 龜 (16 strokes, ~3 kanji): base 1 + 2 = **3** (without bonus it would be 1 — nearly invisible in priority ordering)
- 鬼 (10 strokes, ~12 kanji): base 2 + 1 = **3**

The buckets and bonuses are approximate and may need tuning after processing real data.

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

**Why MAX, not MIN:** JLPT levels are inverted — N5 = 5 (easiest), N1 = 1 (hardest). `MAX(5, 1) = 5`, which is the **easiest** level at which any kanji containing this radical appears. This tells us the earliest point in the JLPT progression where the learner encounters this radical. Implementation note: this inverted scale is a common source of confusion — always comment the intent (`// N5=5 easiest, N1=1 hardest; MAX returns earliest encounter`) when writing the aggregation query. Returns `null` if all containing kanji have `null` JLPT level.

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
| `tarec` | `tarec` | — | Complement of tare (enclosed portion) |
| `nyoc` | `nyoc` | — | Complement of nyo (enclosed portion) |
| `kamaec` | `kamaec` | — | Complement of kamae (enclosed portion) |
| `null` / absent | `unknown` | — | Fallback for unclassified positions |

`tarec`, `nyoc`, and `kamaec` mark the "other half" of a tare, nyo, or kamae structure — the enclosed content rather than the enclosing radical. They are preserved as first-class enum values so the client can decide how to display them.

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
3. Use `position` from whichever part carries a non-null `position` attribute. Iterate all parts — KanjiVG is inconsistent about which part holds the position (sometimes part 1, sometimes part 2). If multiple parts carry different positions, log a warning and use the first non-null value.
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

**Step 1:** Two direct children: 言 and 吾. Both are in the keep set (learnable kanji), so no ghost flattening occurs. The sub-components of 吾 (五 and 口) are **not processed** — they belong to 吾's own entry.

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

### Ghost Flattening in Component Linking

Consider a kanji whose KanjiVG tree contains a ghost component (not in the keep set):

```
X (root)
├── 火 — position: left
└── G — position: right (GHOST — not kanji, not official, freq < 3)
    ├── 米 — position: top
    └── 舛 — position: bottom
```

**Step 1:** Direct children are 火 and G. G is not in the keep set, so ghost flattening replaces it with its own children: 米 and 舛 (both in the keep set). Effective children: [火, 米, 舛].

**Step 2:**
- 火 → radical `火`, position `hen`.
- 米 → radical `米`, position `kanmuri` (keeps its position from G's sub-tree).
- 舛 → radical `舛`, position `ashi`.

**Result:**

| `kanji_id` | `radical_id` | `position` | `radical_type` |
|---|---|---|---|
| X | 火 | `hen` | `component` |
| X | 米 | `kanmuri` | `component` |
| X | 舛 | `ashi` | `component` |

Note: G is never stored in `kanji_components`. The learner sees X as composed of three meaningful pieces (火, 米, 舛) rather than two opaque ones (火, G).

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

### Kanji in KanjiVG but not in `kanji.csv`

Should not happen for in-scope kanji if prerequisites are enforced (kanji composition creates rows for all `kanjidic.parquet` entries, which is a superset of the scope set). If it does, log a warning and skip — no `kanji_components` rows can be created without a `kanji_id`. Out-of-scope kanji are simply not processed (no warning needed).

### Component element missing from `radicals.csv`

An effective child's `element` may not resolve to any radical (e.g. filtered out during Pass 1 or rare sub-component). Log a warning and skip this component. This indicates a gap in the radical registration pass — since Passes 1–2 and Passes 3–4 use the same keep set and ghost flattening algorithm, every effective child of an in-scope kanji should have been registered.

### Empty `element` on a child node

Structural-only `<g>` group — handled by flattening (see §Structural Group Flattening). After flattening, if a child still has an empty element, skip it.

### Variant without `original`

If a node has `variant == true` but `original` is null, log a warning. Treat the element as its own master symbol (non-variant). See [kanjivg_format.md](../sources/kanjivg_format.md) for KanjiVG attribute details.

### Kanji with no children (leaf kanji)

Characters like 一, 丨, 丶 have no sub-components. No `kanji_components` rows are created. These are atomic radicals with no SRS prerequisites.

### Self-referential radical

A kanji's `master_symbol` in `radicals` may equal its `character` in `kanji` (e.g. 木). The `kanji_components` for kanji 木 are empty (leaf), but `kanji_components` for 休 reference radical 木. Both rows exist independently — see [radical.md rule #10](../domain/radical.md).

### Duplicate component positions

If the same radical appears at the same position in the same kanji after part merging, the unique constraint `(kanji_id, radical_id, position)` prevents duplicates. The write is a no-op.

### Multiple radical classifications in one kanji

KanjiVG may mark one component as `general` and another as `nelson` in the same kanji (when references disagree on which component is "the" radical). Both are stored with their respective `radical_type`. `is_primary` only matches `general`.

### No `general` radical in a kanji

Some kanji in KanjiVG have no component marked with `kvg:radical="general"`. All components default to `component`. The app's dictionary mode falls back to showing no radical rather than guessing.

### Radical with no graded kanji

With the JLPT/grade scope filter, this situation is rare — most radicals inherit metadata from the in-scope kanji that contain them. However, it can still happen if a radical only appears in kanji that have JLPT/grade status from one system but not the other. The Step 3 queries return `null` for the missing system. The radical is still usable; it won't appear in the corresponding study path but remains accessible via search/browse.

### Component not in KANJIDIC

A radical extracted from KanjiVG may not have a corresponding entry in `kanjidic.parquet` (e.g. rare components, non-standard decompositions). The radical row exists (from Pass 2) but won't have its own kanji row with readings or KANJIDIC-sourced metadata. This is expected for custom radicals (`is_official: false`).

## Warnings

Warnings are written to `data/csv/warnings/ph2_3_warnings.csv` with columns: `severity, phase, entity, message`.

| Condition | Severity | Rationale |
|---|---|---|
| Kanji in KanjiVG not found in `kanji.csv` | high | Prerequisite violation — kanji composition should have created this row; indicates a pipeline ordering bug |
| Child element not resolved to a radical | high | Prerequisite violation — radical extraction Passes 1–2 should have registered this element |
| Variant without `original` (`variant == true` but `original` is null) | low | Data quality issue — element treated as its own master symbol (same handling as radical extraction) |

The first two conditions are non-blocking per row (the affected kanji/component is skipped) but indicate a pipeline correctness issue that the admin should investigate.

## Business Rules

1. `kanji_id` + `radical_id` + `position` must be unique — a radical appears at a given position in a given kanji exactly once.
2. Every `kanji_components` row must have a `logic_hint` value. Default to `semantic` during this phase; refined by AI enrichment (Phase 3).
3. Every `kanji_components` row must have a `radical_type` value. Default to `component` when the KanjiVG node has no `kvg:radical` attribute.
4. `is_primary` is computed, not stored explicitly: `true` only when `radical_type == general`.
5. A kanji should have at most one component with `radical_type = general`.
6. Component linking always references `radicals.id`, never `kanji.id` — even when the radical's `master_symbol` matches a kanji `character`.
7. Effective children are processed (after structural flattening and ghost flattening). Sub-components of keep-set children are handled by their own KanjiVG entry.
8. Re-processing the same data produces the same output (idempotent file writes).
9. `impact_score` must be in range 1–10 after derivation.
10. `min_grade`, when present after derivation, must be in range 1–10.
11. `min_jlpt_level`, when present after derivation, must be in range 1–5.

## Output Summary

| File | What gets created/updated | Step |
|---|---|---|
| `kanji_components.csv` | One row per effective-child component per kanji (after ghost flattening) | Step 2 |
| `radicals.csv` `impact_score` | Updated from kanji count | Step 3a |
| `radicals.csv` `min_grade` | Updated from MIN across containing kanji | Step 3b |
| `radicals.csv` `min_jlpt_level` | Updated from MAX across containing kanji | Step 3c |

Files updated by **later phases** (not this algorithm):
- `kanji_components.csv` `logic_hint` refinement — AI Enrichment (Phase 3)

## Subsequent Phase: AI Enrichment (Phase 3)

After component linking and SVG processing are complete, Phase 3 refines the `logic_hint` on each `kanji_components` row. This is documented in [pipeline.md §Phase 3](pipeline.md#phase-3-ai-enrichment) and summarized here for context:

1. For each `kanji_components` row, fetch onyomi for the kanji and for the radical's `master_symbol` (looked up in `kanjidic.parquet`).
2. If onyomi match → set `logic_hint = phonetic`. If no match → keep `logic_hint = semantic`.
3. The admin reviews AI-generated `logic_hint` values before upload (Phase 4).

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
Phase 2.1 Passes 1-2: Radical extraction (outputs radicals.csv, radical_variants.csv)
    |
Phase 2.2 Steps 1-3: Kanji composition (outputs kanji.csv, kanji_readings.csv, kanji_i18n.csv)
    |
Phase 2.3: Component linking + metadata derivation (outputs kanji_components.csv, updates radicals.csv)  <-- THIS DOC
    |
Phase 2.4: SVG Processing (updates svg fields on radicals.csv, radical_variants.csv, kanji.csv)
    |
Phase 2.5: Vocabulary extraction (outputs vocabulary CSVs, needs kanji.csv for vocabulary_kanji)
    |
Phase 3: AI Enrichment (refines logic_hint, populates system_mnemonic, search_tags)
```

Steps 1–2 (linking) depend on both the kanji rows from kanji composition and the radical rows from radical extraction. Step 3 (metadata derivation) depends on Step 2 (all links must exist before aggregation).

## Related Docs

- [kanji_component.md](../domain/kanji_component.md) — KanjiComponent entity spec (target schema, business rules, edge cases)
- [radical.md](../domain/radical.md) — Radical entity spec (master_symbol, variants, metadata fields)
- [kanji.md](../domain/kanji.md) — Kanji entity spec (min_grade, min_jlpt_level used in metadata derivation)
- [kanjivg_format.md](../sources/kanjivg_format.md) — KanjiVG SVG format (position values, radical markers, split parts)
- [ph2_1_radical_extraction.md](ph2_1_radical_extraction.md) — Passes 1–2 (radical registration) and full worked examples
- [ph2_2_kanji_composition.md](ph2_2_kanji_composition.md) — Steps 1–3 (kanji creation) and JLPT level mapping
- [pipeline.md](pipeline.md) — Full pipeline orchestration (Phases 1–4)
