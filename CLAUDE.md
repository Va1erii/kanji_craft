# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Kanji Craft is a Japanese kanji learning Flutter app using FSRS spaced repetition, Supabase backend, and offline-first architecture. Learning progression: Radical → Kanji → Vocabulary (each requires prior mastery at stability >= 7.0 days).

**Bundle ID:** `com.kanjicraft.app` (all platforms)

## Commands

```bash
# Flutter
flutter run                                    # Run the app
flutter test                                   # Run all tests
flutter test test/path/to_test.dart            # Run a single test
flutter analyze                                # Lint (uses flutter_lints)
flutter pub run build_runner build             # Code generation (Freezed)
flutter pub run build_runner watch             # Watch mode for code gen

# Supabase (local dev)
supabase start                                 # Start local Supabase
supabase stop                                  # Stop local Supabase
supabase db reset                              # Reset DB (apply migrations + seed)
supabase migration new <name>                  # Create a new migration
supabase db push                               # Push migrations to remote
```

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

### Offline-First Sync

- **Content tables** (radicals, kanji, vocabulary): one-directional sync (remote → local). Admin-managed, never user-modified. Incremental pull via `updated_at > last_content_sync_at`.
- **User tables** (srs_cards, user_mnemonics): bidirectional sync using `SyncStatus` enum (`synced`, `pending_push`, `pending_delete`). Conflict resolution: last-write-wins.
- **SVG assets:** local-first resolution (bundled → cache → remote download → text fallback). Cache invalidation via `svg_hash` field per entity.

### Auth

Apple + Google OAuth via Supabase Auth. Apple client secret expires every 6 months — see `docs/guides/apple-sign-in-key-rotation.md`. Script: `scripts/apple_client_secret.sh`.

## Conventions

- **Commits:** conventional commit format via `/commit` skill. Types: feat, fix, docs, style, refactor, perf, test, build, ci, chore. No Co-Authored-By lines.
- **Field naming:** snake_case. FKs: `{entity}_id`. Booleans: `is_*`. Timestamps: `*_at`. Enums: snake_case values.
- **Linting:** `package:flutter_lints/flutter.yaml` (no custom overrides).

## Monetization (MVP)

Free tier only during validation. N5 (JLPT path) and Grade 1 (grade path) are free. N4–N1 and Grades 2–6 require paid plan post-validation. Early users grandfathered via `User.created_at`.
