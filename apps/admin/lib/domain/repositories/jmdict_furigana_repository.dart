import '../entities/jmdict_furigana.dart';

abstract class JmdictFuriganaRepository {
  /// Inserts a batch of furigana rows for the given import.
  Future<void> insertBatch(List<JmdictFurigana> rows, {required int importId});

  /// Returns all rows for the given [importId].
  Future<List<JmdictFurigana>> getByImportId(int importId);

  /// Looks up a single furigana entry by text and reading.
  Future<JmdictFurigana?> getByTextAndReading({
    required int importId,
    required String text,
    required String reading,
  });

  /// Returns the total row count for the given [importId].
  Future<int> countByImportId(int importId);

  /// Deletes all rows for the given [importId].
  Future<void> deleteByImportId(int importId);
}
