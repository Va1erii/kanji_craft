import 'package:drift/drift.dart';
import 'package:kanji_craft_core/kanji_craft_core.dart';

import '../../../domain/repositories/vocabulary_repository.dart';
import '../../database/admin_database.dart';
import '../../database/mappers/admin_mappers.dart';

class DriftVocabularyRepository implements VocabularyRepository {
  DriftVocabularyRepository(this._db);

  final AdminDatabase _db;

  @override
  Future<void> insertVocabularyBatch(List<Vocabulary> vocabulary) async {
    await _db.batch((b) {
      for (final item in vocabulary) {
        b.insert(_db.vocabularyEntries, item.toCompanion());
      }
    });
  }

  @override
  Future<void> insertReadingBatch(List<VocabularyReading> readings) async {
    await _db.batch((b) {
      for (final item in readings) {
        b.insert(_db.vocabularyReadingEntries, item.toCompanion());
      }
    });
  }

  @override
  Future<void> insertI18nBatch(List<VocabularyI18n> i18n) async {
    await _db.batch((b) {
      for (final item in i18n) {
        b.insert(_db.vocabularyI18nEntries, item.toCompanion());
      }
    });
  }

  @override
  Future<void> insertKanjiBatch(List<VocabularyKanji> kanjiLinks) async {
    await _db.batch((b) {
      for (final item in kanjiLinks) {
        b.insert(_db.vocabularyKanjiEntries, item.toCompanion());
      }
    });
  }

  @override
  Future<List<VocabularySentence>> insertSentenceBatch(
    List<VocabularySentence> sentences,
  ) async {
    final saved = <VocabularySentence>[];
    for (final sentence in sentences) {
      final id = await _db.into(_db.vocabularySentenceEntries).insert(
            sentence.toCompanion(),
          );
      final entry = await (_db.select(_db.vocabularySentenceEntries)
            ..where((t) => t.id.equals(id)))
          .getSingle();
      saved.add(entry.toDomain());
    }
    return saved;
  }

  @override
  Future<void> insertSentenceI18nBatch(
    List<VocabularySentenceI18n> i18n,
  ) async {
    await _db.batch((b) {
      for (final item in i18n) {
        b.insert(_db.vocabularySentenceI18nEntries, item.toCompanion());
      }
    });
  }

  @override
  Future<List<Vocabulary>> getAllVocabulary() async {
    final entries = await (_db.select(_db.vocabularyEntries)
          ..orderBy([(t) => OrderingTerm.asc(t.word)]))
        .get();
    return entries.map((e) => e.toDomain()).toList();
  }

  @override
  Future<void> deleteAllVocabulary() async {
    // Delete children first — FK cascade requires PRAGMA foreign_keys = ON
    // which isn't enabled by default in SQLite.
    await _db.delete(_db.vocabularySentenceI18nEntries).go();
    await _db.delete(_db.vocabularySentenceEntries).go();
    await _db.delete(_db.vocabularyKanjiEntries).go();
    await _db.delete(_db.vocabularyI18nEntries).go();
    await _db.delete(_db.vocabularyReadingEntries).go();
    await _db.delete(_db.vocabularyEntries).go();
  }

  @override
  Future<int> countVocabulary() async {
    final c = countAll();
    final query = _db.selectOnly(_db.vocabularyEntries)..addColumns([c]);
    final result = await query.getSingle();
    return result.read(c)!;
  }

  @override
  Future<int> countReadings() async {
    final c = countAll();
    final query = _db.selectOnly(_db.vocabularyReadingEntries)
      ..addColumns([c]);
    final result = await query.getSingle();
    return result.read(c)!;
  }

  @override
  Future<int> countI18n() async {
    final c = countAll();
    final query = _db.selectOnly(_db.vocabularyI18nEntries)..addColumns([c]);
    final result = await query.getSingle();
    return result.read(c)!;
  }

  @override
  Future<int> countKanji() async {
    final c = countAll();
    final query = _db.selectOnly(_db.vocabularyKanjiEntries)..addColumns([c]);
    final result = await query.getSingle();
    return result.read(c)!;
  }

  @override
  Future<int> countSentences() async {
    final c = countAll();
    final query = _db.selectOnly(_db.vocabularySentenceEntries)
      ..addColumns([c]);
    final result = await query.getSingle();
    return result.read(c)!;
  }
}
