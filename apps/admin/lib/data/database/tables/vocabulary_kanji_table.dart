import 'package:drift/drift.dart';

import 'kanji_table.dart';
import 'vocabulary_table.dart';

class VocabularyKanjiEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get vocabularyId => integer()
      .references(VocabularyEntries, #id, onDelete: KeyAction.cascade)();
  IntColumn get kanjiId =>
      integer().references(KanjiEntries, #id, onDelete: KeyAction.cascade)();
  IntColumn get position =>
      integer().customConstraint('NOT NULL CHECK (position >= 0)')();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {vocabularyId, position},
      ];
}
