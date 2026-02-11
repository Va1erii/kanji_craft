import 'package:drift/drift.dart';

import '../../../domain/entities/jmdict_furigana.dart';
import '../../../domain/repositories/jmdict_furigana_repository.dart';
import '../../database/admin_database.dart';
import '../../database/mappers/admin_mappers.dart';

class DriftJmdictFuriganaRepository implements JmdictFuriganaRepository {
  DriftJmdictFuriganaRepository(this._db);

  final AdminDatabase _db;

  @override
  Future<void> insertBatch(
    List<JmdictFurigana> rows, {
    required int importId,
  }) async {
    await _db.batch((b) {
      for (final row in rows) {
        b.insert(
          _db.jmdictFuriganaEntries,
          row.toCompanion(importId: importId),
        );
      }
    });
  }

  @override
  Future<List<JmdictFurigana>> getByImportId(int importId) async {
    final entries = await (_db.select(_db.jmdictFuriganaEntries)
          ..where((t) => t.importId.equals(importId))
          ..orderBy([
            (t) => OrderingTerm.asc(t.textField),
            (t) => OrderingTerm.asc(t.reading),
          ]))
        .get();
    return entries.map((e) => e.toDomain()).toList();
  }

  @override
  Future<JmdictFurigana?> getByTextAndReading({
    required int importId,
    required String text,
    required String reading,
  }) async {
    final entry = await (_db.select(_db.jmdictFuriganaEntries)
          ..where(
            (t) =>
                t.importId.equals(importId) &
                t.textField.equals(text) &
                t.reading.equals(reading),
          ))
        .getSingleOrNull();
    return entry?.toDomain();
  }

  @override
  Future<int> countByImportId(int importId) async {
    final c = countAll();
    final query = _db.selectOnly(_db.jmdictFuriganaEntries)
      ..addColumns([c])
      ..where(_db.jmdictFuriganaEntries.importId.equals(importId));
    final result = await query.getSingle();
    return result.read(c)!;
  }

  @override
  Future<void> deleteByImportId(int importId) async {
    await (_db.delete(_db.jmdictFuriganaEntries)
          ..where((t) => t.importId.equals(importId)))
        .go();
  }
}
