import 'package:drift/drift.dart';

import '../../domain/entities/data_import.dart';
import '../../domain/entities/import_source.dart';
import '../../domain/entities/import_status.dart';
import '../../domain/repositories/data_import_repository.dart';
import '../local/admin_database.dart';
import '../local/mappers/admin_mappers.dart';

class DriftDataImportRepository implements DataImportRepository {
  DriftDataImportRepository(this._db);

  final AdminDatabase _db;

  @override
  Future<DataImport> create({
    required ImportSource source,
    required String sourceVersion,
    Map<String, Object?>? metadata,
  }) async {
    final now = DateTime.now().toUtc();
    final id = await _db.into(_db.dataImportEntries).insert(
          DataImportEntriesCompanion.insert(
            source: source,
            sourceVersion: sourceVersion,
            metadata: metadata != null ? Value(metadata) : const Value.absent(),
            startedAt: now,
            createdAt: now,
            updatedAt: now,
          ),
        );
    final entry = await (_db.select(_db.dataImportEntries)
          ..where((t) => t.id.equals(id)))
        .getSingle();
    return entry.toDomain();
  }

  @override
  Future<DataImport?> getById(int id) async {
    final entry = await (_db.select(_db.dataImportEntries)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return entry?.toDomain();
  }

  @override
  Future<DataImport?> getActiveBySource(ImportSource source) async {
    final entry = await (_db.select(_db.dataImportEntries)
          ..where(
            (t) =>
                t.source.equalsValue(source) &
                t.status.isNotInValues([ImportStatus.processed, ImportStatus.failed]),
          ))
        .getSingleOrNull();
    return entry?.toDomain();
  }

  @override
  Future<DataImport> updateStatus({
    required int id,
    required ImportStatus status,
    int? recordCount,
    String? errorMessage,
    Map<String, Object?>? metadata,
  }) async {
    final now = DateTime.now().toUtc();

    final companion = DataImportEntriesCompanion(
      status: Value(status),
      recordCount: recordCount != null ? Value(recordCount) : const Value.absent(),
      errorMessage: errorMessage != null ? Value(errorMessage) : const Value.absent(),
      metadata: metadata != null ? Value(metadata) : const Value.absent(),
      updatedAt: Value(now),
      ingestedAt: status == ImportStatus.ingested ? Value(now) : const Value.absent(),
      processedAt: status == ImportStatus.processed ? Value(now) : const Value.absent(),
    );

    await (_db.update(_db.dataImportEntries)..where((t) => t.id.equals(id)))
        .write(companion);

    return (await (_db.select(_db.dataImportEntries)
              ..where((t) => t.id.equals(id)))
            .getSingle())
        .toDomain();
  }

  @override
  Future<bool> hasProcessedVersion({
    required ImportSource source,
    required String sourceVersion,
  }) async {
    final query = _db.select(_db.dataImportEntries)
      ..where(
        (t) =>
            t.source.equalsValue(source) &
            t.sourceVersion.equals(sourceVersion) &
            t.status.equalsValue(ImportStatus.processed),
      )
      ..limit(1);
    final result = await query.getSingleOrNull();
    return result != null;
  }

  @override
  Future<List<DataImport>> listAll() async {
    final entries = await (_db.select(_db.dataImportEntries)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
    return entries.map((e) => e.toDomain()).toList();
  }

  Future<void> upsertAll(List<DataImport> imports) async {
    await _db.batch((b) {
      for (final item in imports) {
        b.insert(
          _db.dataImportEntries,
          item.toEntry(),
          onConflict: DoUpdate(
            (old) => item.toEntry().toCompanion(false),
          ),
        );
      }
    });
  }
}
