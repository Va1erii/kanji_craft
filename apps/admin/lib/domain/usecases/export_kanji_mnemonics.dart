import 'dart:developer';

import '../entities/draft_kanji_i18n.dart';
import '../entities/warning.dart';
import '../repositories/kanji_component_repository.dart';
import '../repositories/kanji_repository.dart';
import '../repositories/radical_repository.dart';
import '../../data/services/csv_service.dart';

class ExportKanjiMnemonicsResult {
  const ExportKanjiMnemonicsResult({
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

class ExportKanjiMnemonics {
  ExportKanjiMnemonics({
    required KanjiRepository kanjiRepository,
    required RadicalRepository radicalRepository,
    required KanjiComponentRepository kanjiComponentRepository,
    required CsvService csvService,
  })  : _kanjiRepository = kanjiRepository,
        _radicalRepository = radicalRepository,
        _kanjiComponentRepository = kanjiComponentRepository,
        _csvService = csvService;

  final KanjiRepository _kanjiRepository;
  final RadicalRepository _radicalRepository;
  final KanjiComponentRepository _kanjiComponentRepository;
  final CsvService _csvService;

  static const headers = [
    'kanji_id',
    'character',
    'stroke_count',
    'min_jlpt_level',
    'min_grade',
    'en_meanings',
    'es_meanings',
    'component_names',
    'has_ghost_components',
    'en_system_mnemonic',
    'es_system_mnemonic',
    'en_search_tags',
    'es_search_tags',
  ];

  Future<ExportKanjiMnemonicsResult> call({
    required String outputDir,
    required int batchSize,
    required int offset,
  }) async {
    final warnings = <Warning>[];

    // Load draft kanji in export sort order.
    log('Loading draft kanji (offset=$offset, limit=$batchSize)...',
        name: 'ExportKanjiMnemonics');
    final kanjiList = await _kanjiRepository.getDraftKanjiForExport(
      limit: batchSize,
      offset: offset,
    );
    final totalCount = await _kanjiRepository.countDraftKanjiForExport();

    if (kanjiList.isEmpty) {
      return ExportKanjiMnemonicsResult(
        filePath: '',
        rowCount: 0,
        totalCount: totalCount,
        warnings: [const Warning('No kanji to export')],
      );
    }

    // Bulk-load all draft kanji i18n → index by (draftKanjiId, langCode).
    log('Loading draft kanji i18n rows...', name: 'ExportKanjiMnemonics');
    final allI18n = await _kanjiRepository.getAllDraftKanjiI18n();
    final i18nIndex = <(int, String), DraftKanjiI18n>{};
    for (final row in allI18n) {
      i18nIndex[(row.draftKanjiId, row.langCode)] = row;
    }

    // Bulk-load all kanji components → group by kanjiId.
    log('Loading kanji components...', name: 'ExportKanjiMnemonics');
    final allComponents = await _kanjiComponentRepository.getAll();
    final componentsByKanjiId = <int, List<int>>{};
    for (final comp in allComponents) {
      componentsByKanjiId.putIfAbsent(comp.kanjiId, () => []);
      componentsByKanjiId[comp.kanjiId]!.add(comp.radicalId);
    }

    // Bulk-load all draft radicals → index by id (for SVG null check).
    log('Loading draft radicals...', name: 'ExportKanjiMnemonics');
    final allRadicals = await _radicalRepository.getAllDraftRadicals();
    final radicalById = {for (final r in allRadicals) r.id: r};

    // Bulk-load all draft radical i18n → index by (draftRadicalId, 'en').
    log('Loading draft radical i18n for names...',
        name: 'ExportKanjiMnemonics');
    final allRadicalI18n = await _radicalRepository.getAllDraftRadicalI18n();
    final radicalNameById = <int, String>{};
    for (final row in allRadicalI18n) {
      if (row.langCode == 'en') {
        radicalNameById[row.draftRadicalId] = row.name;
      }
    }

    // Build CSV rows.
    log('Processing ${kanjiList.length} kanji...', name: 'ExportKanjiMnemonics');
    final csvRows = <List<String>>[];
    final now = DateTime.now();

    for (final kanji in kanjiList) {
      // Resolve meanings from existing i18n.
      final enI18n = i18nIndex[(kanji.id, 'en')];
      final esI18n = i18nIndex[(kanji.id, 'es')];
      final enMeanings = enI18n?.meanings.join(', ') ?? '';
      final esMeanings = esI18n?.meanings.join(', ') ?? '';

      // Derive component_names and has_ghost_components.
      final radicalIds = componentsByKanjiId[kanji.id] ?? [];
      final componentNames = <String>[];
      var hasGhostComponents = false;

      for (final radicalId in radicalIds) {
        final radical = radicalById[radicalId];
        if (radical != null) {
          final name = radicalNameById[radicalId] ?? radical.masterSymbol;
          componentNames.add(name);
          if (radical.svgFileName == null) {
            hasGhostComponents = true;
          }
        }
      }

      // Pre-create i18n rows if they don't exist.
      for (final lang in ['en', 'es']) {
        final existing = i18nIndex[(kanji.id, lang)];
        if (existing == null) {
          try {
            await _kanjiRepository.upsertDraftKanjiI18n(
              DraftKanjiI18n(
                id: 0,
                draftKanjiId: kanji.id,
                langCode: lang,
                meanings: const [],
                systemMnemonic: '',
                searchTags: const [],
                createdAt: now,
                updatedAt: now,
              ),
            );
          } catch (e, st) {
            log(
              'Failed to upsert i18n for kanji ${kanji.character} ($lang)',
              error: e,
              stackTrace: st,
              name: 'ExportKanjiMnemonics',
            );
          }
        }
      }

      csvRows.add([
        kanji.id.toString(),
        kanji.character,
        kanji.strokeCount.toString(),
        kanji.minJlptLevel?.toString() ?? '',
        kanji.minGrade?.toString() ?? '',
        enMeanings,
        esMeanings,
        componentNames.join(', '),
        hasGhostComponents.toString(),
        '', // en_system_mnemonic — to fill
        '', // es_system_mnemonic — to fill
        '', // en_search_tags — to fill
        '', // es_search_tags — to fill
      ]);
    }

    // Write CSV file.
    final batchNum = (offset ~/ batchSize) + 1;
    final fileName = 'batch2_kanji_mnemonics_$batchNum.csv';
    final filePath = '$outputDir/$fileName';
    log('Writing CSV: $filePath ($batchNum, ${csvRows.length} rows)',
        name: 'ExportKanjiMnemonics');
    await _csvService.writeCsv(
      filePath: filePath,
      headers: headers,
      rows: csvRows,
    );

    return ExportKanjiMnemonicsResult(
      filePath: filePath,
      rowCount: csvRows.length,
      totalCount: totalCount,
      warnings: warnings,
    );
  }

  /// Returns the total count of draft kanji eligible for export.
  Future<int> queryTotalCount() =>
      _kanjiRepository.countDraftKanjiForExport();
}
