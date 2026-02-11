import 'package:drift/drift.dart';

import '../converters/enum_converters.dart';
import 'vocabulary_table.dart';

class VocabularySentenceEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get vocabularyId => integer()
      .references(VocabularyEntries, #id, onDelete: KeyAction.cascade)();
  TextColumn get originalText => text()();
  TextColumn get verificationStatus =>
      text().map(const VerificationStatusConverter())();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {vocabularyId},
      ];
}
