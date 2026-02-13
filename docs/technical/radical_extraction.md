# Radical Extraction

## Overview

Radical extraction turns the nested KanjiVG component trees (stored in `raw_kanjivg.components`) into flat, queryable rows in `radicals`, `radical_variants`, and `kanji_components`. The result is a **Lego-style learning graph** — every kanji is built from a small set of meaningful pieces, and the learner masters each piece before assembling the next character.

**Core principle:** Each kanji decomposes into **meaningful building blocks** — either standalone learnable kanji, official Kangxi radicals, or high-frequency components. Intermediate structural groupings ("ghost radicals") that aren't independently useful to learners are transparently flattened: their children are promoted to become direct children of the parent kanji. Progressive decomposition still applies — multi-level learning chains emerge from the dataset — but only between meaningful components, never through opaque intermediates.

## Scope: JLPT/Grade Kanji Only

KanjiVG covers ~6,700 characters. Processing all of them produces thousands of radical candidates — far too many for a pedagogical app. Most of these come from rare, non-educational kanji that learners will never encounter.

**The filter:** Radical extraction only processes `raw_kanjivg` entries whose character is **educationally relevant** — defined as appearing in `raw_kanjidic` with a non-null `grade`, OR appearing in `source_jlpt_level_entries`. This limits extraction to the ~2,136 kanji in JLPT N5–N1 and/or school grades 1–8.

**How the scope set is built (before Pass 1):**

1. Query `raw_kanjidic` for characters where `grade IS NOT NULL` → set A.
2. Query `source_jlpt_level_entries` for all `kanji_character` values → set B.
3. Scope set = A ∪ B.

Only `raw_kanjivg` entries whose `character` is in the scope set are scanned in Passes 1–2 and linked in Passes 3–4.

**Consequences:**

- Components of in-scope kanji become radical candidates — even if the component itself is not in scope (e.g. 吾 is a component of 語, so 吾 may be registered as a radical regardless of 吾's own JLPT/grade status).
- Components that **only** appear in out-of-scope kanji are never registered. They don't reach learners, so they don't need to be learned.

## Keep Set: What Becomes a Radical

Not every element encountered during scanning becomes a radical. To keep the radical count learnable (~350–450), the pipeline builds a **keep set** — the set of elements that are meaningful enough to register as radicals. An element is in the keep set if ANY of the following is true:

1. **Learnable kanji:** The element is in the JLPT/grade scope set. These are standalone characters the learner will encounter — they should be recognizable building blocks.

2. **Official Kangxi radical:** The element has been marked `radical='general'` in ANY `raw_kanjivg` entry (not just in-scope entries). The 214 Kangxi radicals are the traditional building blocks of CJK characters and are widely taught in reference materials. The official set is built by scanning ALL raw_kanjivg entries to avoid missing designations that only appear in out-of-scope kanji.

3. **High-frequency component:** The element appears as a direct child in **3 or more** in-scope kanji (counted before ghost flattening). Even if a component isn't a standalone kanji or official radical, appearing frequently makes it a reusable learning unit worth memorizing.

Elements NOT in the keep set are **ghost radicals** — intermediate structural groupings from KanjiVG that aren't independently useful to learners. Ghost radicals are flattened (see below).

## Ghost Radical Flattening

**Problem:** KanjiVG decomposes characters into fine-grained structural groups. Many of these groups (e.g. 粦, 龺, 耂) aren't standalone kanji, aren't official radicals, and appear rarely. Registering all of them produces hundreds of opaque symbols that learners must memorize without context — defeating the purpose of a Lego-style approach.

**Solution:** When a direct child of a kanji is a ghost radical (not in the keep set), the pipeline **flattens** it — replacing the ghost with its own children from its KanjiVG entry. This is recursive: if a ghost's children are also ghosts, they too are flattened, until every remaining component is in the keep set or cannot be decomposed further.

**Example:**

```
Before flattening (raw KanjiVG):        After flattening:
燐 (root)                               燐 (root)
├── 火 — left (kanji → KEEP)            ├── 火 — left
└── 粦 — right (GHOST)                  ├── 米 — top
    ├── 米 — top (kanji → KEEP)         └── 舛 — bottom
    └── 舛 — bottom (official → KEEP)
```

粦 is not a learnable kanji, not a Kangxi radical, and appears in fewer than 3 in-scope kanji. Its children 米 (kanji, grade 2) and 舛 (Kangxi #136) are in the keep set, so they become direct children of 燐.

**Algorithm:**

```
resolveEffectiveChildren(component, keepSet, treeMap, depth):
  if depth > 10: return [component's children as-is]  // safety guard

  directChildren = flattenEmptyElements(component.children) + mergeSplitParts(...)

  result = []
  for child in directChildren:
    masterSymbol = child.variant ? child.original : child.element

    if masterSymbol in keepSet:
      result.add(child)  // meaningful component — keep
    else:
      // Ghost radical — try to flatten
      ghostTree = treeMap[masterSymbol]
      if ghostTree exists AND ghostTree has children:
        result.addAll(resolveEffectiveChildren(ghostTree, keepSet, treeMap, depth + 1))
      else:
        result.add(child)  // no tree or leaf — keep as unflattenable radical

  return result
```

**Position inheritance:** Promoted children keep their positions from the ghost's component tree. If 粦 was at position "right" and its child 米 was at position "top", 米 keeps position "top" (its position within the ghost's sub-tree). This preserves the most specific spatial information available.

**Unflattenable ghosts:** If a ghost radical has no KanjiVG entry, or its entry has no children, it cannot be decomposed further. It stays as a **leaf radical** — an atomic building block the learner memorizes directly. This is expected for some rare components and does not block extraction.

**Depth guard:** Recursion is limited to 10 levels. In practice, KanjiVG trees rarely exceed 3–4 levels. The guard prevents infinite loops from hypothetical circular references.

## Progressive Decomposition

Consider the kanji 語 (Language). In KanjiVG it decomposes as:

```
語 (root)
├── 言 (Speech) — hen (left)
└── 吾 (Myself) — tsukuri (right)
    ├── 五 (Five)  — kanmuri (top)
    └── 口 (Mouth) — ashi (bottom)
```

Both 言 and 吾 are in the keep set (learnable kanji with JLPT/grade status), so they are NOT flattened. The progressive approach records only the effective children (which match the direct children here):

| Kanji | Components | Source |
|---|---|---|
| 語 | 言 (hen) + 吾 (tsukuri) | 語's effective children |
| 吾 | 五 (kanmuri) + 口 (ashi) | 吾's effective children |

Each decomposition is **one level deep** (after ghost flattening). The multi-level chain emerges from the dataset: 吾 appears as both a radical (component of 語) and a kanji (with its own components). The SRS unlocking rule (`stability >= 7.0 days` on all component radicals) enforces the learning order:

```
Step 1: Learn radicals 五, 口
Step 2: Unlock kanji 吾 (requires 五 + 口 mastered)
Step 3: Learn radical 言 (+ learn kanji 吾)
Step 4: Unlock kanji 語 (requires 言 + 吾 mastered)
```

**Ghost vs progressive:** Ghost flattening and progressive decomposition serve different goals. Progressive decomposition preserves meaningful intermediate steps (言 → 語 requires learning 言 first). Ghost flattening removes meaningless intermediates (粦 → 燐 would require learning an opaque symbol). The two mechanisms work together: progressive chains form between keep-set elements, while ghost intermediates are transparently bypassed.

### Dual Identity

A character that appears as a component of another kanji exists in **two tables**:

- `radicals` row — its identity as a building block (referenced by `kanji_components.radical_id`)
- `kanji` row — its identity as a learnable item with readings, meanings, and its own SRS card

This dual identity is by design (see [radical.md rule #10](../entities/radical.md)). `kanji_components` always references `radicals.id`, never `kanji.id`.

Examples: 言, 吾, 木, 金, 山, 口, 五 — all are both radicals and kanji.

## Algorithm

The extraction runs in four passes over the active `raw_kanjivg` import. Each pass is idempotent — re-running with the same data produces the same result.

### Pass 0: Build Scope Set

Before scanning, compute the set of educationally relevant kanji characters (see §Scope above).

```
Input:  raw_kanjidic rows for the active import_id + source_jlpt_level_entries
Output: Set<String> scopeCharacters
```

1. Query `raw_kanjidic` for the active import: collect `character` where `grade IS NOT NULL`.
2. Query `source_jlpt_level_entries`: collect all `kanji_character` values.
3. Merge into `scopeCharacters = graded ∪ jlpt`.

This set is used by Passes 1–4 to filter which `raw_kanjivg` entries are processed.

### Pass 1: Scan — Build Keep Set and Collect Radical Candidates

Pass 1 has four sub-steps: build the official set, count frequencies, construct the keep set, and scan with ghost flattening.

```
Input:  ALL raw_kanjivg rows (for official set + tree lookups),
        in-scope raw_kanjivg rows (for scanning),
        scopeCharacters from Pass 0
Output: Set<RadicalCandidate>, Set<String> keepSet
```

**1a. Build official set:** Scan ALL `raw_kanjivg` entries (not just in-scope). For every component node in any tree that has `radical='general'`, resolve the master symbol (use `original` if variant, else `element`) and add it to the official set. This ensures no Kangxi radical is missed due to scope filtering.

**1b. Count raw frequencies:** For each in-scope `raw_kanjivg` entry, extract direct children (after empty-element flattening and part merging, but BEFORE ghost flattening). For each child, resolve the master symbol and increment its count. Output: `Map<String, int>` — element frequency across in-scope kanji.

**1c. Build keep set:** `keepSet = scopeCharacters ∪ officialSet ∪ { elem | frequency[elem] >= 3 }`

**1d. Scan with ghost flattening:** Build a tree lookup map from ALL `raw_kanjivg` entries: `Map<String, KanjiVgComponent>` (character → root component). Then for each in-scope entry:

1. Resolve **effective children** using the ghost flattening algorithm (see §Ghost Radical Flattening). This replaces ghost intermediates with their own children recursively.
2. For each effective child:
   - Record the `element` as a radical candidate.
   - If `variant == true` and `original` is present, record the variant relationship: `element` is a shape of `original`.
   - If `radical == 'general'`, mark as official Kangxi radical.
   - Record any `position` values seen for this element across all kanji trees.
3. **Merge split parts** across effective children (same element, different `part` values).

**Important:** The scanner no longer follows the "direct children only" principle literally. Ghost flattening may promote grandchildren or deeper descendants. However, it only crosses levels through ghost intermediates — meaningful components (in the keep set) are never bypassed.

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
   - `stroke_count` — looked up from `raw_kanjivg` where `character == master_symbol` (the master's own entry, from ALL entries not just in-scope).
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

For each **in-scope** `raw_kanjivg` entry, create `kanji_components` linking the kanji to its **effective child radicals** (after ghost flattening). The same keep set and flattening algorithm from Pass 1 is applied to ensure consistency. Only kanji in `scopeCharacters` are processed — out-of-scope kanji get no component links. The full algorithm — including structural group flattening, split part merging, variant resolution, position mapping, radical_type determination, and worked examples — is documented in [component_linking.md](component_linking.md).

**Summary:** For each in-scope kanji, resolve effective children via ghost flattening, resolve each child to its master radical, map position and radical_type from KanjiVG attributes, and upsert a `kanji_components` row. Default `logic_hint = semantic` (refined later by AI Heuristics in Phase 2.6). Upsert key: `(kanji_id, radical_id, position)`.

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

Both 人 (master of 亻) and 木 are in the keep set (learnable kanji). No ghost flattening needed.

**Pass 1** collects: `{亻 (variant of 人), 木}`

**Pass 2** creates:
- `radicals`: (master_symbol=人, is_official=true), (master_symbol=木, is_official=false)
- `radical_variants`: (radical=人, shape=亻, position=hen, is_locked=true), (radical=人, shape=人, position=...), (radical=木, shape=木, position=...)

**Pass 3** creates:
- `kanji_components`: (kanji=休, radical=人, position=hen), (kanji=休, radical=木, position=tsukuri)

### Ghost Flattening: Kanji with Non-Learnable Intermediate

Consider a kanji whose KanjiVG tree contains a ghost component:

```
Before flattening (raw KanjiVG):        After flattening:
X (root)                                X (root)
├── 火 — left (kanji → KEEP)            ├── 火 — left
└── G — right (GHOST)                   ├── 米 — top
    ├── 米 — top (kanji → KEEP)         └── 舛 — bottom
    └── 舛 — bottom (official → KEEP)
```

G is not in the scope set, not an official Kangxi radical, and appears as a direct child in fewer than 3 in-scope kanji. Ghost flattening promotes G's children (米 and 舛) to become effective children of X.

**Pass 1** collects: `{火, 米, 舛}` — G is never registered as a radical candidate.

**Pass 3** creates:
- `kanji_components`: (kanji=X, radical=火, position=hen), (kanji=X, radical=米, position=kanmuri), (kanji=X, radical=舛, position=ashi)

Note: 米 and 舛 keep their positions from G's sub-tree, not G's position.

### Recursive Ghost Flattening

If a ghost's children are also ghosts, flattening continues recursively:

```
Before:                          After:
Y (root)                        Y (root)
└── G1 (GHOST)                  ├── A — left
    ├── A — left (KEEP)         ├── B — top
    └── G2 (GHOST)              └── C — bottom
        ├── B — top (KEEP)
        └── C — bottom (KEEP)
```

Both G1 and G2 are flattened. Y's effective children are [A, B, C].

### Progressive: 語 (Language) = 言 + 吾

KanjiVG tree for 語:
```
語 (root)
├── 言 — position: hen
└── 吾 — position: tsukuri
    ├── 五 — position: kanmuri
    └── 口 — position: ashi
```

Both 言 and 吾 are in the keep set (learnable kanji with JLPT/grade status). No ghost flattening occurs. Processing 語's entry (one level deep):
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

### Ghost radical with no KanjiVG entry

A ghost component may not have its own `raw_kanjivg` entry. In this case, flattening cannot proceed — the ghost becomes a **leaf radical** (an atomic building block with no further decomposition). It is registered as a radical because it's used by an in-scope kanji. This is expected for some rare CJK components.

### Ghost radical with no children (leaf in KanjiVG)

A ghost's KanjiVG entry may exist but have an empty children array. Like the case above, flattening cannot proceed. The ghost stays as a leaf radical.

### All children of a ghost are also ghosts

Recursive flattening continues through chains of ghosts until reaching keep-set elements or unflattenable leaves. In practice, chains rarely exceed 2 levels.

### Ghost flattening produces duplicate elements

After flattening, two different ghosts may contribute the same child element. The scanner deduplicates by master symbol — the element is registered once as a radical candidate. In `kanji_components`, the unique constraint `(kanji_id, radical_id, position)` prevents duplicate rows.

### Component element missing from `raw_kanjivg` or out of scope

A child's `element` may not have its own `raw_kanjivg` entry (e.g. a rare sub-component), or its entry may exist but the character is not in the JLPT/grade scope set. If the element is in the keep set, it becomes a normal radical. If it's a ghost without a KanjiVG entry, it becomes a leaf radical (see above).

### Empty `element` on a child node

Some KanjiVG `<g>` groups are structural (stroke groupings) without a meaningful `element`. Skip these nodes and process their children as if they were direct children of the parent. This "structural flattening" is applied BEFORE ghost flattening and is distinct from it — structural flattening removes empty wrappers, ghost flattening replaces non-learnable intermediates.

### Component appears in both Kangxi and Nelson systems

A single kanji may have two children with `radical` markers — one `'general'` (Kangxi) and one `'nelson'` (Nelson). Both are preserved during scanning. A radical is marked `is_official: true` if **any** occurrence carries `radical == 'general'`. The Nelson marker is informational and doesn't affect the extraction or keep set.

### Variant without `original`

If a node has `variant == true` but `original` is null ([raw_kanjivg.md edge case](../entities/raw_kanjivg.md)), log a warning. Treat the element as its own master symbol (non-variant). The admin can manually link it during review.

### Kanji with no children (leaf kanji)

Characters like 一, 丨, 丶 have flat component trees — the root with an empty `children` array. No `kanji_components` rows are created. These characters serve as atomic radicals for other kanji. They have no SRS prerequisites and are immediately available for lessons.

### Self-referential radical

A kanji's `master_symbol` in `radicals` may equal its `character` in `kanji`. For example, 木 is both a radical and a kanji. The `kanji_components` for kanji 木 are empty (it's a leaf), but `kanji_components` for 休 reference radical 木. Both rows exist independently.

### Duplicate component positions

If the same radical appears at the same position in the same kanji (after part merging and ghost flattening), the unique constraint `(kanji_id, radical_id, position)` prevents duplicates. The upsert is a no-op.

### Radical with no graded kanji

With the JLPT/grade scope filter, this situation is rare — most radicals inherit metadata from the in-scope kanji that contain them. However, it can still happen if a radical only appears in kanji that have JLPT/grade status from one system but not the other. The Pass 4 queries return `null` for the missing system. The radical is still usable; it won't appear in the corresponding study path (JLPT or grade) but remains accessible via search/browse.

### Component not in KANJIDIC

A radical extracted from KanjiVG may not have a corresponding entry in `raw_kanjidic` (e.g. rare components, non-standard decompositions). The radical row is still created — it just won't have its own kanji row with readings or KANJIDIC-sourced metadata. This is expected for custom radicals (`is_official: false`).

### High-frequency threshold edge cases

The threshold of 3 is a starting point. After running extraction on real data, the admin should review:
- Elements just below the threshold (frequency 2) that might be pedagogically useful — consider lowering to 2
- Elements just above the threshold (frequency 3) that are opaque to learners — consider raising to 4

The threshold can be adjusted without schema changes — it only affects which elements get flattened.

## Warnings

The phase uses the `Warning` class with `WarningSeverity` (see [pipeline.md §Warning Pattern](pipeline.md#warning-pattern)).

| Condition | Severity | Rationale |
|---|---|---|
| Variant without `original` (`variant == true` but `original` is null) | low | Data quality issue — element treated as its own master symbol; admin can manually link later |
| Ghost radical unflattenable (not in keep set, no tree or no children) | low | Informational — leaf radical created from a component that couldn't be decomposed |
| Recursion depth exceeded during ghost flattening | high | Should not happen with real KanjiVG data — indicates circular reference or unexpectedly deep nesting |
| Ghost radical flattened | — | Not a warning — expected behaviour. Logged at debug level only |
| `raw_kanjivg` entry skipped (character not in JLPT/grade scope) | — | Not a warning — expected behaviour. Logged at debug level only |

## Output Summary

| Table | What gets created | Source |
|---|---|---|
| `radicals` | One row per unique keep-set element (by master symbol) found as effective children of in-scope kanji | Pass 2 |
| `radical_variants` | One row per visual shape per radical | Pass 2 |
| `kanji_components` | One row per effective-child component per in-scope kanji (after ghost flattening) | Pass 3 |

**Expected counts** (approximate, for KanjiVG ~20250816 + KANJIDIC ~20260208):
- ~2,136 kanji in scope (JLPT/grade)
- ~350–450 unique radicals (down from ~985 with scope-only filtering, ~1,400 unfiltered)
- ~350–500 radical variants

Tables populated by **later phases** (not this algorithm):
- `radical_i18n` — names and mnemonics (Phase 2.6B, KANJIDIC meanings + AI)
- `kanji_component_reviews` — verification state (Phase 2.6A, AI Heuristics)
- SVG fields on `radicals` and `radical_variants` — (Phase 2.4, SVG Processing)

## Ordering Constraint

Pass 0 (scope set) requires `raw_kanjidic` and `source_jlpt_level_entries` to be loaded (Phase 1 complete). Passes 1–2 (radical and variant creation) have **no dependency** on the `kanji` table and can run independently after Pass 0. Pass 3 (component linking) must run **after** kanji creation from KANJIDIC ([pipeline.md §2.3](pipeline.md#23-kanji--component-composition)), because `kanji_components.kanji_id` references the `kanji` table. Pass 4 (metadata derivation) must run after Pass 3. The full Phase 2 order is:

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
