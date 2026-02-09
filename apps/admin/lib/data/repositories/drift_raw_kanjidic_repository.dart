import 'package:drift/drift.dart';

import '../../domain/entities/raw_kanjidic.dart';
import '../../domain/repositories/raw_kanjidic_repository.dart';
import '../local/admin_database.dart';
import '../local/mappers/admin_mappers.dart';

class DriftRawKanjidicRepository implements RawKanjidicRepository {
  DriftRawKanjidicRepository(this._db);

  final AdminDatabase _db;

  @override
  Future<void> insertBatch(List<RawKanjidic> rows) async {
    await _db.batch((b) {
      for (final row in rows) {
        b.insert(_db.rawKanjidicEntries, row.toEntry());
      }
    });
  }

  @override
  Future<List<RawKanjidic>> getByImportId(int importId) async {
    final entries = await (_db.select(_db.rawKanjidicEntries)
          ..where((t) => t.importId.equals(importId))
          ..orderBy([(t) => OrderingTerm.asc(t.literal)]))
        .get();
    return entries.map((e) => e.toDomain()).toList();
  }

  @override
  Future<RawKanjidic?> getByLiteral({
    required int importId,
    required String literal,
  }) async {
    final entry = await (_db.select(_db.rawKanjidicEntries)
          ..where(
            (t) => t.importId.equals(importId) & t.literal.equals(literal),
          ))
        .getSingleOrNull();
    return entry?.toDomain();
  }

  @override
  Future<int> countByImportId(int importId) async {
    final count = countAll();
    final query = _db.selectOnly(_db.rawKanjidicEntries)
      ..addColumns([count])
      ..where(_db.rawKanjidicEntries.importId.equals(importId));
    final result = await query.getSingle();
    return result.read(count)!;
  }

  @override
  Future<void> deleteByImportId(int importId) async {
    await (_db.delete(_db.rawKanjidicEntries)
          ..where((t) => t.importId.equals(importId)))
        .go();
  }

  Future<void> upsertAll(List<RawKanjidic> rows) async {
    await _db.batch((b) {
      for (final row in rows) {
        b.insert(
          _db.rawKanjidicEntries,
          row.toEntry(),
          onConflict: DoUpdate(
            (old) => row.toEntry().toCompanion(false),
          ),
        );
      }
    });
  }
}
