import 'package:kanji_craft_core/kanji_craft_core.dart';

abstract class KanjiComponentRepository {
  /// Returns all kanji component rows.
  Future<List<KanjiComponent>> getAll();

  /// Returns the total number of kanji component rows.
  Future<int> count();

  /// Updates the `logic_hint` for a single component.
  Future<void> updateLogicHint({
    required int id,
    required LogicHint logicHint,
  });

  /// Returns a map of kanji ID → character from the content `kanji_entries`
  /// table. Used by [EstimateLogicHints] to resolve component FKs.
  Future<Map<int, String>> getKanjiCharMap();

  /// Returns a map of radical ID → master_symbol from the content
  /// `radical_entries` table. Used by [EstimateLogicHints] to resolve
  /// component FKs.
  Future<Map<int, String>> getRadicalSymbolMap();
}
