import '../entities/raw_kanjidic.dart';

abstract class RawKanjidicRepository {
  /// Inserts a batch of raw KANJIDIC rows for the given import.
  Future<void> insertBatch(List<RawKanjidic> rows);

  /// Returns all rows for the given [importId].
  Future<List<RawKanjidic>> getByImportId(int importId);

  /// Returns a single row by [importId] and [literal].
  Future<RawKanjidic?> getByLiteral({
    required int importId,
    required String literal,
  });

  /// Returns the total row count for the given [importId].
  Future<int> countByImportId(int importId);
}
