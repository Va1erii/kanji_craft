import '../entities/vocab_level.dart';

abstract class SourceVocabLevelRepository {
  /// Atomically replaces all rows with the given [levels].
  Future<void> replaceAll(List<VocabLevel> levels);

  /// Returns all stored vocab levels.
  Future<List<VocabLevel>> getAll();

  /// Returns the total row count.
  Future<int> count();
}
