import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kanji_craft_admin/data/database/admin_database.dart';
import 'package:kanji_craft_admin/data/repositories/radical/drift_radical_repository.dart';
import 'package:kanji_craft_admin/data/repositories/raw_kanjidic/drift_raw_kanjidic_repository.dart';
import 'package:kanji_craft_admin/data/services/csv_service.dart';
import 'package:kanji_craft_admin/domain/entities/import_source.dart';
import 'package:kanji_craft_admin/domain/usecases/export_radical_mnemonics.dart';

import '../../helpers/admin_fixtures.dart';
import '../../helpers/admin_test_helpers.dart';

void main() {
  late AdminDatabase db;
  late DriftRadicalRepository radicalRepo;
  late DriftRawKanjidicRepository kanjidicRepo;
  late CsvService csvService;
  late ExportRadicalMnemonics exportRadicalMnemonics;
  late Directory tempDir;
  late int kanjidicImportId;

  setUp(() async {
    resetFixtureIds();
    db = createTestDatabase();
    final repos = createReposFromDb(db);
    radicalRepo = repos.radicals;
    kanjidicRepo = repos.kanjidic;
    csvService = CsvService();
    exportRadicalMnemonics = ExportRadicalMnemonics(
      radicalRepository: radicalRepo,
      rawKanjidicRepository: kanjidicRepo,
      csvService: csvService,
    );
    tempDir = Directory.systemTemp.createTempSync('export_test_');

    // Create KANJIDIC import.
    final imp = await repos.imports.create(
      source: ImportSource.kanjidic,
      sourceVersion: '1.0',
    );
    kanjidicImportId = imp.id;
  });

  tearDown(() {
    db.close();
    if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
  });

  group('ExportRadicalMnemonics', () {
    test('exports CSV with correct headers and radical data', () async {
      // Insert KANJIDIC entry for 木.
      await kanjidicRepo.insertBatch([
        fakeRawKanjidic(
          importId: kanjidicImportId,
          literal: '木',
          meanings: {
            'en': ['tree', 'wood'],
            'es': ['árbol', 'madera'],
          },
        ),
      ]);

      // Insert draft radical.
      await radicalRepo.upsertDraftRadical(fakeDraftRadical(
        id: 0,
        masterSymbol: '木',
        strokeCount: 4,
        isOfficial: true,
        minJlptLevel: 5,
        minGrade: 1,
        impactScore: 100,
      ));

      final result = await exportRadicalMnemonics.call(
        outputDir: tempDir.path,
        kanjidicImportId: kanjidicImportId,
        batchSize: 150,
        offset: 0,
      );

      expect(result.rowCount, 1);
      expect(result.filePath, contains('batch1_radical_mnemonics_1.csv'));

      // Parse the exported CSV.
      final content = await File(result.filePath).readAsString();
      final parsed = csvService.parseCsv(
        content: content,
        requiredHeaders: ExportRadicalMnemonics.headers,
      );

      expect(parsed.rows.length, 1);
      final row = parsed.rows.first;
      expect(row['master_symbol'], '木');
      expect(row['stroke_count'], '4');
      expect(row['is_official'], 'true');
      expect(row['min_jlpt_level'], '5');
      expect(row['min_grade'], '1');
      expect(row['en_name'], 'tree');
      expect(row['es_name'], 'árbol');
      expect(row['en_system_mnemonic'], '');
      expect(row['es_system_mnemonic'], '');
      expect(row['en_search_tags'], '');
      expect(row['es_search_tags'], '');
    });

    test('resolves name from KANJIDIC meanings', () async {
      await kanjidicRepo.insertBatch([
        fakeRawKanjidic(
          importId: kanjidicImportId,
          literal: '水',
          meanings: {
            'en': ['water'],
          },
        ),
      ]);

      await radicalRepo.upsertDraftRadical(fakeDraftRadical(
        id: 0,
        masterSymbol: '水',
        strokeCount: 4,
      ));

      final result = await exportRadicalMnemonics.call(
        outputDir: tempDir.path,
        kanjidicImportId: kanjidicImportId,
        batchSize: 150,
        offset: 0,
      );

      final content = await File(result.filePath).readAsString();
      final parsed = csvService.parseCsv(
        content: content,
        requiredHeaders: ExportRadicalMnemonics.headers,
      );

      expect(parsed.rows.first['en_name'], 'water');
      // No Spanish meaning in KANJIDIC → falls back to English name.
      expect(parsed.rows.first['es_name'], 'water');
    });

    test('uses masterSymbol as fallback for ghost radicals', () async {
      // No KANJIDIC entry for 粦 (ghost radical).
      await radicalRepo.upsertDraftRadical(fakeDraftRadical(
        id: 0,
        masterSymbol: '粦',
        strokeCount: null,
        isOfficial: false,
      ));

      final result = await exportRadicalMnemonics.call(
        outputDir: tempDir.path,
        kanjidicImportId: kanjidicImportId,
        batchSize: 150,
        offset: 0,
      );

      expect(result.warnings.length, 1);
      expect(result.warnings.first.message, contains('Ghost radical'));

      final content = await File(result.filePath).readAsString();
      final parsed = csvService.parseCsv(
        content: content,
        requiredHeaders: ExportRadicalMnemonics.headers,
      );

      expect(parsed.rows.first['en_name'], '粦');
      expect(parsed.rows.first['es_name'], '粦');
    });

    test('pre-creates i18n rows', () async {
      await kanjidicRepo.insertBatch([
        fakeRawKanjidic(
          importId: kanjidicImportId,
          literal: '木',
          meanings: {'en': ['tree']},
        ),
      ]);
      await radicalRepo.upsertDraftRadical(fakeDraftRadical(
        id: 0,
        masterSymbol: '木',
      ));

      await exportRadicalMnemonics.call(
        outputDir: tempDir.path,
        kanjidicImportId: kanjidicImportId,
        batchSize: 150,
        offset: 0,
      );

      final i18nRows = await radicalRepo.getAllDraftRadicalI18n();
      expect(i18nRows.length, 2); // en + es
      expect(i18nRows.any((r) => r.langCode == 'en' && r.name == 'tree'),
          isTrue);
      expect(i18nRows.any((r) => r.langCode == 'es' && r.name == 'tree'),
          isTrue);
    });

    test('pagination works correctly', () async {
      await kanjidicRepo.insertBatch([
        fakeRawKanjidic(
          importId: kanjidicImportId,
          literal: '木',
          meanings: {'en': ['tree']},
        ),
        fakeRawKanjidic(
          importId: kanjidicImportId,
          literal: '水',
          meanings: {'en': ['water']},
        ),
        fakeRawKanjidic(
          importId: kanjidicImportId,
          literal: '火',
          meanings: {'en': ['fire']},
        ),
      ]);

      for (final (symbol, jlpt) in [('木', 5), ('水', 4), ('火', 3)]) {
        await radicalRepo.upsertDraftRadical(fakeDraftRadical(
          id: 0,
          masterSymbol: symbol,
          minJlptLevel: jlpt,
        ));
      }

      // First batch: limit 2.
      final result1 = await exportRadicalMnemonics.call(
        outputDir: tempDir.path,
        kanjidicImportId: kanjidicImportId,
        batchSize: 2,
        offset: 0,
      );
      expect(result1.rowCount, 2);
      expect(result1.totalCount, 3);

      // Second batch: offset 2.
      final result2 = await exportRadicalMnemonics.call(
        outputDir: tempDir.path,
        kanjidicImportId: kanjidicImportId,
        batchSize: 2,
        offset: 2,
      );
      expect(result2.rowCount, 1);
    });

    test('returns empty result when no radicals', () async {
      final result = await exportRadicalMnemonics.call(
        outputDir: tempDir.path,
        kanjidicImportId: kanjidicImportId,
        batchSize: 150,
        offset: 0,
      );

      expect(result.rowCount, 0);
      expect(result.filePath, '');
    });

    test('checkExistingExportResult returns null when no i18n rows', () async {
      final result = await exportRadicalMnemonics.checkExistingExportResult();
      expect(result, isNull);
    });

    test('checkExistingExportResult returns summary when i18n rows exist',
        () async {
      final radical = await radicalRepo.upsertDraftRadical(fakeDraftRadical(
        id: 0,
        masterSymbol: '木',
      ));
      await radicalRepo.upsertDraftRadicalI18n(fakeDraftRadicalI18n(
        id: 0,
        draftRadicalId: radical.id,
        langCode: 'en',
        name: 'tree',
      ));

      final result = await exportRadicalMnemonics.checkExistingExportResult();
      expect(result, isNotNull);
      expect(result, contains('1 i18n rows'));
      expect(result, contains('0 with mnemonics'));
    });
  });
}
