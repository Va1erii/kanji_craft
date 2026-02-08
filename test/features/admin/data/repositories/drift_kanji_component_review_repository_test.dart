import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:kanji_craft/features/admin/data/local/admin_database.dart';
import 'package:kanji_craft/features/admin/data/repositories/drift_kanji_component_review_repository.dart';
import 'package:kanji_craft/shared/domain/entities/verification_status.dart';

import '../../helpers/admin_fixtures.dart';
import '../../helpers/admin_test_helpers.dart';

void main() {
  late AdminDatabase db;
  late DriftKanjiComponentReviewRepository repo;

  setUp(() {
    resetFixtureIds();
    db = createTestDatabase();
    repo = createReposFromDb(db).reviews;
  });

  tearDown(() => db.close());

  group('DriftKanjiComponentReviewRepository', () {
    group('create', () {
      test('returns entity with correct fields', () async {
        final result = await repo.create(
          kanjiComponentId: 42,
          verificationStatus: VerificationStatus.draft,
          aiConfidence: 0.85,
        );

        expect(result.id, isPositive);
        expect(result.kanjiComponentId, 42);
        expect(result.verificationStatus, VerificationStatus.draft);
        expect(result.aiConfidence, 0.85);
        expect(result.createdAt, isNotNull);
        expect(result.updatedAt, isNotNull);
      });

      test('without aiConfidence', () async {
        final result = await repo.create(
          kanjiComponentId: 43,
          verificationStatus: VerificationStatus.verified,
        );

        expect(result.aiConfidence, isNull);
        expect(result.verificationStatus, VerificationStatus.verified);
      });

      test('unique kanjiComponentId constraint', () async {
        await repo.create(
          kanjiComponentId: 42,
          verificationStatus: VerificationStatus.draft,
        );

        await expectLater(
          () => repo.create(
            kanjiComponentId: 42,
            verificationStatus: VerificationStatus.draft,
          ),
          throwsA(isA<SqliteException>()),
        );
      });
    });

    group('getDraftReviews', () {
      test('returns only drafts ordered by aiConfidence ASC', () async {
        await repo.create(
          kanjiComponentId: 1,
          verificationStatus: VerificationStatus.draft,
          aiConfidence: 0.9,
        );
        await repo.create(
          kanjiComponentId: 2,
          verificationStatus: VerificationStatus.draft,
          aiConfidence: 0.3,
        );
        await repo.create(
          kanjiComponentId: 3,
          verificationStatus: VerificationStatus.verified,
          aiConfidence: 0.1,
        );
        await repo.create(
          kanjiComponentId: 4,
          verificationStatus: VerificationStatus.draft,
          aiConfidence: 0.6,
        );

        final drafts = await repo.getDraftReviews();

        expect(drafts, hasLength(3));
        expect(drafts[0].aiConfidence, 0.3);
        expect(drafts[1].aiConfidence, 0.6);
        expect(drafts[2].aiConfidence, 0.9);
      });

      test('respects limit', () async {
        await repo.create(
          kanjiComponentId: 1,
          verificationStatus: VerificationStatus.draft,
          aiConfidence: 0.9,
        );
        await repo.create(
          kanjiComponentId: 2,
          verificationStatus: VerificationStatus.draft,
          aiConfidence: 0.3,
        );

        final drafts = await repo.getDraftReviews(limit: 1);
        expect(drafts, hasLength(1));
        expect(drafts.first.aiConfidence, 0.3);
      });
    });

    group('updateStatus', () {
      test('changes status and updates updatedAt', () async {
        final created = await repo.create(
          kanjiComponentId: 42,
          verificationStatus: VerificationStatus.draft,
        );

        final updated = await repo.updateStatus(
          id: created.id,
          status: VerificationStatus.verified,
        );

        expect(updated.verificationStatus, VerificationStatus.verified);
        expect(
          updated.updatedAt.isAfter(created.updatedAt) ||
              updated.updatedAt == created.updatedAt,
          isTrue,
        );
      });
    });

    group('bulkVerify', () {
      test('verifies drafts at or above threshold', () async {
        await repo.create(
          kanjiComponentId: 1,
          verificationStatus: VerificationStatus.draft,
          aiConfidence: 0.9,
        );
        await repo.create(
          kanjiComponentId: 2,
          verificationStatus: VerificationStatus.draft,
          aiConfidence: 0.5,
        );
        await repo.create(
          kanjiComponentId: 3,
          verificationStatus: VerificationStatus.draft,
          aiConfidence: 0.3,
        );

        final count = await repo.bulkVerify(threshold: 0.5);
        expect(count, 2);

        // Verify that the right ones were updated
        final review1 = await repo.getByComponentId(1);
        expect(review1!.verificationStatus, VerificationStatus.verified);

        final review2 = await repo.getByComponentId(2);
        expect(review2!.verificationStatus, VerificationStatus.verified);

        final review3 = await repo.getByComponentId(3);
        expect(review3!.verificationStatus, VerificationStatus.draft);
      });

      test('leaves non-draft reviews unchanged', () async {
        await repo.create(
          kanjiComponentId: 1,
          verificationStatus: VerificationStatus.flagged,
          aiConfidence: 0.95,
        );

        final count = await repo.bulkVerify(threshold: 0.5);
        expect(count, 0);

        final review = await repo.getByComponentId(1);
        expect(review!.verificationStatus, VerificationStatus.flagged);
      });
    });

    group('upsertAll', () {
      test('inserts and updates', () async {
        final review = fakeReview(
          id: 1,
          kanjiComponentId: 42,
          verificationStatus: VerificationStatus.draft,
          aiConfidence: 0.5,
        );
        await repo.upsertAll([review]);

        final updated = fakeReview(
          id: 1,
          kanjiComponentId: 42,
          verificationStatus: VerificationStatus.verified,
          aiConfidence: 0.99,
        );
        await repo.upsertAll([updated]);

        final result = await repo.getByComponentId(42);
        expect(result!.verificationStatus, VerificationStatus.verified);
        expect(result.aiConfidence, 0.99);
      });
    });
  });
}
