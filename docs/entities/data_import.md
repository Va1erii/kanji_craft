# Data Import

## Overview

Tracks each execution of the content pipeline (see [pipeline.md](../technical/pipeline.md)). Every time raw source data (KanjiVG, KANJIDIC2, or JMdict) enters the pipeline, a `DataImport` row is created to track it through three phases: ingestion, transformation, and verification. Rows in `raw_kanjivg` and `raw_kanjidic` reference this table via `import_id`, enabling version-aware diffing and rollback — old import rows are preserved alongside new ones.

Promotion to production happens at the **item level** (per kanji, radical, vocabulary), not at the import level. Once an import reaches `processed`, individual items are reviewed and promoted independently.

This is an **admin-only table** — not used by the client app. This table lives in the **Remote `admin` schema** (Postgres) as the authoritative source of truth, surviving device loss. The Admin Tool pulls import history from Remote on hydration (see [pipeline.md](../technical/pipeline.md) Hydration section) and writes new imports back. Access is restricted to the `service_role` key (which bypasses RLS).

## Entities

### ImportSource (Enum)

Identifies which external dataset an import run targets.

| Value | Description |
|---|---|
| `kanjivg` | KanjiVG stroke and component data |
| `kanjidic` | KANJIDIC2 dictionary data |
| `jmdict` | JMdict vocabulary and sentence data |

### ImportStatus (Enum)

Tracks the lifecycle of a pipeline run (see [pipeline.md](../technical/pipeline.md)).

| Value | Description |
|---|---|
| `pending` | Import created, parsing not yet started |
| `ingested` | Raw data successfully inserted into staging tables |
| `processing` | Transformation to production tables is running |
| `processed` | Transformation complete, items available for per-item review and promotion |
| `failed` | Pipeline terminated with errors (can occur at any phase) |

### DataImport (Entity)

One row per pipeline execution. Created at the start of an import, updated on completion or failure.

| Field | Type | Description |
|---|---|---|
| `id` | `int` | Unique identifier. Referenced as `import_id` by `raw_kanjivg` and `raw_kanjidic` |
| `source` | `ImportSource` | Which dataset this import targets |
| `source_version` | `String` | Release version of the source data, e.g. "2024-04-01" (KanjiVG) or "2024-363" (KANJIDIC2) |
| `status` | `ImportStatus` | Current state of the import run |
| `record_count` | `int?` | Number of rows written to the raw table. Set when `ingested` |
| `started_at` | `DateTime` | When the pipeline run began |
| `ingested_at` | `DateTime?` | When raw data insertion completed. Null until `ingested` |
| `processed_at` | `DateTime?` | When transformation to production tables completed. Null until `processed` |
| `error_message` | `String?` | Error details if `status` is `failed`. Null otherwise |
| `metadata` | `JsonObject?` | Optional context: file hash, download URL, notes. Null if none |
| `created_at` | `DateTime` | Row creation timestamp (auto-set) |
| `updated_at` | `DateTime` | Last modification timestamp (auto-set) |

**Why a dedicated table instead of just `source_version` on each raw row?**

`source_version` alone tells you *what* version the data came from, but not *when* it was imported, whether it succeeded, or how many records it produced. `DataImport` gives the pipeline run its own identity — you can query "show me all imports for kanjivg", diff two imports, or roll back a failed run by deleting its `import_id` from the raw table.

**Why `metadata` as JSONB?**

Import context varies: a KanjiVG import might store the source archive hash and download URL, while a KANJIDIC2 import might store the XML file date and DTD version. JSONB keeps this flexible without adding columns for every possible field.

## Relationships

```
DataImport ──1:N──→ RawKanjiVg      (one import, many raw rows; see raw_kanjivg.md)
DataImport ──1:N──→ RawKanjidic     (one import, many raw rows; see raw_kanjidic.md)
```

A `DataImport` row with `source: kanjivg` only has children in `raw_kanjivg`; one with `source: kanjidic` only has children in `raw_kanjidic`. The FK is not polymorphic — both raw tables have their own `import_id` column pointing here.

## Business Rules

1. Only one import per `source` can be active (not `processed` or `failed`) at a time. Attempting to start a second concurrent pipeline for the same source must fail.
2. `source_version` + `source` should be unique across `processed` imports — don't re-import the same version twice. A failed import of the same version can be retried.
3. **Status transitions are one-way:** `pending` → `ingested` → `processing` → `processed`. Any state can transition to `failed`. A failed or processed import cannot be reopened.
4. `record_count` must be set when `status` transitions to `ingested`.
5. Each phase sets its corresponding timestamp: `ingested_at`, `processed_at`.
6. Deleting a `DataImport` row must cascade-delete all associated raw rows (`raw_kanjivg` or `raw_kanjidic` rows with that `import_id`). This is the rollback mechanism.
7. **RLS:** RLS is enabled with zero policies for `authenticated` or `anon` roles. Only `service_role` (which bypasses RLS) can read or write this table.

## Edge Cases

- **Failure at any phase:** The pipeline can fail during ingestion (parse error) or processing (transformation bug). The `failed` status plus `error_message` captures where and why. Cleanup of partial data is a manual admin action via cascade-delete.
- **Same version, different content:** Source projects occasionally publish corrections under the same version string. Business rule #2 prevents accidental re-import, but an admin can delete the old processed import and re-run.
- **Concurrent imports for different sources:** Allowed — a KanjiVG import and a KANJIDIC2 import can run simultaneously. The constraint is per-source.
- **Old imports accumulating:** Over time, many import versions may pile up in the raw tables. Admin tooling should provide a "prune old imports" action that keeps the N most recent processed imports per source and cascade-deletes the rest.
