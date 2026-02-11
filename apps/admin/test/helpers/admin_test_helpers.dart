import 'package:drift/native.dart';
import 'package:kanji_craft_admin/data/database/admin_database.dart';
import 'package:kanji_craft_admin/data/repositories/data_import/drift_data_import_repository.dart';
import 'package:kanji_craft_admin/data/repositories/kanji_component_review/drift_kanji_component_review_repository.dart';
import 'package:kanji_craft_admin/data/repositories/raw_kanjidic/drift_raw_kanjidic_repository.dart';
import 'package:kanji_craft_admin/data/repositories/raw_kanjivg/drift_raw_kanjivg_repository.dart';

AdminDatabase createTestDatabase() =>
    AdminDatabase.forTesting(NativeDatabase.memory());

({
  DriftDataImportRepository imports,
  DriftRawKanjiVgRepository kanjiVg,
  DriftRawKanjidicRepository kanjidic,
  DriftKanjiComponentReviewRepository reviews,
}) createReposFromDb(AdminDatabase db) => (
      imports: DriftDataImportRepository(db),
      kanjiVg: DriftRawKanjiVgRepository(db),
      kanjidic: DriftRawKanjidicRepository(db),
      reviews: DriftKanjiComponentReviewRepository(db),
    );
