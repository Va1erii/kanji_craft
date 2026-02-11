import 'package:drift/drift.dart';

import '../converters/enum_converters.dart';
import 'draft_kanji_table.dart';

class DraftKanjiReadingEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get draftKanjiId => integer()
      .references(DraftKanjiEntries, #id, onDelete: KeyAction.cascade)();
  TextColumn get reading => text()();
  TextColumn get readingType => text().map(const ReadingTypeConverter())();
  TextColumn get priority => text().map(const ReadingPriorityConverter())();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {draftKanjiId, reading, readingType},
      ];
}
