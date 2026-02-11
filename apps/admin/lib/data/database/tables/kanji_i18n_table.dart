import 'package:drift/drift.dart';

import '../converters/json_converters.dart';
import 'kanji_table.dart';

class KanjiI18nEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get kanjiId =>
      integer().references(KanjiEntries, #id, onDelete: KeyAction.cascade)();
  TextColumn get langCode => text()();
  TextColumn get meanings =>
      text().map(const NonNullableStringListConverter())();
  TextColumn get systemMnemonic => text()();
  TextColumn get searchTags =>
      text().map(const NonNullableStringListConverter())();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {kanjiId, langCode},
      ];
}
