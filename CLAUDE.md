# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Kanji Craft is a Japanese kanji learning Flutter app using FSRS spaced repetition, Supabase backend, and offline-first architecture. Learning progression: Radical → Kanji → Vocabulary (each requires prior mastery at stability >= 7.0 days).

**Bundle ID:** `com.kanjicraft.app` (all platforms)

## Workspace Structure

Dart native workspace with 2 packages:

- `packages/core` — `kanji_craft_core`: pure Dart package with shared domain entities
- `apps/client` — `kanji_craft_client`: Flutter mobile/web/desktop app for learners

## Commands

```bash
# Client app
cd apps/client && flutter run                   # Run client app
cd apps/client && flutter analyze               # Lint client

# Core package
cd packages/core && dart analyze                # Lint core

# Code generation
cd packages/core && dart run build_runner build --delete-conflicting-outputs   # Freezed (core)

# Workspace-wide
dart pub get                                    # Resolve all packages from root
```

## Architecture

- **Clean Architecture:** domain → data → presentation layers
- **State Management:** BLoC (`flutter_bloc`)
- **Routing:** `go_router`
- **DI:** `get_it` (singleton DB/repos, factory BLoCs) in each app's `lib/di/injection.dart`
- **Local DB:** Drift (SQLite) — source of truth for offline-first
- **Remote:** Supabase (PostgreSQL + Auth + Storage)
- **Code Gen:** Freezed for immutable data classes, Drift for SQLite, json_serializable for DTOs
- **SRS Engine:** `fsrs` package for spaced repetition scheduling (runs locally)
- **Content Pipeline:** Python scripts (`pipeline/`) — Parquet ingestion → CSV extraction → AI enrichment → Supabase upload

## Key Directories

```
packages/core/lib/domain/entities/     # Shared enums + Freezed entities
apps/client/lib/                       # Client app (scaffold)
docs/                                  # See Documentation Map below
pipeline/                              # Python pipeline (src/, data/)
supabase/                              # Supabase config (config.toml)
```

## Documentation Map

Read specific docs only when relevant to the task. Do not load all docs at once.

### Domain Specs (`docs/domain/`) — read when implementing or modifying entities

| Doc | Covers | Key decisions |
|---|---|---|
| `radical.md` | Radical, RadicalI18n, RadicalVariant, Position enum | master_symbol is canonical identity; variants are shapes at positions |
| `kanji.md` | Kanji, KanjiReading, KanjiI18n | frequency_rank always populated (synthetic for unranked) |
| `kanji_component.md` | KanjiComponent, LogicHint, RadicalType | logic_hint is per-kanji-radical pair, not global; is_primary is generated from radical_type |
| `vocabulary.md` | Vocabulary, VocabularyReading/I18n/Kanji/Sentence | furigana uses `{kanji\|reading}` per-character notation |
| `srs.md` | SrsCard, ReviewLog, Rating, CardState | FSRS algorithm; difficulty 0 = new, 1-10 after first review |
| `user.md` | User, UserSettings, StudyPath, AuthProvider | users.id is UUID referencing auth.users |
| `mnemonic.md` | UserMnemonic | Polymorphic: item_type + item_id |
| `shared_types.md` | ItemType, ReadingType, ReadingPriority, PosTag | Shared across entity groups |
| `teaching.md` | Teaching strategy, phono-semantic patterns, SRS card types | Color coding, sound match indicators, question formats |

### Pipeline Docs (`docs/pipeline/`) — read when implementing pipeline

| Doc | Covers | When to read |
|---|---|---|
| `pipeline.md` | Full pipeline: Python + Parquet ingestion → CSV extraction → AI enrichment → Supabase upload | Understanding overall data flow |
| `ph1_ingestion.md` | Phase 1 correctness invariants | Implementing/fixing parsers or import logic |
| `ph2_1_radical_extraction.md` | Passes 1-2: radical/variant registration | Implementing radical scanning from KanjiVG |
| `ph2_2_kanji_composition.md` | Steps 1-3: kanji row creation from KANJIDIC | Implementing kanji/reading/i18n creation |
| `ph2_3_component_linking.md` | Steps 4-5: kanji↔radical linking + metadata | Implementing component linking or radical metadata |
| `ph2_4_svg_processing.md` | Phase 2.4: SVG file matching, SHA-256 hashing, URL construction | Implementing SVG processing or delta sync |
| `ph2_5_vocabulary_extraction.md` | Phase 2.5: JMdict → vocabulary tables, segmentation, JLPT strategy | Implementing vocabulary extraction or Ghost Kanji segments |
| `ph3_ai_enrichment.md` | Phase 3: logic hints, mnemonics (Lego Stack), sentence furigana, translations | Implementing AI enrichment or mnemonic generation |

### ADR Docs (`docs/adr/`) — read when implementing infrastructure

| Doc | Covers | When to read |
|---|---|---|
| `supabase.md` | Auth, database, storage, RLS, migrations | Any Supabase/migration work |
| `offline.md` | Client sync, conflict resolution | Client-side data sync |

### Source Format Docs (`docs/sources/`) — read when modifying parsers

| Doc | Covers |
|---|---|
| `kanjivg_format.md` | KanjiVG SVG namespace, position values, radical markers |
| `kanjidic_format.md` | KANJIDIC2 XML structure, grade/JLPT values |
| `jmdict_format.md` | JMdict XML structure, sense inheritance |
| `jlpt_mapping_format.md` | JLPT kanji mapping CSV format |
| `jlpt_vocab_mapping_format.md` | JLPT vocabulary mapping CSV format (Tanos word lists) |
| `jmdict_furigana_format.md` | JmdictFurigana JSON format (per-character furigana mappings) |

## Database Schema Digest

**17 tables:** 12 content + 5 user. Schema defined in `docs/domain/` entity specs.

**Content tables:** `radicals`, `radical_i18n`, `radical_variants`, `kanji`, `kanji_readings`, `kanji_i18n`, `kanji_components`, `vocabulary`, `vocabulary_readings`, `vocabulary_i18n`, `vocabulary_kanji`, `vocabulary_sentences`, `vocabulary_sentence_i18n`

**User tables:** `users`, `user_settings`, `srs_cards`, `review_logs`, `user_mnemonics`

**11 enums:** `position_type`, `item_type`, `reading_priority`, `reading_type`, `pos_tag`, `logic_hint`, `radical_type`, `card_state`, `rating`, `auth_provider`, `study_path`

**Key constraints:**
- `kanji_components` unique on `(kanji_id, radical_id, position)`
- `srs_cards` unique on `(user_id, item_type, item_id)` — polymorphic FK, no DB FK on item_id
- `review_logs` is append-only (no UPDATE/DELETE RLS)
- `is_primary` on `kanji_components` is a generated column: `radical_type = 'general'`
- `users.id` is UUID referencing `auth.users(id)`

## Key Architectural Decisions

1. **Docs-first design:** Domain specs in `docs/domain/` are written before code. Implementation must follow the spec. The `/doc-entity` skill generates these specs.
2. **Progressive decomposition:** Each kanji records only direct child radicals (one level deep). Multi-level learning chains emerge from the dataset.
3. **Polymorphic FKs:** `srs_cards` and `user_mnemonics` use `item_type` + `item_id` — no DB FK on `item_id`.
4. **Content tables are complete:** All fields NOT NULL — they hold ready-to-sync rows only.
5. **Comparison-based sync:** No `last_synced_at` column. Sync queries Remote at push time and diffs against local state.
6. **Pipeline uploads via service_role key:** Bypasses RLS for content table operations.

## Conventions

- **Commits:** conventional commit format via `/commit` skill. No Co-Authored-By lines.
- **Field naming:** snake_case. FKs: `{entity}_id`. Booleans: `is_*`. Timestamps: `*_at`. Enums: snake_case values.
- **Linting:** `package:flutter_lints/flutter.yaml` (no custom overrides).
- **Constraint naming:** `chk_`, `uq_`, `fk_` prefixes. Triggers: `trg_{table}_updated_at`. Indexes: `idx_{table}_{column(s)}`.
- **DI pattern:** singleton for DB/repos, factory for BLoCs. Registration in `lib/di/injection.dart`.
