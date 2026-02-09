import 'package:drift/drift.dart';

import '../converters/json_converters.dart';
import 'data_import_table.dart';

class RawKanjidicEntries extends Table {
  IntColumn get importId =>
      integer().references(DataImportEntries, #id)();
  TextColumn get literal => text()();
  IntColumn get strokeCount => integer()();
  TextColumn get strokeCountMisstrokes =>
      text().map(const IntListConverter()).nullable()();
  IntColumn get grade => integer().nullable()();
  IntColumn get jlpt => integer().nullable()();
  IntColumn get frequency => integer().nullable()();
  TextColumn get codepoints =>
      text().map(const KanjidicCodepointsConverter())();
  TextColumn get radicals =>
      text().map(const KanjidicRadicalsConverter())();
  TextColumn get dictRefs =>
      text().map(const KanjidicDictRefsConverter()).nullable()();
  TextColumn get queryCodes =>
      text().map(const KanjidicQueryCodesConverter()).nullable()();
  TextColumn get readings =>
      text().map(const KanjidicReadingsConverter())();
  TextColumn get nanori =>
      text().map(const StringListConverter()).nullable()();
  TextColumn get meanings => text().map(const MeaningsConverter())();
  TextColumn get variants =>
      text().map(const KanjidicVariantsConverter()).nullable()();
  TextColumn get radicalNames =>
      text().map(const StringListConverter()).nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {importId, literal};
}
