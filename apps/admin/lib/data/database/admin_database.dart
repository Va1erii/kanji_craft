import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../domain/entities/import_source.dart';
import '../../domain/entities/import_status.dart';
import '../../domain/entities/raw_jmdict.dart';
import '../../domain/entities/raw_kanjidic.dart';
import '../../domain/entities/raw_kanjivg.dart';
import 'package:kanji_craft_core/kanji_craft_core.dart';
import 'converters/enum_converters.dart';
import 'converters/json_converters.dart';
import 'tables/data_import_table.dart';
import 'tables/kanji_component_review_table.dart';
import 'tables/kanji_component_table.dart';
import 'tables/kanji_i18n_table.dart';
import 'tables/kanji_reading_table.dart';
import 'tables/kanji_table.dart';
import 'tables/radical_i18n_table.dart';
import 'tables/radical_table.dart';
import 'tables/radical_variant_table.dart';
import 'tables/raw_jmdict_table.dart';
import 'tables/raw_kanjidic_table.dart';
import 'tables/raw_kanjivg_table.dart';
import 'tables/source_jlpt_level_table.dart';
import 'tables/sync_metadata_table.dart';
import 'tables/vocabulary_i18n_table.dart';
import 'tables/vocabulary_kanji_table.dart';
import 'tables/vocabulary_reading_table.dart';
import 'tables/vocabulary_sentence_table.dart';
import 'tables/vocabulary_table.dart';

part 'admin_database.g.dart';

@DriftDatabase(
  tables: [
    DataImportEntries,
    RawKanjiVgEntries,
    RawKanjidicEntries,
    RawJmdictEntries,
    KanjiComponentReviewEntries,
    SyncMetadataEntries,
    SourceJlptLevelEntries,
    RadicalEntries,
    RadicalI18nEntries,
    RadicalVariantEntries,
    KanjiEntries,
    KanjiReadingEntries,
    KanjiI18nEntries,
    KanjiComponentEntries,
    VocabularyEntries,
    VocabularyReadingEntries,
    VocabularyI18nEntries,
    VocabularyKanjiEntries,
    VocabularySentenceEntries,
  ],
)
class AdminDatabase extends _$AdminDatabase {
  AdminDatabase() : super(_openConnection());

  AdminDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 8;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(syncMetadataEntries);
          }
          if (from < 3) {
            await m.createTable(rawJmdictEntries);
          }
          if (from < 4) {
            await m.database.customStatement(
              'ALTER TABLE data_import_entries DROP COLUMN promoted_at',
            );
          }
          if (from < 5) {
            // Recreate raw tables without surrogate id column.
            // Composite natural keys become the primary keys.
            for (final name in [
              'raw_kanji_vg_entries',
              'raw_kanjidic_entries',
              'raw_jmdict_entries',
            ]) {
              await m.database.customStatement('DROP TABLE IF EXISTS $name');
            }
            await m.createTable(rawKanjiVgEntries);
            await m.createTable(rawKanjidicEntries);
            await m.createTable(rawJmdictEntries);
          }
          if (from < 6) {
            await m.createTable(sourceJlptLevelEntries);
          }
          if (from < 7) {
            await m.createTable(radicalEntries);
            await m.createTable(radicalI18nEntries);
            await m.createTable(radicalVariantEntries);
            await m.createTable(kanjiEntries);
            await m.createTable(kanjiReadingEntries);
            await m.createTable(kanjiI18nEntries);
            await m.createTable(kanjiComponentEntries);
          }
          if (from < 8) {
            await m.createTable(vocabularyEntries);
            await m.createTable(vocabularyReadingEntries);
            await m.createTable(vocabularyI18nEntries);
            await m.createTable(vocabularyKanjiEntries);
            await m.createTable(vocabularySentenceEntries);
          }
        },
      );

  /// Deletes all rows from every table. Useful for pipeline reset.
  Future<void> clearAll() async {
    await transaction(() async {
      for (final table in allTables) {
        await delete(table).go();
      }
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'admin_staging.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
