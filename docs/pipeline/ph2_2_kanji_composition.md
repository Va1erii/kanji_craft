# Kanji Composition

## Overview

Kanji composition transforms KANJIDIC2 data (from `kanjidic.parquet`) into structured output CSVs: `kanji.csv`, `kanji_readings.csv`, and `kanji_i18n.csv`. The result is a structured educational dataset where every kanji carries its readings, localized meanings, level classifications, and frequency ordering. Some fields (e.g. `system_mnemonic`, `search_tags`) are left empty for Phase 3 (AI enrichment) to populate.

This phase sits between radical extraction Passes 1–2 (which create `radicals` and `radical_variants`) and Passes 3–4 (which link kanji to their component radicals and derive radical metadata). The kanji rows must exist before component linking can reference them via `kanji_components.kanji_id`.

**What this phase does NOT do:** Component decomposition and radical metadata derivation. Those are documented in [ph2_1_radical_extraction.md](ph2_1_radical_extraction.md) Passes 3–4 and merely referenced here for sequencing.

## Source Data

The primary source is `kanjidic.parquet` — the Parquet file produced by KANJIDIC2 ingestion (pipeline Phase 1). Each row contains the complete dictionary entry for a single character with structured columns. See [kanjidic_format.md](../sources/kanjidic_format.md) for field-level mapping from the source XML.

Key fields consumed by this phase:

| `kanjidic.parquet` field | Used in | Purpose |
|---|---|---|
| `literal` | Step 1 | The kanji character |
| `stroke_count` | Step 1 | Stroke count |
| `grade` | Step 1 | School grade (1–6, 8, 9, 10, or null) |
| `jlpt` | — | Old JLPT level 1–4 (pre-2010 scale) — reference only, not used for mapping |
| `frequency` | Step 1 | Newspaper frequency rank (1–2501, or null) |
| `readings.ja_on` | Step 2 | Onyomi readings in katakana |
| `readings.ja_kun` | Step 2 | Kunyomi readings in hiragana (with okurigana markers) |
| `meanings` | Step 3 | Meanings grouped by language code |

## Algorithm

The composition runs in five steps over the KANJIDIC2 Parquet data. Each step is idempotent — re-running with the same data produces the same output files.

**Strategy:** Steps 1-3 write complete CSV files from scratch (overwriting any previous output). This is simpler than incremental updates for the ~13K character dataset. Idempotency is preserved — re-running produces identical CSV output.

### Step 1: Create Kanji Rows

For each row in `kanjidic.parquet`, write a row to `kanji.csv`.

**Field mapping:**

| `kanjidic.parquet` | `kanji.csv` | Transformation |
|---|---|---|
| `literal` | `character` | Direct copy |
| `stroke_count` | `stroke_count` | Direct copy |
| `grade` | `min_grade` | Direct copy (1–6, 8, 9, 10, or null) |
| — | `min_jlpt_level` | From `jlpt_kanji.parquet` lookup (see §JLPT Level Mapping); `kanjidic.parquet` `jlpt` is ignored |
| `frequency` | `frequency_rank` | Direct for 1–2501; `null` → synthetic rank (see below) |
| — | `svg_file_name` | Empty; populated by SVG Processing (Phase 2.4) |
| — | `svg_file_url` | Empty; populated by SVG Processing (Phase 2.4) |
| — | `svg_hash` | Empty; populated by SVG Processing (Phase 2.4) |

**Grade values:**

KANJIDIC2 grade values carry specific meanings (see [kanjidic_format.md](../sources/kanjidic_format.md#grade-level)):

| `kanjidic.parquet` grade | `kanji.csv` min_grade | Meaning |
|---|---|---|
| 1–6 | 1–6 | Kyouiku kanji — elementary school grade |
| 8 | 8 | Remaining jouyou kanji — secondary school |
| 9 | 9 | Jinmeiyou (name kanji) — not part of the standard school curriculum |
| 10 | 10 | Jinmeiyou variant of jouyou kanji |
| `null` | `null` | Ungraded character |

All grade values are stored as-is. Grades 9–10 (Jinmeiyō name kanji) are preserved for reference and filtering but are **not included** in the radical extraction scope set (which uses grade ≤ 8). This keeps the radical count learnable without adding radicals for uncommon name kanji. See [ph2_1_radical_extraction.md §Scope](ph2_1_radical_extraction.md#scope-jlptgrade-kanji-only).

**Synthetic frequency rank:**

Kanji outside the top 2,501 (the newspaper corpus survey) have `frequency = null` in KANJIDIC2. The pipeline assigns a synthetic rank to ensure `frequency_rank` is always populated:

1. Synthetic ranks start at a **safe offset of 10,001** (well above the maximum real rank of 2,501).
2. For each unranked kanji, assign `10,001 + N` where N increments per kanji. The relative order among unranked kanji is arbitrary but stable across re-runs (deterministic ordering by `literal` code point).

The safe offset keeps real frequency ranks (1–2,501) and synthetic ranks (10,001+) in numerically distinct ranges. This avoids collisions if a future KANJIDIC release expands its ranked set beyond 2,501, and enables simple filtering: `WHERE frequency_rank <= 2501` selects only kanji with proven corpus frequency.

This ensures `frequency_rank` is never null, allowing the client to sort all kanji within a level by frequency without null-handling logic.

**Unique constraint:** `character` in `kanji.csv`.

### Step 2: Create Reading Rows

For each kanji, extract readings from `kanjidic.parquet` and write to `kanji_readings.csv`.

**Onyomi** (`readings.ja_on`):
- Each entry becomes a `kanji_readings.csv` row with `reading_type = onyomi`.
- Stored as katakana (matching source format).

**Kunyomi** (`readings.ja_kun`):
- Each entry becomes a `kanji_readings.csv` row with `reading_type = kunyomi`.
- Stored as hiragana, **preserving okurigana dots and prefix/suffix dashes** from KANJIDIC2. For example, `やす.む` is stored as-is — the dot marks the inflection boundary (kanji reads やす, む is appended hiragana). The client parses on the dot to split stem from suffix for display (see edge case below). The raw notation is preserved for admin review and future processing.

**Priority assignment:** All readings start as `primary`. KANJIDIC2 does not distinguish primary from secondary readings — every listed reading is considered equally important by the source. An admin may downgrade readings to `secondary` during review if a reading is archaic or domain-specific.

**Unique constraint:** `(kanji_id, reading, reading_type)` — no duplicate readings for the same kanji.

**Validation:** After processing, every kanji must have at least one reading row. If a `kanjidic.parquet` entry has empty `ja_on` and empty `ja_kun`, log a warning (this should not happen per KANJIDIC2 rules — every character has at least one Japanese reading).

### Step 3: Create I18n Rows

For each kanji, write localized meaning rows to `kanji_i18n.csv` for languages in `TARGET_LANGS` (from `src/config.py`). Only languages present in both the source data and `TARGET_LANGS` produce rows. Languages not in `TARGET_LANGS` (e.g. `fr`, `pt` from KANJIDIC) are skipped. Languages in `TARGET_LANGS` but absent from the source (e.g. `ru` — KANJIDIC has no Russian meanings) produce no rows here; they are populated by Phase 3 AI enrichment.

For each language key in the kanji's meanings:

1. Look up `meanings[lang_code]`.
2. If the meanings array is non-empty:
   - `meanings` ← the array as-is (preserves source ordering, which is priority order).
   - `system_mnemonic` ← empty string placeholder. Populated by AI in Phase 3 or manually by admin.
   - `search_tags` ← empty array. Populated later during content enrichment.
3. If the meanings array is empty, **skip** — do not write an i18n row.

**Unique constraint:** `(kanji_id, lang_code)`.

**Validation:** After processing, every kanji must have at least an English (`en`) i18n row. KANJIDIC2 always includes English meanings, so a missing `en` row indicates a parser bug.

### Step 4: Component Linking

For each kanji, link to its direct child radicals from KanjiVG component trees.

The full algorithm — including structural group flattening, split part merging, variant resolution, position mapping, and radical_type determination — is documented in [ph2_3_component_linking.md](ph2_3_component_linking.md).

**Prerequisite:** Steps 1–3 must complete first (kanji rows must exist for `kanji_components.kanji_id`). Radical extraction Passes 1–2 must also have completed (radicals must exist for `kanji_components.radical_id`).

### Step 5: Metadata Derivation

Compute derived fields on each radical: `impact_score`, `min_grade`, `min_jlpt_level`.

The full algorithm — including impact score bucketing and the MIN/MAX queries for grade and JLPT — is documented in [ph2_3_component_linking.md Step 3](ph2_3_component_linking.md#step-3-derive-radical-metadata).

**Prerequisite:** Step 4 must complete first (component links must exist for the aggregation queries).

## JLPT Level Mapping

KANJIDIC2 uses the **pre-2010 JLPT scale** (levels 1–4). Our schema uses the **current scale** (levels 1–5, where 5 = N5 easiest, 1 = N1 hardest). The mapping between old and new is not 1:1 — the 2010 JLPT reform split old level 4 into N4 and N5, and redistributed kanji across adjacent levels:

| Old Level | Approximate New Level(s) | Notes |
|---|---|---|
| 4 | N5, N4 | Old 4 was split — simpler kanji became N5, rest became N4 |
| 3 | N4, N3 | Old 3 maps roughly to N4, some overlap with N3 |
| 2 | N3, N2 | Old 2 was split between N2 and N3 |
| 1 | N1 | Old 1 maps to N1 |

Because of these splits, the raw `jlpt` value **cannot be mechanically converted** to a new level. Instead, the pipeline uses an **external JLPT mapping** — a curated dataset that maps individual kanji characters to their current N1–N5 level based on community-maintained kanji lists.

**Source data:** The de-facto standard for "New JLPT" kanji lists is the [Tanos (Jonathan Waller)](https://www.tanos.co.uk/jlpt/) collection, supplemented by community-maintained JLPT Resources lists. A curated CSV (`jlpt_mapping.csv`) is committed to `sources/jlpt_mapping/` and ingested into `jlpt_kanji.parquet` during Phase 1 (see [jlpt_mapping_format.md](../sources/jlpt_mapping_format.md)). Each row maps a single character to its N1–N5 level.

**Strategy:**

1. The raw `kanjidic.parquet` `jlpt` field (1–4) is preserved for reference and auditing.
2. `jlpt_kanji.parquet` maps `character → N level` (integer 1–5), sourced from `sources/jlpt_mapping/jlpt_mapping.csv`.
3. During Step 1, look up each kanji's character in `jlpt_kanji.parquet`:
   - Found → set `min_jlpt_level` to the mapped value.
   - Not found → set `min_jlpt_level` to `null`.
4. Kanji with `null` JLPT level are excluded from JLPT-based study paths but remain accessible via grade-based paths and search.

**Note on `min_jlpt_level` semantics:** The value 5 means N5 (easiest), 1 means N1 (hardest). This means `MAX(min_jlpt_level)` returns the easiest level — relevant for radical metadata derivation in Pass 4 (see [ph2_1_radical_extraction.md](ph2_1_radical_extraction.md#pass-4-derive--compute-radical-metadata)).

## Fields Not Derived from KANJIDIC

Several `kanji` fields come from other pipeline phases, not from `kanjidic.parquet`:

| Field | Source | Phase |
|---|---|---|
| `svg_file_name` | SVG Processing | 2.4 |
| `svg_file_url` | SVG Processing | 2.4 |
| `svg_hash` | SVG Processing | 2.4 |

**Note on `frequency_rank`:** Always populated at Step 1 — ranked kanji get their source value, unranked kanji get a synthetic rank.

## Ordering Constraints

The full Phase 2 execution order, showing where kanji composition fits:

```
Phase 1: Parquet ingestion (produces kanjidic.parquet, kanjivg.parquet, jlpt_kanji.parquet, ...)
    |
Phase 2.1 Passes 1-2: Radical extraction (outputs radicals.csv, radical_variants.csv)
    |
Phase 2.2 Steps 1-3: Kanji composition (outputs kanji.csv, kanji_readings.csv, kanji_i18n.csv)  <-- THIS DOC
    |
Phase 2.3 Passes 3-4: Component linking + radical metadata (outputs kanji_components.csv, updates radicals.csv)
    |
Phase 2.4: SVG Processing (updates svg fields on radicals.csv, radical_variants.csv, kanji.csv)
    |
Phase 2.5: Vocabulary extraction (outputs vocabulary CSVs, needs kanji.csv for vocabulary_kanji)
    |
Phase 3: AI Enrichment (populates system_mnemonic, search_tags, logic_hint in CSVs)
```

Steps 1–3 (kanji creation) depend only on `kanjidic.parquet` and `jlpt_kanji.parquet` and can run independently of radical extraction. Steps 4–5 (component linking and metadata derivation) depend on both the kanji rows from Steps 1–3 and the radical rows from Passes 1–2.

## Worked Example

### 日 (Day/Sun)

**Source:** `kanjidic.parquet` entry:
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

**Step 1 → `kanji.csv` row:**

| Field | Value | Notes |
|---|---|---|
| `character` | 日 | Direct copy |
| `stroke_count` | 4 | Direct copy |
| `min_grade` | 1 | Direct copy |
| `min_jlpt_level` | 5 | Old level 4 → mapped to N5 via `jlpt_kanji.parquet` |
| `frequency_rank` | 1 | Direct copy (most common kanji) |
| `svg_file_name` | — | From SVG Processing (Phase 2.4) |
| `svg_file_url` | — | From SVG Processing (Phase 2.4) |
| `svg_hash` | — | From SVG Processing (Phase 2.4) |

**Step 2 → `kanji_readings.csv` rows (5 rows):**

| `reading` | `reading_type` | `priority` |
|---|---|---|
| ニチ | `onyomi` | `primary` |
| ジツ | `onyomi` | `primary` |
| ひ | `kunyomi` | `primary` |
| -び | `kunyomi` | `primary` |
| -か | `kunyomi` | `primary` |

Note: the dashes on -び and -か are preserved as-is (prefix/suffix markers from KANJIDIC2).

**Step 3 → `kanji_i18n.csv` rows (2 rows):**

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

**Source:** `kanjidic.parquet` entry:
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

**Step 1 → `kanji.csv` row:**

| Field | Value | Notes |
|---|---|---|
| `character` | 龍 | |
| `stroke_count` | 16 | |
| `min_grade` | `null` | No grade assignment |
| `min_jlpt_level` | `null` | Not in `jlpt_kanji.parquet` |
| `frequency_rank` | 10,001+ | Synthetic rank (no newspaper frequency; safe offset) |
| `svg_*` | — | From SVG Processing (Phase 2.4) |

This kanji is excluded from both JLPT-based and grade-based study paths. It surfaces only via search or browse.

## Business Rules

1. Every `kanjidic.parquet` row produces exactly one `kanji.csv` row (unique on `character`).
2. `stroke_count` must be a positive integer (validated during Phase 1 ingestion).
3. `min_grade` stored as-is from KANJIDIC2 (1–6, 8, 9, 10, or null).
4. `min_jlpt_level` must come from `jlpt_kanji.parquet`, not from `kanjidic.parquet` `jlpt` directly. The raw `jlpt` field is reference-only.
5. Every kanji must have at least one reading row after Step 2.
6. Every kanji must have at least one `primary` reading.
7. `kanji_i18n.csv` required for `en` at minimum (KANJIDIC2 always has English meanings). Missing `en` is logged as a warning.
8. `kanji_i18n.csv` `meanings` must have at least one entry per row.
9. Kunyomi readings preserve okurigana notation: dots for inflection points (e.g. `やす.む`), dashes for prefixes/suffixes (e.g. `-び`).
10. Re-processing the same `kanjidic.parquet` data produces the same output files (idempotent via full file overwrite).
11. `frequency_rank` is always populated — ranked kanji get their source value, unranked kanji get a synthetic rank.

## Edge Cases

### Kanji outside JLPT set
`jlpt_kanji.parquet` does not cover every kanji in KANJIDIC2. Unmapped kanji get `min_jlpt_level = null` and are invisible to users on the JLPT study path. They remain accessible via grade-based paths (if graded) or search.

### Kanji with grade 9–10 (jinmeiyou)
Name kanji (grade 9) and jouyou variants used in names (grade 10) are stored with their original grade values. They are excluded from the radical extraction scope set (grade ≤ 8) to keep the radical count learnable, but the grade data is preserved for filtering and display.

### Kanji without frequency
Characters outside the newspaper corpus top 2,501 have no frequency rank. The pipeline assigns a synthetic rank starting at 10,001 (incrementing per unranked kanji ordered by code point) to ensure `frequency_rank` is never null and to keep synthetic ranks numerically distinct from real corpus ranks.

### Kunyomi with okurigana dots
Readings like `やす.む` (for 休む) are stored as-is in `kanji_readings.csv`. The dot marks where the kanji's reading ends and the appended hiragana begins. The client must parse on the dot — not just strip it — to split the stem (`やす`) from the okurigana suffix (`む`). This enables differentiated display (e.g. bold stem + light suffix, or color-coded segments) rather than a flat string. A naive `replace('.', '')` loses the inflection boundary information.

### Kunyomi with prefix/suffix dashes
Readings like `-び` and `-か` (for 日 in compounds like 祝日) are stored as-is. The dash indicates the reading only occurs as part of a compound, not independently.

### Languages with no meanings
If a language key in the kanji's meanings has an empty array, no `kanji_i18n.csv` row is created for that language-kanji pair. This is expected — not all languages have meanings for every character. The client falls back to English at query time (see [kanji.md](../domain/kanji.md) edge cases).

### Kanji in KANJIDIC but not in KanjiVG
A kanji row is created from KANJIDIC2 data even if no matching KanjiVG entry exists. Steps 1–3 succeed, but Step 4 (component linking) produces no `kanji_components` rows for this character. This is logged as a warning — it means the kanji exists as a learnable item but has no decomposition tree. The admin should investigate missing KanjiVG coverage.

### JLPT mapping missing entry
Same outcome as "Kanji outside JLPT set" — `min_jlpt_level = null`. The kanji is still valid and learnable; it just won't appear in JLPT-filtered study paths.

### Kanji with empty readings
Should not occur — KANJIDIC2 guarantees at least one `ja_on` or `ja_kun` reading per character. If encountered, log a warning and create the kanji row without readings. Content validation tooling should flag these for review.

## Warnings

Warnings are written to `data/csv/warnings/ph2_2_warnings.csv` with columns: `severity, phase, entity, message`.

| Condition | Severity | Rationale |
|---|---|---|
| JLPT-mapped kanji missing from KANJIDIC data | high | Learner-facing gap — kanji expected in a study path won't exist in the dataset |
| No kanji row ID for character after writing | high | Internal error — kanji row creation failed silently |
| Kanji with no readings (empty `ja_on` and `ja_kun`), JLPT-mapped | high | Learner-facing content gap — kanji in study path will have no readings |
| Kanji with no readings, non-JLPT | low | Informational — may be a rare or ungraded character |
| Missing English (`en`) meanings, JLPT-mapped | high | Learner-facing content gap — kanji in study path will have no English meanings |
| Missing English (`en`) meanings, non-JLPT | low | Informational — may be a rare character with no English coverage in KANJIDIC2 |

**JLPT-aware severity:** The "no readings" and "missing English" conditions use a two-tier pattern — `high` if the kanji appears in `jlpt_kanji.parquet`, `low` otherwise. This focuses admin attention on learner-visible content.

## Output Summary

| File | What gets created | Source |
|---|---|---|
| `kanji.csv` | One row per `kanjidic.parquet` entry | Step 1 |
| `kanji_readings.csv` | One row per reading per kanji | Step 2 |
| `kanji_i18n.csv` | One row per target language per kanji (filtered to `TARGET_LANGS`) | Step 3 |

Files populated by **this phase but documented elsewhere:**
- `kanji_components.csv` — component linking (Step 4, see [ph2_1_radical_extraction.md Pass 3](ph2_1_radical_extraction.md#pass-3-link--create-kanjicomponent-rows))

Files updated by **later phases** (not this algorithm):
- `kanji.csv` SVG fields — SVG Processing (Phase 2.4)
- `kanji_i18n.csv` `system_mnemonic`, `search_tags` — AI Enrichment (Phase 3)

## Related Docs

- [kanji.md](../domain/kanji.md) — Kanji entity spec (target schema)
- [kanji_component.md](../domain/kanji_component.md) — KanjiComponent entity spec
- [kanjidic_format.md](../sources/kanjidic_format.md) — KANJIDIC2 XML format reference (JLPT mapping, grade values)
- [ph2_3_component_linking.md](ph2_3_component_linking.md) — Component linking and radical metadata derivation (Steps 4–5)
- [ph2_1_radical_extraction.md](ph2_1_radical_extraction.md) — Passes 1–2 (radical/variant registration)
- [pipeline.md](pipeline.md) — Full pipeline orchestration (Phases 1–4)
