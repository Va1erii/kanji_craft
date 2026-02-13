import 'dart:developer';

import '../entities/draft_radical_i18n.dart';
import '../entities/warning.dart';
import '../repositories/radical_repository.dart';
import '../repositories/raw_kanjidic_repository.dart';
import '../../data/services/csv_service.dart';

class ExportRadicalMnemonicsResult {
  const ExportRadicalMnemonicsResult({
    required this.filePath,
    required this.rowCount,
    required this.totalCount,
    this.warnings = const [],
  });

  final String filePath;
  final int rowCount;
  final int totalCount;
  final List<Warning> warnings;
}

class ExportRadicalMnemonics {
  ExportRadicalMnemonics({
    required RadicalRepository radicalRepository,
    required RawKanjidicRepository rawKanjidicRepository,
    required CsvService csvService,
  })  : _radicalRepository = radicalRepository,
        _rawKanjidicRepository = rawKanjidicRepository,
        _csvService = csvService;

  final RadicalRepository _radicalRepository;
  final RawKanjidicRepository _rawKanjidicRepository;
  final CsvService _csvService;

  static const headers = [
    'radical_id',
    'master_symbol',
    'stroke_count',
    'is_official',
    'min_jlpt_level',
    'min_grade',
    'en_name',
    'es_name',
    'en_system_mnemonic',
    'es_system_mnemonic',
    'en_search_tags',
    'es_search_tags',
  ];

  Future<ExportRadicalMnemonicsResult> call({
    required String outputDir,
    required int kanjidicImportId,
    required int batchSize,
    required int offset,
  }) async {
    final warnings = <Warning>[];

    // Load draft radicals in export sort order.
    log('Loading draft radicals (offset=$offset, limit=$batchSize)...',
        name: 'ExportRadicalMnemonics');
    final radicals = await _radicalRepository.getDraftRadicalsForExport(
      limit: batchSize,
      offset: offset,
    );
    final totalCount = await _radicalRepository.countDraftRadicalsForExport();

    if (radicals.isEmpty) {
      return ExportRadicalMnemonicsResult(
        filePath: '',
        rowCount: 0,
        totalCount: totalCount,
        warnings: [const Warning('No radicals to export')],
      );
    }

    // Build master_symbol → meanings map from raw_kanjidic.
    log('Loading KANJIDIC meanings for name resolution...',
        name: 'ExportRadicalMnemonics');
    final allKanjidic =
        await _rawKanjidicRepository.getByImportId(kanjidicImportId);
    final meaningsByLiteral = <String, Map<String, List<String>>>{};
    for (final entry in allKanjidic) {
      meaningsByLiteral[entry.literal] = entry.meanings;
    }

    // For each radical: resolve names, pre-create i18n rows, build CSV row.
    log('Processing ${radicals.length} radicals...',
        name: 'ExportRadicalMnemonics');
    final csvRows = <List<String>>[];
    final now = DateTime.now();

    for (final radical in radicals) {
      final meanings = meaningsByLiteral[radical.masterSymbol];
      final enName =
          _resolveName(meanings, 'en') ?? radical.masterSymbol;
      final esName =
          _resolveName(meanings, 'es') ?? enName;

      if (meanings == null) {
        warnings.add(Warning(
          'Ghost radical "${radical.masterSymbol}" — '
          'no KANJIDIC entry, using symbol as name',
          severity: WarningSeverity.low,
        ));
      }

      // Pre-create i18n rows (skip if row already has non-empty mnemonic).
      for (final (lang, name) in [('en', enName), ('es', esName)]) {
        try {
          await _radicalRepository.upsertDraftRadicalI18n(
            DraftRadicalI18n(
              id: 0,
              draftRadicalId: radical.id,
              langCode: lang,
              name: name,
              systemMnemonic: '',
              searchTags: const [],
              createdAt: now,
              updatedAt: now,
            ),
          );
        } catch (e, st) {
          log(
            'Failed to upsert i18n for radical ${radical.masterSymbol} ($lang)',
            error: e,
            stackTrace: st,
            name: 'ExportRadicalMnemonics',
          );
        }
      }

      csvRows.add([
        radical.id.toString(),
        radical.masterSymbol,
        radical.strokeCount?.toString() ?? '',
        radical.isOfficial.toString(),
        radical.minJlptLevel?.toString() ?? '',
        radical.minGrade?.toString() ?? '',
        enName,
        esName,
        '', // en_system_mnemonic — to fill
        '', // es_system_mnemonic — to fill
        '', // en_search_tags — to fill
        '', // es_search_tags — to fill
      ]);
    }

    // Write CSV file.
    final batchNum = (offset ~/ batchSize) + 1;
    final fileName = 'batch1_radical_mnemonics_$batchNum.csv';
    final filePath = '$outputDir/$fileName';
    log('Writing CSV: $filePath ($batchNum, ${csvRows.length} rows)',
        name: 'ExportRadicalMnemonics');
    await _csvService.writeCsv(
      filePath: filePath,
      headers: headers,
      rows: csvRows,
    );

    return ExportRadicalMnemonicsResult(
      filePath: filePath,
      rowCount: csvRows.length,
      totalCount: totalCount,
      warnings: warnings,
    );
  }

  /// Returns the total count of draft radicals eligible for export.
  Future<int> queryTotalCount() =>
      _radicalRepository.countDraftRadicalsForExport();

  /// Returns a summary string if draft radical i18n rows already exist.
  Future<String?> checkExistingExportResult() async {
    final i18nCount = await _radicalRepository.countDraftRadicalI18n();
    if (i18nCount == 0) return null;
    final withMnemonic =
        await _radicalRepository.countDraftRadicalI18nWithMnemonic();
    return '$i18nCount i18n rows ($withMnemonic with mnemonics)';
  }

  /// Resolves a name from KANJIDIC meanings for the given language.
  ///
  /// Returns the first meaning for the language, or null if not found.
  String? _resolveName(Map<String, List<String>>? meanings, String lang) {
    if (meanings == null) return null;
    final langMeanings = meanings[lang];
    if (langMeanings == null || langMeanings.isEmpty) return null;
    return langMeanings.first;
  }
}
