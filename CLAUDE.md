# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Kanji Craft is a Japanese kanji learning Flutter app using FSRS spaced repetition, Supabase backend, and offline-first architecture. Learning progression: Radical → Kanji → Vocabulary (each requires prior mastery at stability >= 7.0 days).

**Bundle ID:** `com.kanjicraft.app` (all platforms)

## Commands

```bash
flutter run                                    # Run the app
flutter test                                   # Run all tests
flutter test test/path/to_test.dart            # Run a single test
flutter analyze                                # Lint (uses flutter_lints)
flutter pub run build_runner build             # Code generation (Freezed)
flutter pub run build_runner watch             # Watch mode for code gen
```

Supabase CLI commands are in [docs/technical/supabase.md](docs/technical/supabase.md#commands).

## Architecture

- **Clean Architecture:** domain → data → presentation layers
- **State Management:** BLoC (`flutter_bloc`)
- **Routing:** `go_router`
- **Local DB:** Drift (SQLite) — source of truth for offline-first
- **Remote:** Supabase (PostgreSQL + Auth + Storage)
- **Code Gen:** Freezed for immutable data classes
- **SRS Engine:** `fsrs` package for spaced repetition scheduling (runs locally)

### Key Directories

- `lib/core/` — cross-cutting concerns (analytics, design_system, logging, network)
- `lib/di/` — dependency injection
- `lib/features/` — feature modules
- `lib/shared/domain/entities/` — shared domain entities
- `lib/shared/domain/repositories/` — shared repository interfaces
- `docs/entities/` — entity group specs (docs-first design)
- `docs/technical/` — infrastructure docs (supabase.md, offline.md)
- `supabase/` — config, migrations, seed data, `.env`

### Docs-First Entity Design

Entity specs in `docs/entities/` are written **before** code. They define fields, relationships, business rules, and edge cases. The `/doc-entity` skill generates these specs. Implementation must follow the spec.

### Key Docs

- [docs/technical/offline.md](docs/technical/offline.md) — offline-first sync, conflict resolution, data categories
- [docs/technical/supabase.md](docs/technical/supabase.md) — auth, database, storage, migrations, RLS
- [docs/product/monetization.md](docs/product/monetization.md) — freemium strategy, pricing, grandfathering
- [docs/guides/apple-sign-in-key-rotation.md](docs/guides/apple-sign-in-key-rotation.md) — Apple OAuth secret rotation (every 6 months)

## Conventions

- **Commits:** conventional commit format via `/commit` skill. No Co-Authored-By lines.
- **Field naming:** snake_case. FKs: `{entity}_id`. Booleans: `is_*`. Timestamps: `*_at`. Enums: snake_case values.
- **Linting:** `package:flutter_lints/flutter.yaml` (no custom overrides).
