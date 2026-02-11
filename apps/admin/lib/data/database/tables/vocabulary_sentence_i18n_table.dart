import 'package:drift/drift.dart';

import 'vocabulary_sentence_table.dart';

class VocabularySentenceI18nEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get vocabularySentenceId => integer().references(
      VocabularySentenceEntries, #id,
      onDelete: KeyAction.cascade)();
  TextColumn get langCode => text()();
  TextColumn get sentenceTranslated => text()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {vocabularySentenceId, langCode},
      ];
}
