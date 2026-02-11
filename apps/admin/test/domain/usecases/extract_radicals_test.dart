import 'package:flutter_test/flutter_test.dart';
import 'package:kanji_craft_admin/data/database/admin_database.dart';
import 'package:kanji_craft_admin/data/repositories/radical/drift_radical_repository.dart';
import 'package:kanji_craft_admin/data/repositories/raw_kanjivg/drift_raw_kanjivg_repository.dart';
import 'package:kanji_craft_admin/data/services/radical_scanner.dart';
import 'package:kanji_craft_admin/domain/entities/import_source.dart';
import 'package:kanji_craft_admin/domain/usecases/extract_radicals.dart';
import 'package:kanji_craft_core/kanji_craft_core.dart';

import '../../helpers/admin_fixtures.dart';
import '../../helpers/admin_test_helpers.dart';

void main() {
  late AdminDatabase db;
  late DriftRawKanjiVgRepository kanjiVgRepo;
  late DriftRadicalRepository radicalRepo;
  late ExtractRadicals extractRadicals;
  late int importId;

  setUp(() async {
    resetFixtureIds();
    db = createTestDatabase();
    final repos = createReposFromDb(db);
    kanjiVgRepo = repos.kanjiVg;
    radicalRepo = repos.radicals;
    extractRadicals = ExtractRadicals(
      rawKanjiVgRepository: kanjiVgRepo,
      radicalRepository: radicalRepo,
      scanner: RadicalScanner(),
    );

    // Create parent import.
    final imp = await repos.imports.create(
      source: ImportSource.kanjivg,
      sourceVersion: '1.0',
    );
    importId = imp.id;
  });

  tearDown(() => db.close());

  group('ExtractRadicals', () {
    test('extracts radicals and variants from 休 (亻+木)', () async {
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

      final result = await extractRadicals.call(importId);

      expect(result.radicalCount, 2);

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

      await extractRadicals.call(importId);

      final mizu = await radicalRepo.getDraftRadicalByMasterSymbol('水');
      expect(mizu, isNotNull);
      expect(mizu!.strokeCount, isNull); // 水 not in raw entries
    });

    test('idempotent: re-running clears and recreates', () async {
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

      await extractRadicals.call(importId);
      final firstRun = await radicalRepo.getAllDraftRadicals();
      expect(firstRun, hasLength(1));

      // Run again — should produce same result.
      await extractRadicals.call(importId);
      final secondRun = await radicalRepo.getAllDraftRadicals();
      expect(secondRun, hasLength(1));
    });

    test('empty raw data produces empty draft tables', () async {
      final result = await extractRadicals.call(importId);

      expect(result.radicalCount, 0);
      expect(result.variantCount, 0);
      expect(await radicalRepo.getAllDraftRadicals(), isEmpty);
    });

    test('progressive: 語 and 吾 each contribute their direct children',
        () async {
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

      final result = await extractRadicals.call(importId);

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
}
