import 'package:drift/native.dart';
import 'package:kanji_craft_admin/data/database/admin_database.dart';
import 'package:kanji_craft_admin/data/repositories/data_import/drift_data_import_repository.dart';
import 'package:kanji_craft_admin/data/repositories/jmdict_furigana/drift_jmdict_furigana_repository.dart';
import 'package:kanji_craft_admin/data/repositories/kanji_component_review/drift_kanji_component_review_repository.dart';
import 'package:kanji_craft_admin/data/repositories/kanji_component/drift_kanji_component_repository.dart';
import 'package:kanji_craft_admin/data/repositories/kanji/drift_kanji_repository.dart';
import 'package:kanji_craft_admin/data/repositories/radical/drift_radical_repository.dart';
import 'package:kanji_craft_admin/data/repositories/raw_jmdict/drift_raw_jmdict_repository.dart';
import 'package:kanji_craft_admin/data/repositories/raw_kanjidic/drift_raw_kanjidic_repository.dart';
import 'package:kanji_craft_admin/data/repositories/raw_kanjivg/drift_raw_kanjivg_repository.dart';
import 'package:kanji_craft_admin/data/repositories/source_vocab_level/drift_source_vocab_level_repository.dart';
import 'package:kanji_craft_admin/data/repositories/vocabulary/drift_vocabulary_repository.dart';

AdminDatabase createTestDatabase() =>
    AdminDatabase.forTesting(NativeDatabase.memory());

({
  DriftDataImportRepository imports,
  DriftRawKanjiVgRepository kanjiVg,
  DriftRawKanjidicRepository kanjidic,
  DriftKanjiComponentReviewRepository reviews,
  DriftKanjiComponentRepository kanjiComponents,
  DriftRadicalRepository radicals,
  DriftKanjiRepository kanji,
  DriftRawJmdictRepository rawJmdict,
  DriftSourceVocabLevelRepository sourceVocabLevel,
  DriftJmdictFuriganaRepository jmdictFurigana,
  DriftVocabularyRepository vocabulary,
}) createReposFromDb(AdminDatabase db) => (
      imports: DriftDataImportRepository(db),
      kanjiVg: DriftRawKanjiVgRepository(db),
      kanjidic: DriftRawKanjidicRepository(db),
      reviews: DriftKanjiComponentReviewRepository(db),
      kanjiComponents: DriftKanjiComponentRepository(db),
      radicals: DriftRadicalRepository(db),
      kanji: DriftKanjiRepository(db),
      rawJmdict: DriftRawJmdictRepository(db),
      sourceVocabLevel: DriftSourceVocabLevelRepository(db),
      jmdictFurigana: DriftJmdictFuriganaRepository(db),
      vocabulary: DriftVocabularyRepository(db),
    );
