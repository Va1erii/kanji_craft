import 'package:kanji_craft_core/kanji_craft_core.dart';

abstract class KanjiComponentRepository {
  /// Returns all kanji component rows.
  Future<List<KanjiComponent>> getAll();

  /// Returns the total number of kanji component rows.
  Future<int> count();

  /// Deletes all kanji component rows (idempotent re-run support).
  Future<void> deleteAll();

  /// Batch-upserts components on `(kanji_id, radical_id, position)`.
  Future<void> upsertBatch(List<KanjiComponent> components);

  /// Updates the `logic_hint` for a single component.
  Future<void> updateLogicHint({
    required int id,
    required LogicHint logicHint,
  });

  /// Returns a map of draft kanji ID → character.
  /// Component FKs reference draft kanji IDs during extraction.
  Future<Map<int, String>> getKanjiCharMap();

  /// Returns a map of draft radical ID → master_symbol.
  /// Component FKs reference draft radical IDs during extraction.
  Future<Map<int, String>> getRadicalSymbolMap();
}
