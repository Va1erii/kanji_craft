import 'package:flutter_test/flutter_test.dart';
import 'package:kanji_craft_admin/data/database/admin_database.dart';
import 'package:kanji_craft_admin/data/repositories/source_vocab_level/drift_source_vocab_level_repository.dart';

import '../../helpers/admin_fixtures.dart';
import '../../helpers/admin_test_helpers.dart';

void main() {
  late AdminDatabase db;
  late DriftSourceVocabLevelRepository repo;

  setUp(() {
    db = createTestDatabase();
    repo = DriftSourceVocabLevelRepository(db);
  });

  tearDown(() => db.close());

  group('DriftSourceVocabLevelRepository', () {
    group('replaceAll + count', () {
      test('inserts rows and returns correct count', () async {
        await repo.replaceAll([
          fakeVocabLevel(expression: '食べる', reading: 'たべる', level: 5),
          fakeVocabLevel(expression: '会う', reading: 'あう', level: 5),
        ]);

        final count = await repo.count();
        expect(count, 2);
      });

      test('replaces all previous rows atomically', () async {
        await repo.replaceAll([
          fakeVocabLevel(expression: '食べる', reading: 'たべる', level: 5),
          fakeVocabLevel(expression: '会う', reading: 'あう', level: 5),
        ]);

        await repo.replaceAll([
          fakeVocabLevel(expression: '勉強', reading: 'べんきょう', level: 4),
        ]);

        final count = await repo.count();
        expect(count, 1);

        final all = await repo.getAll();
        expect(all[0].expression, '勉強');
      });

      test('count returns 0 when empty', () async {
        final count = await repo.count();
        expect(count, 0);
      });
    });

    group('getAll', () {
      test('returns rows ordered by level then expression', () async {
        await repo.replaceAll([
          fakeVocabLevel(expression: '様々', reading: 'さまざま', level: 3),
          fakeVocabLevel(expression: '会う', reading: 'あう', level: 5),
          fakeVocabLevel(expression: '食べる', reading: 'たべる', level: 5),
          fakeVocabLevel(expression: '盗む', reading: 'ぬすむ', level: 4),
        ]);

        final all = await repo.getAll();

        expect(all, hasLength(4));
        // Level 3 first, then 4, then 5 (sorted within level by expression).
        expect(all[0].expression, '様々');
        expect(all[0].level, 3);
        expect(all[1].expression, '盗む');
        expect(all[1].level, 4);
        // Level 5 — 会 (U+4F1A) < 食 (U+98DF) by Unicode.
        expect(all[2].level, 5);
        expect(all[3].level, 5);
      });

      test('returns empty list when no data', () async {
        final all = await repo.getAll();
        expect(all, isEmpty);
      });
    });

    group('domain round-trip', () {
      test('preserves all fields', () async {
        await repo.replaceAll([
          fakeVocabLevel(expression: '開く', reading: 'あく', level: 5),
        ]);

        final all = await repo.getAll();
        expect(all, hasLength(1));
        expect(all[0].expression, '開く');
        expect(all[0].reading, 'あく');
        expect(all[0].level, 5);
      });
    });

    group('composite PK constraint', () {
      test('allows same expression with different readings', () async {
        await repo.replaceAll([
          fakeVocabLevel(expression: '開く', reading: 'あく', level: 5),
          fakeVocabLevel(expression: '開く', reading: 'ひらく', level: 3),
        ]);

        final count = await repo.count();
        expect(count, 2);
      });
    });
  });
}
