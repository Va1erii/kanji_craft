# Supabase

## Overview

Supabase is the backend-as-a-service for the app, providing three core services: authentication, PostgreSQL database, and file storage. The app follows an offline-first architecture — Drift (SQLite) is the local source of truth, and Supabase is the remote sync target. Users can study without internet; data syncs when connectivity is available.

## Services Used

| Service | Purpose |
|---|---|
| **Supabase Auth** | User sign-in via email/password, Google, Apple, Facebook |
| **Supabase Database** | PostgreSQL for all entity tables. Remote source of truth for sync |
| **Supabase Storage** | SVG files for radicals, kanji, and their variants |

## Authentication

### Providers

| Provider | Config |
|---|---|
| Email/Password | Built-in Supabase email auth. Email confirmation enabled |
| Google | OAuth via Supabase, requires Google Cloud Console setup |
| Apple | OAuth via Supabase, requires Apple Developer account |
| Facebook | OAuth via Supabase, requires Meta Developer app |

### Auth Flow

1. User signs in via Supabase Auth (any provider)
2. Supabase returns a JWT with the user's `auth.uid()`
3. App creates/updates the local `User` record (see user.md) mapping `auth_provider_id` to the Supabase UID
4. JWT is attached to all subsequent Supabase API calls
5. RLS policies use `auth.uid()` to scope data access

### Token Handling

- Supabase client handles token refresh automatically
- On token expiry, the SDK refreshes silently using the stored refresh token
- If refresh fails (e.g. account deleted), redirect to sign-in screen

## Database

### Naming Convention

Every entity in `docs/entities/` maps to a Supabase Postgres table. Table names use `snake_case`, plural form (e.g. `UserSettings` → `user_settings`, `Radical` → `radicals`).

### Data Categories

Tables fall into two categories with different sync and access patterns:

**Content tables (read-only for users):**
- `radicals`, `radical_i18n`, `radical_variants`
- `kanji`, `kanji_readings`, `kanji_i18n`, `kanji_components`
- `vocabulary`, `vocabulary_readings`, `vocabulary_i18n`, `vocabulary_kanji`, `vocabulary_sentences`

These are populated by the content pipeline (admin-only). Users read but never write. Pre-seeded on first app install via bundled SQLite or initial sync.

**User tables (read-write, per-user):**
- `users`, `user_settings`
- `srs_cards`, `review_logs`
- `user_mnemonics`

These contain personal data scoped by `user_id`. Synced bidirectionally between local Drift DB and Supabase.

## Row Level Security (RLS)

RLS is enabled on all user tables from day one. Content tables are readable by all authenticated users.

### Access Patterns

| Table Category | SELECT | INSERT | UPDATE | DELETE |
|---|---|---|---|---|
| Content tables | All authenticated | Admin only | Admin only | Admin only |
| User tables | Own rows only (`user_id = auth.uid()`) | Own rows only | Own rows only | Own rows only |
| Staging/admin tables | service_role only | service_role only | service_role only | service_role only |

**Staging/admin tables** (`data_imports`, `raw_kanjivg`, `raw_kanjidic`, `kanji_component_reviews`) have RLS enabled with zero policies. This means only the `service_role` key (which bypasses RLS) can access them. The admin app uses the service_role key for this reason.

Policies are defined in `supabase/migrations/`.

## Storage

### Bucket Structure

| Bucket | Purpose | Access |
|---|---|---|
| `svg` | SVG files for radicals, kanji, and variants | Public read (no auth needed for assets) |

### File Naming

SVG files use the Unicode code point as filename (lowercase hex), matching the `svg_file_name` field on entities:
- Radical 水 (U+6C34) → `svg/06c34.svg`
- Kanji 日 (U+65E5) → `svg/065e5.svg`

### Resolution Strategy

The app uses a local-first strategy for SVG loading (see radical.md):

1. Check bundled assets (`assets/svg/{svg_file_name}`)
2. Check device cache
3. Download from `svg_file_url` (Supabase Storage public URL) and cache locally
4. If all fail, render the unicode character as text fallback

### Cache Invalidation

Each entity with an SVG carries an `svg_hash` field (see radical.md, kanji.md). During content sync, if a row's `svg_hash` has changed, the app invalidates only that file's local cache and re-downloads it. This avoids bulk re-fetching when a single SVG is fixed.

## Migrations

### Project Structure

Schema is managed via the Supabase CLI using timestamped migration files. All SQL lives in version control.

```
supabase/
  migrations/
    20260207000000_initial_schema.sql     # tables, indexes, constraints
    20260207000001_rls_policies.sql       # RLS policies (separate for clarity)
    20260207000002_storage_buckets.sql    # storage bucket setup
  seed.sql                                # initial content data (radicals, kanji, vocabulary)
```

### Migration Files

Each migration is a single SQL file that runs once, in order. Never edit a migration after it's been applied — create a new one instead.

| File | Contents |
|---|---|
| `initial_schema.sql` | All `CREATE TABLE` statements, foreign keys, unique constraints, indexes |
| `rls_policies.sql` | `ALTER TABLE ... ENABLE ROW LEVEL SECURITY` + all `CREATE POLICY` statements |
| `storage_buckets.sql` | `INSERT INTO storage.buckets` + storage policies for public SVG access |

### Seed Data

`seed.sql` populates content tables with the initial dataset: radicals, kanji, vocabulary, readings, I18n translations, components, and sentences. This file is large and generated by the content pipeline, not written by hand.

Seed data is **content only** — never seed user tables (users, srs_cards, user_settings, etc.).

### Commands

```bash
# Start local Supabase (runs migrations automatically)
supabase start

# Apply migrations to local DB
supabase db reset

# Create a new migration
supabase migration new <name>

# Push migrations to remote project
supabase db push

# Seed the database (after migrations)
supabase db reset   # runs migrations + seed.sql
```

### Rules

1. One concern per migration file — don't mix schema and RLS in the same file.
2. Never modify an applied migration. Create a new migration for changes.
3. Migration filenames use the format `YYYYMMDDHHMMSS_description.sql`.
4. `seed.sql` must be idempotent — use `INSERT ... ON CONFLICT DO NOTHING` or `TRUNCATE` + `INSERT`.
5. Test migrations locally with `supabase db reset` before pushing to remote.

## Offline-First Architecture

See [offline.md](offline.md) for the full offline-first strategy, sync management, and conflict resolution.
