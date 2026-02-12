import 'package:flutter_test/flutter_test.dart';
import 'package:kanji_craft_admin/data/database/admin_database.dart';
import 'package:kanji_craft_admin/data/repositories/data_import/drift_data_import_repository.dart';
import 'package:kanji_craft_admin/domain/entities/import_source.dart';
import 'package:kanji_craft_admin/domain/entities/import_status.dart';

import '../../helpers/admin_fixtures.dart';
import '../../helpers/admin_test_helpers.dart';

void main() {
  late AdminDatabase db;
  late DriftDataImportRepository repo;

  setUp(() {
    resetFixtureIds();
    db = createTestDatabase();
    repo = createReposFromDb(db).imports;
  });

  tearDown(() => db.close());

  group('DriftDataImportRepository', () {
    group('create', () {
      test('returns entity with correct fields and pending status', () async {
        final result = await repo.create(
          source: ImportSource.kanjivg,
          sourceVersion: '2024.1',
        );

        expect(result.id, isPositive);
        expect(result.source, ImportSource.kanjivg);
        expect(result.sourceVersion, '2024.1');
        expect(result.status, ImportStatus.pending);
        expect(result.recordCount, isNull);
        expect(result.ingestedAt, isNull);
        expect(result.processedAt, isNull);
        expect(result.errorMessage, isNull);
        expect(result.metadata, isNull);
        expect(result.startedAt, isNotNull);
        expect(result.createdAt, isNotNull);
        expect(result.updatedAt, isNotNull);
      });

      test('with metadata round-trips JSON map', () async {
        final meta = {'key': 'value', 'count': 42};
        final result = await repo.create(
          source: ImportSource.kanjidic,
          sourceVersion: '1.0',
          metadata: meta,
        );

        expect(result.metadata, {'key': 'value', 'count': 42});
      });
    });

    group('getById', () {
      test('returns entity when found', () async {
        final created = await repo.create(
          source: ImportSource.kanjivg,
          sourceVersion: '1.0',
        );

        final found = await repo.getById(created.id);

        expect(found, isNotNull);
        expect(found!.id, created.id);
        expect(found.source, ImportSource.kanjivg);
      });

      test('returns null for non-existent id', () async {
        final found = await repo.getById(999);
        expect(found, isNull);
      });
    });

    group('getActiveBySource', () {
      test('returns active import', () async {
        await repo.create(
          source: ImportSource.kanjivg,
          sourceVersion: '1.0',
        );

        final active = await repo.getActiveBySource(ImportSource.kanjivg);
        expect(active, isNotNull);
        expect(active!.status, ImportStatus.pending);
      });

      test('excludes processed imports', () async {
        final created = await repo.create(
          source: ImportSource.kanjivg,
          sourceVersion: '1.0',
        );
        await repo.updateStatus(
          id: created.id,
          status: ImportStatus.processed,
        );

        final active = await repo.getActiveBySource(ImportSource.kanjivg);
        expect(active, isNull);
      });

      test('excludes failed imports', () async {
        final created = await repo.create(
          source: ImportSource.kanjivg,
          sourceVersion: '1.0',
        );
        await repo.updateStatus(
          id: created.id,
          status: ImportStatus.failed,
          errorMessage: 'oops',
        );

        final active = await repo.getActiveBySource(ImportSource.kanjivg);
        expect(active, isNull);
      });

      test('returns null when none exist', () async {
        final active = await repo.getActiveBySource(ImportSource.kanjidic);
        expect(active, isNull);
      });
    });

    group('hasProcessedVersion', () {
      test('returns true when processed import with matching source+version exists',
          () async {
        final created = await repo.create(
          source: ImportSource.kanjivg,
          sourceVersion: '2024.1',
        );
        await repo.updateStatus(
          id: created.id,
          status: ImportStatus.processed,
        );

        final result = await repo.hasProcessedVersion(
          source: ImportSource.kanjivg,
          sourceVersion: '2024.1',
        );
        expect(result, isTrue);
      });

      test('returns false when no match exists', () async {
        final result = await repo.hasProcessedVersion(
          source: ImportSource.kanjivg,
          sourceVersion: '2024.1',
        );
        expect(result, isFalse);
      });

      test('returns false when matching source+version exists but status is failed',
          () async {
        final created = await repo.create(
          source: ImportSource.kanjivg,
          sourceVersion: '2024.1',
        );
        await repo.updateStatus(
          id: created.id,
          status: ImportStatus.failed,
          errorMessage: 'oops',
        );

        final result = await repo.hasProcessedVersion(
          source: ImportSource.kanjivg,
          sourceVersion: '2024.1',
        );
        expect(result, isFalse);
      });
    });

    group('updateStatus', () {
      test('sets status to ingested with ingestedAt timestamp', () async {
        final created = await repo.create(
          source: ImportSource.kanjivg,
          sourceVersion: '1.0',
        );

        final updated = await repo.updateStatus(
          id: created.id,
          status: ImportStatus.ingested,
          recordCount: 100,
        );

        expect(updated.status, ImportStatus.ingested);
        expect(updated.recordCount, 100);
        expect(updated.ingestedAt, isNotNull);
        expect(updated.processedAt, isNull);
      });

      test('sets processedAt when status is processed', () async {
        final created = await repo.create(
          source: ImportSource.kanjivg,
          sourceVersion: '1.0',
        );

        final updated = await repo.updateStatus(
          id: created.id,
          status: ImportStatus.processed,
        );

        expect(updated.status, ImportStatus.processed);
        expect(updated.processedAt, isNotNull);
      });

      test('sets errorMessage on failure', () async {
        final created = await repo.create(
          source: ImportSource.kanjivg,
          sourceVersion: '1.0',
        );

        final updated = await repo.updateStatus(
          id: created.id,
          status: ImportStatus.failed,
          errorMessage: 'parse error',
        );

        expect(updated.status, ImportStatus.failed);
        expect(updated.errorMessage, 'parse error');
      });
    });

    group('delete', () {
      test('removes the import row', () async {
        final created = await repo.create(
          source: ImportSource.kanjivg,
          sourceVersion: '1.0',
        );

        await repo.delete(created.id);

        final found = await repo.getById(created.id);
        expect(found, isNull);
      });

      test('does not affect other imports', () async {
        final first = await repo.create(
          source: ImportSource.kanjivg,
          sourceVersion: '1.0',
        );
        final second = await repo.create(
          source: ImportSource.kanjidic,
          sourceVersion: '2.0',
        );

        await repo.delete(first.id);

        final remaining = await repo.listAll();
        expect(remaining, hasLength(1));
        expect(remaining.single.id, second.id);
      });

      test('is a no-op for non-existent id', () async {
        await repo.create(
          source: ImportSource.kanjivg,
          sourceVersion: '1.0',
        );

        // Should not throw.
        await repo.delete(999);

        final list = await repo.listAll();
        expect(list, hasLength(1));
      });
    });

    group('listAll', () {
      test('returns imports ordered by createdAt desc', () async {
        await repo.create(
          source: ImportSource.kanjivg,
          sourceVersion: '1.0',
        );
        await repo.create(
          source: ImportSource.kanjidic,
          sourceVersion: '2.0',
        );

        final list = await repo.listAll();

        expect(list, hasLength(2));
        // Most recent first
        expect(list.first.sourceVersion, '2.0');
        expect(list.last.sourceVersion, '1.0');
      });

      test('returns empty list when no rows exist', () async {
        final list = await repo.listAll();
        expect(list, isEmpty);
      });
    });

    group('upsertAll', () {
      test('inserts new rows', () async {
        final imports = [
          fakeDataImport(id: 1, sourceVersion: '1.0'),
          fakeDataImport(id: 2, sourceVersion: '2.0'),
        ];

        await repo.upsertAll(imports);

        final list = await repo.listAll();
        expect(list, hasLength(2));
      });

      test('updates existing rows on conflict', () async {
        final original = fakeDataImport(
          id: 1,
          sourceVersion: '1.0',
          status: ImportStatus.pending,
        );
        await repo.upsertAll([original]);

        final updated = fakeDataImport(
          id: 1,
          sourceVersion: '1.0',
          status: ImportStatus.ingested,
        );
        await repo.upsertAll([updated]);

        final result = await repo.getById(1);
        expect(result!.status, ImportStatus.ingested);

        final list = await repo.listAll();
        expect(list, hasLength(1));
      });
    });
  });
}
