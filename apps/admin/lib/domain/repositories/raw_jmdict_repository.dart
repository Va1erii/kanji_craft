import '../entities/raw_jmdict.dart';

abstract class RawJmdictRepository {
  /// Inserts a batch of raw JMDict rows for the given import.
  Future<void> insertBatch(List<RawJmdict> rows);

  /// Returns all rows for the given [importId].
  Future<List<RawJmdict>> getByImportId(int importId);

  /// Returns a single row by [importId] and [entSeq].
  Future<RawJmdict?> getByEntSeq({
    required int importId,
    required int entSeq,
  });

  /// Returns the total row count for the given [importId].
  Future<int> countByImportId(int importId);
}
