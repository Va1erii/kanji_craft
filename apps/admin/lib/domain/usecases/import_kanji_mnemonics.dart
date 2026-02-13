import 'dart:developer';
import 'dart:io';

import '../entities/warning.dart';
import '../repositories/kanji_repository.dart';
import '../../data/services/csv_service.dart';
import 'export_kanji_mnemonics.dart';

class ImportKanjiMnemonicsResult {
  const ImportKanjiMnemonicsResult({
    required this.importedCount,
    required this.skippedCount,
    required this.rejectedCount,
    this.warnings = const [],
  });

  final int importedCount;
  final int skippedCount;
  final int rejectedCount;
  final List<Warning> warnings;
}

class ImportKanjiMnemonics {
  ImportKanjiMnemonics({
    required KanjiRepository kanjiRepository,
    required CsvService csvService,
  })  : _kanjiRepository = kanjiRepository,
        _csvService = csvService;

  final KanjiRepository _kanjiRepository;
  final CsvService _csvService;

  Future<ImportKanjiMnemonicsResult> call(String filePath) async {
    final warnings = <Warning>[];
    var importedCount = 0;
    var skippedCount = 0;
    var rejectedCount = 0;

    // Read CSV file.
    log('Reading CSV: $filePath', name: 'ImportKanjiMnemonics');
    final content = await File(filePath).readAsString();

    final parsed = _csvService.parseCsv(
      content: content,
      requiredHeaders: ExportKanjiMnemonics.headers,
    );
    warnings.addAll(
      parsed.warnings.map((w) => Warning(w)),
    );

    // Load existing i18n rows by draftKanjiId for validation.
    log('Loading draft kanji i18n rows...', name: 'ImportKanjiMnemonics');
    final allI18n = await _kanjiRepository.getAllDraftKanjiI18n();
    final i18nByKanjiAndLang = <(int, String), int>{};
    for (final row in allI18n) {
      i18nByKanjiAndLang[(row.draftKanjiId, row.langCode)] = row.id;
    }

    // Validate rows and build update batches.
    final updates =
        <({int id, String systemMnemonic, List<String> searchTags})>[];

    for (var i = 0; i < parsed.rows.length; i++) {
      final row = parsed.rows[i];
      final rowNum = i + 2; // +1 for 0-index, +1 for header row

      final kanjiIdStr = row['kanji_id'] ?? '';
      final kanjiId = int.tryParse(kanjiIdStr);
      if (kanjiId == null) {
        warnings.add(Warning(
          'Row $rowNum: invalid kanji_id "$kanjiIdStr" — rejected',
          severity: WarningSeverity.high,
        ));
        rejectedCount++;
        continue;
      }

      // Process each language pair.
      var rowImported = false;
      for (final lang in ['en', 'es']) {
        final mnemonicKey = '${lang}_system_mnemonic';
        final tagsKey = '${lang}_search_tags';
        final mnemonic = (row[mnemonicKey] ?? '').trim();
        final tagsRaw = (row[tagsKey] ?? '').trim();

        // Skip if mnemonic is empty — nothing to import for this language.
        if (mnemonic.isEmpty) {
          continue;
        }

        // Validate: reject if tags contain commas (likely delimiter confusion).
        if (tagsRaw.contains(',')) {
          warnings.add(Warning(
            'Row $rowNum ($lang): search tags contain commas — '
            'use pipe (|) delimiter — rejected',
            severity: WarningSeverity.high,
          ));
          rejectedCount++;
          continue;
        }

        // Look up the i18n row.
        final i18nId = i18nByKanjiAndLang[(kanjiId, lang)];
        if (i18nId == null) {
          warnings.add(Warning(
            'Row $rowNum ($lang): no draft_kanji_i18n row for '
            'kanji_id=$kanjiId, lang=$lang — rejected',
            severity: WarningSeverity.high,
          ));
          rejectedCount++;
          continue;
        }

        // Warn on short mnemonics.
        if (mnemonic.length < 10) {
          warnings.add(Warning(
            'Row $rowNum ($lang): mnemonic shorter than 10 characters — '
            'may be placeholder',
          ));
        }

        // Parse and deduplicate tags.
        final tags = _csvService.parsePipeTags(tagsRaw);

        // Warn on empty tags when mnemonic is provided.
        if (tags.isEmpty && mnemonic.isNotEmpty) {
          warnings.add(Warning(
            'Row $rowNum ($lang): mnemonic provided but search tags empty',
          ));
        }

        updates.add((
          id: i18nId,
          systemMnemonic: mnemonic,
          searchTags: tags,
        ));
        rowImported = true;
      }

      if (rowImported) {
        importedCount++;
      } else {
        skippedCount++;
      }
    }

    // Batch update.
    if (updates.isNotEmpty) {
      log('Batch-updating ${updates.length} i18n rows...',
          name: 'ImportKanjiMnemonics');
      try {
        await _kanjiRepository.batchUpdateDraftKanjiI18nEnrichment(updates);
      } catch (e, st) {
        log(
          'Batch update failed',
          error: e,
          stackTrace: st,
          name: 'ImportKanjiMnemonics',
        );
        rethrow;
      }
    }

    log(
      'Import complete: $importedCount imported, $skippedCount skipped, '
      '$rejectedCount rejected, ${warnings.length} warnings',
      name: 'ImportKanjiMnemonics',
    );

    return ImportKanjiMnemonicsResult(
      importedCount: importedCount,
      skippedCount: skippedCount,
      rejectedCount: rejectedCount,
      warnings: warnings,
    );
  }
}
