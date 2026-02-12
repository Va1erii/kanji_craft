import 'package:flutter_test/flutter_test.dart';
import 'package:kanji_craft_admin/data/database/admin_database.dart';
import 'package:kanji_craft_admin/data/repositories/kanji_component/drift_kanji_component_repository.dart';
import 'package:kanji_craft_core/kanji_craft_core.dart';

import '../../../helpers/admin_test_helpers.dart';

void main() {
  late AdminDatabase db;
  late DriftKanjiComponentRepository repo;

  /// Insert a content kanji row and return its auto-generated ID.
  Future<int> insertContentKanji(String character) async {
    return db.into(db.kanjiEntries).insert(
          KanjiEntriesCompanion.insert(
            character: character,
            strokeCount: 4,
            frequencyRank: 100,
            svgFileName: '$character.svg',
            svgFileUrl: 'https://example.com/$character.svg',
            svgHash: 'hash_$character',
          ),
        );
  }

  /// Insert a content radical row and return its auto-generated ID.
  Future<int> insertContentRadical(String masterSymbol) async {
    return db.into(db.radicalEntries).insert(
          RadicalEntriesCompanion.insert(
            masterSymbol: masterSymbol,
            strokeCount: 3,
            impactScore: 5,
            minJlptLevel: 3,
            minGrade: 2,
            svgFileName: '$masterSymbol.svg',
            svgFileUrl: 'https://example.com/$masterSymbol.svg',
            svgHash: 'hash_$masterSymbol',
          ),
        );
  }

  /// Insert a kanji component and return its auto-generated ID.
  Future<int> insertComponent({
    required int kanjiId,
    required int radicalId,
    Position position = Position.unknown,
    LogicHint logicHint = LogicHint.semantic,
    RadicalType radicalType = RadicalType.component,
  }) async {
    return db.into(db.kanjiComponentEntries).insert(
          KanjiComponentEntriesCompanion.insert(
            kanjiId: kanjiId,
            radicalId: radicalId,
            position: position,
            logicHint: logicHint,
            radicalType: radicalType,
          ),
        );
  }

  setUp(() {
    db = createTestDatabase();
    repo = DriftKanjiComponentRepository(db);
  });

  tearDown(() => db.close());

  group('DriftKanjiComponentRepository', () {
    test('getAll returns empty list when no components exist', () async {
      final result = await repo.getAll();
      expect(result, isEmpty);
    });

    test('count returns 0 when no components exist', () async {
      final result = await repo.count();
      expect(result, 0);
    });

    test('getAll returns inserted components', () async {
      final kanjiId = await insertContentKanji('忙');
      final radicalId = await insertContentRadical('亡');

      await insertComponent(kanjiId: kanjiId, radicalId: radicalId);

      final result = await repo.getAll();
      expect(result, hasLength(1));
      expect(result.first.kanjiId, kanjiId);
      expect(result.first.radicalId, radicalId);
      expect(result.first.logicHint, LogicHint.semantic);
    });

    test('count returns correct count', () async {
      final kanjiId = await insertContentKanji('忙');
      final radical1Id = await insertContentRadical('忄');
      final radical2Id = await insertContentRadical('亡');

      await insertComponent(kanjiId: kanjiId, radicalId: radical1Id);
      await insertComponent(kanjiId: kanjiId, radicalId: radical2Id);

      final result = await repo.count();
      expect(result, 2);
    });

    test('updateLogicHint changes the logic_hint value', () async {
      final kanjiId = await insertContentKanji('忙');
      final radicalId = await insertContentRadical('亡');
      final componentId = await insertComponent(
        kanjiId: kanjiId,
        radicalId: radicalId,
        logicHint: LogicHint.semantic,
      );

      await repo.updateLogicHint(
        id: componentId,
        logicHint: LogicHint.phonetic,
      );

      final result = await repo.getAll();
      expect(result.first.logicHint, LogicHint.phonetic);
    });

    test('getKanjiCharMap returns kanji id-to-character map', () async {
      final id1 = await insertContentKanji('忙');
      final id2 = await insertContentKanji('死');

      final result = await repo.getKanjiCharMap();
      expect(result, {id1: '忙', id2: '死'});
    });

    test('getRadicalSymbolMap returns radical id-to-symbol map', () async {
      final id1 = await insertContentRadical('亡');
      final id2 = await insertContentRadical('心');

      final result = await repo.getRadicalSymbolMap();
      expect(result, {id1: '亡', id2: '心'});
    });
  });
}
