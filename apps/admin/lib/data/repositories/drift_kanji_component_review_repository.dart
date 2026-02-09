import 'package:drift/drift.dart';

import '../../domain/entities/kanji_component_review.dart';
import 'package:kanji_craft_core/domain/entities/verification_status.dart';
import '../../domain/repositories/kanji_component_review_repository.dart';
import '../local/admin_database.dart';
import '../local/mappers/admin_mappers.dart';

class DriftKanjiComponentReviewRepository
    implements KanjiComponentReviewRepository {
  DriftKanjiComponentReviewRepository(this._db);

  final AdminDatabase _db;

  @override
  Future<KanjiComponentReview> create({
    required int kanjiComponentId,
    required VerificationStatus verificationStatus,
    double? aiConfidence,
  }) async {
    final now = DateTime.now().toUtc();
    final id = await _db.into(_db.kanjiComponentReviewEntries).insert(
          KanjiComponentReviewEntriesCompanion.insert(
            kanjiComponentId: kanjiComponentId,
            verificationStatus: verificationStatus,
            aiConfidence:
                aiConfidence != null ? Value(aiConfidence) : const Value.absent(),
            createdAt: now,
            updatedAt: now,
          ),
        );
    final entry = await (_db.select(_db.kanjiComponentReviewEntries)
          ..where((t) => t.id.equals(id)))
        .getSingle();
    return entry.toDomain();
  }

  @override
  Future<KanjiComponentReview?> getByComponentId(
    int kanjiComponentId,
  ) async {
    final entry = await (_db.select(_db.kanjiComponentReviewEntries)
          ..where((t) => t.kanjiComponentId.equals(kanjiComponentId)))
        .getSingleOrNull();
    return entry?.toDomain();
  }

  @override
  Future<List<KanjiComponentReview>> getDraftReviews({int? limit}) async {
    final query = _db.select(_db.kanjiComponentReviewEntries)
      ..where(
        (t) => t.verificationStatus.equalsValue(VerificationStatus.draft),
      )
      ..orderBy([(t) => OrderingTerm.asc(t.aiConfidence)]);
    if (limit != null) {
      query.limit(limit);
    }
    final entries = await query.get();
    return entries.map((e) => e.toDomain()).toList();
  }

  @override
  Future<KanjiComponentReview> updateStatus({
    required int id,
    required VerificationStatus status,
  }) async {
    final now = DateTime.now().toUtc();
    await (_db.update(_db.kanjiComponentReviewEntries)
          ..where((t) => t.id.equals(id)))
        .write(
      KanjiComponentReviewEntriesCompanion(
        verificationStatus: Value(status),
        updatedAt: Value(now),
      ),
    );
    return (await (_db.select(_db.kanjiComponentReviewEntries)
              ..where((t) => t.id.equals(id)))
            .getSingle())
        .toDomain();
  }

  @override
  Future<int> bulkVerify({required double threshold}) async {
    final count = await (_db.update(_db.kanjiComponentReviewEntries)
          ..where(
            (t) =>
                t.verificationStatus.equalsValue(VerificationStatus.draft) &
                t.aiConfidence.isBiggerOrEqualValue(threshold),
          ))
        .write(
      KanjiComponentReviewEntriesCompanion(
        verificationStatus: const Value(VerificationStatus.verified),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
    return count;
  }

  @override
  Future<void> upsertAll(List<KanjiComponentReview> reviews) async {
    await _db.batch((b) {
      for (final review in reviews) {
        b.insert(
          _db.kanjiComponentReviewEntries,
          review.toEntry(),
          onConflict: DoUpdate(
            (old) => review.toEntry().toCompanion(false),
          ),
        );
      }
    });
  }
}
