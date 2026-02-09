import 'package:flutter_test/flutter_test.dart';
import 'package:kanji_craft_admin/data/datasources/supabase_data_import_datasource.dart';
import 'package:kanji_craft_admin/data/datasources/supabase_kanji_component_review_datasource.dart';
import 'package:kanji_craft_admin/data/local/admin_database.dart';
import 'package:kanji_craft_admin/data/repositories/drift_data_import_repository.dart';
import 'package:kanji_craft_admin/data/repositories/drift_kanji_component_review_repository.dart';
import 'package:kanji_craft_admin/data/services/admin_sync_service.dart';
import 'package:kanji_craft_admin/domain/entities/import_source.dart';
import 'package:kanji_craft_admin/domain/entities/import_status.dart';
import 'package:kanji_craft_core/domain/entities/verification_status.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/admin_fixtures.dart';
import '../../helpers/admin_test_helpers.dart';

class MockSupabaseDataImportDataSource extends Mock
    implements SupabaseDataImportDataSource {}

class MockSupabaseKanjiComponentReviewDataSource extends Mock
    implements SupabaseKanjiComponentReviewDataSource {}

void main() {
  late AdminDatabase db;
  late DriftDataImportRepository localImports;
  late DriftKanjiComponentReviewRepository localReviews;
  late MockSupabaseDataImportDataSource remoteImports;
  late MockSupabaseKanjiComponentReviewDataSource remoteReviews;
  late AdminSyncService service;

  setUp(() {
    resetFixtureIds();
    db = createTestDatabase();
    final repos = createReposFromDb(db);
    localImports = repos.imports;
    localReviews = repos.reviews;

    remoteImports = MockSupabaseDataImportDataSource();
    remoteReviews = MockSupabaseKanjiComponentReviewDataSource();

    service = AdminSyncService(
      db: db,
      remoteImports: remoteImports,
      localImports: localImports,
      remoteReviews: remoteReviews,
      localReviews: localReviews,
    );
  });

  tearDown(() => db.close());

  group('AdminSyncService', () {
    group('pullImports', () {
      test('first call does full pull via listAll', () async {
        final imports = [
          fakeDataImport(id: 1, sourceVersion: '1.0'),
          fakeDataImport(id: 2, source: ImportSource.kanjidic, sourceVersion: '2.0'),
        ];
        when(() => remoteImports.listAll()).thenAnswer((_) async => imports);

        await service.pullImports();

        verify(() => remoteImports.listAll()).called(1);
        verifyNever(() => remoteImports.listUpdatedSince(any()));

        final local = await localImports.listAll();
        expect(local, hasLength(2));
      });

      test('second call does incremental pull via listUpdatedSince', () async {
        when(() => remoteImports.listAll()).thenAnswer((_) async => []);

        await service.pullImports();

        final updated = [
          fakeDataImport(id: 3, sourceVersion: '3.0'),
        ];
        when(() => remoteImports.listUpdatedSince(any()))
            .thenAnswer((_) async => updated);

        await service.pullImports();

        verify(() => remoteImports.listUpdatedSince(any())).called(1);
        final local = await localImports.listAll();
        expect(local, hasLength(1));
      });

      test('empty result still updates lastSynced', () async {
        when(() => remoteImports.listAll()).thenAnswer((_) async => []);

        await service.pullImports();

        // Second call should be incremental (proves lastSynced was set)
        when(() => remoteImports.listUpdatedSince(any()))
            .thenAnswer((_) async => []);

        await service.pullImports();

        verify(() => remoteImports.listAll()).called(1);
        verify(() => remoteImports.listUpdatedSince(any())).called(1);
      });

      test('upsert overwrites existing local on conflict', () async {
        final original = fakeDataImport(
          id: 1,
          sourceVersion: '1.0',
          status: ImportStatus.pending,
        );
        when(() => remoteImports.listAll())
            .thenAnswer((_) async => [original]);

        await service.pullImports();

        final updated = fakeDataImport(
          id: 1,
          sourceVersion: '1.0',
          status: ImportStatus.ingested,
        );
        when(() => remoteImports.listUpdatedSince(any()))
            .thenAnswer((_) async => [updated]);

        await service.pullImports();

        final local = await localImports.getById(1);
        expect(local!.status, ImportStatus.ingested);
      });
    });

    group('pullReviews', () {
      test('first call does full pull via listAll', () async {
        final reviews = [
          fakeReview(id: 1, kanjiComponentId: 100, aiConfidence: 0.5),
        ];
        when(() => remoteReviews.listAll())
            .thenAnswer((_) async => reviews);

        await service.pullReviews();

        verify(() => remoteReviews.listAll()).called(1);
        verifyNever(() => remoteReviews.getUpdatedSince(any()));
      });

      test('pulled reviews are written to local Drift', () async {
        final reviews = [
          fakeReview(id: 1, kanjiComponentId: 100, aiConfidence: 0.8),
          fakeReview(id: 2, kanjiComponentId: 200, aiConfidence: 0.3),
        ];
        when(() => remoteReviews.listAll())
            .thenAnswer((_) async => reviews);

        await service.pullReviews();

        final local1 = await localReviews.getByComponentId(100);
        final local2 = await localReviews.getByComponentId(200);
        expect(local1, isNotNull);
        expect(local2, isNotNull);
        expect(local1!.aiConfidence, 0.8);
        expect(local2!.aiConfidence, 0.3);
      });

      test('second call does incremental pull via getUpdatedSince', () async {
        when(() => remoteReviews.listAll())
            .thenAnswer((_) async => []);

        await service.pullReviews();

        when(() => remoteReviews.getUpdatedSince(any()))
            .thenAnswer((_) async => []);

        await service.pullReviews();

        verify(() => remoteReviews.getUpdatedSince(any())).called(1);
      });
    });

    group('pushImportStatus', () {
      test('calls remote and upserts result locally', () async {
        final updatedRemote = fakeDataImport(
          id: 1,
          status: ImportStatus.ingested,
          recordCount: 50,
        );
        when(() => remoteImports.updateStatus(
              id: 1,
              status: ImportStatus.ingested,
              recordCount: 50,
            )).thenAnswer((_) async => updatedRemote);

        final result = await service.pushImportStatus(
          id: 1,
          status: ImportStatus.ingested,
          recordCount: 50,
        );

        expect(result.status, ImportStatus.ingested);
        expect(result.recordCount, 50);

        final local = await localImports.getById(1);
        expect(local, isNotNull);
        expect(local!.status, ImportStatus.ingested);
      });
    });

    group('pushReviewStatus', () {
      test('calls remote and upserts result locally', () async {
        final updatedRemote = fakeReview(
          id: 1,
          kanjiComponentId: 42,
          verificationStatus: VerificationStatus.verified,
        );
        when(() => remoteReviews.updateStatus(
              id: 1,
              status: VerificationStatus.verified,
            )).thenAnswer((_) async => updatedRemote);

        final result = await service.pushReviewStatus(
          id: 1,
          status: VerificationStatus.verified,
        );

        expect(result.verificationStatus, VerificationStatus.verified);
      });
    });

    group('sync metadata', () {
      test('lastSynced persists across service instances', () async {
        when(() => remoteImports.listAll()).thenAnswer((_) async => []);

        await service.pullImports();

        // Create new service with same DB
        final service2 = AdminSyncService(
          db: db,
          remoteImports: remoteImports,
          localImports: localImports,
          remoteReviews: remoteReviews,
          localReviews: localReviews,
        );

        when(() => remoteImports.listUpdatedSince(any()))
            .thenAnswer((_) async => []);

        await service2.pullImports();

        // Should have done incremental (listUpdatedSince), not full (listAll)
        verify(() => remoteImports.listAll()).called(1);
        verify(() => remoteImports.listUpdatedSince(any())).called(1);
      });

      test('independent keys do not interfere', () async {
        when(() => remoteImports.listAll()).thenAnswer((_) async => []);
        when(() => remoteReviews.listAll())
            .thenAnswer((_) async => []);

        await service.pullImports();
        // Reviews haven't been synced yet, so should do full pull
        await service.pullReviews();

        verify(() => remoteImports.listAll()).called(1);
        verify(() => remoteReviews.listAll()).called(1);
      });
    });
  });
}
