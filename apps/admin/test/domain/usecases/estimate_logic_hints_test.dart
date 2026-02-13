import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:kanji_craft_admin/data/database/admin_database.dart';
import 'package:kanji_craft_admin/data/repositories/kanji_component/drift_kanji_component_repository.dart';
import 'package:kanji_craft_admin/data/repositories/kanji_component_review/drift_kanji_component_review_repository.dart';
import 'package:kanji_craft_admin/data/repositories/radical/drift_radical_repository.dart';
import 'package:kanji_craft_admin/data/repositories/raw_kanjidic/drift_raw_kanjidic_repository.dart';
import 'package:kanji_craft_admin/domain/entities/import_source.dart';
import 'package:kanji_craft_admin/domain/entities/warning.dart';
import 'package:kanji_craft_admin/domain/usecases/estimate_logic_hints.dart';
import 'package:kanji_craft_core/kanji_craft_core.dart';

import '../../helpers/admin_fixtures.dart';
import '../../helpers/admin_test_helpers.dart';

void main() {
  late AdminDatabase db;
  late DriftKanjiComponentRepository componentRepo;
  late DriftRawKanjidicRepository kanjidicRepo;
  late DriftKanjiComponentReviewRepository reviewRepo;
  late DriftRadicalRepository radicalRepo;
  late EstimateLogicHints estimateLogicHints;
  late int kanjidicImportId;

  /// Insert a draft kanji row and return its auto-generated ID.
  /// EstimateLogicHints resolves kanji characters via draft tables.
  Future<int> insertDraftKanji(String character) async {
    return db.into(db.draftKanjiEntries).insert(
          DraftKanjiEntriesCompanion.insert(
            character: character,
            strokeCount: 4,
            frequencyRank: 100,
          ),
        );
  }

  /// Insert a draft radical row and return its auto-generated ID.
  /// EstimateLogicHints resolves radical symbols via draft tables.
  /// Pass [svgFileName] to simulate a radical that has an SVG file.
  Future<int> insertDraftRadical(
    String masterSymbol, {
    String? svgFileName,
  }) async {
    return db.into(db.draftRadicalEntries).insert(
          DraftRadicalEntriesCompanion.insert(masterSymbol: masterSymbol)
              .copyWith(svgFileName: Value(svgFileName)),
        );
  }

  /// Insert a kanji component and return its auto-generated ID.
  Future<int> insertComponent({
    required int kanjiId,
    required int radicalId,
    Position position = Position.unknown,
  }) async {
    return db.into(db.kanjiComponentEntries).insert(
          KanjiComponentEntriesCompanion.insert(
            kanjiId: kanjiId,
            radicalId: radicalId,
            position: position,
            logicHint: LogicHint.semantic, // default, will be overwritten
            radicalType: RadicalType.component,
          ),
        );
  }

  setUp(() async {
    resetFixtureIds();
    db = createTestDatabase();
    final repos = createReposFromDb(db);
    componentRepo = repos.kanjiComponents;
    kanjidicRepo = repos.kanjidic;
    reviewRepo = repos.reviews;
    radicalRepo = repos.radicals;

    estimateLogicHints = EstimateLogicHints(
      kanjiComponentRepository: componentRepo,
      rawKanjidicRepository: kanjidicRepo,
      reviewRepository: reviewRepo,
      radicalRepository: radicalRepo,
    );

    // Create parent import for raw_kanjidic.
    final import = await repos.imports.create(
      source: ImportSource.kanjidic,
      sourceVersion: '1.0',
    );
    kanjidicImportId = import.id;
  });

  tearDown(() => db.close());

  group('EstimateLogicHints', () {
    test('phonetic match — onyomi overlap → phonetic, 0.9', () async {
      // Setup: 忙 (BOU) contains 亡 (BOU) — onyomi overlap.
      final kanjiId = await insertDraftKanji('忙');
      final radicalId = await insertDraftRadical('亡');
      await insertComponent(kanjiId: kanjiId, radicalId: radicalId);

      // Seed raw_kanjidic with matching onyomi.
      await kanjidicRepo.insertBatch([
        fakeRawKanjidic(
          importId: kanjidicImportId,
          literal: '忙',
          readings: fakeReadings(jaOn: ['ボウ', 'モウ'], jaKun: ['いそが.しい']),
        ),
        fakeRawKanjidic(
          importId: kanjidicImportId,
          literal: '亡',
          readings: fakeReadings(jaOn: ['ボウ', 'モウ'], jaKun: ['な.い']),
        ),
      ]);

      final result = await estimateLogicHints.call(kanjidicImportId);

      expect(result.phoneticCount, 1);
      expect(result.semanticCount, 0);
      expect(result.skippedCount, 0);

      // Verify component updated to phonetic.
      final components = await componentRepo.getAll();
      expect(components.first.logicHint, LogicHint.phonetic);

      // Verify review row created.
      final review = await reviewRepo.getByComponentId(components.first.id);
      expect(review, isNotNull);
      expect(review!.verificationStatus, VerificationStatus.draft);
      expect(review.aiConfidence, 0.9);
    });

    test('semantic no-match — radical has onyomi, none overlap → semantic, 0.6',
        () async {
      // Setup: 想 (SOU) contains 木 (MOKU/BOKU) — no onyomi overlap.
      final kanjiId = await insertDraftKanji('想');
      final radicalId = await insertDraftRadical('木');
      await insertComponent(kanjiId: kanjiId, radicalId: radicalId);

      await kanjidicRepo.insertBatch([
        fakeRawKanjidic(
          importId: kanjidicImportId,
          literal: '想',
          readings: fakeReadings(jaOn: ['ソウ', 'ソ'], jaKun: []),
        ),
        fakeRawKanjidic(
          importId: kanjidicImportId,
          literal: '木',
          readings: fakeReadings(jaOn: ['モク', 'ボク'], jaKun: ['き']),
        ),
      ]);

      final result = await estimateLogicHints.call(kanjidicImportId);

      expect(result.phoneticCount, 0);
      expect(result.semanticCount, 1);

      final components = await componentRepo.getAll();
      expect(components.first.logicHint, LogicHint.semantic);

      final review = await reviewRepo.getByComponentId(components.first.id);
      expect(review!.aiConfidence, 0.6);
    });

    test('ghost radical (no SVG) — not in raw_kanjidic → semantic, 0.2, high severity',
        () async {
      // Setup: kanji exists in kanjidic, but radical does not and has no SVG.
      final kanjiId = await insertDraftKanji('忙');
      final radicalId = await insertDraftRadical('⺖'); // no SVG
      await insertComponent(kanjiId: kanjiId, radicalId: radicalId);

      await kanjidicRepo.insertBatch([
        fakeRawKanjidic(
          importId: kanjidicImportId,
          literal: '忙',
          readings: fakeReadings(jaOn: ['ボウ'], jaKun: []),
        ),
        // ⺖ is NOT in raw_kanjidic
      ]);

      final result = await estimateLogicHints.call(kanjidicImportId);

      expect(result.semanticCount, 1);
      expect(result.phoneticCount, 0);

      final review = await reviewRepo.getByComponentId(
        (await componentRepo.getAll()).first.id,
      );
      expect(review!.aiConfidence, 0.2);

      // Should have a high-severity warning (true ghost: no kanjidic + no SVG).
      final ghostWarning = result.warnings.firstWhere(
        (w) => w.message.contains('⺖') && w.message.contains('not found'),
      );
      expect(ghostWarning.severity, WarningSeverity.high);
    });

    test('not in kanjidic but has SVG → semantic, 0.2, low severity',
        () async {
      // Setup: radical has an SVG file but no raw_kanjidic entry.
      final kanjiId = await insertDraftKanji('忙');
      final radicalId = await insertDraftRadical(
        '⺖',
        svgFileName: '02e96.svg',
      );
      await insertComponent(kanjiId: kanjiId, radicalId: radicalId);

      await kanjidicRepo.insertBatch([
        fakeRawKanjidic(
          importId: kanjidicImportId,
          literal: '忙',
          readings: fakeReadings(jaOn: ['ボウ'], jaKun: []),
        ),
        // ⺖ is NOT in raw_kanjidic, but has SVG
      ]);

      final result = await estimateLogicHints.call(kanjidicImportId);

      expect(result.semanticCount, 1);
      expect(result.phoneticCount, 0);

      final review = await reviewRepo.getByComponentId(
        (await componentRepo.getAll()).first.id,
      );
      expect(review!.aiConfidence, 0.2);

      // Should have a low-severity warning (has SVG, just not in kanjidic).
      final warning = result.warnings.firstWhere(
        (w) => w.message.contains('⺖') && w.message.contains('not found'),
      );
      expect(warning.severity, WarningSeverity.low);
    });

    test('kanji has no onyomi → semantic, 0.5', () async {
      // Setup: kun-only kanji.
      final kanjiId = await insertDraftKanji('畑');
      final radicalId = await insertDraftRadical('火');
      await insertComponent(kanjiId: kanjiId, radicalId: radicalId);

      await kanjidicRepo.insertBatch([
        fakeRawKanjidic(
          importId: kanjidicImportId,
          literal: '畑',
          readings: fakeReadings(jaOn: [], jaKun: ['はた', 'はたけ']),
        ),
        fakeRawKanjidic(
          importId: kanjidicImportId,
          literal: '火',
          readings: fakeReadings(jaOn: ['カ'], jaKun: ['ひ']),
        ),
      ]);

      final result = await estimateLogicHints.call(kanjidicImportId);

      expect(result.semanticCount, 1);
      expect(result.phoneticCount, 0);

      final review = await reviewRepo.getByComponentId(
        (await componentRepo.getAll()).first.id,
      );
      expect(review!.aiConfidence, 0.5);

      // Should have a warning about no onyomi.
      expect(
        result.warnings.any(
          (w) => w.message.contains('畑') && w.message.contains('no onyomi'),
        ),
        isTrue,
      );
    });

    test('idempotent re-run — existing reviews are skipped', () async {
      final kanjiId = await insertDraftKanji('忙');
      final radicalId = await insertDraftRadical('亡');
      await insertComponent(kanjiId: kanjiId, radicalId: radicalId);

      await kanjidicRepo.insertBatch([
        fakeRawKanjidic(
          importId: kanjidicImportId,
          literal: '忙',
          readings: fakeReadings(jaOn: ['ボウ'], jaKun: []),
        ),
        fakeRawKanjidic(
          importId: kanjidicImportId,
          literal: '亡',
          readings: fakeReadings(jaOn: ['ボウ'], jaKun: []),
        ),
      ]);

      // First run.
      final result1 = await estimateLogicHints.call(kanjidicImportId);
      expect(result1.phoneticCount, 1);
      expect(result1.skippedCount, 0);

      // Second run — should skip the existing review.
      final result2 = await estimateLogicHints.call(kanjidicImportId);
      expect(result2.phoneticCount, 0);
      expect(result2.skippedCount, 1);

      // Should still have only 1 review row.
      final reviewCount = await reviewRepo.count();
      expect(reviewCount, 1);
    });

    test('empty components — no-op', () async {
      // No components inserted.
      final result = await estimateLogicHints.call(kanjidicImportId);

      expect(result.componentCount, 0);
      expect(result.phoneticCount, 0);
      expect(result.semanticCount, 0);
      expect(result.skippedCount, 0);
      expect(result.warnings, isEmpty);
    });

    test('JLPT-mapped component with low confidence → high severity warning',
        () async {
      // Setup: JLPT kanji with a ghost radical → confidence 0.2.
      final kanjiId = await insertDraftKanji('海');
      final radicalId = await insertDraftRadical('⺡'); // custom radical
      await insertComponent(kanjiId: kanjiId, radicalId: radicalId);

      await kanjidicRepo.insertBatch([
        fakeRawKanjidic(
          importId: kanjidicImportId,
          literal: '海',
          jlpt: 3,
          readings: fakeReadings(jaOn: ['カイ'], jaKun: ['うみ']),
        ),
        // ⺡ not in kanjidic
      ]);

      final result = await estimateLogicHints.call(kanjidicImportId);

      expect(result.semanticCount, 1);

      // Find the high-severity warning.
      final highWarnings =
          result.warnings.where((w) => w.severity == WarningSeverity.high);
      expect(highWarnings, isNotEmpty);
      expect(
        highWarnings.any((w) => w.message.contains('JLPT-mapped')),
        isTrue,
      );
    });

    test('multiple components processed correctly', () async {
      // Setup: 2 kanji, each with 1 component.
      final kanji1Id = await insertDraftKanji('忙');
      final kanji2Id = await insertDraftKanji('想');
      final radical1Id = await insertDraftRadical('亡');
      final radical2Id = await insertDraftRadical('心');

      await insertComponent(kanjiId: kanji1Id, radicalId: radical1Id);
      await insertComponent(kanjiId: kanji2Id, radicalId: radical2Id);

      await kanjidicRepo.insertBatch([
        fakeRawKanjidic(
          importId: kanjidicImportId,
          literal: '忙',
          readings: fakeReadings(jaOn: ['ボウ'], jaKun: []),
        ),
        fakeRawKanjidic(
          importId: kanjidicImportId,
          literal: '亡',
          readings: fakeReadings(jaOn: ['ボウ'], jaKun: []),
        ),
        fakeRawKanjidic(
          importId: kanjidicImportId,
          literal: '想',
          readings: fakeReadings(jaOn: ['ソウ'], jaKun: []),
        ),
        fakeRawKanjidic(
          importId: kanjidicImportId,
          literal: '心',
          readings: fakeReadings(jaOn: ['シン'], jaKun: ['こころ']),
        ),
      ]);

      final result = await estimateLogicHints.call(kanjidicImportId);

      expect(result.componentCount, 2);
      // 忙 + 亡: onyomi match → phonetic
      // 想 + 心: no overlap → semantic
      expect(result.phoneticCount, 1);
      expect(result.semanticCount, 1);

      final reviewCount = await reviewRepo.count();
      expect(reviewCount, 2);
    });

    test('checkExistingResult returns null when no reviews', () async {
      final result = await estimateLogicHints.checkExistingResult();
      expect(result, isNull);
    });

    test('checkExistingResult returns summary when reviews exist', () async {
      final kanjiId = await insertDraftKanji('忙');
      final radicalId = await insertDraftRadical('亡');
      await insertComponent(kanjiId: kanjiId, radicalId: radicalId);

      await kanjidicRepo.insertBatch([
        fakeRawKanjidic(
          importId: kanjidicImportId,
          literal: '忙',
          readings: fakeReadings(jaOn: ['ボウ'], jaKun: []),
        ),
        fakeRawKanjidic(
          importId: kanjidicImportId,
          literal: '亡',
          readings: fakeReadings(jaOn: ['ボウ'], jaKun: []),
        ),
      ]);

      await estimateLogicHints.call(kanjidicImportId);

      final result = await estimateLogicHints.checkExistingResult();
      expect(result, isNotNull);
      expect(result, contains('1 reviews'));
      expect(result, contains('1 components'));
    });
  });
}
