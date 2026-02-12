import '../entities/kanji_component_review.dart';
import 'package:kanji_craft_core/domain/entities/verification_status.dart';

abstract class KanjiComponentReviewRepository {
  /// Creates a review row for a newly created component.
  Future<KanjiComponentReview> create({
    required int kanjiComponentId,
    required VerificationStatus verificationStatus,
    double? aiConfidence,
  });

  /// Fetches a review by its component ID. Returns null if not found.
  Future<KanjiComponentReview?> getByComponentId(int kanjiComponentId);

  /// Returns draft reviews ordered by ai_confidence ASC (lowest first).
  /// Used for the admin review queue.
  Future<List<KanjiComponentReview>> getDraftReviews({int? limit});

  /// Updates the verification status of a single review.
  Future<KanjiComponentReview> updateStatus({
    required int id,
    required VerificationStatus status,
  });

  /// Bulk-verify all draft reviews with ai_confidence >= [threshold].
  Future<int> bulkVerify({required double threshold});

  /// Bulk upserts reviews (insert or replace on conflict).
  Future<void> upsertAll(List<KanjiComponentReview> reviews);

  /// Returns the total number of review rows.
  Future<int> count();
}
