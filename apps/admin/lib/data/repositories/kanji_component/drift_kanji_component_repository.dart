import 'package:drift/drift.dart';
import 'package:kanji_craft_core/kanji_craft_core.dart';

import '../../../domain/repositories/kanji_component_repository.dart';
import '../../database/admin_database.dart';
import '../../database/mappers/admin_mappers.dart';

class DriftKanjiComponentRepository implements KanjiComponentRepository {
  DriftKanjiComponentRepository(this._db);

  final AdminDatabase _db;

  @override
  Future<List<KanjiComponent>> getAll() async {
    final entries = await _db.select(_db.kanjiComponentEntries).get();
    return entries.map((e) => e.toDomain()).toList();
  }

  @override
  Future<int> count() async {
    final c = countAll();
    final query = _db.selectOnly(_db.kanjiComponentEntries)..addColumns([c]);
    final result = await query.getSingle();
    return result.read(c)!;
  }

  @override
  Future<void> deleteAll() async {
    await _db.delete(_db.kanjiComponentEntries).go();
  }

  @override
  Future<void> upsertBatch(List<KanjiComponent> components) async {
    await _db.batch((b) {
      for (final c in components) {
        b.insert(
          _db.kanjiComponentEntries,
          c.toCompanion(),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  @override
  Future<void> updateLogicHint({
    required int id,
    required LogicHint logicHint,
  }) async {
    await (_db.update(_db.kanjiComponentEntries)
          ..where((t) => t.id.equals(id)))
        .write(
      KanjiComponentEntriesCompanion(
        logicHint: Value(logicHint),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  @override
  Future<Map<int, String>> getKanjiCharMap() async {
    final entries = await _db.select(_db.draftKanjiEntries).get();
    return {for (final e in entries) e.id: e.character};
  }

  @override
  Future<Map<int, String>> getRadicalSymbolMap() async {
    final entries = await _db.select(_db.draftRadicalEntries).get();
    return {for (final e in entries) e.id: e.masterSymbol};
  }
}
