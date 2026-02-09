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
npx supabase start
```

Note the **Publishable** key from the output.

### 3. Configure environment

```bash
cp apps/admin/.env.example apps/admin/.env
```

Edit `apps/admin/.env` and set `SUPABASE_ANON_KEY` to the Publishable key from step 2.

### 4. Run the admin app

```bash
cd apps/admin
flutter run -d macos --dart-define-from-file=.env
```

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
