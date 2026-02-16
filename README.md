# Kanji Craft

Japanese kanji learning app using FSRS spaced repetition, Supabase backend, and offline-first architecture.

## Workspace Structure

Dart native workspace with 2 packages:

- `packages/core` — shared domain entities and design system
- `apps/client` — Flutter mobile/web/desktop app for learners
- `pipeline/` — Python content pipeline (Parquet → CSV → AI enrichment → release bundles → Supabase)

## Prerequisites

- Flutter SDK ^3.10
- Python 3.13+ (for pipeline)
- [uv](https://docs.astral.sh/uv/) (Python package manager)
- [Supabase CLI](https://supabase.com/docs/guides/cli)

## Getting Started

### 1. Install dependencies

```bash
dart pub get
```

### 2. Start local Supabase

```bash
supabase start
```

### 3. Run the client app

```bash
cd apps/client
flutter run
```

## Code Generation

```bash
# Core (Freezed)
cd packages/core && dart run build_runner build --delete-conflicting-outputs
```

## Content Pipeline

The pipeline transforms raw dictionary data into structured learning content. Run from `pipeline/`:

```bash
cd pipeline
uv sync                                # Install dependencies (first time)
uv run python -m src.ingest            # Phase 1: sources → Parquet
uv run python -m src.extract           # Phase 2: Parquet → CSV
uv run python -m src.enrich            # Phase 3: AI enrichment
```

### Release Bundles (Phase 4)

Slice enriched CSVs into reviewable batches, validate completeness, then push to Supabase:

```bash
cd pipeline
uv run python -m src.release slice n5_kanji_1 --jlpt 5 --kanji 30 --vocab 60
# → Edit CSVs in data/releases/n5_kanji_1/ (fill mnemonics, furigana, translations)
uv run python -m src.release validate n5_kanji_1
uv run python -m src.release push n5_kanji_1
```

See [ph4_release_bundles.md](docs/pipeline/ph4_release_bundles.md) for the full workflow.

Source data goes in `sources/` (see [pipeline.md](docs/pipeline/pipeline.md) for folder naming). Generated artifacts live in `pipeline/data/` (gitignored).

## Linting

```bash
cd apps/client && flutter analyze
cd packages/core && dart analyze
cd pipeline && uv run ruff check src/  # Python pipeline
```
