import '../entities/data_import.dart';
import '../entities/kanji_component_review.dart';

/// Writes admin state to the local database.
///
/// Used by [HydrateLocalDb] to persist fetched admin state locally.
abstract class AdminStateWriter {
  Future<void> saveImports(List<DataImport> imports);
  Future<void> saveReviews(List<KanjiComponentReview> reviews);
}
