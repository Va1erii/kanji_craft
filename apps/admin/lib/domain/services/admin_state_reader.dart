import '../entities/data_import.dart';
import '../entities/kanji_component_review.dart';

/// Reads admin state (import history, review decisions) from a remote source.
///
/// Used by [HydrateLocalDb] to fetch the authoritative admin state
/// that survives local DB loss.
abstract class AdminStateReader {
  Future<List<DataImport>> fetchImports();
  Future<List<KanjiComponentReview>> fetchReviews();
}
