import '../entities/draft_kanji.dart';
import '../entities/draft_kanji_i18n.dart';
import '../entities/draft_kanji_reading.dart';

abstract class KanjiRepository {
  /// Batch-inserts draft kanji rows.
  Future<void> insertDraftKanjiBatch(List<DraftKanji> kanji);

  /// Batch-inserts draft kanji reading rows.
  Future<void> insertDraftKanjiReadingBatch(List<DraftKanjiReading> readings);

  /// Batch-inserts draft kanji i18n rows.
  Future<void> insertDraftKanjiI18nBatch(List<DraftKanjiI18n> i18n);

  /// Returns all draft kanji ordered by character.
  Future<List<DraftKanji>> getAllDraftKanji();

  /// Deletes all draft kanji (cascades to readings + i18n).
  Future<void> deleteAllDraftKanji();

  /// Returns the number of draft kanji.
  Future<int> countDraftKanji();

  /// Returns the number of draft kanji readings.
  Future<int> countDraftKanjiReadings();

  /// Returns the number of draft kanji i18n rows.
  Future<int> countDraftKanjiI18n();

  /// Batch-updates SVG fields on draft kanji rows.
  Future<void> batchUpdateDraftKanjiSvg(
    List<({int id, String svgFileName, String svgFileUrl, String svgHash})>
        updates,
  );

  /// Returns the number of draft kanji with non-null svg_file_name.
  Future<int> countDraftKanjiWithSvg();

  // -- Draft Kanji I18n --

  /// Upserts a draft kanji i18n row (by draftKanjiId + langCode).
  Future<DraftKanjiI18n> upsertDraftKanjiI18n(DraftKanjiI18n i18n);

  /// Returns all draft kanji i18n rows.
  Future<List<DraftKanjiI18n>> getAllDraftKanjiI18n();

  /// Returns the number of draft kanji i18n rows with non-empty mnemonic.
  Future<int> countDraftKanjiI18nWithMnemonic();

  /// Batch-updates enrichment fields on draft kanji i18n rows.
  Future<void> batchUpdateDraftKanjiI18nEnrichment(
    List<({int id, String systemMnemonic, List<String> searchTags})> updates,
  );

  // -- Export helpers --

  /// Returns draft kanji sorted for CSV export.
  ///
  /// Sort order: min_jlpt_level DESC NULLS LAST, min_grade ASC NULLS LAST,
  /// frequency_rank ASC.
  Future<List<DraftKanji>> getDraftKanjiForExport({
    required int limit,
    required int offset,
  });

  /// Returns total count of draft kanji eligible for export.
  Future<int> countDraftKanjiForExport();
}
