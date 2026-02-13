# Kanji Craft

Japanese kanji learning app using FSRS spaced repetition, Supabase backend, and offline-first architecture.

## Workspace Structure

Dart native workspace with 3 packages:

- `packages/core` — shared domain entities and design system
- `apps/admin` — Flutter desktop app for data ingestion and review
- `apps/client` — Flutter mobile/web/desktop app for learners

## Prerequisites

- Flutter SDK ^3.10
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

Note the **Secret** key from the output.

### 3. Configure environment

```bash
cp apps/admin/.env.example apps/admin/.env
```

Edit `apps/admin/.env` and set `SUPABASE_SERVICE_ROLE_KEY` to the Secret key from step 2.

### 4. Run the admin app

```bash
cd apps/admin
flutter run -d macos --dart-define-from-file=.env
```

## Database Migrations

Schema changes flow **local → remote** only. Never edit schema on the remote dashboard.

```bash
supabase migration new <name>     # Create migration file
# Write SQL in the generated file
supabase db reset                  # Test locally
supabase db push                   # Push to remote
```

See [docs/adr/supabase.md](docs/adr/supabase.md#workflow) for the full workflow.

## Code Generation

```bash
# Core (Freezed)
cd packages/core && dart run build_runner build --delete-conflicting-outputs

# Admin (Freezed + Drift)
cd apps/admin && flutter pub run build_runner build --delete-conflicting-outputs
```

## Testing

```bash
cd apps/admin && flutter test
```

## Linting

```bash
cd apps/admin && flutter analyze
cd packages/core && dart analyze
```
