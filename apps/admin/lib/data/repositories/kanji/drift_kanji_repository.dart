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

  @override
  Future<void> batchUpdateDraftKanjiSvg(
    List<({int id, String svgFileName, String svgFileUrl, String svgHash})>
        updates,
  ) async {
    await _db.batch((b) {
      for (final u in updates) {
        b.update(
          _db.draftKanjiEntries,
          DraftKanjiEntriesCompanion(
            svgFileName: Value(u.svgFileName),
            svgFileUrl: Value(u.svgFileUrl),
            svgHash: Value(u.svgHash),
          ),
          where: (t) => t.id.equals(u.id),
        );
      }
    });
  }

  @override
  Future<int> countDraftKanjiWithSvg() async {
    final c = countAll();
    final query = _db.selectOnly(_db.draftKanjiEntries)
      ..addColumns([c])
      ..where(_db.draftKanjiEntries.svgFileName.isNotNull());
    final result = await query.getSingle();
    return result.read(c)!;
  }

  // -- Draft Kanji I18n --

  @override
  Future<DraftKanjiI18n> upsertDraftKanjiI18n(DraftKanjiI18n i18n) async {
    final existing = await (_db.select(_db.draftKanjiI18nEntries)
          ..where(
            (t) =>
                t.draftKanjiId.equals(i18n.draftKanjiId) &
                t.langCode.equals(i18n.langCode),
          ))
        .getSingleOrNull();

    if (existing != null) {
      await (_db.update(_db.draftKanjiI18nEntries)
            ..where((t) => t.id.equals(existing.id)))
          .write(i18n.toCompanion());
      return (await (_db.select(_db.draftKanjiI18nEntries)
                ..where((t) => t.id.equals(existing.id)))
              .getSingle())
          .toDomain();
    } else {
      final entry = await _db
          .into(_db.draftKanjiI18nEntries)
          .insertReturning(i18n.toCompanion());
      return entry.toDomain();
    }
  }

  @override
  Future<List<DraftKanjiI18n>> getAllDraftKanjiI18n() async {
    final entries = await (_db.select(_db.draftKanjiI18nEntries)
          ..orderBy([(t) => OrderingTerm.asc(t.draftKanjiId)]))
        .get();
    return entries.map((e) => e.toDomain()).toList();
  }

  @override
  Future<int> countDraftKanjiI18nWithMnemonic() async {
    final c = countAll();
    final query = _db.selectOnly(_db.draftKanjiI18nEntries)
      ..addColumns([c])
      ..where(_db.draftKanjiI18nEntries.systemMnemonic.length.isBiggerThan(
        const Constant(0),
      ));
    final result = await query.getSingle();
    return result.read(c)!;
  }

  @override
  Future<void> batchUpdateDraftKanjiI18nEnrichment(
    List<({int id, String systemMnemonic, List<String> searchTags})> updates,
  ) async {
    await _db.batch((b) {
      for (final u in updates) {
        b.update(
          _db.draftKanjiI18nEntries,
          DraftKanjiI18nEntriesCompanion(
            systemMnemonic: Value(u.systemMnemonic),
            searchTags: Value(u.searchTags),
          ),
          where: (t) => t.id.equals(u.id),
        );
      }
    });
  }

  // -- Export helpers --

  @override
  Future<List<DraftKanji>> getDraftKanjiForExport({
    required int limit,
    required int offset,
  }) async {
    // Sort: min_jlpt_level DESC NULLS LAST, min_grade ASC NULLS LAST,
    // frequency_rank ASC.
    final t = _db.draftKanjiEntries;
    final query = _db.select(t)
      ..orderBy([
        // COALESCE(min_jlpt_level, 0) DESC — nulls become 0 (sort last)
        (t) => OrderingTerm(
              expression:
                  CustomExpression('COALESCE(${t.minJlptLevel.name}, 0)'),
              mode: OrderingMode.desc,
            ),
        // COALESCE(min_grade, 99) ASC — nulls become 99 (sort last)
        (t) => OrderingTerm(
              expression:
                  CustomExpression('COALESCE(${t.minGrade.name}, 99)'),
              mode: OrderingMode.asc,
            ),
        // frequency_rank ASC
        (t) => OrderingTerm.asc(t.frequencyRank),
      ])
      ..limit(limit, offset: offset);
    final entries = await query.get();
    return entries.map((e) => e.toDomain()).toList();
  }

  @override
  Future<int> countDraftKanjiForExport() async {
    return countDraftKanji();
  }
}
