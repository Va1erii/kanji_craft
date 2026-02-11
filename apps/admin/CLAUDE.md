# Admin App — Context

## Data Layer Patterns

### Drift Database (`data/database/`)

- `admin_database.dart` — `@DriftDatabase` with all tables, schema version, migrations
- `tables/` — one file per Drift table definition
- `converters/` — `TypeConverter` implementations for enums and JSONB
- `mappers/admin_mappers.dart` — extension methods: `Entity.toCompanion()` and `DriftRow.toDomain()`
- `dto/` — Freezed DTOs for JSONB columns in raw tables (RawKanjiVg, RawKanjidic, RawJmdict)

**Schema versioning:** increment `schemaVersion` and add `if (from < N)` block in `onUpgrade`.

### Repositories (`data/repositories/{feature}/`)

Each feature folder contains up to 3 files:

```
data/repositories/data_import/
  drift_data_import_repository.dart       # Drift (local SQLite) implementation
  supabase_data_import_datasource.dart    # Supabase (remote Postgres) datasource
  dto/data_import_dto.dart                # Freezed DTO with fromJson/toJson/fromDomain/toDomain
```

- **Drift repos** take `AdminDatabase`, use typed Drift queries
- **Supabase datasources** take `SupabaseClient`, return domain entities via DTO mapping
- **DTOs** use `@JsonKey(name: 'snake_case')` for Supabase JSON mapping

Not all features have all three files. Local-only features (raw repos, source_jlpt_level) have only a Drift repo.

### Services (`data/services/`)

- Parsers: `KanjidicParser`, `KanjiVgParser`, `JmdictParser`, `JlptMappingParser` — static `parse()` methods taking `String` input
- `SupabaseAdminStateReader` / `SupabaseAdminStateWriter` — hydration sync with Remote admin schema

## Presentation Layer Patterns

### Feature-scoped (`presentation/{feature}/`)

```
presentation/data_import/
  bloc/data_import_bloc.dart              # BLoC
  bloc/data_import_event.dart             # Freezed events
  bloc/data_import_state.dart             # Freezed state
  pages/data_pipeline_page.dart           # Full page
  widgets/imports_table.dart              # Feature widgets
  widgets/new_import_dialog.dart
  widgets/status_badge.dart
```

### Common (`presentation/common/`)

- `widgets/admin_shell.dart` — navigation shell with sidebar
- `pages/dashboard_page.dart`, `pages/placeholder_page.dart`

## DI Registration (`di/injection.dart`)

```dart
// Singletons: DB, repos, datasources
getIt.registerLazySingleton<AdminDatabase>(() => AdminDatabase());
getIt.registerLazySingleton<DataImportRepository>(() => DriftDataImportRepository(getIt<AdminDatabase>()));

// Factories: BLoCs (new instance per widget)
getIt.registerFactory<DataImportBloc>(() => DataImportBloc(...));
```

## Domain Layer

- `domain/entities/` — admin-only Freezed entities and enums (DataImport, ImportSource, ImportStatus, raw entities)
- `domain/repositories/` — abstract repository interfaces
- `domain/use_cases/` — use case classes (single responsibility)

Shared entities live in `packages/core/lib/domain/entities/` (Kanji, Radical, Vocabulary, enums).

## Asset Loading

`assets/jlpt_mapping.csv` is a mandatory bundled asset. Loaded on first run via `rootBundle.loadString()` in `main.dart` before `runApp()`. If missing or malformed, the app crashes intentionally.

## Testing

Tests in `test/` mirror `lib/` structure. Key helpers:

- `test/helpers/admin_test_helpers.dart` — in-memory `AdminDatabase.forTesting()`, mock factories
- Parser tests: provide XML/CSV strings, assert parsed entities
- Repository tests: use in-memory Drift DB, no mocks
