import 'package:flutter_test/flutter_test.dart';
import 'package:kanji_craft_admin/data/local/admin_database.dart';
import 'package:kanji_craft_admin/data/repositories/drift_data_import_repository.dart';
import 'package:kanji_craft_admin/data/repositories/drift_raw_kanjidic_repository.dart';
import 'package:kanji_craft_admin/domain/entities/import_source.dart';
import 'package:kanji_craft_admin/domain/entities/raw_kanjidic.dart';
import 'package:sqlite3/sqlite3.dart';

import '../../helpers/admin_fixtures.dart';
import '../../helpers/admin_test_helpers.dart';

void main() {
  late AdminDatabase db;
  late DriftDataImportRepository importRepo;
  late DriftRawKanjidicRepository repo;
  late int importId;

  setUp(() async {
    resetFixtureIds();
    db = createTestDatabase();
    final repos = createReposFromDb(db);
    importRepo = repos.imports;
    repo = repos.kanjidic;

    final imp = await importRepo.create(
      source: ImportSource.kanjidic,
      sourceVersion: '1.0',
    );
    importId = imp.id;
  });

  tearDown(() => db.close());

  group('DriftRawKanjidicRepository', () {
    group('insertBatch + countByImportId', () {
      test('inserts rows and returns correct count', () async {
        await repo.insertBatch([
          fakeRawKanjidic(importId: importId, literal: '木'),
          fakeRawKanjidic(importId: importId, literal: '水'),
        ]);

        final count = await repo.countByImportId(importId);
        expect(count, 2);
      });

      test('count returns 0 for non-existent importId', () async {
        final count = await repo.countByImportId(999);
        expect(count, 0);
      });
    });

    group('complex nested types round-trip', () {
      test('preserves all nested structures', () async {
        final entity = fakeRawKanjidic(
          importId: importId,
          literal: '日',
          strokeCount: 4,
          strokeCountMisstrokes: [3, 5],
          grade: 1,
          jlpt: 4,
          frequency: 5,
          codepoints: fakeCodepoints(
            ucs: '65E5',
            jis208: '38-92',
            jis212: '1-1',
            jis213: '2-2',
          ),
          radicals: fakeRadicals(classical: 72, nelsonC: 73),
          dictRefs: const KanjidicDictRefs(
            nelsonC: '2097',
            nelsonN: '2410',
            halpernNjecd: '3027',
            halpernKkd: '3829',
            halpernKkld: '1946',
            halpernKkld2ed: '2636',
            heisig: '12',
            heisig6: '12',
            gakken: '1',
            oneillNames: '1',
            oneillKk: '1',
            moro: KanjidicMoroRef(volume: '4', page: '0123'),
            henshall: '62',
            shKk: '1',
            shKk2: '1',
            jfCards: '1',
            tuttCards: '1',
            kanjiInContext: '1',
            kodanshaCompact: '1',
            skip: '3-3-1',
            busyPeople: '1',
          ),
          queryCodes: const KanjidicQueryCodes(
            skip: '3-3-1',
            fourCorner: '6010.0',
            shDesc: '3',
            deroo: '3855',
            misclass: [
              KanjidicMisclass(type: 'posn', value: '3-2-2'),
              KanjidicMisclass(type: 'strokes', value: '5'),
            ],
          ),
          readings: fakeReadings(
            jaOn: ['ニチ', 'ジツ'],
            jaKun: ['ひ', 'か'],
            pinyin: ['ri4'],
            koreanR: ['il'],
            koreanH: ['일'],
          ),
          nanori: ['あ', 'く'],
          meanings: {
            'en': ['day', 'sun'],
            'fr': ['jour', 'soleil'],
          },
          variants: const [
            KanjidicVariant(varType: 'jis208', value: '38-92'),
          ],
          radicalNames: ['ひ'],
        );

        await repo.insertBatch([entity]);

        final result =
            await repo.getByLiteral(importId: importId, literal: '日');
        expect(result, isNotNull);

        // Codepoints
        expect(result!.codepoints.ucs, '65E5');
        expect(result.codepoints.jis208, '38-92');
        expect(result.codepoints.jis212, '1-1');
        expect(result.codepoints.jis213, '2-2');

        // Radicals
        expect(result.radicals.classical, 72);
        expect(result.radicals.nelsonC, 73);

        // Dict refs
        expect(result.dictRefs, isNotNull);
        expect(result.dictRefs!.nelsonC, '2097');
        expect(result.dictRefs!.moro!.volume, '4');
        expect(result.dictRefs!.moro!.page, '0123');
        expect(result.dictRefs!.skip, '3-3-1');

        // Query codes
        expect(result.queryCodes, isNotNull);
        expect(result.queryCodes!.fourCorner, '6010.0');
        expect(result.queryCodes!.misclass, hasLength(2));
        expect(result.queryCodes!.misclass!.first.type, 'posn');

        // Readings
        expect(result.readings.jaOn, ['ニチ', 'ジツ']);
        expect(result.readings.jaKun, ['ひ', 'か']);
        expect(result.readings.pinyin, ['ri4']);
        expect(result.readings.koreanR, ['il']);
        expect(result.readings.koreanH, ['일']);

        // Other
        expect(result.nanori, ['あ', 'く']);
        expect(result.meanings['en'], ['day', 'sun']);
        expect(result.meanings['fr'], ['jour', 'soleil']);
        expect(result.variants, hasLength(1));
        expect(result.variants!.first.varType, 'jis208');
        expect(result.radicalNames, ['ひ']);
        expect(result.strokeCountMisstrokes, [3, 5]);
        expect(result.grade, 1);
        expect(result.jlpt, 4);
        expect(result.frequency, 5);
      });
    });

    group('minimal entity round-trips', () {
      test('all nullable fields null', () async {
        final entity = fakeRawKanjidic(
          importId: importId,
          literal: '一',
          strokeCount: 1,
        );

        await repo.insertBatch([entity]);

        final result =
            await repo.getByLiteral(importId: importId, literal: '一');
        expect(result, isNotNull);
        expect(result!.strokeCountMisstrokes, isNull);
        expect(result.grade, isNull);
        expect(result.jlpt, isNull);
        expect(result.frequency, isNull);
        expect(result.dictRefs, isNull);
        expect(result.queryCodes, isNull);
        expect(result.nanori, isNull);
        expect(result.variants, isNull);
        expect(result.radicalNames, isNull);
      });
    });

    group('getByImportId', () {
      test('returns rows ordered by literal', () async {
        await repo.insertBatch([
          fakeRawKanjidic(importId: importId, literal: '水'),
          fakeRawKanjidic(importId: importId, literal: '木'),
          fakeRawKanjidic(importId: importId, literal: '火'),
        ]);

        final rows = await repo.getByImportId(importId);

        expect(rows, hasLength(3));
        expect(rows.map((r) => r.literal).toList(), ['木', '水', '火']);
      });

      test('returns empty for non-existent importId', () async {
        final rows = await repo.getByImportId(999);
        expect(rows, isEmpty);
      });
    });

    group('getByLiteral', () {
      test('returns matching row', () async {
        await repo.insertBatch([
          fakeRawKanjidic(importId: importId, literal: '木'),
        ]);

        final result =
            await repo.getByLiteral(importId: importId, literal: '木');
        expect(result, isNotNull);
        expect(result!.literal, '木');
      });

      test('returns null for non-existent literal', () async {
        final result =
            await repo.getByLiteral(importId: importId, literal: '金');
        expect(result, isNull);
      });
    });

    group('unique (importId, literal) constraint', () {
      test('throws on duplicate insert', () async {
        await repo.insertBatch([
          fakeRawKanjidic(importId: importId, literal: '木'),
        ]);

        await expectLater(
          () => repo.insertBatch([
            fakeRawKanjidic(importId: importId, literal: '木'),
          ]),
          throwsA(isA<SqliteException>()),
        );
      });
    });

    group('upsertAll', () {
      test('inserts new and updates existing on conflict', () async {
        await repo.upsertAll([
          fakeRawKanjidic(
            importId: importId,
            literal: '木',
            strokeCount: 4,
          ),
        ]);

        await repo.upsertAll([
          fakeRawKanjidic(
            importId: importId,
            literal: '木',
            strokeCount: 5,
          ),
          fakeRawKanjidic(
            importId: importId,
            literal: '水',
          ),
        ]);

        final count = await repo.countByImportId(importId);
        expect(count, 2);

        final updated =
            await repo.getByLiteral(importId: importId, literal: '木');
        expect(updated!.strokeCount, 5);
      });
    });
  });
}
