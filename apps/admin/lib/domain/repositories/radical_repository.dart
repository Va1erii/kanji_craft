import '../entities/draft_radical.dart';
import '../entities/draft_radical_i18n.dart';
import '../entities/draft_radical_variant.dart';

abstract class RadicalRepository {
  /// Upserts a draft radical row (by masterSymbol). Returns the saved entity.
  Future<DraftRadical> upsertDraftRadical(DraftRadical radical);

  /// Upserts a draft radical variant row (by draftRadicalId + shape).
  /// Returns the saved entity.
  Future<DraftRadicalVariant> upsertDraftRadicalVariant(
    DraftRadicalVariant variant,
  );

  /// Returns a draft radical by its [masterSymbol], or null if not found.
  Future<DraftRadical?> getDraftRadicalByMasterSymbol(String masterSymbol);

  /// Returns all draft radicals.
  Future<List<DraftRadical>> getAllDraftRadicals();

  /// Returns all draft radical variants.
  Future<List<DraftRadicalVariant>> getAllDraftRadicalVariants();

  /// Deletes all draft radicals (cascades to variants).
  Future<void> deleteAllDraftRadicals();

  /// Returns the number of draft radicals.
  Future<int> countDraftRadicals();

  /// Returns the number of draft radical variants.
  Future<int> countDraftRadicalVariants();

  /// Batch-updates SVG fields on draft radical rows.
  ///
  /// Each entry maps a draft radical ID to its SVG metadata.
  Future<void> batchUpdateDraftRadicalSvg(
    List<({int id, String svgFileName, String svgFileUrl, String svgHash})>
        updates,
  );

  /// Batch-updates SVG fields on draft radical variant rows.
  Future<void> batchUpdateDraftRadicalVariantSvg(
    List<({int id, String svgFileName, String svgFileUrl, String svgHash})>
        updates,
  );

  /// Returns the number of draft radicals with non-null svg_file_name.
  Future<int> countDraftRadicalsWithSvg();

  /// Returns the number of draft radical variants with non-null svg_file_name.
  Future<int> countDraftRadicalVariantsWithSvg();

  /// Batch-updates derived metadata fields on draft radical rows.
  ///
  /// Used by component linking (Step 3) to set impact_score, min_grade,
  /// and min_jlpt_level computed from kanji associations.
  Future<void> batchUpdateDraftRadicalMetadata(
    List<({int id, int? impactScore, int? minGrade, int? minJlptLevel})>
        updates,
  );

  // -- Draft Radical I18n --

  /// Upserts a draft radical i18n row (by draftRadicalId + langCode).
  /// Returns the saved entity.
  Future<DraftRadicalI18n> upsertDraftRadicalI18n(DraftRadicalI18n i18n);

  /// Inserts a batch of draft radical i18n rows.
  Future<void> insertDraftRadicalI18nBatch(List<DraftRadicalI18n> rows);

  /// Returns all draft radical i18n rows.
  Future<List<DraftRadicalI18n>> getAllDraftRadicalI18n();

  /// Returns the number of draft radical i18n rows.
  Future<int> countDraftRadicalI18n();

  /// Returns the number of draft radical i18n rows with non-empty mnemonic.
  Future<int> countDraftRadicalI18nWithMnemonic();

  /// Batch-updates enrichment fields on draft radical i18n rows.
  Future<void> batchUpdateDraftRadicalI18nEnrichment(
    List<({int id, String systemMnemonic, List<String> searchTags})> updates,
  );

  /// Deletes all draft radical i18n rows.
  Future<void> deleteAllDraftRadicalI18n();

  /// Returns draft radicals sorted for CSV export.
  ///
  /// Sort order: min_jlpt_level DESC NULLS LAST, min_grade ASC NULLS LAST,
  /// impact_score DESC.
  Future<List<DraftRadical>> getDraftRadicalsForExport({
    required int limit,
    required int offset,
  });

  /// Returns total count of draft radicals eligible for export.
  Future<int> countDraftRadicalsForExport();
}
