import 'package:drift/drift.dart';

import '../../../domain/entities/draft_kanji.dart';
import '../../../domain/entities/draft_kanji_i18n.dart';
import '../../../domain/entities/draft_kanji_reading.dart';
import '../../../domain/repositories/kanji_repository.dart';
import '../../database/admin_database.dart';
import '../../database/mappers/admin_mappers.dart';

class DriftKanjiRepository implements KanjiRepository {
  DriftKanjiRepository(this._db);

  final AdminDatabase _db;

  @override
  Future<void> insertDraftKanjiBatch(List<DraftKanji> kanji) async {
    await _db.batch((b) {
      for (final item in kanji) {
        b.insert(_db.draftKanjiEntries, item.toCompanion());
      }
    });
  }

  @override
  Future<void> insertDraftKanjiReadingBatch(
    List<DraftKanjiReading> readings,
  ) async {
    await _db.batch((b) {
      for (final item in readings) {
        b.insert(_db.draftKanjiReadingEntries, item.toCompanion());
      }
    });
  }

  @override
  Future<void> insertDraftKanjiI18nBatch(List<DraftKanjiI18n> i18n) async {
    await _db.batch((b) {
      for (final item in i18n) {
        b.insert(_db.draftKanjiI18nEntries, item.toCompanion());
      }
    });
  }

  @override
  Future<List<DraftKanji>> getAllDraftKanji() async {
    final entries = await (_db.select(_db.draftKanjiEntries)
          ..orderBy([(t) => OrderingTerm.asc(t.character)]))
        .get();
    return entries.map((e) => e.toDomain()).toList();
  }

  @override
  Future<void> deleteAllDraftKanji() async {
    // Explicitly delete children first — FK cascade requires PRAGMA
    // foreign_keys = ON which isn't enabled by default in SQLite.
    await _db.delete(_db.draftKanjiI18nEntries).go();
    await _db.delete(_db.draftKanjiReadingEntries).go();
    await _db.delete(_db.draftKanjiEntries).go();
  }

  @override
  Future<int> countDraftKanji() async {
    final c = countAll();
    final query = _db.selectOnly(_db.draftKanjiEntries)..addColumns([c]);
    final result = await query.getSingle();
    return result.read(c)!;
  }

  @override
  Future<int> countDraftKanjiReadings() async {
    final c = countAll();
    final query = _db.selectOnly(_db.draftKanjiReadingEntries)
      ..addColumns([c]);
    final result = await query.getSingle();
    return result.read(c)!;
  }

  @override
  Future<int> countDraftKanjiI18n() async {
    final c = countAll();
    final query = _db.selectOnly(_db.draftKanjiI18nEntries)..addColumns([c]);
    final result = await query.getSingle();
    return result.read(c)!;
  }
}
