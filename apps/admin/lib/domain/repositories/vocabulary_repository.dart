import 'package:kanji_craft_core/kanji_craft_core.dart';

abstract class VocabularyRepository {
  /// Batch-inserts vocabulary rows.
  Future<void> insertVocabularyBatch(List<Vocabulary> vocabulary);

  /// Batch-inserts vocabulary reading rows.
  Future<void> insertReadingBatch(List<VocabularyReading> readings);

  /// Batch-inserts vocabulary i18n rows.
  Future<void> insertI18nBatch(List<VocabularyI18n> i18n);

  /// Batch-inserts vocabulary kanji link rows.
  Future<void> insertKanjiBatch(List<VocabularyKanji> kanjiLinks);

  /// Inserts sentence rows one-by-one (for auto-ID resolution).
  /// Returns saved rows with generated IDs.
  Future<List<VocabularySentence>> insertSentenceBatch(
    List<VocabularySentence> sentences,
  );

  /// Batch-inserts vocabulary sentence i18n rows.
  Future<void> insertSentenceI18nBatch(List<VocabularySentenceI18n> i18n);

  /// Returns all vocabulary rows.
  Future<List<Vocabulary>> getAllVocabulary();

  /// Deletes all vocabulary (FK cascade handles child tables).
  Future<void> deleteAllVocabulary();

  /// Returns the number of vocabulary rows.
  Future<int> countVocabulary();

  /// Returns the number of vocabulary reading rows.
  Future<int> countReadings();

  /// Returns the number of vocabulary i18n rows.
  Future<int> countI18n();

  /// Returns the number of vocabulary kanji link rows.
  Future<int> countKanji();

  /// Returns the number of vocabulary sentence rows.
  Future<int> countSentences();
}
