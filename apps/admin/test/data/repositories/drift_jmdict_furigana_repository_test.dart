import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kanji_craft_admin/data/database/admin_database.dart';
import 'package:kanji_craft_admin/data/repositories/data_import/drift_data_import_repository.dart';
import 'package:kanji_craft_admin/data/repositories/jmdict_furigana/drift_jmdict_furigana_repository.dart';
import 'package:kanji_craft_admin/domain/entities/import_source.dart';
import 'package:sqlite3/sqlite3.dart';

import '../../helpers/admin_fixtures.dart';
import '../../helpers/admin_test_helpers.dart';

void main() {
  late AdminDatabase db;
  late DriftDataImportRepository importRepo;
  late DriftJmdictFuriganaRepository repo;
  late int importId;

  setUp(() async {
    resetFixtureIds();
    db = createTestDatabase();
    importRepo = createReposFromDb(db).imports;
    repo = DriftJmdictFuriganaRepository(db);

    final imp = await importRepo.create(
      source: ImportSource.jmdict,
      sourceVersion: '1.0',
    );
    importId = imp.id;
  });

  tearDown(() => db.close());

  group('DriftJmdictFuriganaRepository', () {
    group('insertBatch + countByImportId', () {
      test('inserts rows and returns correct count', () async {
        await repo.insertBatch(
          [
            fakeJmdictFurigana(text: '食べる', reading: 'たべる'),
            fakeJmdictFurigana(text: '大人', reading: 'おとな'),
          ],
          importId: importId,
        );

        final count = await repo.countByImportId(importId);
        expect(count, 2);
      });

      test('count returns 0 for non-existent importId', () async {
        final count = await repo.countByImportId(999);
        expect(count, 0);
      });
    });

    group('getByImportId', () {
      test('returns rows ordered by text then reading', () async {
        await repo.insertBatch(
          [
            fakeJmdictFurigana(text: '食べる', reading: 'たべる'),
            fakeJmdictFurigana(text: '大人', reading: 'おとな'),
            fakeJmdictFurigana(text: '冷蔵庫', reading: 'れいぞうこ'),
          ],
          importId: importId,
        );

        final rows = await repo.getByImportId(importId);

        expect(rows, hasLength(3));
        // Ordered by text (Unicode): 冷 < 大 < 食.
        expect(rows[0].text, '冷蔵庫');
        expect(rows[1].text, '大人');
        expect(rows[2].text, '食べる');
      });

      test('returns empty for non-existent importId', () async {
        final rows = await repo.getByImportId(999);
        expect(rows, isEmpty);
      });
    });

    group('getByTextAndReading', () {
      test('returns matching entry', () async {
        await repo.insertBatch(
          [fakeJmdictFurigana(text: '食べる', reading: 'たべる')],
          importId: importId,
        );

        final result = await repo.getByTextAndReading(
          importId: importId,
          text: '食べる',
          reading: 'たべる',
        );

        expect(result, isNotNull);
        expect(result!.text, '食べる');
        expect(result.reading, 'たべる');
      });

      test('returns null for non-existent text/reading', () async {
        final result = await repo.getByTextAndReading(
          importId: importId,
          text: '存在しない',
          reading: 'そんざいしない',
        );
        expect(result, isNull);
      });

      test('distinguishes different readings for same text', () async {
        await repo.insertBatch(
          [
            fakeJmdictFurigana(
              text: '明白',
              reading: 'めいはく',
              furiganaSegments: [
                {'ruby': '明', 'rt': 'めい'},
                {'ruby': '白', 'rt': 'はく'},
              ],
            ),
            fakeJmdictFurigana(
              text: '明白',
              reading: 'あからさま',
              furiganaSegments: [
                {'ruby': '明白', 'rt': 'あからさま'},
              ],
            ),
          ],
          importId: importId,
        );

        final r1 = await repo.getByTextAndReading(
          importId: importId,
          text: '明白',
          reading: 'めいはく',
        );
        final r2 = await repo.getByTextAndReading(
          importId: importId,
          text: '明白',
          reading: 'あからさま',
        );

        expect(r1, isNotNull);
        expect(r2, isNotNull);
        expect(r1!.reading, 'めいはく');
        expect(r2!.reading, 'あからさま');
      });
    });

    group('deleteByImportId', () {
      test('deletes all rows for given importId', () async {
        await repo.insertBatch(
          [
            fakeJmdictFurigana(text: '食べる', reading: 'たべる'),
            fakeJmdictFurigana(text: '大人', reading: 'おとな'),
          ],
          importId: importId,
        );

        await repo.deleteByImportId(importId);

        final count = await repo.countByImportId(importId);
        expect(count, 0);
      });

      test('does not affect rows from other imports', () async {
        final imp2 = await importRepo.create(
          source: ImportSource.jmdict,
          sourceVersion: '2.0',
        );

        await repo.insertBatch(
          [fakeJmdictFurigana(text: '食べる', reading: 'たべる')],
          importId: importId,
        );
        await repo.insertBatch(
          [fakeJmdictFurigana(text: '大人', reading: 'おとな')],
          importId: imp2.id,
        );

        await repo.deleteByImportId(importId);

        expect(await repo.countByImportId(importId), 0);
        expect(await repo.countByImportId(imp2.id), 1);
      });
    });

    group('domain round-trip', () {
      test('preserves furigana JSON string', () async {
        final furigana = [
          {'ruby': '食', 'rt': 'た'},
          {'ruby': 'べる'},
        ];

        await repo.insertBatch(
          [
            fakeJmdictFurigana(
              text: '食べる',
              reading: 'たべる',
              furiganaSegments: furigana,
            ),
          ],
          importId: importId,
        );

        final result = await repo.getByTextAndReading(
          importId: importId,
          text: '食べる',
          reading: 'たべる',
        );

        expect(result, isNotNull);
        final decoded = jsonDecode(result!.furigana) as List;
        expect(decoded, hasLength(2));
        expect(decoded[0]['ruby'], '食');
        expect(decoded[0]['rt'], 'た');
        expect(decoded[1]['ruby'], 'べる');
        expect(decoded[1].containsKey('rt'), isFalse);
      });
    });

    group('composite PK constraint', () {
      test('throws on duplicate (importId, text, reading)', () async {
        await repo.insertBatch(
          [fakeJmdictFurigana(text: '食べる', reading: 'たべる')],
          importId: importId,
        );

        await expectLater(
          () => repo.insertBatch(
            [fakeJmdictFurigana(text: '食べる', reading: 'たべる')],
            importId: importId,
          ),
          throwsA(isA<SqliteException>()),
        );
      });

      test('allows same text/reading under different importId', () async {
        final imp2 = await importRepo.create(
          source: ImportSource.jmdict,
          sourceVersion: '2.0',
        );

        await repo.insertBatch(
          [fakeJmdictFurigana(text: '食べる', reading: 'たべる')],
          importId: importId,
        );
        await repo.insertBatch(
          [fakeJmdictFurigana(text: '食べる', reading: 'たべる')],
          importId: imp2.id,
        );

        expect(await repo.countByImportId(importId), 1);
        expect(await repo.countByImportId(imp2.id), 1);
      });
    });
  });
}
