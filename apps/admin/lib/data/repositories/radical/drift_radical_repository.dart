import 'package:drift/drift.dart';

import '../../../domain/entities/draft_radical.dart';
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
}
