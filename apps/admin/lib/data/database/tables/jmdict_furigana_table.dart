import 'package:drift/drift.dart';

import 'data_import_table.dart';

class JmdictFuriganaEntries extends Table {
  IntColumn get importId =>
      integer().references(DataImportEntries, #id)();
  // 'text' is a reserved name in Drift, so we use a custom column name.
  TextColumn get textField =>
      text().named('text')();
  TextColumn get reading => text()();
  TextColumn get furigana => text()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {importId, textField, reading};
}
