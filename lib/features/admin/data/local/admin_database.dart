import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../domain/entities/import_source.dart';
import '../../domain/entities/import_status.dart';
import '../../domain/entities/raw_kanjidic.dart';
import '../../domain/entities/raw_kanjivg.dart';
import '../../domain/entities/verification_status.dart';
import 'converters/enum_converters.dart';
import 'converters/json_converters.dart';
import 'tables/data_import_table.dart';
import 'tables/kanji_component_review_table.dart';
import 'tables/raw_kanjidic_table.dart';
import 'tables/raw_kanjivg_table.dart';

part 'admin_database.g.dart';

@DriftDatabase(
  tables: [
    DataImportEntries,
    RawKanjiVgEntries,
    RawKanjidicEntries,
    KanjiComponentReviewEntries,
  ],
)
class AdminDatabase extends _$AdminDatabase {
  AdminDatabase() : super(_openConnection());

  AdminDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

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
