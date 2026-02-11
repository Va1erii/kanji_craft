# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Kanji Craft is a Japanese kanji learning Flutter app using FSRS spaced repetition, Supabase backend, and offline-first architecture. Learning progression: Radical → Kanji → Vocabulary (each requires prior mastery at stability >= 7.0 days).

**Bundle ID:** `com.kanjicraft.app` (all platforms)

## Workspace Structure

Dart native workspace with 3 packages:

- `packages/core` — `kanji_craft_core`: pure Dart package with shared domain entities
- `apps/admin` — `kanji_craft_admin`: Flutter desktop app for data ingestion and review
- `apps/client` — `kanji_craft_client`: Flutter mobile/web/desktop app for learners

## Commands

```bash
# Admin app
cd apps/admin && flutter run -d macos          # Run admin app
cd apps/admin && flutter test                   # Run admin tests
cd apps/admin && flutter analyze                # Lint admin

# Client app
cd apps/client && flutter run                   # Run client app
cd apps/client && flutter analyze               # Lint client

# Core package
cd packages/core && dart analyze                # Lint core

# Code generation
cd packages/core && dart run build_runner build --delete-conflicting-outputs   # Freezed (core)
cd apps/admin && flutter pub run build_runner build --delete-conflicting-outputs  # Freezed + Drift (admin)

# Workspace-wide
dart pub get                                    # Resolve all packages from root
```

Supabase CLI commands are in [docs/technical/supabase.md](docs/technical/supabase.md#commands).

## Architecture

- **Clean Architecture:** domain → data → presentation layers
- **State Management:** BLoC (`flutter_bloc`)
- **Routing:** `go_router`
- **DI:** `get_it` (singleton DB/repos, factory BLoCs)
- **Local DB:** Drift (SQLite) — source of truth for offline-first
- **Remote:** Supabase (PostgreSQL + Auth + Storage)
- **Code Gen:** Freezed for immutable data classes
- **SRS Engine:** `fsrs` package for spaced repetition scheduling (runs locally)

### Key Directories

- `packages/core/lib/domain/entities/` — shared domain entities and enums
- `apps/admin/lib/domain/` — admin-only entities, repository interfaces, use cases
- `apps/admin/lib/data/database/` — Drift DB, tables, mappers, converters, raw DTOs
- `apps/admin/lib/data/repositories/{feature}/` — feature-scoped: Drift repo + Supabase datasource + DTO
- `apps/admin/lib/data/services/` — parsers, admin state reader/writer
- `apps/admin/lib/presentation/{feature}/` — feature-scoped: BLoC + pages + widgets
- `apps/admin/lib/presentation/common/` — shared widgets (admin_shell) and pages (dashboard, placeholder)
- `apps/admin/lib/di/` — get_it dependency injection
- `apps/client/lib/` — client app (scaffold)
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
