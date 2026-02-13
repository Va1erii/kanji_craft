import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kanji_craft_admin/data/database/admin_database.dart';
import 'package:kanji_craft_admin/data/repositories/radical/drift_radical_repository.dart';
import 'package:kanji_craft_admin/data/repositories/raw_kanjidic/drift_raw_kanjidic_repository.dart';
import 'package:kanji_craft_admin/data/services/csv_service.dart';
import 'package:kanji_craft_admin/domain/entities/import_source.dart';
import 'package:kanji_craft_admin/domain/entities/warning.dart';
import 'package:kanji_craft_admin/domain/usecases/export_radical_mnemonics.dart';
import 'package:kanji_craft_admin/domain/usecases/import_radical_mnemonics.dart';

import '../../helpers/admin_fixtures.dart';
import '../../helpers/admin_test_helpers.dart';

void main() {
  late AdminDatabase db;
  late DriftRadicalRepository radicalRepo;
  late DriftRawKanjidicRepository kanjidicRepo;
  late CsvService csvService;
  late ExportRadicalMnemonics exportRadicalMnemonics;
  late ImportRadicalMnemonics importRadicalMnemonics;
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
    importRadicalMnemonics = ImportRadicalMnemonics(
      radicalRepository: radicalRepo,
      csvService: csvService,
    );
    tempDir = Directory.systemTemp.createTempSync('import_test_');

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

  /// Helper: exports a CSV, then enriches it with mnemonics and saves.
  Future<String> exportAndEnrich({
    required Map<String, (String enMnemonic, String esMnemonic)> mnemonics,
    Map<String, (String enTags, String esTags)> tags = const {},
  }) async {
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

    // Write enriched CSV.
    final enrichedPath = '${tempDir.path}/enriched.csv';
    final enrichedRows = <List<String>>[];
    for (final row in parsed.rows) {
      final symbol = row['master_symbol']!;
      final m = mnemonics[symbol];
      final t = tags[symbol];
      enrichedRows.add([
        row['radical_id']!,
        row['master_symbol']!,
        row['stroke_count']!,
        row['is_official']!,
        row['min_jlpt_level']!,
        row['min_grade']!,
        row['en_name']!,
        row['es_name']!,
        m?.$1 ?? '',
        m?.$2 ?? '',
        t?.$1 ?? '',
        t?.$2 ?? '',
      ]);
    }
    await csvService.writeCsv(
      filePath: enrichedPath,
      headers: ExportRadicalMnemonics.headers,
      rows: enrichedRows,
    );

    return enrichedPath;
  }

  group('ImportRadicalMnemonics', () {
    test('imports valid mnemonics and updates i18n rows', () async {
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

      final enrichedPath = await exportAndEnrich(
        mnemonics: {
          '木': (
            'A tall tree growing from the ground',
            'Un árbol alto creciendo del suelo',
          ),
        },
        tags: {
          '木': ('tree|wood|forest', 'árbol|madera'),
        },
      );

      final result = await importRadicalMnemonics.call(enrichedPath);

      expect(result.importedCount, 1);
      expect(result.skippedCount, 0);
      expect(result.rejectedCount, 0);

      // Verify i18n rows were updated.
      final i18nRows = await radicalRepo.getAllDraftRadicalI18n();
      final enRow = i18nRows.firstWhere((r) => r.langCode == 'en');
      expect(enRow.systemMnemonic, 'A tall tree growing from the ground');
      expect(enRow.searchTags, ['tree', 'wood', 'forest']);

      final esRow = i18nRows.firstWhere((r) => r.langCode == 'es');
      expect(esRow.systemMnemonic, 'Un árbol alto creciendo del suelo');
      expect(esRow.searchTags, ['árbol', 'madera']);
    });

    test('rejects rows with comma in search tags', () async {
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

      // Export and manually write CSV with commas in tags.
      await exportRadicalMnemonics.call(
        outputDir: tempDir.path,
        kanjidicImportId: kanjidicImportId,
        batchSize: 150,
        offset: 0,
      );

      final radical = (await radicalRepo.getAllDraftRadicals()).first;
      final enrichedPath = '${tempDir.path}/bad_tags.csv';
      await csvService.writeCsv(
        filePath: enrichedPath,
        headers: ExportRadicalMnemonics.headers,
        rows: [
          [
            radical.id.toString(),
            '木',
            '4',
            'true',
            '',
            '',
            'tree',
            'tree',
            'A tall tree growing from the ground',
            'Un árbol alto',
            'tree, wood, forest', // commas — should be rejected
            'árbol|madera',
          ],
        ],
      );

      final result = await importRadicalMnemonics.call(enrichedPath);

      expect(result.rejectedCount, greaterThan(0));
      expect(
        result.warnings.any((w) =>
            w.message.contains('commas') &&
            w.severity == WarningSeverity.high),
        isTrue,
      );
    });

    test('rejects rows with invalid radical_id', () async {
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
      // Pre-create i18n.
      await exportRadicalMnemonics.call(
        outputDir: tempDir.path,
        kanjidicImportId: kanjidicImportId,
        batchSize: 150,
        offset: 0,
      );

      final enrichedPath = '${tempDir.path}/bad_id.csv';
      await csvService.writeCsv(
        filePath: enrichedPath,
        headers: ExportRadicalMnemonics.headers,
        rows: [
          [
            'abc', // invalid ID
            '木',
            '4',
            'true',
            '',
            '',
            'tree',
            'tree',
            'A tall tree growing from the ground',
            '',
            '',
            '',
          ],
        ],
      );

      final result = await importRadicalMnemonics.call(enrichedPath);

      expect(result.rejectedCount, greaterThan(0));
      expect(
        result.warnings.any((w) =>
            w.message.contains('invalid radical_id') &&
            w.severity == WarningSeverity.high),
        isTrue,
      );
    });

    test('deduplicates search tags silently', () async {
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

      final enrichedPath = await exportAndEnrich(
        mnemonics: {
          '木': (
            'A tall tree growing from the ground',
            'Un árbol alto',
          ),
        },
        tags: {
          '木': ('tree|wood|tree|forest|wood', 'árbol|madera'),
        },
      );

      final result = await importRadicalMnemonics.call(enrichedPath);
      expect(result.importedCount, 1);

      final i18nRows = await radicalRepo.getAllDraftRadicalI18n();
      final enRow = i18nRows.firstWhere((r) => r.langCode == 'en');
      expect(enRow.searchTags, ['tree', 'wood', 'forest']);
    });

    test('warns on short mnemonic', () async {
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

      final enrichedPath = await exportAndEnrich(
        mnemonics: {
          '木': ('short', 'corto'),
        },
      );

      final result = await importRadicalMnemonics.call(enrichedPath);

      expect(result.importedCount, 1);
      expect(
        result.warnings.any((w) => w.message.contains('shorter than 10')),
        isTrue,
      );
    });

    test('warns on empty search tags when mnemonic provided', () async {
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

      final enrichedPath = await exportAndEnrich(
        mnemonics: {
          '木': (
            'A tall tree growing from the ground',
            'Un árbol alto creciendo del suelo',
          ),
        },
        // No tags provided.
      );

      final result = await importRadicalMnemonics.call(enrichedPath);

      expect(result.importedCount, 1);
      expect(
        result.warnings.any((w) => w.message.contains('search tags empty')),
        isTrue,
      );
    });

    test('skips rows where both mnemonics are empty', () async {
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

      final enrichedPath = await exportAndEnrich(
        mnemonics: {}, // No mnemonics.
      );

      final result = await importRadicalMnemonics.call(enrichedPath);

      expect(result.importedCount, 0);
      expect(result.skippedCount, 1);
    });
  });
}
