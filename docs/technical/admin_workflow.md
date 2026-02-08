# Admin Tool — User Workflow

## Overview

The Admin Tool is a **desktop Flutter app** (macOS / Windows) for managing the content lifecycle. It provides a GUI over the [Content Pipeline](pipeline.md), letting the admin ingest source data, run transformations, review AI-generated content, and promote verified data to production — all without touching SQL or CLI commands.

**Runtime:** Connects to **Local Supabase** only. Production sync happens through the Promotion action, which pushes data one-way to Remote Supabase.

## Navigation

A persistent left sidebar provides top-level navigation:

| Destination | Purpose |
|---|---|
| **Dashboard** | At-a-glance status of all imports and review queues |
| **Data Pipeline** | Ingest, transform, and enrich source data |
| **Review: Components** | Verify AI-assigned `logic_hint` on kanji components |
| **Review: Sentences** | Verify AI-translated vocabulary sentences |
| **Content Browser** | Browse radicals, kanji, and vocabulary in read-only tables |
| **Settings** | Local Supabase connection, AI model config, batch thresholds |

## Dashboard

The landing screen. Shows a summary card for each area:

- **Imports** — count by `import_status` (`pending`, `ingested`, `processing`, `processed`, `promoted`, `failed`). Clicking a status filters the Data Pipeline view.
- **Component Reviews** — count of `kanji_component_reviews` rows where `verification_status = 'draft'`. Links to the Component Review queue.
- **Sentence Reviews** — count of `vocabulary_sentences` rows where `verification_status = 'draft'`. Links to the Sentence Review queue.
- **Last Promotion** — timestamp of the most recent `data_imports.promoted_at`, or "Never" if no promotion has run.

## Data Pipeline

Three sequential stages, presented as tabs or an accordion. Each stage corresponds to pipeline phases in [pipeline.md](pipeline.md).

### Source Management (Phase 1: Ingestion)

**Table** listing all `data_imports` rows, sorted by `created_at DESC`.

| Column | Source |
|---|---|
| Source | `import_source` enum (`kanjidic`, `kanjivg`, `jmdict`) |
| Version | `source_version` |
| Status | `import_status` badge |
| Records | `record_count` |
| Error | `error_message` (truncated, expandable) |
| Started | `started_at` |

**Actions:**

- **"New Import"** button opens a dialog:
  1. Select `import_source` from a dropdown (`kanjidic`, `kanjivg`, `jmdict`).
  2. Enter `source_version` (free text, e.g. "2024-04-01").
  3. Pick the source file via native file picker (`.xml.gz` for kanjidic/kanjivg, `.zip` for jmdict).
  4. For `jmdict`: two file pickers appear — one for `JMdict_english_with_examples.zip`, one for `JMdict_spanish.zip`.
  5. Click **"Start Ingestion"**. A progress bar shows records inserted. On completion the row status updates to `ingested`.

- **Row actions** (context menu or inline buttons):
  - **"View Details"** — expands to show full `error_message` and `metadata` JSON.
  - **"Retry"** — available only when status is `failed`. Re-runs ingestion for this import.
  - **"Delete"** — removes the `data_imports` row and its associated staging rows (`raw_kanjidic` or `raw_kanjivg`). Confirmation dialog required.

**Service invoked:** `IngestionService` — creates `data_imports` row, runs the appropriate Dart XML/JSON parser, inserts into `raw_kanjidic` / `raw_kanjivg`, updates status to `ingested` or `failed`. See [pipeline.md — Phase 1](pipeline.md#phase-1-ingestion-raw-staging).

### Transformation (Phase 2)

Available only for imports with status `ingested`.

**"Run Processor"** button beside each eligible import row. Clicking it:

1. Sets `data_imports.status` = `processing`.
2. Runs sub-phases sequentially:
   - **Radical Extraction** (2.2) — upserts `radicals` and `radical_variants` from `raw_kanjivg`.
   - **Kanji & Component Composition** (2.3) — upserts `kanji`, `kanji_readings`, `kanji_i18n`, `kanji_components` from `raw_kanjidic` + `raw_kanjivg`.
   - **SVG Processing** (2.4) — extracts SVGs, computes `svg_hash` (SHA-256), populates `svg_file_name` and `svg_file_url`.
   - **AI Heuristics** (2.5) — estimates `logic_hint` (`semantic` / `phonetic`) via onyomi matching, creates `kanji_component_reviews` rows with `ai_confidence`.
   - **Vocabulary Extraction** (2.6) — two-pass merge (EN + ES), kanji association, AI sentence translation, JLPT inference.
3. A step-by-step progress indicator shows which sub-phase is running.
4. On success: status → `processed`, `processed_at` populated.
5. On failure: status → `failed`, `error_message` populated, partial progress preserved.

**Service invoked:** `TransformationService`. See [pipeline.md — Phase 2](pipeline.md#phase-2-transformation-raw--local-production).

### AI Enrichment

A supplementary panel (not tied to a single import) for running AI tasks on existing content.

- **Content Gaps Report** — shows counts of:
  - Kanji components without a `kanji_component_reviews` row.
  - Vocabulary words missing Spanish `vocabulary_i18n`.
  - Vocabulary sentences missing a Spanish translation.
- **"Run AI Enricher"** button with checkboxes:
  - [ ] Generate missing `logic_hint` estimates
  - [ ] Translate missing Spanish sentences
  - [ ] Infer missing JLPT levels
- Progress bar and log output while running.

**Service invoked:** `EnrichmentService` — runs the same AI heuristic and translation logic as Phase 2 sub-phases, but scoped to rows missing data rather than a specific import.

## Review: Components

**Purpose:** Verify the AI-assigned `logic_hint` on `kanji_components`. Corresponds to [pipeline.md — Phase 3.2](pipeline.md#32-review-queue-admin-dashboard).

### Queue

A filterable list of `kanji_component_reviews` rows where `verification_status = 'draft'`, ordered by `ai_confidence ASC` (least confident first).

**Filters:**
- Confidence range slider (0.0 – 1.0)
- Logic hint (`semantic` / `phonetic` / all)
- Kanji grade level

**Batch action:** **"Auto-verify high confidence"** button. Verifies all `draft` rows with `ai_confidence >= threshold` (default 0.95, configurable in Settings). Sets `verification_status = 'verified'`.

### Review Card

Split-screen layout for the selected component:

| Left Panel | Right Panel |
|---|---|
| **Kanji** character (large) | **Radical** character (large) |
| Kanji onyomi readings | Radical onyomi readings (looked up from `raw_kanjidic`) |
| Kanji meanings (EN) | Radical name (if available) |
| Stroke count, grade, JLPT | `position` (`hen`, `tsukuri`, `kanmuri`, etc.) |

**Center section:**
- Current `logic_hint` assignment highlighted (`semantic` or `phonetic`)
- `ai_confidence` score displayed as percentage
- Onyomi match indicator: green checkmark if kanji and radical share an onyomi, red X if no match

**Actions (buttons + keyboard shortcuts):**

| Button | Shortcut | Effect |
|---|---|---|
| **Confirm Phonetic** | `1` | Set `logic_hint = 'phonetic'`, `verification_status = 'verified'` |
| **Confirm Semantic** | `2` | Set `logic_hint = 'semantic'`, `verification_status = 'verified'` |
| **Flag** | `3` | Set `verification_status = 'flagged'` |
| **Skip** | `→` | Move to next item without changes |

After each action, the next `draft` item loads automatically.

**Service invoked:** Updates `kanji_components.logic_hint` and `kanji_component_reviews.verification_status` via repository.

## Review: Sentences

**Purpose:** Verify AI-translated vocabulary sentences (primarily Spanish). Corresponds to [pipeline.md — Phase 3.4](pipeline.md#34-sentence-review-queue).

### Queue

A filterable list of `vocabulary_sentences` rows where `verification_status = 'draft'`, ordered by `created_at ASC`.

**Filters:**
- Language (`es` by default, since EN sentences are born `verified`)
- JLPT level of the parent vocabulary word

**Batch action:** **"Approve all visible"** — sets `verification_status = 'verified'` for all currently filtered `draft` rows. Confirmation dialog warns about bulk approval.

### Review Card

| Section | Content |
|---|---|
| **Japanese** | `sentence_ja` with `sentence_furigana` above |
| **English (source)** | `sentence_translated` from the EN row (same `vocabulary_id`, `lang_code = 'en'`) |
| **Spanish (AI)** | `sentence_translated` from the draft ES row — **editable text field** |
| **Context** | Parent vocabulary word + meanings |

**Actions:**

| Button | Effect |
|---|---|
| **Approve** | Set `verification_status = 'verified'` |
| **Edit & Approve** | Save edited `sentence_translated`, set `verification_status = 'verified'` |
| **Reject** | Set `verification_status = 'flagged'` |
| **Skip** | Move to next item without changes |

After each action, the next `draft` item loads automatically.

**Service invoked:** Updates `vocabulary_sentences.sentence_translated` and `vocabulary_sentences.verification_status` via repository.

## Promotion (Phase 4)

Accessible from the Dashboard or Data Pipeline view when at least one import has status `processed` and review queues have been addressed.

### Pre-Promotion Report

Before syncing, a **diff report** is generated:

- **New entities** — count of radicals, kanji, components, vocabulary words, and sentences that will be created on Remote.
- **Updated entities** — count of rows where local data differs from Remote (by field comparison).
- **SVG changes** — count of SVGs with different `svg_hash` vs Remote (will be uploaded).
- **Skipped** — count of items excluded:
  - `kanji_components` with `verification_status != 'verified'`
  - `vocabulary_sentences` with `verification_status != 'verified'`
  - Vocabulary words referencing kanji not yet on Remote

### Orphan Validation Gate

Before the "Promote" button becomes active, the system checks for:

- `vocabulary_kanji` rows pointing to `kanji_id` values not present on Remote and not in the current promotion batch.
- `kanji_components` rows pointing to `radical_id` values not present on Remote and not in the current promotion batch.

If orphans are found, a warning is displayed listing the affected items. Promotion is **blocked** until orphans are resolved (either by including the missing parent entities or removing the orphaned rows).

### Promotion Execution

**"Promote to Production"** button. Clicking it:

1. Uploads changed SVGs to Remote `svg` bucket (hash diff). See [pipeline.md — Phase 4.2](pipeline.md#42-svg-upload).
2. Syncs database rows in FK dependency order:
   - `radicals` (+ `radical_i18n`, `radical_variants`)
   - `kanji` (+ `kanji_i18n`, `kanji_readings`)
   - `kanji_components`
   - `vocabulary` (+ `vocabulary_i18n`, `vocabulary_readings`, `vocabulary_kanji`, `vocabulary_sentences`)
3. Rewrites `svg_file_url` from local base URL to Remote Production URL during sync.
4. Sets `data_imports.status = 'promoted'`, populates `promoted_at`.

**Log output** panel shows real-time progress: entity counts synced, SVGs uploaded, errors encountered.

**Service invoked:** `PromotionService`. See [pipeline.md — Phase 4](pipeline.md#phase-4-remote-sync-promotion).

## Content Browser

Read-only tabbed view for inspecting local production data.

| Tab | Table(s) | Key Columns Shown |
|---|---|---|
| Radicals | `radicals`, `radical_i18n` | `master_symbol`, name, `stroke_count`, `is_official`, `impact_score` |
| Kanji | `kanji`, `kanji_i18n`, `kanji_readings` | `character`, meanings, onyomi/kunyomi, `min_grade`, `min_jlpt_level`, `frequency_rank` |
| Vocabulary | `vocabulary`, `vocabulary_i18n` | `word`, meanings (EN/ES), `min_jlpt_level`, `frequency_rank` |

Each row is expandable to show related data (components, readings, sentences, variants).

**Search:** Full-text search across characters, meanings, and readings.

## Settings

| Setting | Purpose |
|---|---|
| Supabase URL (Local) | Connection to Local Supabase instance |
| Supabase URL (Remote) | Production Supabase URL for promotion |
| Service Role Key (Local) | Admin auth for local DB |
| Service Role Key (Remote) | Admin auth for remote DB |
| AI Model | Model selection for translation and heuristics |
| Auto-verify Threshold | `ai_confidence` cutoff for batch component verification (default: 0.95) |

## Admin User Journey

End-to-end flow for adding a new version of source data:

1. **Download** source archives into `sources/` (manual step, outside the app).
2. **Ingest** — Open Data Pipeline → New Import → select source file → Start Ingestion. Repeat for each source (kanjidic, kanjivg, jmdict).
3. **Transform** — Click "Run Processor" on each `ingested` import. Wait for all sub-phases to complete.
4. **Enrich** (if needed) — Open AI Enrichment panel → check gaps → run enricher for missing translations or JLPT inferences.
5. **Review Components** — Open Review: Components → work through the queue using keyboard shortcuts (`1`/`2`/`3`). Use "Auto-verify high confidence" for bulk verification.
6. **Review Sentences** — Open Review: Sentences → verify AI-translated sentences. Edit translations as needed.
7. **Promote** — Open Promotion → review the diff report → resolve any orphan warnings → click "Promote to Production". Monitor log output.
8. **Verify** — Check Dashboard for updated promotion timestamp. App clients receive new content through their standard sync mechanism (see [offline.md](offline.md)).

## Related Docs

- [pipeline.md](pipeline.md) — pipeline architecture, phases, and technical details
- [offline.md](offline.md) — client-side sync after promotion
- [supabase.md](supabase.md) — database infrastructure and storage
- [Radical entity](../entities/radical.md)
- [Kanji entity](../entities/kanji.md)
- [Kanji Component entity](../entities/kanji_component.md)
- [Vocabulary entity](../entities/vocabulary.md)
- [Data Import entity](../entities/data_import.md)
