import 'package:drift/native.dart';
import 'package:kanji_craft_admin/data/local/admin_database.dart';
import 'package:kanji_craft_admin/data/repositories/drift_data_import_repository.dart';
import 'package:kanji_craft_admin/data/repositories/drift_kanji_component_review_repository.dart';
import 'package:kanji_craft_admin/data/repositories/drift_raw_kanjidic_repository.dart';
import 'package:kanji_craft_admin/data/repositories/drift_raw_kanjivg_repository.dart';

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
