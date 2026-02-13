# AI Enrichment (Phase 2.6)

## Overview

Phase 2.6 combines two enrichment concerns — algorithmic logic hint estimation and AI-assisted content generation — into a single pipeline phase. It runs after all extraction phases (2.2–2.5) have populated the content tables.

**Key constraint:** There is no programmatic API access to AI models. The admin has chat-based tools (Claude, Cursor, Gemini) but no API keys. The workflow is **Batch-and-Script**: export CSV → enrich via chat tools → import CSV back → next batch.

The phase has two sub-phases:

| Sub-phase | Name | Method | Requires |
|---|---|---|---|
| A | Logic Hint Estimation | Automated (onyomi matching algorithm) | `kanji_components`, `raw_kanjidic` |
| B | CSV Batch Enrichment | Manual (export → chat tool → import) | Content tables from phases 2.2–2.5 |

### Ghost Radicals

A **ghost radical** is a component registered during radical extraction (Phase 2.2) that lacks its own standalone KanjiVG entry and/or KANJIDIC entry. Example: 粦 appears inside 隣 (`kvg:element="粦"`) but has no `07ca6.svg` file and no `raw_kanjidic` row.

Ghost radicals break the "Lego-style" learning chain — a learner must master all child radicals before unlocking a kanji, but a ghost radical has no SVG to display and no readings to teach. The enrichment phase acts as the safety net for these cases:

- **Sub-phase A** assigns lowest confidence to ghost radical components.
- **Sub-phase B, Batch 0** recovers SVG paths from the parent kanji's KanjiVG data.
- **Sub-phase B, Batch 1** ensures ghost radicals receive mnemonics so they can appear in SRS.
- **Promotion gate (Phase 4)** rejects kanji whose components have missing SVGs.

## Sub-phase A: Logic Hint Estimation (Automated)

Estimates `logic_hint` (semantic vs phonetic) for every `kanji_component` row using onyomi comparison. This is purely algorithmic — no CSV workflow needed.

### Algorithm

For each `kanji_component` row:

1. **Fetch kanji onyomi:** Query `raw_kanjidic` for the parent kanji's onyomi readings.
2. **Fetch radical onyomi:** Look up the radical's `master_symbol` as a character in `raw_kanjidic` to get its onyomi. Radicals don't store readings directly (see [radical.md](../entities/radical.md) rule #5) — this lookup treats the master symbol as a kanji to retrieve any readings it may have.
3. **Compare:**
   - **Match found** → at least one onyomi of the radical matches an onyomi of the kanji.
   - **No match** → no onyomi overlap, or radical's master symbol has no entry in `raw_kanjidic`.

### Output

| Condition | `logic_hint` | `ai_confidence` | Rationale |
|---|---|---|---|
| Onyomi match (exact) | `phonetic` | 0.9 | Strong phonetic signal — radical contributes its reading |
| No match (radical has onyomi but none overlap) | `semantic` | 0.6 | Radical has readings but doesn't share them — likely semantic |
| Kanji has no onyomi | `semantic` | 0.5 | Kun-only kanji — phonetic matching not applicable |
| Ghost radical (no `raw_kanjidic` entry) | `semantic` | 0.2 | No reading data available — ghost radical requires manual hint verification |

For every `kanji_component`, the use case creates a `kanji_component_reviews` row with:
- `verification_status = draft`
- `ai_confidence` from the table above
- `logic_hint` set on the `kanji_components` row itself

All components start as `draft` regardless of confidence. The `ai_confidence` score helps prioritize the review queue (Phase 3) — lowest confidence first.

### Ordering Constraint

Sub-phase A requires:
- **kanjiComposition (2.3)** — `kanji_components` rows must exist
- **svgProcessing (2.4)** — ensures all component metadata is populated

### Implementation

Implemented as a single use case class (`EstimateLogicHintsUseCase`) that:
1. Queries all `kanji_component` rows without an existing `kanji_component_reviews` row
2. For each, runs the onyomi matching algorithm
3. Updates `kanji_components.logic_hint` and inserts `kanji_component_reviews`
4. Collects warnings (see Warnings section)
5. Logs progress via `dart:developer`

## Sub-phase B: CSV Batch Enrichment (Manual + Chat Tools)

Generates CSV exports for the admin to enrich using chat-based AI tools, then imports the enriched CSVs back into the database.

### Workflow

```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐     ┌──────────────┐
│ Export CSV   │────→│ Chat Tool    │────→│ Enriched CSV│────→│ Import CSV   │
│ (use case)  │     │ (manual)     │     │ (on disk)   │     │ (use case)   │
└─────────────┘     └──────────────┘     └─────────────┘     └──────────────┘
       │                                                            │
       │            configured output directory                     │
       └────────────────────────────────────────────────────────────┘
```

1. **Export** use case generates a CSV file to a configured output directory, containing context columns (read-only) and empty columns to fill.
2. Admin opens the CSV in a chat tool and asks for enrichment (mnemonics, translations, etc.).
3. Admin saves the enriched CSV back to the same directory.
4. **Import** use case reads the CSV, validates all rows, and upserts into the database.
5. Repeat for the next batch.

### CSV Format Specification

- **Encoding:** UTF-8 with BOM (for Excel/Sheets compatibility with Japanese characters)
- **Delimiter:** Comma (standard CSV)
- **Search tags:** Pipe-delimited within a single cell (e.g. `liquid|splash|ocean`)
- **Header row:** Required — exact column names per batch type
- **Quoting:** Standard CSV quoting rules (double-quote fields containing commas, newlines, or quotes)

### Batch Types

#### Batch 0: Ghost Radical SVG Recovery

Recovers missing SVG paths for ghost radicals by extracting the `<g>` subtree from a parent kanji's KanjiVG data. This must run before promotion (Phase 4) because a kanji cannot be promoted if any child component lacks an SVG.

**Process:**

1. Identify ghost radicals: draft radicals with `svg_file_name IS NULL` AND `impact_score > 0` (used by at least one kanji).
2. For each ghost radical, find a parent kanji in `raw_kanjivg` that contains it as a `kvg:element`.
3. Extract the `<g>` subtree (including all child strokes) from the parent's component tree.
4. Construct a standalone SVG document from the extracted paths, adjusting the `viewBox` to fit.
5. Save as `[unicode_hex].svg`, compute SHA-256 hash, update `draft_radical_entries` SVG fields.

**Sort order:** `impact_score` DESC (highest-impact ghost radicals first — they block the most kanji promotions).

**Scope:** Only radicals missing SVGs that are actually referenced by `kanji_components`. Radicals with `impact_score = 0` or `NULL` are unused and can be skipped.

**Note:** This step requires programmatic SVG manipulation. If the extracted paths don't render well standalone (e.g., coordinates assume parent context), the admin may need to manually adjust the viewBox or paths.

---

#### Batch 1: Radical Mnemonics & Search Tags

Generate system mnemonics and search tags for radicals across all target languages.

**Export columns (context — read-only):**

| Column | Source | Description |
|---|---|---|
| `radical_id` | `radicals.id` | Primary key |
| `master_symbol` | `radicals.master_symbol` | The radical character, e.g. "水" |
| `stroke_count` | `radicals.stroke_count` | Number of strokes |
| `is_official` | `radicals.is_official` | Whether this is an official Kangxi radical |
| `min_jlpt_level` | `radicals.min_jlpt_level` | Easiest JLPT level (5=N5, null=not in JLPT) |
| `min_grade` | `radicals.min_grade` | Earliest school grade (1–8, null=ungraded) |
| `en_name` | `radical_i18n.name` (en) | English name |
| `es_name` | `radical_i18n.name` (es) | Spanish name |

**Fill columns (to be enriched):**

| Column | Target | Required | Description |
|---|---|---|---|
| `en_system_mnemonic` | `radical_i18n.system_mnemonic` (en) | Yes | English learning mnemonic |
| `es_system_mnemonic` | `radical_i18n.system_mnemonic` (es) | Yes | Spanish learning mnemonic |
| `en_search_tags` | `radical_i18n.search_tags` (en) | No | Pipe-delimited English search synonyms |
| `es_search_tags` | `radical_i18n.search_tags` (es) | No | Pipe-delimited Spanish search synonyms |

**Sort order:** `min_jlpt_level` DESC NULLS LAST (N5=5 first → N4 → N3 → N2 → N1 → null), then `min_grade` ASC NULLS LAST (1 → 8 → null), then `impact_score` DESC. High-impact JLPT radicals first.

**Batch size:** ~600–700 radicals total — likely 4–5 CSV batches of ~150.

**Target table:** `radical_i18n.system_mnemonic` (NOT NULL — required per entity spec), `radical_i18n.search_tags`.

---

#### Batch 2: Kanji Mnemonics & Search Tags

Generate system mnemonics and search tags for kanji across all target languages.

**Export columns (context — read-only):**

| Column | Source | Description |
|---|---|---|
| `kanji_id` | `kanji.id` | Primary key |
| `character` | `kanji.character` | The kanji character, e.g. "日" |
| `stroke_count` | `kanji.stroke_count` | Number of strokes |
| `min_jlpt_level` | `kanji.min_jlpt_level` | Easiest JLPT level (5=N5, null=not in JLPT) |
| `min_grade` | `kanji.min_grade` | Earliest school grade (1–8, null=ungraded) |
| `en_meanings` | `kanji_i18n.meanings` (en) | English meanings (comma-joined) |
| `es_meanings` | `kanji_i18n.meanings` (es) | Spanish meanings (comma-joined) |
| `component_names` | Derived | Comma-separated radical names composing this kanji (for mnemonic context) |
| `has_ghost_components` | Derived | `true` if any child radical lacks a standalone SVG — ghost radical that is itself a compound |

**Fill columns (to be enriched):**

| Column | Target | Required | Description |
|---|---|---|---|
| `en_system_mnemonic` | `kanji_i18n.system_mnemonic` (en) | Yes | English learning mnemonic |
| `es_system_mnemonic` | `kanji_i18n.system_mnemonic` (es) | Yes | Spanish learning mnemonic |
| `en_search_tags` | `kanji_i18n.search_tags` (en) | No | Pipe-delimited English search synonyms |
| `es_search_tags` | `kanji_i18n.search_tags` (es) | No | Pipe-delimited Spanish search synonyms |

**Sort order:** `min_jlpt_level` DESC NULLS LAST (N5 first → N1 → null), then `min_grade` ASC NULLS LAST (1 → 8 → null), then `frequency_rank` ASC. Learner-facing content is enriched first.

**Batch size:** ~2,200 kanji total — needs ~15–20 CSV batches of ~150.

**Target table:** `kanji_i18n.system_mnemonic` (NOT NULL — required per entity spec), `kanji_i18n.search_tags`.

---

#### Batch 3: Sentence Translation (Non-English)

Translate existing English example sentences into other target languages.

**Export columns (context — read-only):**

| Column | Source | Description |
|---|---|---|
| `vocabulary_sentence_id` | `vocabulary_sentences.id` | Primary key |
| `word` | `vocabulary.word` | The parent vocabulary word |
| `min_jlpt_level` | `vocabulary.min_jlpt_level` | Parent word's JLPT level |
| `original_text` | `vocabulary_sentences.original_text` | Japanese sentence |
| `en_translation` | `vocabulary_sentence_i18n.sentence_translated` (en) | English translation |

**Fill columns (to be enriched):**

| Column | Target | Required | Description |
|---|---|---|---|
| `es_translation` | `vocabulary_sentence_i18n.sentence_translated` (es) | Yes | Spanish translation |

**Sort order:** Parent vocabulary's `min_jlpt_level` DESC NULLS LAST (N5 first → N1 → null), then `frequency_rank` ASC. JLPT words get translations first.

**Batch size:** Varies — only words with existing English sentences that lack a translation in the target language.

**Target:** Insert `vocabulary_sentence_i18n` row for the target language. Set `vocabulary_sentences.verification_status = draft` (AI translations require human review before sync).

---

#### Batch 4: Sentence Furigana Annotation

Add `[kanji](reading)` furigana notation to Japanese sentences that lack it.

**Export columns (context — read-only):**

| Column | Source | Description |
|---|---|---|
| `vocabulary_sentence_id` | `vocabulary_sentences.id` | Primary key |
| `word` | `vocabulary.word` | The parent vocabulary word |
| `min_jlpt_level` | `vocabulary.min_jlpt_level` | Parent word's JLPT level |
| `original_text` | `vocabulary_sentences.original_text` | Plain Japanese sentence (no furigana) |

**Fill columns (to be enriched):**

| Column | Target | Required | Description |
|---|---|---|---|
| `annotated_text` | `vocabulary_sentences.original_text` | Yes | Same sentence with `[kanji](reading)` notation added |

**Sort order:** Same as Batch 3 — parent vocabulary's `min_jlpt_level` DESC NULLS LAST, then `frequency_rank` ASC.

**Batch size:** Only sentences whose `original_text` does not already contain `[` (no existing furigana notation).

**Target:** Update `vocabulary_sentences.original_text` with the annotated version. See [vocabulary.md §Furigana Notation](../entities/vocabulary.md#furigana-notation) for the exact format specification.

---

#### Batch 5 (Post-MVP): Vocabulary Mnemonics

Generate optional system mnemonics and search tags for vocabulary words. This batch is deferred — vocabulary meanings are often self-explanatory, so mnemonics are lower priority than radicals/kanji.

**Export columns (context — read-only):**

| Column | Source | Description |
|---|---|---|
| `vocabulary_id` | `vocabulary.id` | Primary key |
| `word` | `vocabulary.word` | The vocabulary word |
| `min_jlpt_level` | `vocabulary.min_jlpt_level` | JLPT level |
| `en_meanings` | `vocabulary_i18n.meanings` (en) | English meanings (comma-joined) |
| `pos_tags` | `vocabulary.pos_tags` | Grammar/usage tags (comma-joined) |

**Fill columns (to be enriched):**

| Column | Target | Required | Description |
|---|---|---|---|
| `en_system_mnemonic` | `vocabulary_i18n.system_mnemonic` (en) | No | English learning mnemonic |
| `es_system_mnemonic` | `vocabulary_i18n.system_mnemonic` (es) | No | Spanish learning mnemonic |
| `en_search_tags` | `vocabulary_i18n.search_tags` (en) | No | Pipe-delimited English search synonyms |
| `es_search_tags` | `vocabulary_i18n.search_tags` (es) | No | Pipe-delimited Spanish search synonyms |

**Sort order:** `min_jlpt_level` DESC NULLS LAST (N5 first → N1 → null), then `frequency_rank` ASC.

**Target table:** `vocabulary_i18n.system_mnemonic` (nullable — optional per entity spec), `vocabulary_i18n.search_tags`.

## Validation Rules

### Import Validation

The CSV import use case validates every row before upserting:

| Rule | Applies to | Behavior |
|---|---|---|
| Required fields non-empty | `system_mnemonic` in Batches 1, 2; `es_translation` in Batch 3; `annotated_text` in Batch 4 | Reject row, log error |
| Search tags pipe-delimited | `*_search_tags` in Batches 1, 2, 5 | Reject row if contains commas (likely delimiter confusion) |
| Furigana notation well-formed | `annotated_text` in Batch 4 | Every `[` must have matching `](reading)`, non-empty kanji and reading |
| ID exists in database | All `*_id` columns | Reject row if FK target not found |
| No duplicate search tags | `*_search_tags` | Deduplicate silently |
| Ghost radical flag | All batches | If `has_ghost_components` is true, flag row for high-priority review in Phase 3 |

### Import Warnings

| Condition | Severity | Rationale |
|---|---|---|
| Mnemonic shorter than 10 characters | `low` | Suspiciously short — may be placeholder text |
| Empty search tags (when mnemonic provided) | `low` | Tags improve discoverability but aren't required |
| Furigana annotation unchanged from input | `low` | May indicate the chat tool didn't process the sentence |
| Row count mismatch (CSV vs export) | `high` | Rows may have been accidentally added or removed |

## Ordering Constraints

### Sub-phase A (Logic Hints)

| Dependency | Reason |
|---|---|
| kanjiComposition (2.3) | `kanji_components` rows must exist |
| svgProcessing (2.4) | Ensures full component metadata is populated |

### Sub-phase B (CSV Enrichment)

Each batch type can run independently after its source content tables exist:

| Batch | Depends on | Reason |
|---|---|---|
| 0 (Ghost SVG recovery) | svgProcessing (2.4) | Needs SVG matching to identify which radicals are missing |
| 1 (Radical mnemonics) | radicalExtraction (2.2) | Needs `radicals` + `radical_i18n` |
| 2 (Kanji mnemonics) | kanjiComposition (2.3) | Needs `kanji` + `kanji_i18n` + `kanji_components` (for component_names context) |
| 3 (Sentence translation) | vocabularyExtraction (2.5) | Needs `vocabulary_sentences` + `vocabulary_sentence_i18n` (en) |
| 4 (Sentence furigana) | vocabularyExtraction (2.5) | Needs `vocabulary_sentences` with plain text |
| 5 (Vocabulary mnemonics) | vocabularyExtraction (2.5) | Needs `vocabulary` + `vocabulary_i18n` |

The `ExtractionPhase.aiEnrichment` enum value declares the union of all dependencies: `{kanjiComposition, svgProcessing, vocabularyExtraction}`.

## Warnings

### Sub-phase A Warnings

| Condition | Severity | Rationale |
|---|---|---|
| Ghost radical — no `raw_kanjidic` AND no `raw_kanjivg` entry | `high` | Lego chain broken — radical exists in `kanji_components` but has no readings or standalone SVG |
| Radical master_symbol not found in `raw_kanjidic` (but has SVG) | `low` | Expected for custom (non-Kangxi) radicals — no reading data but renderable |
| Kanji has no onyomi readings | `low` | Kun-only kanji; phonetic matching not applicable |
| JLPT-mapped component gets low confidence (< 0.5) | `high` | Learner-visible content needs manual review priority |
| Component already has a `kanji_component_reviews` row | `low` | Skipped — idempotent re-run does not overwrite existing reviews |

### Sub-phase B Warnings

See Import Warnings table in the Validation Rules section above.

## Related Docs

- [pipeline.md](pipeline.md) — overall pipeline orchestration (this phase is §2.6)
- [radical.md](../entities/radical.md) — radical entity spec (target for Batch 1)
- [kanji.md](../entities/kanji.md) — kanji entity spec (target for Batch 2)
- [kanji_component.md](../entities/kanji_component.md) — component entity and KanjiComponentReview (target for Sub-phase A)
- [vocabulary.md](../entities/vocabulary.md) — vocabulary entity spec (target for Batches 3–5), furigana notation spec
