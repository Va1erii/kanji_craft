import '../entities/raw_kanjivg.dart';

abstract class RawKanjiVgRepository {
  /// Inserts a batch of raw KanjiVG rows for the given import.
  Future<void> insertBatch(List<RawKanjiVg> rows);

  /// Returns all rows for the given [importId].
  Future<List<RawKanjiVg>> getByImportId(int importId);

  /// Returns a single row by [importId] and [character].
  Future<RawKanjiVg?> getByCharacter({
    required int importId,
    required String character,
  });

  /// Returns the total row count for the given [importId].
  Future<int> countByImportId(int importId);
}
