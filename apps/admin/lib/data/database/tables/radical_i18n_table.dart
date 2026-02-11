import 'package:drift/drift.dart';

import '../converters/json_converters.dart';
import 'radical_table.dart';

class RadicalI18nEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get radicalId =>
      integer().references(RadicalEntries, #id, onDelete: KeyAction.cascade)();
  TextColumn get langCode => text()();
  TextColumn get name => text()();
  TextColumn get systemMnemonic => text()();
  TextColumn get searchTags =>
      text().map(const NonNullableStringListConverter())();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {radicalId, langCode},
      ];
}
