import 'package:drift/drift.dart';

import '../../../domain/entities/raw_jmdict.dart';
import '../../../domain/repositories/raw_jmdict_repository.dart';
import '../../database/admin_database.dart';
import '../../database/mappers/admin_mappers.dart';

class DriftRawJmdictRepository implements RawJmdictRepository {
  DriftRawJmdictRepository(this._db);

  final AdminDatabase _db;

  @override
  Future<void> insertBatch(List<RawJmdict> rows) async {
    await _db.batch((b) {
      for (final row in rows) {
        b.insert(_db.rawJmdictEntries, row.toCompanion());
      }
    });
  }

  @override
  Future<List<RawJmdict>> getByImportId(int importId) async {
    final entries = await (_db.select(_db.rawJmdictEntries)
          ..where((t) => t.importId.equals(importId))
          ..orderBy([(t) => OrderingTerm.asc(t.entSeq)]))
        .get();
    return entries.map((e) => e.toDomain()).toList();
  }

  @override
  Future<RawJmdict?> getByEntSeq({
    required int importId,
    required int entSeq,
  }) async {
    final entry = await (_db.select(_db.rawJmdictEntries)
          ..where(
            (t) => t.importId.equals(importId) & t.entSeq.equals(entSeq),
          ))
        .getSingleOrNull();
    return entry?.toDomain();
  }

  @override
  Future<void> deleteByImportId(int importId) async {
    await (_db.delete(_db.rawJmdictEntries)
          ..where((t) => t.importId.equals(importId)))
        .go();
  }

  @override
  Future<int> countByImportId(int importId) async {
    final count = countAll();
    final query = _db.selectOnly(_db.rawJmdictEntries)
      ..addColumns([count])
      ..where(_db.rawJmdictEntries.importId.equals(importId));
    final result = await query.getSingle();
    return result.read(count)!;
  }
}
