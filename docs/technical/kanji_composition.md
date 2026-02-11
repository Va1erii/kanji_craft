# Kanji Composition

## Overview

Kanji composition transforms `raw_kanjidic` staging data into learnable kanji rows and their child tables: `kanji`, `kanji_readings`, and `kanji_i18n`. The result is a structured educational dataset where every kanji carries its readings, localized meanings, level classifications, and frequency ordering — everything the SRS engine needs to schedule lessons and the client needs to render cards.

This phase sits between radical extraction Passes 1–2 (which create `radicals` and `radical_variants`) and Passes 3–4 (which link kanji to their component radicals and derive radical metadata). The kanji rows must exist before component linking can reference them via `kanji_components.kanji_id`.

**What this phase does NOT do:** Component decomposition and radical metadata derivation. Those are documented in [radical_extraction.md](radical_extraction.md) Passes 3–4 and merely referenced here for sequencing.

## Source Data

The primary source is `raw_kanjidic` — the staging table populated by KANJIDIC2 ingestion (pipeline Phase 1.2). Each row contains the complete dictionary entry for a single character as structured JSONB. See [raw_kanjidic.md](../entities/raw_kanjidic.md) for the table schema and [kanjidic_format.md](../sources/kanjidic_format.md) for field-level mapping from the source XML.

Key fields consumed by this phase:

| `raw_kanjidic` field | Used in | Purpose |
|---|---|---|
| `literal` | Step 1 | The kanji character |
| `stroke_count` | Step 1 | Stroke count |
| `grade` | Step 1 | School grade (1–6, 8, 9, 10, or null) |
| `jlpt` | Step 1 | Old JLPT level 1–4 (pre-2010 scale) |
| `frequency` | Step 1 | Newspaper frequency rank (1–2501, or null) |
| `readings.ja_on` | Step 2 | Onyomi readings in katakana |
| `readings.ja_kun` | Step 2 | Kunyomi readings in hiragana (with okurigana markers) |
| `meanings` | Step 3 | Meanings grouped by language code |

## Algorithm

The composition runs in five steps over the active `raw_kanjidic` import. Each step is idempotent — re-running with the same data produces the same result.

### Step 1: Create Kanji Rows

For each `raw_kanjidic` row in the active import, upsert a `kanji` row.

**Field mapping:**

| `raw_kanjidic` | `kanji` | Transformation |
|---|---|---|
| `literal` | `character` | Direct copy |
| `stroke_count` | `stroke_count` | Direct copy |
| `grade` | `min_grade` | 1–6, 8 → keep; 9–10 → `null`; `null` → `null` |
| `jlpt` | `min_jlpt_level` | Map old 1–4 → new 1–5 via JLPT mapping table (see §JLPT Level Mapping) |
| `frequency` | `frequency_rank` | Direct for 1–2501; `null` → synthetic rank (see below) |
| — | `svg_file_name` | `null` at creation; populated in Phase 2.4 (SVG Processing) |
| — | `svg_file_url` | `null` at creation; populated in Phase 2.4 |
| — | `svg_hash` | `null` at creation; populated in Phase 2.4 |

**Grade mapping detail:**

KANJIDIC2 grade values carry specific meanings (see [kanjidic_format.md](../sources/kanjidic_format.md#grade-level)):

| `raw_kanjidic.grade` | `kanji.min_grade` | Meaning |
|---|---|---|
| 1–6 | 1–6 | Kyouiku kanji — elementary school grade |
| 8 | 8 | Remaining jouyou kanji — secondary school |
| 9 | `null` | Jinmeiyou (name kanji) — not part of the standard school curriculum |
| 10 | `null` | Jinmeiyou variant of jouyou kanji — same exclusion |
| `null` | `null` | Ungraded character |

Grades 9–10 map to `null` because these characters are approved for use in personal names and official documents but are not part of the jouyou set taught in schools. They may be excluded from the learnable kanji set depending on content scope.

**Synthetic frequency rank:**

Kanji outside the top 2,501 (the newspaper corpus survey) have `frequency = null` in KANJIDIC2. The pipeline assigns a synthetic rank to ensure `frequency_rank` is always populated:

1. Synthetic ranks start at a **safe offset of 10,001** (well above the maximum real rank of 2,501).
2. For each unranked kanji, assign `10,001 + N` where N increments per kanji. The relative order among unranked kanji is arbitrary but stable across re-runs (deterministic ordering by `literal` code point).

The safe offset keeps real frequency ranks (1–2,501) and synthetic ranks (10,001+) in numerically distinct ranges. This avoids collisions if a future KANJIDIC release expands its ranked set beyond 2,501, and enables simple filtering: `WHERE frequency_rank <= 2501` selects only kanji with proven corpus frequency.

This ensures `frequency_rank` is never null, allowing the client to sort all kanji within a level by frequency without null-handling logic.

**Upsert key:** `character` (unique constraint on `kanji`).

### Step 2: Create Reading Rows

For each kanji, extract readings from `raw_kanjidic.readings` and upsert into `kanji_readings`.

**Onyomi** (`readings.ja_on`):
- Each entry becomes a `kanji_readings` row with `reading_type = onyomi`.
- Stored as katakana (matching source format).

**Kunyomi** (`readings.ja_kun`):
- Each entry becomes a `kanji_readings` row with `reading_type = kunyomi`.
- Stored as hiragana, **preserving okurigana dots and prefix/suffix dashes** from KANJIDIC2. For example, `やす.む` is stored as-is — the dot marks the inflection boundary (kanji reads やす, む is appended hiragana). The client parses on the dot to split stem from suffix for display (see edge case below). The raw notation is preserved for admin review and future processing.

**Priority assignment:** All readings start as `primary`. KANJIDIC2 does not distinguish primary from secondary readings — every listed reading is considered equally important by the source. An admin may downgrade readings to `secondary` during review if a reading is archaic or domain-specific.

**Upsert key:** `(kanji_id, reading, reading_type)` — no duplicate readings for the same kanji.

**Validation:** After processing, every kanji must have at least one reading row. If a `raw_kanjidic` entry has empty `ja_on` and empty `ja_kun`, log a warning (this should not happen per KANJIDIC2 rules — every character has at least one Japanese reading).

### Step 3: Create I18n Rows

For each kanji, create localized meaning rows in `kanji_i18n` for each target language in the pipeline configuration (default: `['en', 'es']`).

For each target language:

1. Look up `raw_kanjidic.meanings[lang_code]`.
2. If the language key is present and the meanings array is non-empty:
   - `meanings` ← the array as-is (preserves source ordering, which is priority order).
   - `system_mnemonic` ← empty string placeholder. Populated by AI in Phase 2.5 or manually by admin.
   - `search_tags` ← empty array. Populated later during content enrichment.
3. If the language key is not present in `raw_kanjidic.meanings`, **skip** — do not create an i18n row. Fallback to English happens at query time per [kanji.md](../entities/kanji.md) edge cases, not at ingestion time.

**Upsert key:** `(kanji_id, lang_code)`.

**Validation:** After processing, every kanji must have at least an English (`en`) i18n row. KANJIDIC2 always includes English meanings, so a missing `en` row indicates a parser bug.

### Step 4: Component Linking

For each kanji, link to its direct child radicals from `raw_kanjivg.components`.

This step is the same operation as radical extraction Pass 3. The full algorithm — including structural group flattening, split part merging, variant resolution, position mapping, and radical_type determination — is documented in [radical_extraction.md Pass 3](radical_extraction.md#pass-3-link--create-kanjicomponent-rows).

**Prerequisite:** Steps 1–3 must complete first (kanji rows must exist for `kanji_components.kanji_id`). Radical extraction Passes 1–2 must also have completed (radicals must exist for `kanji_components.radical_id`).

### Step 5: Metadata Derivation

Compute derived fields on each radical: `impact_score`, `min_grade`, `min_jlpt_level`.

This step is the same operation as radical extraction Pass 4. The full algorithm — including impact score bucketing and the MIN/MAX queries for grade and JLPT — is documented in [radical_extraction.md Pass 4](radical_extraction.md#pass-4-derive--compute-radical-metadata).

**Prerequisite:** Step 4 must complete first (component links must exist for the aggregation queries).

## JLPT Level Mapping

KANJIDIC2 uses the **pre-2010 JLPT scale** (levels 1–4). Our schema uses the **current scale** (levels 1–5, where 5 = N5 easiest, 1 = N1 hardest). The mapping between old and new is not 1:1 — the 2010 JLPT reform split old level 4 into N4 and N5, and redistributed kanji across adjacent levels:

| Old Level | Approximate New Level(s) | Notes |
|---|---|---|
| 4 | N5, N4 | Old 4 was split — simpler kanji became N5, rest became N4 |
| 3 | N4, N3 | Old 3 maps roughly to N4, some overlap with N3 |
| 2 | N3, N2 | Old 2 was split between N2 and N3 |
| 1 | N1 | Old 1 maps to N1 |

Because of these splits, the raw `jlpt` value **cannot be mechanically converted** to a new level. Instead, the pipeline uses an **external JLPT mapping table** — a curated dataset that maps individual kanji characters to their current N1–N5 level based on community-maintained kanji lists.

**Source data:** The de-facto standard for "New JLPT" kanji lists is the [Tanos (Jonathan Waller)](https://www.tanos.co.uk/jlpt/) collection, supplemented by community-maintained JLPT Resources lists. A curated CSV (`jlpt_mapping.csv`) is committed to `sources/jlpt_mapping/` and loaded into the `source_jlpt_levels` table (see [jlpt_mapping_format.md](../sources/jlpt_mapping_format.md)). Each row maps a single character to its N1–N5 level.

**Strategy:**

1. `raw_kanjidic.jlpt` stores the raw 1–4 value for reference and auditing.
2. The `source_jlpt_levels` table maps `character → N level` (integer 1–5), sourced from `sources/jlpt_mapping/jlpt_mapping.csv`.
3. During Step 1, look up each kanji's character in the lookup table:
   - Found → set `kanji.min_jlpt_level` to the mapped value.
   - Not found → set `kanji.min_jlpt_level` to `null`.
4. Kanji with `null` JLPT level are excluded from JLPT-based study paths but remain accessible via grade-based paths and search.

**Note on `min_jlpt_level` semantics:** The value 5 means N5 (easiest), 1 means N1 (hardest). This means `MAX(min_jlpt_level)` returns the easiest level — relevant for radical metadata derivation in Pass 4 (see [radical_extraction.md](radical_extraction.md#pass-4-derive--compute-radical-metadata)).

## Deferred Fields

Several fields on the `kanji` table are **null at creation time** and populated by later pipeline phases:

| Field | Populated in | Phase |
|---|---|---|
| `svg_file_name` | SVG Processing | 2.4 |
| `svg_file_url` | SVG Processing | 2.4 |
| `svg_hash` | SVG Processing | 2.4 |

This is the same pattern used by radical extraction (see [radical_extraction.md](radical_extraction.md) schema note on deferred fields). The domain entity ([kanji.md](../entities/kanji.md)) defines the complete kanji — all fields populated. The Release Builder (Phase 4) rejects rows with null SVG fields before remote sync — only fully-populated kanji are eligible.

**Migration needed:** The current `kanji` table schema defines SVG fields as `NOT NULL`. A migration is needed to make `svg_file_name`, `svg_file_url`, and `svg_hash` nullable, matching the same pattern applied to radicals in migration `20260210150814`. Without this migration, Step 1 cannot insert kanji rows with null SVG fields.

**Note on `frequency_rank`:** Unlike SVG fields, `frequency_rank` is always populated at Step 1 — ranked kanji get their source value, unranked kanji get a synthetic rank. No nullable migration is needed for this field.

## Ordering Constraints

The full Phase 2 execution order, showing where kanji composition fits:

```
Phase 1.2: raw_kanjidic ingestion (populates raw_kanjidic)
    |
Phase 2.2 Passes 1-2: Radical extraction (populates radicals, radical_variants)
    |
Phase 2.3 Steps 1-3: Kanji composition (populates kanji, kanji_readings, kanji_i18n)  <-- THIS DOC
    |
Phase 2.2 Passes 3-4: Component linking + radical metadata (populates kanji_components, updates radicals)
    |
Phase 2.4: SVG Processing (populates svg fields on radicals, radical_variants, kanji)
    |
Phase 2.5: AI Heuristics (populates logic_hint, creates kanji_component_reviews)
    |
Phase 2.6: Vocabulary extraction (needs kanji table for vocabulary_kanji)
```

Steps 1–3 (kanji creation) depend only on `raw_kanjidic` and can run independently of radical extraction. Steps 4–5 (component linking and metadata derivation) depend on both the kanji rows from Steps 1–3 and the radical rows from Passes 1–2.

## Worked Example

### 日 (Day/Sun)

**Source:** `raw_kanjidic` entry:
```
literal       = 日
stroke_count  = 4
grade         = 1
jlpt          = 4
frequency     = 1
readings.ja_on  = ["ニチ", "ジツ"]
readings.ja_kun = ["ひ", "-び", "-か"]
meanings.en     = ["day", "sun", "Japan", "counter for days"]
meanings.es     = ["día", "sol", "Japón"]
```

**Step 1 → `kanji` row:**

| Field | Value | Notes |
|---|---|---|
| `character` | 日 | Direct copy |
| `stroke_count` | 4 | Direct copy |
| `min_grade` | 1 | Grade 1 → keep |
| `min_jlpt_level` | 5 | Old level 4 → mapped to N5 via JLPT mapping table |
| `frequency_rank` | 1 | Direct copy (most common kanji) |
| `svg_file_name` | `null` | Deferred to Phase 2.4 |
| `svg_file_url` | `null` | Deferred to Phase 2.4 |
| `svg_hash` | `null` | Deferred to Phase 2.4 |

**Step 2 → `kanji_readings` rows (5 rows):**

| `reading` | `reading_type` | `priority` |
|---|---|---|
| ニチ | `onyomi` | `primary` |
| ジツ | `onyomi` | `primary` |
| ひ | `kunyomi` | `primary` |
| -び | `kunyomi` | `primary` |
| -か | `kunyomi` | `primary` |

Note: the dashes on -び and -か are preserved as-is (prefix/suffix markers from KANJIDIC2).

**Step 3 → `kanji_i18n` rows (2 rows):**

For `en`:
| Field | Value |
|---|---|
| `lang_code` | en |
| `meanings` | ["day", "sun", "Japan", "counter for days"] |
| `system_mnemonic` | "" |
| `search_tags` | [] |

For `es`:
| Field | Value |
|---|---|
| `lang_code` | es |
| `meanings` | ["día", "sol", "Japón"] |
| `system_mnemonic` | "" |
| `search_tags` | [] |

### 龍 (Dragon) — Unranked, High Grade

**Source:** `raw_kanjidic` entry:
```
literal       = 龍
stroke_count  = 16
grade         = null
jlpt          = null
frequency     = null
readings.ja_on  = ["リュウ", "リョウ", "ロウ"]
readings.ja_kun = ["たつ"]
meanings.en     = ["dragon", "imperial"]
```

**Step 1 → `kanji` row:**

| Field | Value | Notes |
|---|---|---|
| `character` | 龍 | |
| `stroke_count` | 16 | |
| `min_grade` | `null` | No grade assignment |
| `min_jlpt_level` | `null` | Not in JLPT mapping table |
| `frequency_rank` | 10,001+ | Synthetic rank (no newspaper frequency; safe offset) |
| `svg_*` | `null` | Deferred |

This kanji is excluded from both JLPT-based and grade-based study paths. It surfaces only via search or browse.

## Business Rules

1. Every `raw_kanjidic` row produces exactly one `kanji` row (upsert on `character`).
2. `stroke_count` must be a positive integer (validated during raw_kanjidic ingestion).
3. `min_grade` mapped: 1–6, 8 → keep; 9–10 → `null`; `null` → `null`.
4. `min_jlpt_level` must come from the JLPT mapping table, not from `raw_kanjidic.jlpt` directly. The raw `jlpt` field is reference-only.
5. Every kanji must have at least one reading row after Step 2.
6. Every kanji must have at least one `primary` reading.
7. `kanji_i18n` required for `en` at minimum (KANJIDIC2 always has English meanings).
8. `kanji_i18n.meanings` must have at least one entry per row.
9. Kunyomi readings preserve okurigana notation: dots for inflection points (e.g. `やす.む`), dashes for prefixes/suffixes (e.g. `-び`).
10. Re-processing the same `raw_kanjidic` data produces the same result (idempotent upserts).
11. `frequency_rank` is always populated — ranked kanji get their source value, unranked kanji get a synthetic rank.

## Edge Cases

### Kanji outside JLPT set
The JLPT mapping table does not cover every kanji in KANJIDIC2. Unmapped kanji get `min_jlpt_level = null` and are invisible to users on the JLPT study path. They remain accessible via grade-based paths (if graded) or search.

### Kanji with grade 9–10 (jinmeiyou)
Name kanji (grade 9) and jouyou variants used in names (grade 10) map to `min_grade = null`. These may be excluded from the learnable set entirely depending on content scope. The raw grade is preserved in `raw_kanjidic.grade` for reference.

### Kanji without frequency
Characters outside the newspaper corpus top 2,501 have no frequency rank. The pipeline assigns a synthetic rank starting at 10,001 (incrementing per unranked kanji ordered by code point) to ensure `frequency_rank` is never null and to keep synthetic ranks numerically distinct from real corpus ranks.

### Kunyomi with okurigana dots
Readings like `やす.む` (for 休む) are stored as-is in `kanji_readings.reading`. The dot marks where the kanji's reading ends and the appended hiragana begins. The client must parse on the dot — not just strip it — to split the stem (`やす`) from the okurigana suffix (`む`). This enables differentiated display (e.g. bold stem + light suffix, or color-coded segments) rather than a flat string. A naive `replace('.', '')` loses the inflection boundary information.

### Kunyomi with prefix/suffix dashes
Readings like `-び` and `-か` (for 日 in compounds like 祝日) are stored as-is. The dash indicates the reading only occurs as part of a compound, not independently.

### Languages not in target set
If a target language (e.g. `es`) has no entry in `raw_kanjidic.meanings`, no `kanji_i18n` row is created for that language-kanji pair. This is not an error — Spanish coverage in KANJIDIC2 is partial. The client falls back to English at query time (see [kanji.md](../entities/kanji.md) edge cases).

### Kanji in raw_kanjidic but not in raw_kanjivg
A kanji row is created from KANJIDIC2 data even if no matching KanjiVG entry exists. Steps 1–3 succeed, but Step 4 (component linking) produces no `kanji_components` rows for this character. This is logged as a warning — it means the kanji exists as a learnable item but has no decomposition tree. The admin should investigate missing KanjiVG coverage.

### JLPT mapping table missing entry
Same outcome as "Kanji outside JLPT set" — `min_jlpt_level = null`. The kanji is still valid and learnable; it just won't appear in JLPT-filtered study paths.

### Kanji with empty readings
Should not occur — KANJIDIC2 guarantees at least one `ja_on` or `ja_kun` reading per character. If encountered, log a warning and create the kanji row without readings. Content validation tooling should flag these for review.

## Output Summary

| Table | What gets created | Source |
|---|---|---|
| `kanji` | One row per `raw_kanjidic` entry | Step 1 |
| `kanji_readings` | One row per reading per kanji | Step 2 |
| `kanji_i18n` | One row per language per kanji (for target languages with data) | Step 3 |

Tables populated by **this phase but documented elsewhere:**
- `kanji_components` — component linking (Step 4, see [radical_extraction.md Pass 3](radical_extraction.md#pass-3-link--create-kanjicomponent-rows))

Tables populated by **later phases** (not this algorithm):
- `kanji.svg_*` fields — SVG Processing (Phase 2.4)
- `kanji_component_reviews` — AI Heuristics (Phase 2.5)

## Related Docs

- [kanji.md](../entities/kanji.md) — Kanji entity spec (target schema)
- [kanji_component.md](../entities/kanji_component.md) — KanjiComponent entity and review state
- [raw_kanjidic.md](../entities/raw_kanjidic.md) — Source staging table schema
- [kanjidic_format.md](../sources/kanjidic_format.md) — KANJIDIC2 XML format reference (JLPT mapping, grade values)
- [radical_extraction.md](radical_extraction.md) — Passes 3–4 algorithm (component linking, metadata derivation)
- [pipeline.md](pipeline.md) — Full pipeline orchestration (Phases 1–4)
