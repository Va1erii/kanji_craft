import 'package:drift/drift.dart';

import '../converters/json_converters.dart';
import 'vocabulary_table.dart';

class VocabularyI18nEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get vocabularyId => integer()
      .references(VocabularyEntries, #id, onDelete: KeyAction.cascade)();
  TextColumn get langCode => text()();
  TextColumn get meanings =>
      text().map(const NonNullableStringListConverter())();
  TextColumn get systemMnemonic => text().nullable()();
  TextColumn get searchTags =>
      text().map(const NonNullableStringListConverter())();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {vocabularyId, langCode},
      ];
}
