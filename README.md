# Kanji Craft

Japanese kanji learning app using FSRS spaced repetition, Supabase backend, and offline-first architecture.

## Workspace Structure

Dart native workspace with 2 packages:

- `packages/core` — shared domain entities and design system
- `apps/client` — Flutter mobile/web/desktop app for learners
- `pipeline/` — Python content pipeline (Parquet ingestion → CSV extraction → AI enrichment → Supabase upload)

## Prerequisites

- Flutter SDK ^3.10
- Python 3.11+ (for pipeline)
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

## Linting

```bash
cd apps/client && flutter analyze
cd packages/core && dart analyze
```
