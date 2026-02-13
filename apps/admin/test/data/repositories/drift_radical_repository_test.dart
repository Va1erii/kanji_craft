import 'package:flutter_test/flutter_test.dart';
import 'package:kanji_craft_admin/data/database/admin_database.dart';
import 'package:kanji_craft_admin/data/repositories/radical/drift_radical_repository.dart';
import 'package:kanji_craft_core/kanji_craft_core.dart';

import '../../helpers/admin_fixtures.dart';
import '../../helpers/admin_test_helpers.dart';

void main() {
  late AdminDatabase db;
  late DriftRadicalRepository repo;

  setUp(() {
    resetFixtureIds();
    db = createTestDatabase();
    repo = createReposFromDb(db).radicals;
  });

  tearDown(() => db.close());

  group('DriftRadicalRepository', () {
    group('upsertDraftRadical', () {
      test('inserts a new draft radical and returns it with an id', () async {
        final radical = fakeDraftRadical(masterSymbol: '木');

        final saved = await repo.upsertDraftRadical(radical);

        expect(saved.id, greaterThan(0));
        expect(saved.masterSymbol, '木');
        expect(saved.strokeCount, 4);
        expect(saved.isOfficial, isFalse);
        expect(saved.impactScore, isNull);
      });

      test('updates existing radical on conflict (same masterSymbol)',
          () async {
        await repo.upsertDraftRadical(
          fakeDraftRadical(masterSymbol: '人', isOfficial: false),
        );

        final updated = await repo.upsertDraftRadical(
          fakeDraftRadical(masterSymbol: '人', isOfficial: true),
        );

        expect(updated.isOfficial, isTrue);

        final all = await repo.getAllDraftRadicals();
        expect(all, hasLength(1));
      });
    });

    group('upsertDraftRadicalVariant', () {
      test('inserts a new variant linked to a draft radical', () async {
        final radical = await repo.upsertDraftRadical(
          fakeDraftRadical(masterSymbol: '人'),
        );

        final variant = await repo.upsertDraftRadicalVariant(
          fakeDraftRadicalVariant(
            draftRadicalId: radical.id,
            shape: '亻',
            position: Position.hen,
            isLocked: true,
          ),
        );

        expect(variant.id, greaterThan(0));
        expect(variant.draftRadicalId, radical.id);
        expect(variant.shape, '亻');
        expect(variant.position, Position.hen);
        expect(variant.isLocked, isTrue);
        expect(variant.svgFileName, isNull);
      });

      test('updates existing variant on conflict (same radical + shape)',
          () async {
        final radical = await repo.upsertDraftRadical(
          fakeDraftRadical(masterSymbol: '木'),
        );

        await repo.upsertDraftRadicalVariant(
          fakeDraftRadicalVariant(
            draftRadicalId: radical.id,
            shape: '木',
            position: Position.unknown,
          ),
        );

        final updated = await repo.upsertDraftRadicalVariant(
          fakeDraftRadicalVariant(
            draftRadicalId: radical.id,
            shape: '木',
            position: Position.tsukuri,
          ),
        );

        expect(updated.position, Position.tsukuri);

        final all = await repo.getAllDraftRadicalVariants();
        expect(all, hasLength(1));
      });
    });

    group('getDraftRadicalByMasterSymbol', () {
      test('returns the radical when found', () async {
        await repo.upsertDraftRadical(fakeDraftRadical(masterSymbol: '木'));

        final found = await repo.getDraftRadicalByMasterSymbol('木');

        expect(found, isNotNull);
        expect(found!.masterSymbol, '木');
      });

      test('returns null when not found', () async {
        final found = await repo.getDraftRadicalByMasterSymbol('水');

        expect(found, isNull);
      });
    });

    group('getAllDraftRadicals', () {
      test('returns all radicals ordered by masterSymbol', () async {
        await repo.upsertDraftRadical(fakeDraftRadical(masterSymbol: '水'));
        await repo.upsertDraftRadical(fakeDraftRadical(masterSymbol: '人'));
        await repo.upsertDraftRadical(fakeDraftRadical(masterSymbol: '木'));

        final all = await repo.getAllDraftRadicals();

        expect(all, hasLength(3));
        // Ordered by masterSymbol (Unicode order)
        expect(all.map((r) => r.masterSymbol).toList(), ['人', '木', '水']);
      });
    });

    group('getAllDraftRadicalVariants', () {
      test('returns all variants', () async {
        final r1 = await repo.upsertDraftRadical(
          fakeDraftRadical(masterSymbol: '人'),
        );
        final r2 = await repo.upsertDraftRadical(
          fakeDraftRadical(masterSymbol: '木'),
        );

        await repo.upsertDraftRadicalVariant(
          fakeDraftRadicalVariant(draftRadicalId: r1.id, shape: '人'),
        );
        await repo.upsertDraftRadicalVariant(
          fakeDraftRadicalVariant(draftRadicalId: r1.id, shape: '亻'),
        );
        await repo.upsertDraftRadicalVariant(
          fakeDraftRadicalVariant(draftRadicalId: r2.id, shape: '木'),
        );

        final all = await repo.getAllDraftRadicalVariants();

        expect(all, hasLength(3));
      });
    });

    group('deleteAllDraftRadicals', () {
      test('deletes all radicals and cascades to variants', () async {
        final radical = await repo.upsertDraftRadical(
          fakeDraftRadical(masterSymbol: '木'),
        );
        await repo.upsertDraftRadicalVariant(
          fakeDraftRadicalVariant(draftRadicalId: radical.id, shape: '木'),
        );

        await repo.deleteAllDraftRadicals();

        expect(await repo.getAllDraftRadicals(), isEmpty);
        expect(await repo.getAllDraftRadicalVariants(), isEmpty);
      });
    });

    group('batchUpdateDraftRadicalMetadata', () {
      test('updates impact_score, min_grade, and min_jlpt_level', () async {
        final r1 = await repo.upsertDraftRadical(
          fakeDraftRadical(masterSymbol: '木'),
        );
        final r2 = await repo.upsertDraftRadical(
          fakeDraftRadical(masterSymbol: '人'),
        );

        await repo.batchUpdateDraftRadicalMetadata([
          (id: r1.id, impactScore: 5, minGrade: 2, minJlptLevel: 4),
          (id: r2.id, impactScore: 8, minGrade: 1, minJlptLevel: 5),
        ]);

        final updated1 = await repo.getDraftRadicalByMasterSymbol('木');
        expect(updated1!.impactScore, 5);
        expect(updated1.minGrade, 2);
        expect(updated1.minJlptLevel, 4);

        final updated2 = await repo.getDraftRadicalByMasterSymbol('人');
        expect(updated2!.impactScore, 8);
        expect(updated2.minGrade, 1);
        expect(updated2.minJlptLevel, 5);
      });

      test('handles null metadata values', () async {
        final r = await repo.upsertDraftRadical(
          fakeDraftRadical(masterSymbol: '木'),
        );

        await repo.batchUpdateDraftRadicalMetadata([
          (id: r.id, impactScore: 3, minGrade: null, minJlptLevel: null),
        ]);

        final updated = await repo.getDraftRadicalByMasterSymbol('木');
        expect(updated!.impactScore, 3);
        expect(updated.minGrade, isNull);
        expect(updated.minJlptLevel, isNull);
      });
    });

    group('nullable deferred fields', () {
      test('stores and retrieves null values for deferred fields', () async {
        final radical = await repo.upsertDraftRadical(
          fakeDraftRadical(
            masterSymbol: '木',
            strokeCount: null,
            impactScore: null,
            minJlptLevel: null,
            minGrade: null,
            svgFileName: null,
            svgFileUrl: null,
            svgHash: null,
          ),
        );

        expect(radical.strokeCount, isNull);
        expect(radical.impactScore, isNull);
        expect(radical.minJlptLevel, isNull);
        expect(radical.minGrade, isNull);
        expect(radical.svgFileName, isNull);
        expect(radical.svgFileUrl, isNull);
        expect(radical.svgHash, isNull);
      });
    });
  });
}
