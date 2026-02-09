import 'package:drift/drift.dart';

import '../../domain/entities/raw_kanjivg.dart';
import '../../domain/repositories/raw_kanjivg_repository.dart';
import '../local/admin_database.dart';
import '../local/mappers/admin_mappers.dart';

class DriftRawKanjiVgRepository implements RawKanjiVgRepository {
  DriftRawKanjiVgRepository(this._db);

  final AdminDatabase _db;

  @override
  Future<void> insertBatch(List<RawKanjiVg> rows) async {
    await _db.batch((b) {
      for (final row in rows) {
        b.insert(_db.rawKanjiVgEntries, row.toEntry());
      }
    });
  }

  @override
  Future<List<RawKanjiVg>> getByImportId(int importId) async {
    final entries = await (_db.select(_db.rawKanjiVgEntries)
          ..where((t) => t.importId.equals(importId))
          ..orderBy([(t) => OrderingTerm.asc(t.character)]))
        .get();
    return entries.map((e) => e.toDomain()).toList();
  }

  @override
  Future<RawKanjiVg?> getByCharacter({
    required int importId,
    required String character,
  }) async {
    final entry = await (_db.select(_db.rawKanjiVgEntries)
          ..where(
            (t) =>
                t.importId.equals(importId) & t.character.equals(character),
          ))
        .getSingleOrNull();
    return entry?.toDomain();
  }

  @override
  Future<int> countByImportId(int importId) async {
    final count = countAll();
    final query = _db.selectOnly(_db.rawKanjiVgEntries)
      ..addColumns([count])
      ..where(_db.rawKanjiVgEntries.importId.equals(importId));
    final result = await query.getSingle();
    return result.read(count)!;
  }

  @override
  Future<void> deleteByImportId(int importId) async {
    await (_db.delete(_db.rawKanjiVgEntries)
          ..where((t) => t.importId.equals(importId)))
        .go();
  }

  Future<void> upsertAll(List<RawKanjiVg> rows) async {
    await _db.batch((b) {
      for (final row in rows) {
        b.insert(
          _db.rawKanjiVgEntries,
          row.toEntry(),
          onConflict: DoUpdate(
            (old) => row.toEntry().toCompanion(false),
          ),
        );
      }
    });
  }
}
