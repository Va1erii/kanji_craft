import 'package:flutter_test/flutter_test.dart';
import 'package:kanji_craft_admin/data/local/admin_database.dart';
import 'package:kanji_craft_admin/data/repositories/drift_data_import_repository.dart';
import 'package:kanji_craft_admin/data/repositories/drift_raw_kanjivg_repository.dart';
import 'package:kanji_craft_admin/domain/entities/import_source.dart';
import 'package:sqlite3/sqlite3.dart';

import '../../helpers/admin_fixtures.dart';
import '../../helpers/admin_test_helpers.dart';

void main() {
  late AdminDatabase db;
  late DriftDataImportRepository importRepo;
  late DriftRawKanjiVgRepository repo;
  late int importId;

  setUp(() async {
    resetFixtureIds();
    db = createTestDatabase();
    final repos = createReposFromDb(db);
    importRepo = repos.imports;
    repo = repos.kanjiVg;

    // Create a parent import for FK
    final imp = await importRepo.create(
      source: ImportSource.kanjivg,
      sourceVersion: '1.0',
    );
    importId = imp.id;
  });

  tearDown(() => db.close());

  group('DriftRawKanjiVgRepository', () {
    group('insertBatch + countByImportId', () {
      test('inserts rows and returns correct count', () async {
        final rows = [
          fakeRawKanjiVg(id: 10, importId: importId, character: '木'),
          fakeRawKanjiVg(id: 11, importId: importId, character: '水'),
        ];

        await repo.insertBatch(rows);

        final count = await repo.countByImportId(importId);
        expect(count, 2);
      });

      test('count returns 0 for non-existent importId', () async {
        final count = await repo.countByImportId(999);
        expect(count, 0);
      });
    });

    group('complex nested strokes/components round-trip', () {
      test('preserves nested component tree', () async {
        final child = fakeComponent(
          element: '十',
          position: 'top',
          strokeIndices: [0, 1],
        );
        final root = fakeComponent(
          element: '木',
          position: 'whole',
          variant: true,
          original: '本',
          part: 1,
          radical: 'general',
          phon: 'moku',
          tradForm: '木',
          strokeIndices: [0, 1, 2, 3],
          children: [child],
        );
        final strokes = [
          fakeStroke(number: 1, type: 'brush', pathData: 'M0,0 L10,10'),
          fakeStroke(number: 2, type: 'press', pathData: 'M5,5 C1,2 3,4 5,6'),
          fakeStroke(number: 3, type: 'flick', pathData: 'M10,0 L0,10'),
          fakeStroke(number: 4, type: 'dot', pathData: 'M3,3 L3,4'),
        ];

        final entity = fakeRawKanjiVg(
          id: 10,
          importId: importId,
          character: '木',
          strokeCount: 4,
          strokes: strokes,
          components: root,
        );

        await repo.insertBatch([entity]);

        final result =
            await repo.getByCharacter(importId: importId, character: '木');
        expect(result, isNotNull);

        // Verify strokes
        expect(result!.strokes, hasLength(4));
        expect(result.strokes[0].number, 1);
        expect(result.strokes[0].type, 'brush');
        expect(result.strokes[1].pathData, 'M5,5 C1,2 3,4 5,6');

        // Verify root component
        expect(result.components.element, '木');
        expect(result.components.position, 'whole');
        expect(result.components.variant, true);
        expect(result.components.original, '本');
        expect(result.components.part, 1);
        expect(result.components.radical, 'general');
        expect(result.components.phon, 'moku');
        expect(result.components.tradForm, '木');
        expect(result.components.strokeIndices, [0, 1, 2, 3]);

        // Verify child
        expect(result.components.children, hasLength(1));
        expect(result.components.children.first.element, '十');
        expect(result.components.children.first.position, 'top');
      });
    });

    group('getByImportId', () {
      test('returns rows ordered by character', () async {
        await repo.insertBatch([
          fakeRawKanjiVg(id: 10, importId: importId, character: '水'),
          fakeRawKanjiVg(id: 11, importId: importId, character: '木'),
          fakeRawKanjiVg(id: 12, importId: importId, character: '火'),
        ]);

        final rows = await repo.getByImportId(importId);

        expect(rows, hasLength(3));
        expect(rows.map((r) => r.character).toList(), ['木', '水', '火']);
      });

      test('returns empty for non-existent importId', () async {
        final rows = await repo.getByImportId(999);
        expect(rows, isEmpty);
      });
    });

    group('getByCharacter', () {
      test('returns matching row', () async {
        await repo.insertBatch([
          fakeRawKanjiVg(id: 10, importId: importId, character: '木'),
        ]);

        final result =
            await repo.getByCharacter(importId: importId, character: '木');
        expect(result, isNotNull);
        expect(result!.character, '木');
      });

      test('returns null for non-existent character', () async {
        final result =
            await repo.getByCharacter(importId: importId, character: '金');
        expect(result, isNull);
      });
    });

    group('unique (importId, character) constraint', () {
      test('throws on duplicate insert', () async {
        await repo.insertBatch([
          fakeRawKanjiVg(id: 10, importId: importId, character: '木'),
        ]);

        await expectLater(
          () => repo.insertBatch([
            fakeRawKanjiVg(id: 11, importId: importId, character: '木'),
          ]),
          throwsA(isA<SqliteException>()),
        );
      });
    });

    group('upsertAll', () {
      test('inserts new and updates existing on conflict', () async {
        // Insert initial
        await repo.upsertAll([
          fakeRawKanjiVg(
            id: 10,
            importId: importId,
            character: '木',
            strokeCount: 4,
          ),
        ]);

        // Upsert with changed strokeCount
        await repo.upsertAll([
          fakeRawKanjiVg(
            id: 10,
            importId: importId,
            character: '木',
            strokeCount: 5,
          ),
          fakeRawKanjiVg(
            id: 11,
            importId: importId,
            character: '水',
          ),
        ]);

        final count = await repo.countByImportId(importId);
        expect(count, 2);

        final updated =
            await repo.getByCharacter(importId: importId, character: '木');
        expect(updated!.strokeCount, 5);
      });
    });
  });
}
