# AI Enrichment

## Overview

AI Enrichment adds human-quality learning content to the structured CSVs produced by Phase 2. Phase 2 extracts facts (readings, meanings, component links) from dictionaries — Phase 3 transforms those facts into **memorable teaching material** (mnemonics, sentence translations, annotated sentences) that make the SRS experience effective.

**Note:** Vocabulary i18n localization (es/ru meanings) is fully handled in Phase 2 via `manual_localization.csv` — an AI-translated override file with 14,254 entries covering all JLPT words missing JMdict glosses. Phase 3 does **not** generate vocabulary translations; it only generates **sentence** translations (Step 6).

The phase has two distinct modes:

- **Deterministic** (Steps 0–1): Radical classification (analysis pass for multi-level decomposition) and logic hint refinement (onyomi comparison). No AI needed — runs as scripts via `uv run python -m src.enrich`.
- **AI-generated** (Steps 2–6): Mnemonics, translations, furigana annotation, search tags. Now handled **per-batch** via the release workflow: `release enrich` scaffolds template CSVs, user fills them (with AI assistance), then `release merge` validates and applies the content.

**Key properties:**

- **Human-in-the-loop:** Every AI-generated field is reviewed by the admin before upload. The pipeline does not auto-promote AI output to Phase 4.
- **Layer ordering:** Radical names (Step 2) must be finalized before kanji mnemonics (Step 3), because kanji stories reference radical names.
- **Batch-based enrichment:** AI content is generated per release batch, not globally. This enables level-appropriate content (N5 sentences use N5 grammar) and manageable review units.

## Source Data

| Source | Used in | Purpose |
|---|---|---|
| `kanji_components.csv` | Steps 0, 1 | Usage stats for radical classification; rows to refine `logic_hint` |
| `kanjidic.parquet` | Steps 1, 2 | Onyomi lookup for kanji and radical master symbols; KANJIDIC meanings for radical names |
| `radicals.csv` | Steps 1, 2 | `master_symbol` → onyomi lookup; radical identity for i18n creation |
| `radicals.csv` | Step 0 | Radical identity, `is_official`, `impact_score` for classification |
| `kanji.csv` | Steps 0, 1, 3 | `character` → onyomi lookup; `min_jlpt_level` for cross-JLPT analysis; kanji identity for mnemonic context |
| `kanji_readings.csv` | Step 1 | Onyomi readings for kanji (alternative to `kanjidic.parquet` lookup) |
| `kanji_i18n.csv` | Step 3 | Rows to enrich with `system_mnemonic` and `search_tags` |
| `vocabulary_i18n.csv` | Step 4 | Rows to enrich with `system_mnemonic` and `search_tags` |
| `vocabulary_sentences.csv` | Step 5 | Rows to annotate `original_text` with furigana notation |
| `vocabulary_sentence_i18n.csv` | Step 6 | Existing English rows; target for new ES/RU translations |
| `jmdict_furigana.parquet` | Step 5 | Pre-computed per-character furigana mappings for sentence annotation |
| `kanji.csv` | Step 5 | Known kanji set for identifying kanji characters in sentences |

## Prerequisites

All conditions must hold before this phase runs:

1. **Phase 2 complete** — All Phase 2 sub-phases (2.1 through 2.5) have finished. All CSV files in `data/csv/` are populated with their Phase 2 content.
2. **Parquet files available** — `kanjidic.parquet` and `jmdict_furigana.parquet` from Phase 1 are present in `data/parquet/`.

## Batching Strategy

AI enrichment is now integrated into the release batch workflow:

```
slice → enrich → [user fills CSVs with AI] → merge → review → validate → push
```

### Commands

```bash
# Scaffold template CSVs with context columns + empty fill columns
uv run python -m src.release enrich <name> [--entity radical|kanji|vocab|sentence|all]

# Validate AI-filled CSVs and merge into batch CSVs
uv run python -m src.release merge <name> [--entity radical|kanji|vocab|sentence|all] [--dry-run]
```

### Enrichment dependency order (within a batch)

1. **Radical i18n** — enrich + fill + merge first (names needed in kanji context)
2. **Kanji i18n** — depends on radical names being finalized
3. **Vocabulary i18n** — independent, logically follows kanji
4. **Sentences** — independent, can run in parallel with 2-3

### Template structure

After `release enrich`, templates appear in `<batch_dir>/ai/templates/`:

| Template | Context columns (read-only) | Fill columns |
|---|---|---|
| `radical_i18n_ai.csv` | master_symbol, en_name_seed, lang_code | name, system_mnemonic, search_tags |
| `kanji_i18n_ai.csv` | character, meanings_en, components, readings, lang_code | system_mnemonic, search_tags |
| `vocab_i18n_ai.csv` | vocabulary_id, word, furigana, meanings_en, lang_code | system_mnemonic, search_tags |
| `sentence_ai.csv` | vocabulary_id, word, lang_code | original_text, sentence_translated |

### Static instruction files

AI instructions are in `pipeline/data/ai/instructions/`:

| File | Describes |
|---|---|
| `RADICAL_I18N.md` | Radical naming, Layer 1 mnemonic rules, search tags |
| `KANJI_I18N.md` | Layer 2 mnemonic rules, sound anchor tables |
| `VOCAB_I18N.md` | Layer 3 mnemonic rules, when to skip |
| `SENTENCE.md` | Sentence generation, JLPT grammar constraints, furigana format |

### JLPT batch ordering

Content is processed in JLPT-level batches, ordered from easiest to hardest:

```
N5 → N4 → N3 → N2 → N1 → ungraded
```

**Why this order:**

- N5 is beginner content — highest priority for initial release.
- Each batch is a manageable review unit for the admin.
- Incremental release is possible: upload N5 content while N4 is still in review.

**Batch size considerations:**

| JLPT Level | Approx. kanji | Approx. radicals | Approx. vocabulary |
|---|---|---|---|
| N5 | ~80 | ~100–150 | ~700 |
| N4 | ~170 | ~50–80 (incremental) | ~600 |
| N3 | ~370 | ~80–120 (incremental) | ~1,800 |
| N2 | ~380 | ~60–90 (incremental) | ~2,500 |
| N1 | ~1,200 | ~100–150 (incremental) | ~2,500 |

Radical counts are incremental — many radicals are shared across levels. A radical is assigned to the batch of its `min_jlpt_level`.

## Step 0: Radical Classification (Deterministic)

**Target:** `radical_classification.csv` (new file — analysis output, not a content table)

**Purpose:** Classify every radical as either kept (as a radical) or convertible to a kanji component reference, supporting the multi-level decomposition strategy described in [component_model.md](../adr/component_model.md). The output CSV is for **human review** — it does not modify any existing content tables.

### Classification Rules (first match wins)

| Priority | Classification | Condition |
|---|---|---|
| 0 | `keep_manual` | Listed in `data/manual_keep.txt` (phonetic anchors, structural primitives) |
| 1 | `keep_kangxi` | `is_official == True` (Kangxi radical) |
| 2 | `keep_radical_only` | `master_symbol` not in `kanji.csv` characters (no kanji form exists) |
| 3 | `keep_cross_jlpt` | Radical IS a kanji but used in parents with easier JLPT (higher number). Also: null-JLPT component used in any JLPT-assigned parent (play safe) |
| 4 | `keep_high_freq` | Usage count >= 15 (tunable threshold) |
| 5 | `convert_to_kanji` | Everything else — candidate for kanji→kanji component reference |

### Cross-JLPT Rule Detail

- `min_parent_jlpt > kanji_jlpt[master_symbol]` → cross-JLPT (harder component in easier parent). `min_parent_jlpt` follows project convention: MAX of parent JLPT numbers (N5=5 easiest = earliest encounter).
- Component has null JLPT, any parent has JLPT → cross-JLPT (unknown difficulty, play safe).
- Both null → skip rule, fall through to next priority.

### Output Columns

| Column | Type | Source |
|---|---|---|
| `master_symbol` | str | `radicals.csv` |
| `family_symbol` | str | `radicals.csv` |
| `is_official` | bool | `radicals.csv` |
| `is_kanji` | bool | computed: `master_symbol` in `kanji.csv` |
| `kanji_jlpt` | int? | `kanji.csv` `min_jlpt_level` |
| `min_parent_jlpt` | int? | computed from `kanji_components.csv` + `kanji.csv` |
| `usage_count` | int | computed from `kanji_components.csv` |
| `impact_score` | int? | `radicals.csv` |
| `classification` | str | computed |
| `reason` | str | computed |

Output sorted by `classification` then `master_symbol`. Target: 300–400 radicals classified as "keep".

### Derived Data Files

After classification, two derived files are generated automatically:

| File | Purpose |
|---|---|
| `radical_classification_review.csv` | Copy of `radical_classification.csv` with added `parent_kanji` column (comma-joined list of kanji that use each radical, from `kanji_components.csv`) |
| `kanji_decomposition.csv` | Kanji-centric view: `character`, `stroke_count`, `min_jlpt_level`, `frequency_rank`, `components` (formatted as `田(top,semantic) + 力(bottom,semantic)`), `component_count`. Sorted by JLPT level (N5 first → nulls last), then `frequency_rank`. Data source for batch review in Phase 4. |

### Warnings

| Severity | Condition |
|---|---|
| medium | Null-JLPT component with high usage classified as cross-JLPT |
| low | Radical not used in any kanji component |

## Step 1: Logic Hint Refinement (Deterministic)

**Target:** `kanji_components.csv` → `logic_hint` field

**This is a fully deterministic step.** No AI is needed — it compares onyomi readings using data already available in the pipeline. It can run as a standalone script before any AI generation begins.

### Permissive Heuristic

The algorithm uses a **permissive** matching strategy: if *any* kanji onyomi matches *any* radical onyomi, the hint is set to `phonetic`. This is deliberately broad.

- **Benefit:** Catches obscure phonetic connections, including historical sound shifts where the etymological link is real but non-obvious to modern learners.
- **Risk:** False positives. A radical with 4 readings and a kanji with 3 readings have a statistical chance of coincidental overlap that isn't etymologically motivated.
- **V1 verdict:** Permissive is better for learning. It is more helpful to tell the user "this sound matches!" (a useful hint even if coincidental) than to miss a valid phonetic clue. False positives still aid memorization — the sound *does* match, giving the learner a hook regardless of etymology.

### Algorithm

For each row in `kanji_components.csv`:

1. **Get kanji onyomi:** Look up all onyomi readings for `kanji_id` (from `kanji_readings.csv` where `reading_type = onyomi`, or from `kanjidic.parquet`).
2. **Get radical onyomi:** Look up the radical's `master_symbol` from `radicals.csv`, then find all onyomi readings for that character in `kanjidic.parquet` (treating the master symbol as a kanji character for lookup purposes).
3. **Compare:**
   - If **any** kanji onyomi matches **any** radical onyomi → set `logic_hint = phonetic`.
   - If no onyomi match → keep `logic_hint = semantic` (the Phase 2 default).
4. **Radicals without KANJIDIC entries:** If the radical's `master_symbol` has no entry in `kanjidic.parquet` (e.g., a rare component or custom radical), it cannot contribute a phonetic reading. Keep `logic_hint = semantic`.

### Position-Based Heuristic (Secondary)

When onyomi comparison is inconclusive or as a validation cross-check, position predicts the likely role:

| Structure | Semantic (meaning) position | Phonetic (sound) position | Example |
|---|---|---|---|
| Left-Right (⿰) | Left (`hen`) | Right (`tsukuri`) | 江: 氵 Water + 工 KOU → reading KOU |
| Top-Bottom (⿱) | Top (`kanmuri`) | Bottom (`ashi`) | 花: 艹 Grass + 化 KA → reading KA |
| Enclosure (⿴) | Outside (`kamae`) | Inside | 聞: 門 Gate + 耳 ear → reading MON |

**Usage:** The position heuristic is informational — it can flag rows where onyomi comparison and position disagree (e.g., onyomi says `phonetic` but position is `hen`). These conflicts are logged as warnings for admin review but the onyomi comparison result takes precedence.

### Worked Example

Kanji 清 (SEI) with components:
- 水 (radical, position: `hen`) — onyomi: スイ. Does not match SEI → `semantic`.
- 青 (radical, position: `tsukuri`) — onyomi: セイ, ショウ. セイ matches SEI → `phonetic`.

Result: 水 stays `semantic`, 青 becomes `phonetic`. Position heuristic agrees (left=semantic, right=phonetic).

### Edge Cases

- **Radical has multiple onyomi:** Any match is sufficient. 生 has onyomi セイ and ショウ — if the kanji reads セイ, it's a match.
- **Kanji has multiple onyomi:** Check each kanji onyomi against each radical onyomi. Any pair match → `phonetic`.
- **Kanji with no onyomi:** Rare native-Japanese kanji (e.g., 畑) may lack onyomi entirely. All components stay `semantic`.
- **Same radical is phonetic in one kanji and semantic in another:** This is expected and correct. 亡 is phonetic in 忙 (BOU matches) but semantic in 死 (no onyomi match).

## Steps 2–6: AI-Generated Content (Batch-Based)

Steps 2–6 are now handled per release batch via `release enrich` and `release merge`. See [ph4_release_bundles.md](ph4_release_bundles.md) for the full batch workflow.

### Step 2: Radical I18n

**Template:** `radical_i18n_ai.csv` | **Target:** batch `radical_i18n.csv`

Creates localized names, Layer 1 mnemonics, and search tags for radicals. EN name seeds come from KANJIDIC. See `pipeline/data/ai/instructions/RADICAL_I18N.md` for full rules.

### Step 3: Kanji I18n

**Template:** `kanji_i18n_ai.csv` | **Target:** batch `kanji_i18n.csv`

Layer 2 mnemonics linking radical keywords to kanji meaning via onyomi sound anchors. Depends on radical names being merged first. See `pipeline/data/ai/instructions/KANJI_I18N.md`.

### Step 4: Vocabulary I18n

**Template:** `vocab_i18n_ai.csv` | **Target:** batch `vocabulary_i18n.csv`

Layer 3 mnemonics for word readings. `system_mnemonic` is nullable — skip self-explanatory words. See `pipeline/data/ai/instructions/VOCAB_I18N.md`.

### Step 5–6: Sentences

**Template:** `sentence_ai.csv` | **Target:** batch `vocabulary_sentences.csv` + `vocabulary_sentence_i18n.csv`

AI-generated level-appropriate sentences with furigana notation and translations for all 3 languages. Grammar complexity matches JLPT level. See `pipeline/data/ai/instructions/SENTENCE.md`.

## Mnemonic Rules Summary

Consolidated rules from [mnemonic.md](../domain/mnemonic.md) that apply across all steps:

### Language Rules

| Language | Register | Notes |
|---|---|---|
| English | CEFR A2/B1 | Simple, common words. Prefer physical actions (hit, run, eat) over abstract language |
| Spanish | Standard neutral (Latin American generic) | No regional slang |
| Russian | Standard literary | No regional colloquialisms |

### Independence Rule

Each language has its own sound anchors and mnemonics. "KYUU-cumber" works in English but not in Russian — each language must find native words that sound like the target reading. Stories will differ across languages.

### Consistency Rules

1. **Sound anchor consistency:** Once chosen for an onyomi in a language, reuse across all kanji. See §Sound Anchor Tables above.
2. **Radical-kanji name consistency:** When a radical is also a kanji, the keyword must match across Layer 1 (radical name) and Layer 2 (kanji mnemonic component reference).
3. **Layer ordering:** Radical names (Layer 1) → kanji mnemonics (Layer 2) → vocabulary mnemonics (Layer 3). Each layer builds on the previous.
4. **No abstract anchors:** Sound anchors must be concrete, physical, visual objects or actions — never abstract concepts.

### Layer Summary

| Layer | Step | What it teaches | Formula | Target |
|---|---|---|---|---|
| 1 (Radical) | Step 2 | Shape + meaning | Visual keyword (concrete noun) | `radical_i18n.system_mnemonic` |
| 2 (Kanji) | Step 3 | Components + onyomi | Radical keywords + sound anchor = meaning | `kanji_i18n.system_mnemonic` |
| 3 (Vocabulary) | Step 4 | Usage + actual reading | Kanji meaning + context + reading | `vocabulary_i18n.system_mnemonic` (nullable) |

## Admin Review Workflow

The admin reviews AI output at two stages:

### 1. Template review (before merge)

After filling templates with AI, the admin reviews the AI-generated content in the template CSVs (`ai/templates/`) before running `release merge`. This catches quality issues early.

### 2. Batch review (before push)

After merging, use `release review <name>` for a comprehensive review of the full batch. This catches cross-entity consistency issues (e.g. radical names matching kanji mnemonics).

### Review process

1. **Steps 0-1 (deterministic):** Spot-check `radical_classification.csv` and `logic_hint` assignments.
2. **Radical i18n:** Review all radical names for accuracy. This is the foundation — errors cascade into kanji mnemonics.
3. **Kanji i18n:** Check radical name usage, sound anchor consistency, story quality.
4. **Vocabulary i18n:** Review mnemonics where present. Verify skipped words are self-explanatory.
5. **Sentences:** Validate furigana notation, grammar level, translation accuracy.

### Iteration

If the admin rejects content, edit the template CSV in `ai/templates/` and re-run `release merge`. The merge is idempotent — non-empty fill values always overwrite.

## Warnings

Warnings are written to `data/csv/warnings/ph3_warnings.csv` with columns: `severity, phase, entity, message`.

| Condition | Severity | Rationale |
|---|---|---|
| Null-JLPT component with high usage classified as cross-JLPT (Step 0) | medium | May need manual JLPT assignment or reclassification |
| Radical not used in any kanji component (Step 0) | low | Orphaned radical — verify if it should exist |
| Onyomi comparison and position heuristic disagree on `logic_hint` | medium | May indicate an unusual phono-semantic pattern — admin should verify |
| Radical `master_symbol` not found in `kanjidic.parquet` (Step 1) | low | Custom radical with no KANJIDIC entry — `logic_hint` stays `semantic` |
| Radical name differs from kanji meaning for dual-identity character | high | Radical-kanji name consistency violation — must be resolved before Step 3 |
| Sound anchor inconsistency (same onyomi, different anchor in same language) | high | Breaks memorability — all kanji with the same onyomi should use the same anchor word |
| Sentence furigana validation failure (stripped text doesn't match original) | high | Notation error — the annotated sentence doesn't reconstruct to the original text |
| Missing radical i18n row for a language | high | Every radical must have i18n for all 3 languages (EN/ES/RU) |
| Kanji mnemonic references a radical name not matching Step 2 output | high | Layer consistency violation — mnemonic uses a different word than the radical's assigned name |
| Vocabulary mnemonic mentions radical names | medium | Layer 3 should focus on the word itself, not radicals |

## Validation Invariants

Before proceeding to Phase 4, the following completeness checks must pass for each JLPT level being uploaded:

### Radical completeness

- Every radical with `min_jlpt_level` in the batch has `radical_i18n` rows for all 3 languages (EN, ES, RU).
- Every `radical_i18n` row has a non-empty `name`.
- Every `radical_i18n` row has a non-empty `system_mnemonic`.
- Every `radical_i18n` row has a non-empty `search_tags` array.

### Kanji completeness

- Every kanji in the batch has `kanji_i18n` rows for all 3 languages.
- Every `kanji_i18n` row has a non-empty `system_mnemonic`.
- Every `kanji_i18n` row has a non-empty `search_tags` array.
- Every `kanji_components` row has a non-default `logic_hint` (i.e., Step 1 has been applied — though the value may still be `semantic` if onyomi don't match).

### Vocabulary completeness

- Every vocabulary in the batch has `vocabulary_i18n` rows for all 3 languages. (EN from JMdict, ES/RU from JMdict + `manual_localization.csv` in Phase 2.)
- Every `vocabulary_i18n` row has a non-empty `search_tags` array.
- `system_mnemonic` may be null (intentionally skipped) — no completeness check on this field.

### Sentence completeness

- Every `vocabulary_sentences` row in the batch has furigana-annotated `original_text` (contains at least one `{...}` group, unless the sentence is pure kana).
- Every `vocabulary_sentences` row has `vocabulary_sentence_i18n` rows for all 3 languages (EN, ES, RU).

### Cross-layer consistency

- Every radical name referenced in a kanji `system_mnemonic` matches the `radical_i18n.name` for that language.
- Every sound anchor used in kanji mnemonics is consistent within the batch (same onyomi → same anchor word per language).

## Output Summary

### Global outputs (`uv run python -m src.enrich`)

| File | Action | Step | Description |
|---|---|---|---|
| `radical_classification.csv` | **Created** | Step 0 | Analysis output — radical classification for multi-level decomposition review |
| `radical_classification_review.csv` | **Created** | Step 0 | Enriched classification with `parent_kanji` column for review context |
| `kanji_decomposition.csv` | **Created** | Step 0 | Kanji-centric component view — data source for batch review |
| `kanji_components.csv` | Updated | Step 1 | `logic_hint` refined from default `semantic` to `phonetic` where onyomi match |

**Warning file:** `data/csv/warnings/ph3_warnings.csv`

### Per-batch outputs (`release enrich` + `release merge`)

| File | Action | Steps | Description |
|---|---|---|---|
| `ai/templates/radical_i18n_ai.csv` | **Created** | Step 2 | Template → merged into `radical_i18n.csv` |
| `ai/templates/kanji_i18n_ai.csv` | **Created** | Step 3 | Template → merged into `kanji_i18n.csv` |
| `ai/templates/vocab_i18n_ai.csv` | **Created** | Step 4 | Template → merged into `vocabulary_i18n.csv` |
| `ai/templates/sentence_ai.csv` | **Created** | Steps 5-6 | Template → merged into `vocabulary_sentences.csv` + `vocabulary_sentence_i18n.csv` |

## Ordering Constraints

Phase 3 sits between Phase 2 (extraction) and Phase 4 (verification & upload). Within Phase 3, steps have internal dependencies:

```
Phase 2 (all sub-phases complete)
    |
    v
Step 0: Radical Classification (deterministic — `uv run python -m src.enrich`)
    |
    v
Step 1: Logic Hint Refinement (deterministic — `uv run python -m src.enrich`)
    |
    v
release slice <name> --jlpt <N> --kanji <N> --vocab <N>
    |
    v
release enrich <name> --entity radical  →  [fill radical_i18n_ai.csv]
    |
    v
release merge <name> --entity radical
    |
    v
release enrich <name> --entity kanji  →  [fill kanji_i18n_ai.csv]
    |
    v
release merge <name> --entity kanji
    |                                    (parallel)
    v                                        |
release enrich <name> --entity vocab     release enrich <name> --entity sentence
    |                                        |
    v                                        v
release merge <name> --entity vocab      release merge <name> --entity sentence
    |                                        |
    v────────────────────────────────────────v
release review <name>
    |
    v
release validate <name>
    |
    v
release push <name>
```

**Sequential:** Radical → kanji is strictly ordered (kanji mnemonics reference radical names). Kanji → vocab is recommended but not required. Sentences are independent of all other entities.

## Related Docs

### Domain specs

- [mnemonic.md](../domain/mnemonic.md) — Mnemonic Lego Stack theory, sound anchor tables, consistency rules
- [radical.md](../domain/radical.md) — Radical and RadicalI18n entity spec
- [kanji.md](../domain/kanji.md) — Kanji and KanjiI18n entity spec
- [kanji_component.md](../domain/kanji_component.md) — KanjiComponent entity spec, LogicHint enum
- [vocabulary.md](../domain/vocabulary.md) — Vocabulary, VocabularyI18n, VocabularySentence entity specs, furigana notation

### Pipeline docs

- [pipeline.md](pipeline.md) — Full pipeline orchestration (Phases 1–4)
- [ph2_1_radical_extraction.md](ph2_1_radical_extraction.md) — Radical registration (produces `radicals.csv`)
- [ph2_2_kanji_composition.md](ph2_2_kanji_composition.md) — Kanji creation (produces `kanji_i18n.csv` with empty mnemonic fields)
- [ph2_3_component_linking.md](ph2_3_component_linking.md) — Component linking (produces `kanji_components.csv` with default `logic_hint`)
- [ph2_5_vocabulary_extraction.md](ph2_5_vocabulary_extraction.md) — Vocabulary extraction (produces `vocabulary_i18n.csv`, `vocabulary_sentences.csv`, `vocabulary_sentence_i18n.csv`)

### Source format docs

- [kanjidic_format.md](../sources/kanjidic_format.md) — KANJIDIC2 XML structure (onyomi readings, meanings)
- [jmdict_furigana_format.md](../sources/jmdict_furigana_format.md) — JmdictFurigana JSON format (sentence furigana lookups)
