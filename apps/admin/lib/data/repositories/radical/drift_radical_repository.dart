import 'package:drift/drift.dart';

import '../../../domain/entities/draft_radical.dart';
import '../../../domain/entities/draft_radical_i18n.dart';
import '../../../domain/entities/draft_radical_variant.dart';
import '../../../domain/repositories/radical_repository.dart';
import '../../database/admin_database.dart';
import '../../database/mappers/admin_mappers.dart';

class DriftRadicalRepository implements RadicalRepository {
  DriftRadicalRepository(this._db);

  final AdminDatabase _db;

  @override
  Future<DraftRadical> upsertDraftRadical(DraftRadical radical) async {
    final existing = await (_db.select(_db.draftRadicalEntries)
          ..where((t) => t.masterSymbol.equals(radical.masterSymbol)))
        .getSingleOrNull();

    if (existing != null) {
      await (_db.update(_db.draftRadicalEntries)
            ..where((t) => t.id.equals(existing.id)))
          .write(radical.toCompanion());
      return (await (_db.select(_db.draftRadicalEntries)
                ..where((t) => t.id.equals(existing.id)))
              .getSingle())
          .toDomain();
    } else {
      final entry = await _db
          .into(_db.draftRadicalEntries)
          .insertReturning(radical.toCompanion());
      return entry.toDomain();
    }
  }

  @override
  Future<DraftRadicalVariant> upsertDraftRadicalVariant(
    DraftRadicalVariant variant,
  ) async {
    final existing = await (_db.select(_db.draftRadicalVariantEntries)
          ..where(
            (t) =>
                t.draftRadicalId.equals(variant.draftRadicalId) &
                t.shape.equals(variant.shape),
          ))
        .getSingleOrNull();

    if (existing != null) {
      await (_db.update(_db.draftRadicalVariantEntries)
            ..where((t) => t.id.equals(existing.id)))
          .write(variant.toCompanion());
      return (await (_db.select(_db.draftRadicalVariantEntries)
                ..where((t) => t.id.equals(existing.id)))
              .getSingle())
          .toDomain();
    } else {
      final entry = await _db
          .into(_db.draftRadicalVariantEntries)
          .insertReturning(variant.toCompanion());
      return entry.toDomain();
    }
  }

  @override
  Future<DraftRadical?> getDraftRadicalByMasterSymbol(
    String masterSymbol,
  ) async {
    final entry = await (_db.select(_db.draftRadicalEntries)
          ..where((t) => t.masterSymbol.equals(masterSymbol)))
        .getSingleOrNull();
    return entry?.toDomain();
  }

  @override
  Future<List<DraftRadical>> getAllDraftRadicals() async {
    final entries = await (_db.select(_db.draftRadicalEntries)
          ..orderBy([(t) => OrderingTerm.asc(t.masterSymbol)]))
        .get();
    return entries.map((e) => e.toDomain()).toList();
  }

  @override
  Future<List<DraftRadicalVariant>> getAllDraftRadicalVariants() async {
    final entries = await (_db.select(_db.draftRadicalVariantEntries)
          ..orderBy([(t) => OrderingTerm.asc(t.draftRadicalId)]))
        .get();
    return entries.map((e) => e.toDomain()).toList();
  }

  @override
  Future<void> deleteAllDraftRadicals() async {
    // Explicitly delete variants first — FK cascade requires PRAGMA
    // foreign_keys = ON which isn't enabled by default in SQLite.
    await _db.delete(_db.draftRadicalVariantEntries).go();
    await _db.delete(_db.draftRadicalEntries).go();
  }

  @override
  Future<int> countDraftRadicals() async {
    final c = countAll();
    final query = _db.selectOnly(_db.draftRadicalEntries)..addColumns([c]);
    final result = await query.getSingle();
    return result.read(c)!;
  }

  @override
  Future<int> countDraftRadicalVariants() async {
    final c = countAll();
    final query = _db.selectOnly(_db.draftRadicalVariantEntries)
      ..addColumns([c]);
    final result = await query.getSingle();
    return result.read(c)!;
  }

  @override
  Future<void> batchUpdateDraftRadicalSvg(
    List<({int id, String svgFileName, String svgFileUrl, String svgHash})>
        updates,
  ) async {
    await _db.batch((b) {
      for (final u in updates) {
        b.update(
          _db.draftRadicalEntries,
          DraftRadicalEntriesCompanion(
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
  Future<void> batchUpdateDraftRadicalVariantSvg(
    List<({int id, String svgFileName, String svgFileUrl, String svgHash})>
        updates,
  ) async {
    await _db.batch((b) {
      for (final u in updates) {
        b.update(
          _db.draftRadicalVariantEntries,
          DraftRadicalVariantEntriesCompanion(
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
  Future<int> countDraftRadicalsWithSvg() async {
    final c = countAll();
    final query = _db.selectOnly(_db.draftRadicalEntries)
      ..addColumns([c])
      ..where(_db.draftRadicalEntries.svgFileName.isNotNull());
    final result = await query.getSingle();
    return result.read(c)!;
  }

  @override
  Future<int> countDraftRadicalVariantsWithSvg() async {
    final c = countAll();
    final query = _db.selectOnly(_db.draftRadicalVariantEntries)
      ..addColumns([c])
      ..where(_db.draftRadicalVariantEntries.svgFileName.isNotNull());
    final result = await query.getSingle();
    return result.read(c)!;
  }

  @override
  Future<void> batchUpdateDraftRadicalMetadata(
    List<({int id, int? impactScore, int? minGrade, int? minJlptLevel})>
        updates,
  ) async {
    await _db.batch((b) {
      for (final u in updates) {
        b.update(
          _db.draftRadicalEntries,
          DraftRadicalEntriesCompanion(
            impactScore: Value(u.impactScore),
            minGrade: Value(u.minGrade),
            minJlptLevel: Value(u.minJlptLevel),
          ),
          where: (t) => t.id.equals(u.id),
        );
      }
    });
  }

  // -- Draft Radical I18n --

  @override
  Future<DraftRadicalI18n> upsertDraftRadicalI18n(
    DraftRadicalI18n i18n,
  ) async {
    final existing = await (_db.select(_db.draftRadicalI18nEntries)
          ..where(
            (t) =>
                t.draftRadicalId.equals(i18n.draftRadicalId) &
                t.langCode.equals(i18n.langCode),
          ))
        .getSingleOrNull();

    if (existing != null) {
      await (_db.update(_db.draftRadicalI18nEntries)
            ..where((t) => t.id.equals(existing.id)))
          .write(i18n.toCompanion());
      return (await (_db.select(_db.draftRadicalI18nEntries)
                ..where((t) => t.id.equals(existing.id)))
              .getSingle())
          .toDomain();
    } else {
      final entry = await _db
          .into(_db.draftRadicalI18nEntries)
          .insertReturning(i18n.toCompanion());
      return entry.toDomain();
    }
  }

  @override
  Future<void> insertDraftRadicalI18nBatch(List<DraftRadicalI18n> rows) async {
    await _db.batch((b) {
      for (final row in rows) {
        b.insert(_db.draftRadicalI18nEntries, row.toCompanion());
      }
    });
  }

  @override
  Future<List<DraftRadicalI18n>> getAllDraftRadicalI18n() async {
    final entries = await (_db.select(_db.draftRadicalI18nEntries)
          ..orderBy([(t) => OrderingTerm.asc(t.draftRadicalId)]))
        .get();
    return entries.map((e) => e.toDomain()).toList();
  }

  @override
  Future<int> countDraftRadicalI18n() async {
    final c = countAll();
    final query = _db.selectOnly(_db.draftRadicalI18nEntries)..addColumns([c]);
    final result = await query.getSingle();
    return result.read(c)!;
  }

  @override
  Future<int> countDraftRadicalI18nWithMnemonic() async {
    final c = countAll();
    final query = _db.selectOnly(_db.draftRadicalI18nEntries)
      ..addColumns([c])
      ..where(_db.draftRadicalI18nEntries.systemMnemonic.length.isBiggerThan(
        const Constant(0),
      ));
    final result = await query.getSingle();
    return result.read(c)!;
  }

  @override
  Future<void> batchUpdateDraftRadicalI18nEnrichment(
    List<({int id, String systemMnemonic, List<String> searchTags})> updates,
  ) async {
    await _db.batch((b) {
      for (final u in updates) {
        b.update(
          _db.draftRadicalI18nEntries,
          DraftRadicalI18nEntriesCompanion(
            systemMnemonic: Value(u.systemMnemonic),
            searchTags: Value(u.searchTags),
          ),
          where: (t) => t.id.equals(u.id),
        );
      }
    });
  }

  @override
  Future<void> deleteAllDraftRadicalI18n() async {
    await _db.delete(_db.draftRadicalI18nEntries).go();
  }

  @override
  Future<List<DraftRadical>> getDraftRadicalsForExport({
    required int limit,
    required int offset,
  }) async {
    // Sort: min_jlpt_level DESC NULLS LAST, min_grade ASC NULLS LAST,
    // impact_score DESC.
    final t = _db.draftRadicalEntries;
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
        // impact_score DESC (nulls naturally sort last in DESC)
        (t) => OrderingTerm(
              expression: CustomExpression(
                  'COALESCE(${t.impactScore.name}, 0)'),
              mode: OrderingMode.desc,
            ),
      ])
      ..limit(limit, offset: offset);
    final entries = await query.get();
    return entries.map((e) => e.toDomain()).toList();
  }

  @override
  Future<int> countDraftRadicalsForExport() async {
    return countDraftRadicals();
  }
}
