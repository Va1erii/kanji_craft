# Content Pipeline Orchestration

## Overview

The Content Pipeline transforms raw open-source dictionary data (KANJIDIC2, KanjiVG, JMdict) and reference datasets (JLPT mappings, JmdictFurigana) into structured, verified educational content used by the app.

The pipeline runs as a series of **Python scripts** that produce intermediate files (Parquet, CSV) between phases. The final phase uploads verified content to Remote Supabase.

**Key properties:**

- **Idempotent:** same source files → same Parquet → same CSVs → same upload
- **Inspectable:** every intermediate artifact is a file on disk (Parquet or CSV) — no hidden database state
- **Human-in-the-loop:** AI-generated content (Phase 3) is reviewed by the admin before upload

## Source Archives

Immutable source data lives in `sources/` at the project root. Each folder is a versioned snapshot — never modified after download.

### 1. Kanji Source (Official XML) — `kanjidic2-{date}/`

Downloaded from the [EDRDG](http://www.edrdg.org/wiki/KANJIDIC_Project.html) project. The official KANJIDIC2 XML contains every field (meanings in all languages, classical radicals, nanori, variants, dictionary refs) in a single file.

| Archive | Contents |
|---|---|
| `kanjidic2.xml.gz` | Full KANJIDIC2 dictionary (~13,000 entries) |

### 2. Vocabulary Source (Official XML) — `jmdict-{version}/`

Downloaded from the [EDRDG](http://www.edrdg.org/wiki/JMdict-EDICT_Dictionary_Project.html). The official JMDict XML contains all vocabulary entries with readings, senses, and cross-references.

| Archive | Contents |
|---|---|
| `JMdict.gz` | Full JMDict dictionary (~200,000 entries, all languages) |
| `JMdict_e_examp.gz` | English JMDict + example sentence pairs from the Tanaka Corpus |

### 3. Visual Source (KanjiVG) — `kanjivg-{version}/`

Downloaded from the [KanjiVG](https://kanjivg.tagaini.net/) project. Stroke order and component decomposition data.

| Archive | Contents |
|---|---|
| `kanjivg-{version}.xml.gz` | Single XML with all kanji stroke/component data (~6,700 entries) |
| `kanjivg-{version}-main.zip` | Individual SVG files per kanji (stroke diagrams) |

### 4. JLPT Level Mapping — `jlpt_mapping/`

Curated kanji-to-JLPT-level mapping compiled from Jonathan Waller's [Tanos](https://www.tanos.co.uk/jlpt/) lists and David Luz Gouveia's [kanji-data](https://github.com/davidluzgouveia/kanji-data) repo.

| File | Contents |
|---|---|
| `jlpt_mapping.csv` | 2,211 kanji → N1–N5 level |

No version suffix — single curated file, updated manually. See [jlpt_mapping_format.md](../sources/jlpt_mapping_format.md).

### 5. JLPT Vocabulary Mapping — `jlpt_vocab_mapping/`

Curated vocabulary-to-JLPT-level mapping compiled from Jamie Sinclair's [Open Anki JLPT Decks](https://github.com/jamsinclair/open-anki-jlpt-decks), originally derived from Jonathan Waller's [Tanos](https://www.tanos.co.uk/jlpt/) word lists.

| File | Contents |
|---|---|
| `n1.csv` through `n5.csv` | 8,131 vocabulary → N1–N5 level (one file per level) |

No version suffix — curated files, updated manually. See [jlpt_vocab_mapping_format.md](../sources/jlpt_vocab_mapping_format.md).

### 6. Furigana Mapping — `jmdictfurigana-{semver}+{date}/`

Pre-computed per-character furigana mappings from [Doublevil's JmdictFurigana](https://github.com/Doublevil/JmdictFurigana). Auto-rebuilt monthly from the latest JMdict and KANJIDIC releases.

| Archive | Contents |
|---|---|
| `JmdictFurigana.json.tar.gz` | 230,371 word → furigana segment mappings |

Uses semantic versioning with a build date suffix (e.g. `jmdictfurigana-2.3.1+20260125/`). Tightly coupled with JMdict — both should be updated together. See [jmdict_furigana_format.md](../sources/jmdict_furigana_format.md).

### Folder Preparation

The admin prepares source data by placing downloaded archives into correctly named folders under `sources/`. The pipeline operates on **folders, not individual files**.

**Required folder naming:**

| Source | Folder pattern | Example |
|---|---|---|
| KANJIDIC | `kanjidic2-{version}/` | `kanjidic2-20260208/` |
| JMDict | `jmdict-{version}/` | `jmdict-20260207/` |
| KanjiVG | `kanjivg-{version}/` | `kanjivg-20250816/` |
| JLPT Mapping | `jlpt_mapping/` (no version) | `jlpt_mapping/` |
| JLPT Vocab Mapping | `jlpt_vocab_mapping/` (no version) | `jlpt_vocab_mapping/` |
| JmdictFurigana | `jmdictfurigana-{semver}+{date}/` | `jmdictfurigana-2.3.1+20260125/` |

**Required folder contents:**

| Source | Required files | Optional files |
|---|---|---|
| KANJIDIC | `kanjidic2.xml.gz` | — |
| JMDict | `JMdict.gz`, `JMdict_e_examp.gz` | — |
| KanjiVG | `kanjivg-{version}.xml.gz` | `kanjivg-{version}-main.zip` (SVGs, used in Phase 2) |
| JLPT Mapping | `jlpt_mapping.csv` | — |
| JLPT Vocab Mapping | `n1.csv`, `n2.csv`, `n3.csv`, `n4.csv`, `n5.csv` | — |
| JmdictFurigana | `JmdictFurigana.json.tar.gz` | — |

## Directory Structure

```
kanji_craft/
  sources/                          # Read-only source archives (never modified)
    kanjidic2-20260208/
    kanjivg-20250816/
    jmdict-20260207/
    jlpt_mapping/
    jlpt_vocab_mapping/
    jmdictfurigana-2.3.1+20260125/
  pipeline/                         # Python project root
    pyproject.toml                  # Dependencies (pandas, pyarrow, etc.)
    .venv/                          # Python virtual environment
    src/                            # Pipeline scripts
      config.py                     # Central config: TARGET_LANGS, JMDICT_LANG_MAP
      ingest.py                     # Phase 1: sources → Parquet
      extract.py                    # Phase 2: Parquet → CSV
      verify.py                     # Phase 4: validate + upload
    data/                           # Generated artifacts (gitignored)
      parquet/                      # Phase 1 output
      csv/                          # Phase 2 output (+ Phase 3 enrichment)
      svg/                          # Phase 2.4 output: SVG files for Phase 4 upload
        radicals/                   # Pass 1: ZIP-matched radical + variant SVGs
        kanji/                      # Pass 1: ZIP-matched kanji SVGs
        extracted/
          radicals/                 # Pass 2: Component-extracted radical SVGs
```

- **`sources/`** — immutable, versioned snapshots of external data. Read-only for the pipeline.
- **`pipeline/`** — self-contained Python project with its own venv. All scripts read from `sources/` and write to `pipeline/data/`.
- **`pipeline/data/`** — gitignored, fully regenerable. Parquet, CSV, and SVG files are intermediate artifacts.

## Architecture

```
sources/ (read-only)              Phase 1              Phase 2             Phase 3              Phase 4
 kanjidic2.xml.gz  ─┐         ┌──────────┐        ┌──────────┐       ┌──────────┐        ┌──────────────┐
 kanjivg.xml.gz    ─┤         │ Ingestion│        │Extraction│       │    AI    │        │ Verification │
 JMdict.gz         ─┼────────►│ Python   │──Parq─►│ Python   │──CSV─►│Enrichment│──CSV─►│  & Upload    │
 jlpt_mapping.csv  ─┤         │          │        │          │       │          │        │              │
 JmdictFurigana    ─┘         └──────────┘        └──────────┘       └──────────┘        └──────┬───────┘
                            data/parquet/        data/csv/           data/csv/                   │
                                                                                   Supabase ◄───┘
                                                                                (PostgreSQL + Storage)
```

**File flow:** `sources/` → `data/parquet/` (Phase 1) → `data/csv/` + `data/svg/` (Phase 2) → enriched `data/csv/` (Phase 3) → Supabase (Phase 4)

## Phase 1: Ingestion (Python → Parquet)

**Goal:** Parse source XML/CSV/JSON files into columnar Parquet files for fast querying in Phase 2. No transformation — faithful representation of source data.

### What it does

Python scripts using pandas parse each source into DataFrames, then write Parquet files to `data/parquet/`.

| Source | Parser input | Parquet output |
|---|---|---|
| KANJIDIC2 | `kanjidic2.xml.gz` | `kanjidic.parquet` — one row per kanji, meanings grouped by language |
| KanjiVG | `kanjivg-{version}.xml.gz` | `kanjivg.parquet` — one row per kanji, component tree preserved |
| JMdict | `JMdict.gz` | `jmdict.parquet` — one row per entry, senses and glosses nested |
| JMdict examples | `JMdict_e_examp.gz` | `jmdict_examples.parquet` — sentence pairs |
| JLPT kanji | `jlpt_mapping.csv` | `jlpt_kanji.parquet` — kanji → level mapping |
| JLPT vocab | `n1.csv`–`n5.csv` | `jlpt_vocab.parquet` — vocab → level mapping |
| JmdictFurigana | `JmdictFurigana.json.tar.gz` | `jmdict_furigana.parquet` — (text, reading) → furigana segments |

### Properties

- **No transformation:** Parquet columns mirror source structure. Language filtering, ghost flattening, etc. happen in Phase 2.
- **Idempotent:** Same source files always produce identical Parquet output.
- **Fast re-reads:** Parquet's columnar format enables fast filtered queries in Phase 2 without re-parsing XML.

## Phase 2: Extraction (Parquet → CSV)

**Goal:** Read Parquet from Phase 1, apply domain logic (radical extraction, kanji composition, component linking, SVG processing, vocabulary extraction), and produce CSV files that map 1:1 to Supabase content tables.

Output CSVs go to `data/csv/` and are ordered by JLPT level then grade for Phase 3 prioritization (N5 first).

### 2.1 Radical Extraction

Reads `kanjivg.parquet` + `kanjidic.parquet` + `jlpt_kanji.parquet`.

**Scope:** Only kanji with a JLPT level (N1–N5) or Jōyō school grade 1–8 are processed. See [ph2_1_radical_extraction.md §Scope](ph2_1_radical_extraction.md#scope-jlptgrade-kanji-only).

**Ghost flattening:** Builds a **keep set** (learnable kanji + official Kangxi radicals + components appearing in 5+ in-scope kanji) and flattens non-keep-set intermediates by replacing them with their own children. Reduces ~900 scope-only radicals to ~600–700 meaningful building blocks. See [ph2_1_radical_extraction.md §Keep Set](ph2_1_radical_extraction.md#keep-set-what-becomes-a-radical) and [§Ghost Flattening](ph2_1_radical_extraction.md#ghost-radical-flattening).

**Output CSVs:**

| File | Content | Maps to table |
|---|---|---|
| `radicals.csv` | Radical rows (master_symbol, stroke_count, kangxi_number) | `radicals` |
| `radical_i18n.csv` | Radical names/keywords per language (deferred — populated in Phase 3) | `radical_i18n` |
| `radical_variants.csv` | Shape variants with positions | `radical_variants` |

See [radical.md](../domain/radical.md), [ph2_1_radical_extraction.md](ph2_1_radical_extraction.md).

### 2.2 Kanji Composition

Reads `kanjidic.parquet` + `jlpt_kanji.parquet`.

1. **Kanji creation:** Create rows using metadata from KANJIDIC2 (stroke count, grade, frequency, JLPT mapping). Frequency rank is always populated — synthetic values assigned for unranked kanji.
2. **Readings:** Extract on'yomi and kun'yomi readings with priority from `re_pri`.
3. **I18n:** Create meaning rows per language from KANJIDIC2 meanings, filtered to `TARGET_LANGS` from `src/config.py`.

**Output CSVs:**

| File | Content | Maps to table |
|---|---|---|
| `kanji.csv` | Kanji rows (character, stroke_count, grade, frequency_rank, jlpt_level) | `kanji` |
| `kanji_readings.csv` | On/kun readings with priority | `kanji_readings` |
| `kanji_i18n.csv` | Meanings per language (deferred i18n fields populated in Phase 3) | `kanji_i18n` |

See [kanji.md](../domain/kanji.md), [ph2_2_kanji_composition.md](ph2_2_kanji_composition.md).

### 2.3 Component Linking

Reads `kanjivg.parquet` + radicals from 2.1 + kanji from 2.2.

1. **Component linking:** Resolve effective children per kanji (after ghost flattening), resolve each child to its master radical, and create `kanji_components` rows with position and radical_type.
2. **Radical metadata derivation:** Compute `impact_score`, `min_grade`, `min_jlpt_level` from the component links and update `radicals.csv`.

**Output CSVs:**

| File | Content | Maps to table |
|---|---|---|
| `kanji_components.csv` | Kanji ↔ radical links with position, radical_type, logic_hint | `kanji_components` |

Also updates `radicals.csv` with derived metadata fields.

See [kanji_component.md](../domain/kanji_component.md), [ph2_3_component_linking.md](ph2_3_component_linking.md).

### 2.4 SVG Processing

Reads the `kanjivg-{version}-main.zip` archive + `kanjivg.parquet` + radicals/kanji from prior steps. Runs in two passes:

**Pass 1 — ZIP matching:**
1. **Build SVG map:** Read ZIP archive, compute SHA-256 hash per file.
2. **Match entities:** For each radical, radical_variant, and kanji row, look up the character's SVG by Unicode code point filename.
3. **Populate fields:** Set `svg_file_name`, `svg_hash`, `svg_file_url`.
4. **Save to disk:** Write matched SVGs to `data/svg/{radicals,kanji}/`.

**Pass 2 — Component extraction** (radicals/variants only):
5. **Extract missing:** For radicals still missing SVGs, find a parent kanji SVG containing the radical as a `kvg:element` component, extract the stroke paths, and generate a standalone SVG.
6. **Save extracted:** Write to `data/svg/extracted/radicals/` (separate folder for admin visual verification). Same naming, hash, and URL rules — uploads to the same `radicals/` bucket.

**Local upload:** Upload to Local Supabase Storage (when env vars set) for dev verification.

Updates `radicals.csv`, `radical_variants.csv`, and `kanji.csv` with SVG fields.

**Hash stability:** If a new KanjiVG version ships identical bytes for a character, the hash stays the same. Only characters with actual SVG changes get a new hash. This enables efficient delta uploads in Phase 4.

See [ph2_4_svg_processing.md](ph2_4_svg_processing.md).

### 2.5 Vocabulary Extraction

Reads `jmdict.parquet` + `jmdict_examples.parquet` + `jlpt_vocab.parquet` + `jmdict_furigana.parquet` + kanji from 2.2.

**From JMdict + reference data:**

1. **Vocabulary creation:** Select common words (priority-flagged or in JLPT vocab mapping) and create rows using `ent_seq` as stable ID. Resolve `min_jlpt_level` from JLPT vocab mapping (authoritative) with fallback to `MAX(kanji.min_jlpt_level)`.
2. **Furigana:** Construct `{kanji|reading}` notation using JmdictFurigana data. Per-character readings for standard words, single-span for jukujikun.
3. **Readings:** Extract into vocabulary_readings with primary/secondary priority.
4. **I18n:** Create meaning rows per language from JMdict senses/glosses.

**From JMdict examples (Tanaka Corpus):**

5. **Example sentences:** Extract sentence pairs with `original_text` (Japanese) and English translation.

**Post-processing:**

6. **Kanji linking:** Scan each word for known kanji, create vocabulary_kanji rows with position. Orphan kanji (not in kanji table) are logged but the word is still imported.

**Output CSVs:**

| File | Content | Maps to table |
|---|---|---|
| `vocabulary.csv` | Vocabulary rows (ent_seq, furigana, jlpt_level, is_common) | `vocabulary` |
| `vocabulary_readings.csv` | Readings with priority | `vocabulary_readings` |
| `vocabulary_i18n.csv` | Meanings per language (deferred i18n fields populated in Phase 3) | `vocabulary_i18n` |
| `vocabulary_kanji.csv` | Word ↔ kanji links with position | `vocabulary_kanji` |
| `vocabulary_sentences.csv` | Example sentences (original_text) | `vocabulary_sentences` |
| `vocabulary_sentence_i18n.csv` | Sentence translations (English from source, others deferred) | `vocabulary_sentence_i18n` |

**Ordering constraint:** Vocabulary extraction must run after kanji creation (2.2), because kanji linking requires the kanji table.

See [vocabulary.md](../domain/vocabulary.md), [ph2_5_vocabulary_extraction.md](ph2_5_vocabulary_extraction.md).

## Phase 3: AI Enrichment

**Goal:** Add AI-generated content to the extraction output from Phase 2. The exact tooling (chat AI, scripts, local Supabase UI, etc.) is flexible — what matters is that the admin reviews results before Phase 4.

### Workflow

1. **Batch by priority:** Content is grouped by JLPT level → grade level (N5 first, then N4, etc.) for manageable review chunks.
2. **AI generation:** Generate content via whatever tool is most effective (chat AI, scripts, batch API).
3. **Admin review:** Admin reviews AI output before proceeding — this is the human-in-the-loop checkpoint. Review can happen in CSVs, a script-based validator, local Supabase, or any other workflow.
4. **Write back:** Approved content is merged back into the pipeline output (CSVs or directly into a staging database).

### Content types

| Content | Target tables | Description |
|---|---|---|
| System mnemonics (radical) | `radical_i18n` | Visual keywords and memory stories for EN/ES/RU |
| System mnemonics (kanji) | `kanji_i18n` | Onyomi sound anchor stories for EN/ES/RU |
| System mnemonics (vocabulary) | `vocabulary_i18n` | Kunyomi context stories for EN/ES/RU |
| Search tags | `radical_i18n`, `kanji_i18n` | Alternative search terms per language |
| Logic hints | `kanji_components` | Semantic/phonetic classification for each component link |
| Sentence translations | `vocabulary_sentence_i18n` | ES/RU translations of English example sentences |
| Furigana annotation | `vocabulary_sentences` | `{kanji|reading}` notation on sentence `original_text` |

### Batching strategy

Batches are ordered by JLPT level (N5 → N1) to prioritize beginner content. Within each level, items are grouped by grade. This ensures the most commonly studied content is enriched and reviewed first.

## Phase 4: Verification & Upload

**Goal:** Validate the final CSVs from Phase 3 for completeness and referential integrity, then upload to Remote Supabase.

### 4.1 Verification Checks

Before uploading, the pipeline validates the complete CSV dataset:

**Referential integrity:**
- All foreign keys resolve (e.g. every `kanji_components.radical_id` exists in `radicals.csv`)
- Unique constraints hold (e.g. `(kanji_id, radical_id, position)` on kanji_components)
- All NOT NULL fields in the Supabase schema are present and non-empty

**Completeness (per JLPT level being uploaded):**
- Every kanji has components, readings, i18n for all 3 languages (EN/ES/RU), SVG fields, system mnemonic
- Every radical has at least one variant, i18n for all languages, system mnemonic, SVG fields
- Every vocabulary has readings, kanji links, i18n for all languages, furigana
- Every vocabulary sentence has translations for all languages, furigana annotation on `original_text`

Verification failures are reported with the specific rows and fields that failed. The pipeline does not proceed to upload until all checks pass.

### 4.2 Upload Order (FK Dependency Resolution)

Tables are uploaded in strict order to satisfy foreign key constraints:

1. **radicals** + `radical_i18n` + `radical_variants` — root entities
2. **kanji** + `kanji_i18n` + `kanji_readings` — depends on nothing directly
3. **kanji_components** — depends on both `radicals` and `kanji`
4. **vocabulary** + `vocabulary_i18n` + `vocabulary_readings` + `vocabulary_kanji` + `vocabulary_sentences` + `vocabulary_sentence_i18n` — depends on `kanji`

### 4.3 SVG Upload

Before uploading database rows, upload changed SVG files from `data/svg/` to the remote `svg` bucket so that `svg_file_url` values are valid when clients receive them.

1. **Diff by hash:** For each radical, radical_variant, and kanji row being uploaded, compare local `svg_hash` against the remote row's `svg_hash` (if it exists).
2. **Upload changed:** Only upload SVGs where the hash differs or the remote row is new. Read the file from `data/svg/{radicals,kanji}/` or `data/svg/extracted/radicals/` and upload via `supabase.storage.from('svg').upload()` with upsert mode. Both sources upload to the same bucket folders.
3. **Skip unchanged:** Identical hashes mean identical bytes — no upload needed.

**Failure handling:** If an SVG upload fails, the row is skipped and logged. The database row is not uploaded without its SVG — this prevents clients from receiving a `svg_file_url` that 404s.

### 4.4 Comparison-Based Sync

The upload uses **comparison-based sync** — it queries Remote at upload time and compares against the CSV data:

1. Query Remote for all IDs + `updated_at` within the selected scope (e.g. all N5 kanji).
2. Compare each CSV row against the remote result:
   - **New** — no remote match → upsert
   - **Updated** — content differs → upsert
   - **Unchanged** — identical → skip
3. Batch upsert in FK dependency order.

### 4.5 URL Rewrite

Replace the local base URL in `svg_file_url` with the Remote Production Storage URL (e.g. `https://<project-ref>.supabase.co/storage/v1/object/public/svg/...`). Local development URLs must never reach production.

### 4.6 Scenarios

**Source update (e.g. new KANJIDIC version):**
1. Re-run Phase 1 (new Parquet), Phase 2 (new CSVs), Phase 3 (re-enrich only changed items).
2. Phase 4 comparison-based sync detects changed rows and uploads only the diff.

**Adding a new language (e.g. French):**
1. Add the language code to `TARGET_LANGS` in `src/config.py` (and add the ISO 639-2/B mapping to `JMDICT_LANG_MAP` if not already present).
2. Re-run Phase 2 — extraction produces i18n CSV rows for the new language.
3. Phase 3 AI enrichment generates mnemonics and translations for the new language only.
4. Phase 4 uploads the new i18n rows.

**Incremental JLPT release (e.g. N5 first, then N4):**
1. Run Phases 1–3 for the full dataset.
2. Phase 4 upload scoped to N5 only for initial release.
3. Later, re-run Phase 4 scoped to N4 — comparison-based sync uploads only the new level.

## Related Docs

### Pipeline sub-docs

- [ph1_ingestion.md](ph1_ingestion.md) — Phase 1 correctness invariants and recovery procedures (stale — old Dart pipeline, domain logic accurate)
- [ph2_1_radical_extraction.md](ph2_1_radical_extraction.md) — Radical/variant registration algorithm
- [ph2_2_kanji_composition.md](ph2_2_kanji_composition.md) — Kanji creation from KANJIDIC2
- [ph2_3_component_linking.md](ph2_3_component_linking.md) — Component linking and radical metadata derivation
- [ph2_4_svg_processing.md](ph2_4_svg_processing.md) — SVG file matching, SHA-256 hashing, URL construction
- [ph2_5_vocabulary_extraction.md](ph2_5_vocabulary_extraction.md) — Vocabulary extraction from JMdict
- [ph3_ai_enrichment.md](ph3_ai_enrichment.md) — AI enrichment: logic hints, mnemonics, translations, furigana annotation

### Domain specs

- [radical.md](../domain/radical.md) — Radical entity spec
- [kanji.md](../domain/kanji.md) — Kanji entity spec
- [kanji_component.md](../domain/kanji_component.md) — KanjiComponent entity spec
- [vocabulary.md](../domain/vocabulary.md) — Vocabulary entity spec
- [mnemonic.md](../domain/mnemonic.md) — Mnemonic lego stack (radical → kanji → vocabulary)

### Source format docs

- [kanjivg_format.md](../sources/kanjivg_format.md) — KanjiVG SVG namespace and radical markers
- [kanjidic_format.md](../sources/kanjidic_format.md) — KANJIDIC2 XML structure
- [jmdict_format.md](../sources/jmdict_format.md) — JMdict XML structure
- [jlpt_mapping_format.md](../sources/jlpt_mapping_format.md) — JLPT kanji mapping CSV format
- [jlpt_vocab_mapping_format.md](../sources/jlpt_vocab_mapping_format.md) — JLPT vocabulary mapping CSV format
- [jmdict_furigana_format.md](../sources/jmdict_furigana_format.md) — JmdictFurigana JSON format

### Infrastructure

- [supabase.md](../adr/supabase.md) — Database infrastructure
- [offline.md](../adr/offline.md) — Client-side sync
