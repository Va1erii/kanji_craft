import 'dart:developer';
import 'dart:io';

import '../entities/warning.dart';
import '../repositories/radical_repository.dart';
import '../../data/services/csv_service.dart';
import 'export_radical_mnemonics.dart';

class ImportRadicalMnemonicsResult {
  const ImportRadicalMnemonicsResult({
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

class ImportRadicalMnemonics {
  ImportRadicalMnemonics({
    required RadicalRepository radicalRepository,
    required CsvService csvService,
  })  : _radicalRepository = radicalRepository,
        _csvService = csvService;

  final RadicalRepository _radicalRepository;
  final CsvService _csvService;

  Future<ImportRadicalMnemonicsResult> call(String filePath) async {
    final warnings = <Warning>[];
    var importedCount = 0;
    var skippedCount = 0;
    var rejectedCount = 0;

    // Read CSV file.
    log('Reading CSV: $filePath', name: 'ImportRadicalMnemonics');
    final content = await File(filePath).readAsString();

    final parsed = _csvService.parseCsv(
      content: content,
      requiredHeaders: ExportRadicalMnemonics.headers,
    );
    warnings.addAll(
      parsed.warnings.map((w) => Warning(w)),
    );

    // Load existing i18n rows by draftRadicalId for validation.
    log('Loading draft radical i18n rows...', name: 'ImportRadicalMnemonics');
    final allI18n = await _radicalRepository.getAllDraftRadicalI18n();
    final i18nByRadicalAndLang = <(int, String), int>{};
    for (final row in allI18n) {
      i18nByRadicalAndLang[(row.draftRadicalId, row.langCode)] = row.id;
    }

    // Validate rows and build update batches.
    final updates =
        <({int id, String systemMnemonic, List<String> searchTags})>[];

    for (var i = 0; i < parsed.rows.length; i++) {
      final row = parsed.rows[i];
      final rowNum = i + 2; // +1 for 0-index, +1 for header row

      final radicalIdStr = row['radical_id'] ?? '';
      final radicalId = int.tryParse(radicalIdStr);
      if (radicalId == null) {
        warnings.add(Warning(
          'Row $rowNum: invalid radical_id "$radicalIdStr" — rejected',
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
        final i18nId = i18nByRadicalAndLang[(radicalId, lang)];
        if (i18nId == null) {
          warnings.add(Warning(
            'Row $rowNum ($lang): no draft_radical_i18n row for '
            'radical_id=$radicalId, lang=$lang — rejected',
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
          name: 'ImportRadicalMnemonics');
      try {
        await _radicalRepository.batchUpdateDraftRadicalI18nEnrichment(updates);
      } catch (e, st) {
        log(
          'Batch update failed',
          error: e,
          stackTrace: st,
          name: 'ImportRadicalMnemonics',
        );
        rethrow;
      }
    }

    log(
      'Import complete: $importedCount imported, $skippedCount skipped, '
      '$rejectedCount rejected, ${warnings.length} warnings',
      name: 'ImportRadicalMnemonics',
    );

    return ImportRadicalMnemonicsResult(
      importedCount: importedCount,
      skippedCount: skippedCount,
      rejectedCount: rejectedCount,
      warnings: warnings,
    );
  }
}
