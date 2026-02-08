import 'package:drift/drift.dart';

import '../converters/json_converters.dart';
import 'data_import_table.dart';

class RawKanjiVgEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get importId =>
      integer().references(DataImportEntries, #id)();
  TextColumn get character => text()();
  TextColumn get unicodeHex => text()();
  TextColumn get viewBox => text()();
  IntColumn get strokeCount => integer()();
  TextColumn get strokes => text().map(const KanjiVgStrokesConverter())();
  TextColumn get components =>
      text().map(const KanjiVgComponentConverter())();
  DateTimeColumn get createdAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {importId, character},
      ];
}
