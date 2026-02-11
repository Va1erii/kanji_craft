import '../entities/draft_kanji.dart';
import '../entities/draft_kanji_i18n.dart';
import '../entities/draft_kanji_reading.dart';

abstract class KanjiRepository {
  /// Batch-inserts draft kanji rows.
  Future<void> insertDraftKanjiBatch(List<DraftKanji> kanji);

  /// Batch-inserts draft kanji reading rows.
  Future<void> insertDraftKanjiReadingBatch(List<DraftKanjiReading> readings);

  /// Batch-inserts draft kanji i18n rows.
  Future<void> insertDraftKanjiI18nBatch(List<DraftKanjiI18n> i18n);

  /// Returns all draft kanji ordered by character.
  Future<List<DraftKanji>> getAllDraftKanji();

  /// Deletes all draft kanji (cascades to readings + i18n).
  Future<void> deleteAllDraftKanji();

  /// Returns the number of draft kanji.
  Future<int> countDraftKanji();

  /// Returns the number of draft kanji readings.
  Future<int> countDraftKanjiReadings();

  /// Returns the number of draft kanji i18n rows.
  Future<int> countDraftKanjiI18n();
}
