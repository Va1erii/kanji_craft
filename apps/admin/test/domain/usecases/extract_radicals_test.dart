import 'package:flutter_test/flutter_test.dart';
import 'package:kanji_craft_admin/data/database/admin_database.dart';
import 'package:kanji_craft_admin/data/repositories/radical/drift_radical_repository.dart';
import 'package:kanji_craft_admin/data/repositories/raw_kanjidic/drift_raw_kanjidic_repository.dart';
import 'package:kanji_craft_admin/data/repositories/raw_kanjivg/drift_raw_kanjivg_repository.dart';
import 'package:kanji_craft_admin/data/repositories/source_jlpt_level/drift_source_jlpt_level_repository.dart';
import 'package:kanji_craft_admin/data/services/radical_scanner.dart';
import 'package:kanji_craft_admin/domain/entities/import_source.dart';
import 'package:kanji_craft_admin/domain/usecases/extract_radicals.dart';
import 'package:kanji_craft_core/kanji_craft_core.dart';

import '../../helpers/admin_fixtures.dart';
import '../../helpers/admin_test_helpers.dart';

void main() {
  late AdminDatabase db;
  late DriftRawKanjiVgRepository kanjiVgRepo;
  late DriftRawKanjidicRepository kanjidicRepo;
  late DriftSourceJlptLevelRepository sourceJlptLevelRepo;
  late DriftRadicalRepository radicalRepo;
  late ExtractRadicals extractRadicals;
  late int importId;
  late int kanjidicImportId;

  setUp(() async {
    resetFixtureIds();
    db = createTestDatabase();
    final repos = createReposFromDb(db);
    kanjiVgRepo = repos.kanjiVg;
    kanjidicRepo = repos.kanjidic;
    sourceJlptLevelRepo = repos.sourceJlptLevel;
    radicalRepo = repos.radicals;
    extractRadicals = ExtractRadicals(
      rawKanjiVgRepository: kanjiVgRepo,
      radicalRepository: radicalRepo,
      scanner: RadicalScanner(),
      rawKanjidicRepository: kanjidicRepo,
      sourceJlptLevelRepository: sourceJlptLevelRepo,
    );

    // Create parent imports.
    final vgImp = await repos.imports.create(
      source: ImportSource.kanjivg,
      sourceVersion: '1.0',
    );
    importId = vgImp.id;

    final kdImp = await repos.imports.create(
      source: ImportSource.kanjidic,
      sourceVersion: '1.0',
    );
    kanjidicImportId = kdImp.id;
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

  group('ExtractRadicals', () {
    test('extracts radicals and variants from 休 (亻+木)', () async {
      await putInScope(['休']);

      // Insert raw entries: 休, 人 (for stroke count lookup), 木
      await kanjiVgRepo.insertBatch([
        fakeRawKanjiVg(
          importId: importId,
          character: '休',
          strokeCount: 6,
          components: fakeComponent(
            element: '休',
            children: [
              fakeComponent(
                element: '亻',
                position: 'left',
                variant: true,
                original: '人',
                radical: 'general',
              ),
              fakeComponent(element: '木', position: 'right'),
            ],
          ),
        ),
        fakeRawKanjiVg(
          importId: importId,
          character: '人',
          strokeCount: 2,
          components: fakeComponent(element: '人', children: []),
        ),
        fakeRawKanjiVg(
          importId: importId,
          character: '木',
          strokeCount: 4,
          components: fakeComponent(element: '木', children: []),
        ),
      ]);

      final result = await extractRadicals.call(
        kanjivgImportId: importId,
        kanjidicImportId: kanjidicImportId,
      );

      expect(result.radicalCount, 2);
      expect(result.scopeSize, 1);

      // Verify draft radicals.
      final radicals = await radicalRepo.getAllDraftRadicals();
      expect(radicals, hasLength(2));

      final jin = radicals.firstWhere((r) => r.masterSymbol == '人');
      expect(jin.isOfficial, isTrue);
      expect(jin.strokeCount, 2); // from raw_kanjivg for 人

      final ki = radicals.firstWhere((r) => r.masterSymbol == '木');
      expect(ki.isOfficial, isFalse);
      expect(ki.strokeCount, 4);

      // Verify draft variants.
      final variants = await radicalRepo.getAllDraftRadicalVariants();

      // 人 should have: 亻 (explicit) + 人 (self-variant)
      final jinVariants =
          variants.where((v) => v.draftRadicalId == jin.id).toList();
      expect(jinVariants, hasLength(2));
      final ninben = jinVariants.firstWhere((v) => v.shape == '亻');
      expect(ninben.position, Position.hen);
      expect(ninben.isLocked, isTrue);
      final jinSelf = jinVariants.firstWhere((v) => v.shape == '人');
      expect(jinSelf.position, Position.unknown); // not seen directly

      // 木 should have: 木 (self-variant, seen directly)
      final kiVariants =
          variants.where((v) => v.draftRadicalId == ki.id).toList();
      expect(kiVariants, hasLength(1));
      expect(kiVariants.first.shape, '木');
      expect(kiVariants.first.position, Position.tsukuri);
      expect(kiVariants.first.isLocked, isTrue);
    });

    test('stroke count is null when master has no raw_kanjivg entry', () async {
      await putInScope(['清']);

      // 清 uses 氵(variant of 水) + 青, but 水 has no raw entry
      await kanjiVgRepo.insertBatch([
        fakeRawKanjiVg(
          importId: importId,
          character: '清',
          strokeCount: 11,
          components: fakeComponent(
            element: '清',
            children: [
              fakeComponent(
                element: '氵',
                position: 'left',
                variant: true,
                original: '水',
              ),
              fakeComponent(element: '青', position: 'right'),
            ],
          ),
        ),
      ]);

      await extractRadicals.call(
        kanjivgImportId: importId,
        kanjidicImportId: kanjidicImportId,
      );

      final mizu = await radicalRepo.getDraftRadicalByMasterSymbol('水');
      expect(mizu, isNotNull);
      expect(mizu!.strokeCount, isNull); // 水 not in raw entries
    });

    test('idempotent: re-running clears and recreates', () async {
      await putInScope(['休']);

      await kanjiVgRepo.insertBatch([
        fakeRawKanjiVg(
          importId: importId,
          character: '休',
          strokeCount: 6,
          components: fakeComponent(
            element: '休',
            children: [
              fakeComponent(element: '木', position: 'right'),
            ],
          ),
        ),
      ]);

      await extractRadicals.call(
        kanjivgImportId: importId,
        kanjidicImportId: kanjidicImportId,
      );
      final firstRun = await radicalRepo.getAllDraftRadicals();
      expect(firstRun, hasLength(1));

      // Run again — should produce same result.
      await extractRadicals.call(
        kanjivgImportId: importId,
        kanjidicImportId: kanjidicImportId,
      );
      final secondRun = await radicalRepo.getAllDraftRadicals();
      expect(secondRun, hasLength(1));
    });

    test('empty raw data produces empty draft tables', () async {
      final result = await extractRadicals.call(
        kanjivgImportId: importId,
        kanjidicImportId: kanjidicImportId,
      );

      expect(result.radicalCount, 0);
      expect(result.variantCount, 0);
      expect(result.scopeSize, 0);
      expect(await radicalRepo.getAllDraftRadicals(), isEmpty);
    });

    test('progressive: 語 and 吾 each contribute their direct children',
        () async {
      await putInScope(['語', '吾']);

      await kanjiVgRepo.insertBatch([
        fakeRawKanjiVg(
          importId: importId,
          character: '語',
          strokeCount: 14,
          components: fakeComponent(
            element: '語',
            children: [
              fakeComponent(element: '言', position: 'left'),
              fakeComponent(element: '吾', position: 'right'),
            ],
          ),
        ),
        fakeRawKanjiVg(
          importId: importId,
          character: '吾',
          strokeCount: 7,
          components: fakeComponent(
            element: '吾',
            children: [
              fakeComponent(element: '五', position: 'top'),
              fakeComponent(element: '口', position: 'bottom'),
            ],
          ),
        ),
        fakeRawKanjiVg(
          importId: importId,
          character: '言',
          strokeCount: 7,
          components: fakeComponent(element: '言', children: []),
        ),
        fakeRawKanjiVg(
          importId: importId,
          character: '五',
          strokeCount: 4,
          components: fakeComponent(element: '五', children: []),
        ),
        fakeRawKanjiVg(
          importId: importId,
          character: '口',
          strokeCount: 3,
          components: fakeComponent(element: '口', children: []),
        ),
      ]);

      final result = await extractRadicals.call(
        kanjivgImportId: importId,
        kanjidicImportId: kanjidicImportId,
      );

      // 語's children: 言, 吾
      // 吾's children: 五, 口
      // Total unique masters: 言, 吾, 五, 口
      expect(result.radicalCount, 4);

      final radicals = await radicalRepo.getAllDraftRadicals();
      final symbols = radicals.map((r) => r.masterSymbol).toSet();
      expect(symbols, containsAll(['言', '吾', '五', '口']));

      // Verify stroke counts are looked up correctly
      final go = radicals.firstWhere((r) => r.masterSymbol == '五');
      expect(go.strokeCount, 4);
      final kuchi = radicals.firstWhere((r) => r.masterSymbol == '口');
      expect(kuchi.strokeCount, 3);
    });
  });

  group('Ghost radical flattening', () {
    test('flattens ghost radical not in keep set', () async {
      // G is not in scope, not official, appears in only 1 kanji → ghost.
      // G's children A and B are in scope → kept.
      await putInScope(['X', 'A', 'B']);

      await kanjiVgRepo.insertBatch([
        fakeRawKanjiVg(
          importId: importId,
          character: 'X',
          strokeCount: 10,
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

      final result = await extractRadicals.call(
        kanjivgImportId: importId,
        kanjidicImportId: kanjidicImportId,
      );

      // G is ghost → flattened. Only A and B registered.
      final radicals = await radicalRepo.getAllDraftRadicals();
      final symbols = radicals.map((r) => r.masterSymbol).toSet();
      expect(symbols, containsAll(['A', 'B']));
      expect(symbols, isNot(contains('G')));
      expect(result.radicalCount, 2);
    });

    test('keeps official radical regardless of frequency', () async {
      // R is marked radical='general' in some entry, appears in only 1 kanji.
      // It should be kept because it's an official Kangxi radical.
      await putInScope(['X']);

      await kanjiVgRepo.insertBatch([
        fakeRawKanjiVg(
          importId: importId,
          character: 'X',
          strokeCount: 8,
          components: fakeComponent(
            element: 'X',
            children: [
              fakeComponent(element: 'R', position: 'left', radical: 'general'),
            ],
          ),
        ),
        fakeRawKanjiVg(
          importId: importId,
          character: 'R',
          strokeCount: 3,
          components: fakeComponent(element: 'R', children: []),
        ),
      ]);

      final result = await extractRadicals.call(
        kanjivgImportId: importId,
        kanjidicImportId: kanjidicImportId,
      );

      final radicals = await radicalRepo.getAllDraftRadicals();
      final symbols = radicals.map((r) => r.masterSymbol).toSet();
      expect(symbols, contains('R'));
      expect(result.radicalCount, 1);
    });

    test('keeps high-frequency component (>= 5 kanji)', () async {
      // H appears in 5 in-scope kanji → high frequency → kept.
      await putInScope(['V', 'W', 'X', 'Y', 'Z']);

      await kanjiVgRepo.insertBatch([
        for (final ch in ['V', 'W', 'X', 'Y', 'Z'])
          fakeRawKanjiVg(
            importId: importId,
            character: ch,
            strokeCount: 8,
            components: fakeComponent(
              element: ch,
              children: [fakeComponent(element: 'H', position: 'left')],
            ),
          ),
        fakeRawKanjiVg(
          importId: importId,
          character: 'H',
          strokeCount: 4,
          components: fakeComponent(element: 'H', children: []),
        ),
      ]);

      final result = await extractRadicals.call(
        kanjivgImportId: importId,
        kanjidicImportId: kanjidicImportId,
      );

      final radicals = await radicalRepo.getAllDraftRadicals();
      final symbols = radicals.map((r) => r.masterSymbol).toSet();
      expect(symbols, contains('H'));
      expect(result.radicalCount, 1);
    });

    test('flattens low-frequency non-scope non-official element', () async {
      // L appears in only 4 kanji (below threshold of 5), not in scope, not
      // official → ghost. L's children C and D are in scope → kept.
      await putInScope(['X', 'Y', 'C', 'D']);

      await kanjiVgRepo.insertBatch([
        fakeRawKanjiVg(
          importId: importId,
          character: 'X',
          strokeCount: 8,
          components: fakeComponent(
            element: 'X',
            children: [fakeComponent(element: 'L', position: 'right')],
          ),
        ),
        fakeRawKanjiVg(
          importId: importId,
          character: 'Y',
          strokeCount: 9,
          components: fakeComponent(
            element: 'Y',
            children: [fakeComponent(element: 'L', position: 'left')],
          ),
        ),
        fakeRawKanjiVg(
          importId: importId,
          character: 'L',
          strokeCount: 5,
          components: fakeComponent(
            element: 'L',
            children: [
              fakeComponent(element: 'C', position: 'top'),
              fakeComponent(element: 'D', position: 'bottom'),
            ],
          ),
        ),
        fakeRawKanjiVg(
          importId: importId,
          character: 'C',
          strokeCount: 3,
          components: fakeComponent(element: 'C', children: []),
        ),
        fakeRawKanjiVg(
          importId: importId,
          character: 'D',
          strokeCount: 4,
          components: fakeComponent(element: 'D', children: []),
        ),
      ]);

      final result = await extractRadicals.call(
        kanjivgImportId: importId,
        kanjidicImportId: kanjidicImportId,
      );

      final radicals = await radicalRepo.getAllDraftRadicals();
      final symbols = radicals.map((r) => r.masterSymbol).toSet();
      expect(symbols, containsAll(['C', 'D']));
      expect(symbols, isNot(contains('L')));
      // C and D appear from both X and Y flattening, so 2 unique radicals.
      expect(result.radicalCount, 2);
    });

    test('recursive ghost flattening', () async {
      // G1 is ghost → flatten to [A, G2]
      // G2 is ghost → flatten to [B, C]
      // Final effective children of X: [A, B, C]
      await putInScope(['X', 'A', 'B', 'C']);

      await kanjiVgRepo.insertBatch([
        fakeRawKanjiVg(
          importId: importId,
          character: 'X',
          strokeCount: 10,
          components: fakeComponent(
            element: 'X',
            children: [
              fakeComponent(element: 'G1', position: 'right'),
            ],
          ),
        ),
        fakeRawKanjiVg(
          importId: importId,
          character: 'G1',
          strokeCount: 6,
          components: fakeComponent(
            element: 'G1',
            children: [
              fakeComponent(element: 'A', position: 'left'),
              fakeComponent(element: 'G2', position: 'right'),
            ],
          ),
        ),
        fakeRawKanjiVg(
          importId: importId,
          character: 'G2',
          strokeCount: 4,
          components: fakeComponent(
            element: 'G2',
            children: [
              fakeComponent(element: 'B', position: 'top'),
              fakeComponent(element: 'C', position: 'bottom'),
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
          strokeCount: 2,
          components: fakeComponent(element: 'B', children: []),
        ),
        fakeRawKanjiVg(
          importId: importId,
          character: 'C',
          strokeCount: 2,
          components: fakeComponent(element: 'C', children: []),
        ),
      ]);

      final result = await extractRadicals.call(
        kanjivgImportId: importId,
        kanjidicImportId: kanjidicImportId,
      );

      final radicals = await radicalRepo.getAllDraftRadicals();
      final symbols = radicals.map((r) => r.masterSymbol).toSet();
      expect(symbols, containsAll(['A', 'B', 'C']));
      expect(symbols, isNot(contains('G1')));
      expect(symbols, isNot(contains('G2')));
      expect(result.radicalCount, 3);
    });

    test('unflattenable ghost becomes leaf radical (no KanjiVG entry)',
        () async {
      // G has no raw_kanjivg entry → unflattenable → kept as leaf.
      await putInScope(['X']);

      await kanjiVgRepo.insertBatch([
        fakeRawKanjiVg(
          importId: importId,
          character: 'X',
          strokeCount: 8,
          components: fakeComponent(
            element: 'X',
            children: [
              fakeComponent(element: 'G', position: 'right'),
            ],
          ),
        ),
        // No entry for G.
      ]);

      final result = await extractRadicals.call(
        kanjivgImportId: importId,
        kanjidicImportId: kanjidicImportId,
      );

      // G is unflattenable → kept as leaf radical.
      final radicals = await radicalRepo.getAllDraftRadicals();
      final symbols = radicals.map((r) => r.masterSymbol).toSet();
      expect(symbols, contains('G'));
      expect(result.radicalCount, 1);
      // Should have a low-severity warning about unflattenable ghost.
      expect(
        result.warnings.any(
          (w) => w.message.contains('unflattenable') &&
              w.message.contains('G'),
        ),
        isTrue,
      );
    });

    test('ghost with no children becomes leaf radical', () async {
      // G has a KanjiVG entry but empty children → unflattenable → leaf.
      await putInScope(['X']);

      await kanjiVgRepo.insertBatch([
        fakeRawKanjiVg(
          importId: importId,
          character: 'X',
          strokeCount: 8,
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
          strokeCount: 3,
          components: fakeComponent(element: 'G', children: []),
        ),
      ]);

      final result = await extractRadicals.call(
        kanjivgImportId: importId,
        kanjidicImportId: kanjidicImportId,
      );

      final radicals = await radicalRepo.getAllDraftRadicals();
      final symbols = radicals.map((r) => r.masterSymbol).toSet();
      expect(symbols, contains('G'));
      expect(result.radicalCount, 1);
      expect(
        result.warnings.any(
          (w) => w.message.contains('unflattenable') &&
              w.message.contains('no children'),
        ),
        isTrue,
      );
    });
  });
}
