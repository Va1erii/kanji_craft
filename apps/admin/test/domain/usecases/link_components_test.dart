import 'package:flutter_test/flutter_test.dart';
import 'package:kanji_craft_admin/data/database/admin_database.dart';
import 'package:kanji_craft_admin/data/repositories/kanji/drift_kanji_repository.dart';
import 'package:kanji_craft_admin/data/repositories/kanji_component/drift_kanji_component_repository.dart';
import 'package:kanji_craft_admin/data/repositories/radical/drift_radical_repository.dart';
import 'package:kanji_craft_admin/data/repositories/raw_kanjidic/drift_raw_kanjidic_repository.dart';
import 'package:kanji_craft_admin/data/repositories/raw_kanjivg/drift_raw_kanjivg_repository.dart';
import 'package:kanji_craft_admin/data/repositories/source_jlpt_level/drift_source_jlpt_level_repository.dart';
import 'package:kanji_craft_admin/data/services/radical_scanner.dart';
import 'package:kanji_craft_admin/domain/entities/warning.dart';
import 'package:kanji_craft_admin/domain/usecases/link_components.dart';
import 'package:kanji_craft_core/kanji_craft_core.dart';

import '../../helpers/admin_fixtures.dart';
import '../../helpers/admin_test_helpers.dart';

void main() {
  late AdminDatabase db;
  late DriftRawKanjiVgRepository rawKanjiVgRepo;
  late DriftRawKanjidicRepository kanjidicRepo;
  late DriftSourceJlptLevelRepository sourceJlptLevelRepo;
  late DriftKanjiComponentRepository componentRepo;
  late DriftRadicalRepository radicalRepo;
  late DriftKanjiRepository kanjiRepo;
  late LinkComponents useCase;

  const importId = 1;
  const kanjidicImportId = 2;

  setUp(() {
    resetFixtureIds();
    db = createTestDatabase();
    final repos = createReposFromDb(db);
    rawKanjiVgRepo = repos.kanjiVg;
    kanjidicRepo = repos.kanjidic;
    sourceJlptLevelRepo = repos.sourceJlptLevel;
    componentRepo = repos.kanjiComponents;
    radicalRepo = repos.radicals;
    kanjiRepo = repos.kanji;

    useCase = LinkComponents(
      rawKanjiVgRepository: rawKanjiVgRepo,
      kanjiComponentRepository: componentRepo,
      radicalRepository: radicalRepo,
      kanjiRepository: kanjiRepo,
      rawKanjidicRepository: kanjidicRepo,
      sourceJlptLevelRepository: sourceJlptLevelRepo,
      scanner: RadicalScanner(),
    );
  });

  tearDown(() => db.close());

  /// Insert kanjidic entries with grade to put characters in scope.
  Future<void> putInScope(List<String> characters) async {
    await kanjidicRepo.insertBatch([
      for (final char in characters)
        fakeRawKanjidic(
          importId: kanjidicImportId,
          literal: char,
          grade: 1,
        ),
    ]);
  }

  /// Insert a draft kanji via batch insert and return its DB-assigned ID.
  Future<int> insertDraftKanji(
    String character, {
    int? minGrade,
    int? minJlptLevel,
  }) async {
    await kanjiRepo.insertDraftKanjiBatch([
      fakeDraftKanji(
        character: character,
        minGrade: minGrade,
        minJlptLevel: minJlptLevel,
      ),
    ]);
    final all = await kanjiRepo.getAllDraftKanji();
    return all.firstWhere((k) => k.character == character).id;
  }

  /// Insert a draft radical via upsert and return its DB-assigned ID.
  Future<int> insertDraftRadical(String masterSymbol) async {
    final saved = await radicalRepo.upsertDraftRadical(
      fakeDraftRadical(masterSymbol: masterSymbol),
    );
    return saved.id;
  }

  group('LinkComponents', () {
    test('creates components from simple direct children', () async {
      final kanjiId = await insertDraftKanji('忙');
      final rad1Id = await insertDraftRadical('忄');
      final rad2Id = await insertDraftRadical('亡');
      await putInScope(['忙']);

      await rawKanjiVgRepo.insertBatch([
        fakeRawKanjiVg(
          importId: importId,
          character: '忙',
          components: fakeComponent(
            element: '忙',
            children: [
              fakeComponent(element: '忄', position: 'left'),
              fakeComponent(element: '亡', position: 'right'),
            ],
          ),
        ),
      ]);

      final result = await useCase.call(
        kanjivgImportId: importId,
        kanjidicImportId: kanjidicImportId,
      );

      expect(result.componentCount, 2);
      expect(result.kanjiProcessed, 1);
      expect(result.warnings, isEmpty);

      final components = await componentRepo.getAll();
      expect(components, hasLength(2));

      final leftComp = components.firstWhere((c) => c.radicalId == rad1Id);
      expect(leftComp.kanjiId, kanjiId);
      expect(leftComp.position, Position.hen);
      expect(leftComp.logicHint, LogicHint.semantic);

      final rightComp = components.firstWhere((c) => c.radicalId == rad2Id);
      expect(rightComp.kanjiId, kanjiId);
      expect(rightComp.position, Position.tsukuri);
    });

    test('flattens structural groups (empty element nodes)', () async {
      await insertDraftKanji('森');
      final radId = await insertDraftRadical('木');
      await putInScope(['森']);

      await rawKanjiVgRepo.insertBatch([
        fakeRawKanjiVg(
          importId: importId,
          character: '森',
          components: fakeComponent(
            element: '森',
            children: [
              // Structural group — empty element wrapping one child.
              fakeComponent(
                element: '',
                children: [
                  fakeComponent(element: '木', position: 'top'),
                ],
              ),
              // Direct child with same element.
              fakeComponent(element: '木', position: 'bottom'),
            ],
          ),
        ),
      ]);

      final result = await useCase.call(
        kanjivgImportId: importId,
        kanjidicImportId: kanjidicImportId,
      );

      // '木' appears twice but merged by (element, number) grouping.
      // Position comes from the first part ('top' → kanmuri).
      expect(result.componentCount, 1);

      final components = await componentRepo.getAll();
      expect(components, hasLength(1));
      expect(components.first.radicalId, radId);
      expect(components.first.position, Position.kanmuri);
    });

    test('merges split parts (same element, different part values)', () async {
      await insertDraftKanji('道');
      final nyoRadId = await insertDraftRadical('辶');
      final topRadId = await insertDraftRadical('首');
      await putInScope(['道']);

      await rawKanjiVgRepo.insertBatch([
        fakeRawKanjiVg(
          importId: importId,
          character: '道',
          components: fakeComponent(
            element: '道',
            children: [
              fakeComponent(element: '首', position: 'top'),
              fakeComponent(element: '辶', position: 'nyo', part: 1),
              fakeComponent(element: '辶', part: 2),
            ],
          ),
        ),
      ]);

      final result = await useCase.call(
        kanjivgImportId: importId,
        kanjidicImportId: kanjidicImportId,
      );

      expect(result.componentCount, 2);

      final components = await componentRepo.getAll();
      expect(components, hasLength(2));

      final nyoComp = components.firstWhere((c) => c.radicalId == nyoRadId);
      expect(nyoComp.position, Position.nyo);

      final topComp = components.firstWhere((c) => c.radicalId == topRadId);
      expect(topComp.position, Position.kanmuri);
    });

    test('resolves variant to original radical', () async {
      await insertDraftKanji('仁');
      final radId = await insertDraftRadical('人');
      await putInScope(['仁']);

      await rawKanjiVgRepo.insertBatch([
        fakeRawKanjiVg(
          importId: importId,
          character: '仁',
          components: fakeComponent(
            element: '仁',
            children: [
              fakeComponent(
                element: 'イ',
                position: 'left',
                variant: true,
                original: '人',
              ),
              fakeComponent(element: '二', position: 'right'),
            ],
          ),
        ),
      ]);

      final result = await useCase.call(
        kanjivgImportId: importId,
        kanjidicImportId: kanjidicImportId,
      );

      // '人' resolves via variant→original; '二' not in radicals → warning.
      expect(result.componentCount, 1);
      expect(result.warnings, hasLength(1));
      expect(
        result.warnings.first.message,
        contains('not found in radicals table'),
      );

      final components = await componentRepo.getAll();
      expect(components.first.radicalId, radId);
      expect(components.first.position, Position.hen);
    });

    test('maps radical attribute to RadicalType', () async {
      await insertDraftKanji('木');
      await insertDraftRadical('木');
      await putInScope(['木']);

      await rawKanjiVgRepo.insertBatch([
        fakeRawKanjiVg(
          importId: importId,
          character: '木',
          components: fakeComponent(
            element: '木',
            children: [
              fakeComponent(element: '木', radical: 'general'),
            ],
          ),
        ),
      ]);

      final result = await useCase.call(
        kanjivgImportId: importId,
        kanjidicImportId: kanjidicImportId,
      );
      expect(result.componentCount, 1);

      final components = await componentRepo.getAll();
      expect(components.first.radicalType, RadicalType.general);
    });

    test('skips kanji not in draft table', () async {
      await insertDraftRadical('木');
      await putInScope(['木']);

      await rawKanjiVgRepo.insertBatch([
        fakeRawKanjiVg(
          importId: importId,
          character: '木',
          components: fakeComponent(
            element: '木',
            children: [fakeComponent(element: '木')],
          ),
        ),
      ]);

      final result = await useCase.call(
        kanjivgImportId: importId,
        kanjidicImportId: kanjidicImportId,
      );

      expect(result.componentCount, 0);
      expect(result.kanjiProcessed, 0);
      expect(result.warnings, isEmpty);
    });

    test('warns when radical not found', () async {
      await insertDraftKanji('明');
      await putInScope(['明']);

      await rawKanjiVgRepo.insertBatch([
        fakeRawKanjiVg(
          importId: importId,
          character: '明',
          components: fakeComponent(
            element: '明',
            children: [
              fakeComponent(element: '日', position: 'left'),
              fakeComponent(element: '月', position: 'right'),
            ],
          ),
        ),
      ]);

      final result = await useCase.call(
        kanjivgImportId: importId,
        kanjidicImportId: kanjidicImportId,
      );

      expect(result.componentCount, 0);
      expect(result.kanjiProcessed, 1);
      expect(result.warnings, hasLength(2));
      expect(
        result.warnings.every((w) => w.severity == WarningSeverity.high),
        isTrue,
      );
    });

    test('derives radical metadata (impact_score, min_grade, min_jlpt_level)',
        () async {
      await insertDraftKanji('忙', minGrade: 3, minJlptLevel: 3);
      await insertDraftKanji('忘', minGrade: 6, minJlptLevel: 2);
      await insertDraftRadical('亡');
      await putInScope(['忙', '忘']);

      await rawKanjiVgRepo.insertBatch([
        fakeRawKanjiVg(
          importId: importId,
          character: '忙',
          components: fakeComponent(
            element: '忙',
            children: [fakeComponent(element: '亡')],
          ),
        ),
        fakeRawKanjiVg(
          importId: importId,
          character: '忘',
          components: fakeComponent(
            element: '忘',
            children: [fakeComponent(element: '亡')],
          ),
        ),
      ]);

      final result = await useCase.call(
        kanjivgImportId: importId,
        kanjidicImportId: kanjidicImportId,
      );

      expect(result.componentCount, 2);
      expect(result.radicalsUpdated, 1);

      final updatedRad =
          await radicalRepo.getDraftRadicalByMasterSymbol('亡');
      expect(updatedRad, isNotNull);
      // impact_score for 2 kanji → 1 (<=5).
      expect(updatedRad!.impactScore, 1);
      // min_grade = MIN(3, 6) = 3.
      expect(updatedRad.minGrade, 3);
      // min_jlpt_level = MAX(3, 2) = 3 (easiest JLPT level).
      expect(updatedRad.minJlptLevel, 3);
    });

    test('idempotent re-run deletes previous components', () async {
      await insertDraftKanji('忙');
      await insertDraftRadical('忄');
      await insertDraftRadical('亡');
      await putInScope(['忙']);

      await rawKanjiVgRepo.insertBatch([
        fakeRawKanjiVg(
          importId: importId,
          character: '忙',
          components: fakeComponent(
            element: '忙',
            children: [
              fakeComponent(element: '忄', position: 'left'),
              fakeComponent(element: '亡', position: 'right'),
            ],
          ),
        ),
      ]);

      // First run.
      await useCase.call(
        kanjivgImportId: importId,
        kanjidicImportId: kanjidicImportId,
      );
      expect(await componentRepo.count(), 2);

      // Second run — same result, no duplicates.
      final result = await useCase.call(
        kanjivgImportId: importId,
        kanjidicImportId: kanjidicImportId,
      );
      expect(result.componentCount, 2);
      expect(await componentRepo.count(), 2);
    });

    test('checkExistingResult returns summary when components exist', () async {
      await insertDraftKanji('忙');
      await insertDraftRadical('亡');
      await putInScope(['忙']);

      await rawKanjiVgRepo.insertBatch([
        fakeRawKanjiVg(
          importId: importId,
          character: '忙',
          components: fakeComponent(
            element: '忙',
            children: [fakeComponent(element: '亡')],
          ),
        ),
      ]);

      await useCase.call(
        kanjivgImportId: importId,
        kanjidicImportId: kanjidicImportId,
      );

      final existing = await useCase.checkExistingResult();
      expect(existing, isNotNull);
      expect(existing, contains('1 components'));
    });

    test('checkExistingResult returns null when no components', () async {
      final existing = await useCase.checkExistingResult();
      expect(existing, isNull);
    });

    test('empty raw entries produces no components', () async {
      final result = await useCase.call(
        kanjivgImportId: importId,
        kanjidicImportId: kanjidicImportId,
      );

      expect(result.componentCount, 0);
      expect(result.kanjiProcessed, 0);
      expect(result.radicalsUpdated, 0);
      expect(result.warnings, isEmpty);
    });
  });

  group('Ghost flattening in component linking', () {
    test('flattens ghost radical in component linking', () async {
      // X's direct child G is a ghost → flattened.
      // G's children A and B are in scope and registered as radicals.
      final kanjiId = await insertDraftKanji('X');
      final radAId = await insertDraftRadical('A');
      final radBId = await insertDraftRadical('B');
      await putInScope(['X', 'A', 'B']);

      await rawKanjiVgRepo.insertBatch([
        fakeRawKanjiVg(
          importId: importId,
          character: 'X',
          components: fakeComponent(
            element: 'X',
            children: [
              fakeComponent(element: 'G', position: 'right'),
            ],
          ),
        ),
        fakeRawKanjiVg(
          importId: importId,
          character: 'G',
          strokeCount: 5,
          components: fakeComponent(
            element: 'G',
            children: [
              fakeComponent(element: 'A', position: 'top'),
              fakeComponent(element: 'B', position: 'bottom'),
            ],
          ),
        ),
        fakeRawKanjiVg(
          importId: importId,
          character: 'A',
          strokeCount: 3,
          components: fakeComponent(element: 'A', children: []),
        ),
        fakeRawKanjiVg(
          importId: importId,
          character: 'B',
          strokeCount: 4,
          components: fakeComponent(element: 'B', children: []),
        ),
      ]);

      final result = await useCase.call(
        kanjivgImportId: importId,
        kanjidicImportId: kanjidicImportId,
      );

      // Ghost G is flattened → components link to A and B, not G.
      expect(result.componentCount, 2);
      expect(result.kanjiProcessed, 1);

      final components = await componentRepo.getAll();
      expect(components, hasLength(2));

      final compA = components.firstWhere((c) => c.radicalId == radAId);
      expect(compA.kanjiId, kanjiId);
      expect(compA.position, Position.kanmuri); // 'top' → kanmuri

      final compB = components.firstWhere((c) => c.radicalId == radBId);
      expect(compB.kanjiId, kanjiId);
      expect(compB.position, Position.ashi); // 'bottom' → ashi
    });

    test('ghost flattening consistent with extraction', () async {
      // Both ExtractRadicals and LinkComponents should produce the same
      // radical set for the same input.
      await insertDraftKanji('X');
      await insertDraftRadical('A');
      await insertDraftRadical('B');
      // Don't register G as a radical (it's a ghost).
      await putInScope(['X', 'A', 'B']);

      await rawKanjiVgRepo.insertBatch([
        fakeRawKanjiVg(
          importId: importId,
          character: 'X',
          components: fakeComponent(
            element: 'X',
            children: [
              fakeComponent(element: 'G', position: 'right'),
            ],
          ),
        ),
        fakeRawKanjiVg(
          importId: importId,
          character: 'G',
          strokeCount: 5,
          components: fakeComponent(
            element: 'G',
            children: [
              fakeComponent(element: 'A', position: 'top'),
              fakeComponent(element: 'B', position: 'bottom'),
            ],
          ),
        ),
        fakeRawKanjiVg(
          importId: importId,
          character: 'A',
          strokeCount: 3,
          components: fakeComponent(element: 'A', children: []),
        ),
        fakeRawKanjiVg(
          importId: importId,
          character: 'B',
          strokeCount: 4,
          components: fakeComponent(element: 'B', children: []),
        ),
      ]);

      final result = await useCase.call(
        kanjivgImportId: importId,
        kanjidicImportId: kanjidicImportId,
      );

      // A and B are linked — G is not (it's a ghost).
      final components = await componentRepo.getAll();
      final linkedRadicalIds = components.map((c) => c.radicalId).toSet();

      final draftRadicals = await radicalRepo.getAllDraftRadicals();
      final radicalA =
          draftRadicals.firstWhere((r) => r.masterSymbol == 'A');
      final radicalB =
          draftRadicals.firstWhere((r) => r.masterSymbol == 'B');

      expect(linkedRadicalIds, contains(radicalA.id));
      expect(linkedRadicalIds, contains(radicalB.id));
      expect(result.componentCount, 2);
    });
  });
}
