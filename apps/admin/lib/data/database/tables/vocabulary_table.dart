import 'package:drift/drift.dart';

class VocabularyEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get word => text().unique()();
  IntColumn get minJlptLevel => integer().nullable()();
  IntColumn get frequencyRank =>
      integer().customConstraint('NOT NULL CHECK (frequency_rank > 0)')();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}
