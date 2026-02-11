import '../entities/draft_radical.dart';
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
}
