# Ingestion Correctness Invariants

## Purpose & Scope

This document defines the correctness rules that the Phase 1 ingestion layer must enforce. It covers only the ingestion phase — parsing source files and inserting rows into raw staging tables (`raw_kanjivg`, `raw_kanjidic`, `raw_jmdict`).

For the full pipeline lifecycle (ingestion → transformation → verification → promotion), see [pipeline.md](pipeline.md). For entity schemas and field-level rules, see the entity docs: [data_import.md](../entities/data_import.md), [raw_kanjivg.md](../entities/raw_kanjivg.md), [raw_kanjidic.md](../entities/raw_kanjidic.md).

## Invariants

### Pre-Ingestion Guards

1. **Single active import per source.** Only one import per `ImportSource` can be in a non-terminal status (`pending`, `ingested`, `processing`, `processed`) at a time. Starting a second concurrent import for the same source must throw immediately. *(Implemented: `getActiveBySource` check in `IngestionService`.)*

2. **Version uniqueness against processed imports.** The same `(source, source_version)` pair must not be re-ingested if a `processed` import with that version already exists ([data_import.md](../entities/data_import.md) rule #2). A failed import of the same version may be retried. *(Implemented: `hasProcessedVersion` check in `IngestSourceData` use case.)*

3. **Folder validation.** The pipeline operates on folders, not individual files. Before parsing begins, the service must validate that: (a) the folder name matches the expected pattern for the source (`kanjidic-{version}/`, `jmdict-{version}/`, `kanjivg-{version}/`), (b) all required files are present (see [pipeline.md — Folder Preparation](pipeline.md#folder-preparation)), and (c) the `source_version` is extracted from the folder name. *(Partially implemented: the import dialog detects files, but `IngestionService` does not validate folder structure or required file presence.)*

### During Ingestion

4. **Import ID tagging.** Every raw row inserted must carry the `import_id` from the `DataImport` created in the pre-ingestion step. This is the sole link between raw rows and their import run.

5. **Batch insertion.** Rows are inserted in chunks of 500. Each batch call is atomic (single DB write), but the overall ingestion across all batches is **not** wrapped in a single transaction. A failure mid-way leaves partial data that must be cleaned up (see invariant #7).

6. **Progress reporting.** After each batch completes, the `onProgress` callback is invoked with `(inserted, total)` counts.

### On Failure

7. **Partial row cleanup.** If ingestion fails at any point after the `DataImport` row is created, all raw rows for that `import_id` must be deleted before the import is marked `failed`. This prevents orphaned staging data. *(Implemented: `deleteByImportId` in the catch block.)*

8. **Error capture.** The exception message must be stored in `DataImport.error_message`.

9. **Status transition.** `DataImport.status` must be set to `failed`.

10. **Failed imports do not block re-import.** The single-active-import guard (invariant #1) only blocks non-terminal statuses. A `failed` import for the same source does not prevent starting a new import.

### On Success

11. **Record count.** `DataImport.record_count` must be set to the total number of parsed entries (the full list length, not the number of batches).

12. **Status and timestamp.** `DataImport.status` must transition to `ingested` and `ingested_at` must be set.

### Post-Ingestion

13. **No automatic pruning.** Old imports accumulate in the raw tables indefinitely. Pruning is a separate admin action, not triggered by ingestion.

14. **Re-import after failure is allowed.** Same `(source, source_version)` can be re-ingested if the previous import failed.

15. **Re-import after processing is blocked.** Same `(source, source_version)` cannot be re-ingested if a `processed` import with that version exists (invariant #2).

## Source-Specific Rules

### KanjiVG

| Aspect | Value |
|---|---|
| Primary file | `kanjivg-{version}.xml.gz` |
| Secondary file | `kanjivg-{version}-main.zip` (SVG archive, used in Phase 2) |
| Raw table | `raw_kanjivg` |
| Unique constraint | `(import_id, character)` |
| Decompression | `GZipCodec` (dart:io) |

### KANJIDIC

| Aspect | Value |
|---|---|
| Primary file | `kanjidic2.xml.gz` |
| Raw table | `raw_kanjidic` |
| Unique constraint | `(import_id, literal)` |
| Decompression | `GZipCodec` (dart:io) |

### JMDict

| Aspect | Value |
|---|---|
| Primary file | `JMdict_english_with_examples.zip` |
| Primary file | `JMdict_spanish.zip` (Spanish, separate import) |
| Raw table | `raw_jmdict` |
| Unique constraint | `(import_id, ent_seq)` |

## What Is NOT Enforced (Known Gaps)

These are known limitations of the current ingestion layer, documented here so they are explicitly deferred rather than silently missing.

1. **No content diffing between imports.** Re-importing the same data creates duplicate rows under a different `import_id`. There is no mechanism to detect "nothing changed" and skip insertion.

2. ~~**No version uniqueness check against processed imports.**~~ Resolved: `IngestSourceData` use case now checks `hasProcessedVersion` before starting ingestion.

3. **No database-level constraint for single-active-import.** The one-active-import guard is app logic only (`getActiveBySource` query + throw). A race condition is theoretically possible if two ingestion runs start simultaneously for the same source. There is no DB partial unique index or advisory lock.

4. **No parsed data validation beyond DB constraints.** The ingestion layer trusts the parser output. Validation (e.g., `stroke_count > 0`, `literal` is a single codepoint) relies on database constraints, not application-level checks before insertion.

5. **No automatic pruning of old imports.** Raw rows from old imports accumulate. The admin must manually delete old imports to reclaim space.

6. ~~**No folder validation in the service layer.**~~ Resolved: `IngestSourceData` use case validates folder existence, naming pattern, and required file presence before delegating to `IngestionService`.

## Recovery Procedures

### Failed import
Rows are cleaned up automatically by `deleteByImportId` (invariant #7). The `DataImport` row remains with `status: failed` and `error_message` populated. Re-running the import for the same source and version is safe.

### Stuck import (active but not progressing)
If the app crashes or is killed mid-ingestion, the `DataImport` row stays in `pending` status with partial raw rows in the staging table. Recovery requires:
1. Manually delete raw rows for the stuck `import_id`.
2. Update the `DataImport.status` to `failed`.
3. Re-run the import.

The single-active-import guard will block new imports until the stuck one is resolved.

### Duplicate processed versions
If the same `(source, source_version)` was processed twice (possible if the DB constraint is bypassed), the admin must manually delete the older processed import and its associated raw rows. Downstream tables may also need reconciliation depending on how far the duplicate progressed.
