import 'package:drift/drift.dart';

import '../converters/json_converters.dart';
import 'data_import_table.dart';

class RawJmdictEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get importId =>
      integer().references(DataImportEntries, #id)();
  IntColumn get entSeq => integer()();
  TextColumn get kanjiElements =>
      text().map(const JmdictKanjiElementsConverter())();
  TextColumn get readingElements =>
      text().map(const JmdictReadingElementsConverter())();
  TextColumn get senses => text().map(const JmdictSensesConverter())();
  DateTimeColumn get createdAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {importId, entSeq},
      ];
}
