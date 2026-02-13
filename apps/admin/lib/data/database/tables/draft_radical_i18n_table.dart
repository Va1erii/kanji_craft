import 'package:drift/drift.dart';

import '../converters/json_converters.dart';
import 'draft_radical_table.dart';

class DraftRadicalI18nEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get draftRadicalId => integer()
      .references(DraftRadicalEntries, #id, onDelete: KeyAction.cascade)();
  TextColumn get langCode => text()();
  TextColumn get name => text()();
  TextColumn get systemMnemonic => text().withDefault(const Constant(''))();
  TextColumn get searchTags =>
      text().map(const NonNullableStringListConverter()).withDefault(
            const Constant('[]'),
          )();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {draftRadicalId, langCode},
      ];
}
