import 'package:drift/drift.dart';

import '../converters/json_converters.dart';
import 'data_import_table.dart';

class RawJmdictEntries extends Table {
  IntColumn get importId =>
      integer().references(DataImportEntries, #id)();
  IntColumn get entSeq => integer()();
  TextColumn get kanjiElements =>
      text().map(const JmdictKanjiElementsConverter()).nullable()();
  TextColumn get readingElements =>
      text().map(const JmdictReadingElementsConverter())();
  TextColumn get senses => text().map(const JmdictSensesConverter())();
  TextColumn get examples =>
      text().map(const JmdictExamplesConverter()).nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {importId, entSeq};
}
