import 'package:flutter_test/flutter_test.dart';
import 'package:kanji_craft_admin/data/datasources/supabase_data_import_datasource.dart';
import 'package:kanji_craft_admin/data/datasources/supabase_kanji_component_review_datasource.dart';
import 'package:kanji_craft_admin/data/datasources/supabase_raw_kanjidic_datasource.dart';
import 'package:kanji_craft_admin/data/datasources/supabase_raw_kanjivg_datasource.dart';
import 'package:kanji_craft_admin/data/local/admin_database.dart';
import 'package:kanji_craft_admin/data/repositories/drift_data_import_repository.dart';
import 'package:kanji_craft_admin/data/repositories/drift_kanji_component_review_repository.dart';
import 'package:kanji_craft_admin/data/repositories/drift_raw_kanjidic_repository.dart';
import 'package:kanji_craft_admin/data/repositories/drift_raw_kanjivg_repository.dart';
import 'package:kanji_craft_admin/data/services/admin_sync_service.dart';
import 'package:kanji_craft_admin/domain/entities/import_source.dart';
import 'package:kanji_craft_admin/domain/entities/import_status.dart';
import 'package:kanji_craft_core/domain/entities/verification_status.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/admin_fixtures.dart';
import '../../helpers/admin_test_helpers.dart';

class MockSupabaseDataImportDataSource extends Mock
    implements SupabaseDataImportDataSource {}

class MockSupabaseRawKanjiVgDataSource extends Mock
    implements SupabaseRawKanjiVgDataSource {}

class MockSupabaseRawKanjidicDataSource extends Mock
    implements SupabaseRawKanjidicDataSource {}

class MockSupabaseKanjiComponentReviewDataSource extends Mock
    implements SupabaseKanjiComponentReviewDataSource {}

void main() {
  late AdminDatabase db;
  late DriftDataImportRepository localImports;
  late DriftRawKanjiVgRepository localKanjiVg;
  late DriftRawKanjidicRepository localKanjidic;
  late DriftKanjiComponentReviewRepository localReviews;
  late MockSupabaseDataImportDataSource remoteImports;
  late MockSupabaseRawKanjiVgDataSource remoteKanjiVg;
  late MockSupabaseRawKanjidicDataSource remoteKanjidic;
  late MockSupabaseKanjiComponentReviewDataSource remoteReviews;
  late AdminSyncService service;

  setUp(() {
    resetFixtureIds();
    db = createTestDatabase();
    final repos = createReposFromDb(db);
    localImports = repos.imports;
    localKanjiVg = repos.kanjiVg;
    localKanjidic = repos.kanjidic;
    localReviews = repos.reviews;

    remoteImports = MockSupabaseDataImportDataSource();
    remoteKanjiVg = MockSupabaseRawKanjiVgDataSource();
    remoteKanjidic = MockSupabaseRawKanjidicDataSource();
    remoteReviews = MockSupabaseKanjiComponentReviewDataSource();

    service = AdminSyncService(
      db: db,
      remoteImports: remoteImports,
      localImports: localImports,
      remoteKanjiVg: remoteKanjiVg,
      localKanjiVg: localKanjiVg,
      remoteKanjidic: remoteKanjidic,
      localKanjidic: localKanjidic,
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

    group('pullKanjiVg', () {
      test('first call does full pull via getByImportId', () async {
        // Seed a local import for FK
        await localImports.upsertAll([fakeDataImport(id: 1)]);

        final rows = [
          fakeRawKanjiVg(id: 10, importId: 1, character: '木'),
        ];
        when(() => remoteKanjiVg.getByImportId(1))
            .thenAnswer((_) async => rows);

        await service.pullKanjiVg(1);

        verify(() => remoteKanjiVg.getByImportId(1)).called(1);
        final count = await localKanjiVg.countByImportId(1);
        expect(count, 1);
      });

      test('second call does incremental pull via getByImportIdCreatedSince',
          () async {
        await localImports.upsertAll([fakeDataImport(id: 1)]);

        when(() => remoteKanjiVg.getByImportId(1))
            .thenAnswer((_) async => []);

        await service.pullKanjiVg(1);

        final newRows = [
          fakeRawKanjiVg(id: 11, importId: 1, character: '水'),
        ];
        when(() => remoteKanjiVg.getByImportIdCreatedSince(1, any()))
            .thenAnswer((_) async => newRows);

        await service.pullKanjiVg(1);

        verify(() => remoteKanjiVg.getByImportIdCreatedSince(1, any()))
            .called(1);
      });

      test('different importIds have independent sync metadata', () async {
        await localImports.upsertAll([
          fakeDataImport(id: 1),
          fakeDataImport(id: 2),
        ]);

        when(() => remoteKanjiVg.getByImportId(1))
            .thenAnswer((_) async => []);
        when(() => remoteKanjiVg.getByImportId(2))
            .thenAnswer((_) async => []);

        await service.pullKanjiVg(1);
        // Import 2 hasn't been synced yet, so full pull
        await service.pullKanjiVg(2);

        verify(() => remoteKanjiVg.getByImportId(1)).called(1);
        verify(() => remoteKanjiVg.getByImportId(2)).called(1);
      });
    });

    group('pullKanjidic', () {
      test('first call does full pull via getByImportId', () async {
        await localImports.upsertAll([
          fakeDataImport(id: 1, source: ImportSource.kanjidic),
        ]);

        final rows = [
          fakeRawKanjidic(id: 10, importId: 1, literal: '木'),
        ];
        when(() => remoteKanjidic.getByImportId(1))
            .thenAnswer((_) async => rows);

        await service.pullKanjidic(1);

        verify(() => remoteKanjidic.getByImportId(1)).called(1);
        final count = await localKanjidic.countByImportId(1);
        expect(count, 1);
      });

      test('second call does incremental pull', () async {
        await localImports.upsertAll([
          fakeDataImport(id: 1, source: ImportSource.kanjidic),
        ]);

        when(() => remoteKanjidic.getByImportId(1))
            .thenAnswer((_) async => []);

        await service.pullKanjidic(1);

        when(() => remoteKanjidic.getByImportIdCreatedSince(1, any()))
            .thenAnswer((_) async => []);

        await service.pullKanjidic(1);

        verify(() => remoteKanjidic.getByImportIdCreatedSince(1, any()))
            .called(1);
      });
    });

    group('pullReviews', () {
      test('first call does full pull via getDraftReviews', () async {
        final reviews = [
          fakeReview(id: 1, kanjiComponentId: 100, aiConfidence: 0.5),
        ];
        when(() => remoteReviews.getDraftReviews())
            .thenAnswer((_) async => reviews);

        await service.pullReviews();

        verify(() => remoteReviews.getDraftReviews()).called(1);
        verifyNever(() => remoteReviews.getUpdatedSince(any()));
      });

      test('second call does incremental pull via getUpdatedSince', () async {
        when(() => remoteReviews.getDraftReviews())
            .thenAnswer((_) async => []);

        await service.pullReviews();

        when(() => remoteReviews.getUpdatedSince(any()))
            .thenAnswer((_) async => []);

        await service.pullReviews();

        verify(() => remoteReviews.getUpdatedSince(any())).called(1);
      });
    });

    group('pullAll', () {
      test('orchestrates all pulls in correct order', () async {
        final imp1 = fakeDataImport(id: 1, source: ImportSource.kanjivg);
        final imp2 = fakeDataImport(id: 2, source: ImportSource.kanjidic);
        when(() => remoteImports.listAll())
            .thenAnswer((_) async => [imp1, imp2]);
        when(() => remoteKanjiVg.getByImportId(any()))
            .thenAnswer((_) async => []);
        when(() => remoteKanjidic.getByImportId(any()))
            .thenAnswer((_) async => []);
        when(() => remoteReviews.getDraftReviews())
            .thenAnswer((_) async => []);

        await service.pullAll();

        // Imports pulled first
        verify(() => remoteImports.listAll()).called(1);
        // Both imports get kanjiVg + kanjidic pulls
        verify(() => remoteKanjiVg.getByImportId(any())).called(2);
        verify(() => remoteKanjidic.getByImportId(any())).called(2);
        // Reviews pulled last
        verify(() => remoteReviews.getDraftReviews()).called(1);
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
          remoteKanjiVg: remoteKanjiVg,
          localKanjiVg: localKanjiVg,
          remoteKanjidic: remoteKanjidic,
          localKanjidic: localKanjidic,
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
        when(() => remoteReviews.getDraftReviews())
            .thenAnswer((_) async => []);

        await service.pullImports();
        // Reviews haven't been synced yet, so should do full pull
        await service.pullReviews();

        verify(() => remoteImports.listAll()).called(1);
        verify(() => remoteReviews.getDraftReviews()).called(1);
      });
    });
  });
}
