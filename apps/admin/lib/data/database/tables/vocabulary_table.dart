import 'package:drift/drift.dart';

import '../converters/json_converters.dart';

class VocabularyEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get word => text().unique()();
  TextColumn get segments =>
      text().map(const VocabularySegmentListConverter())();
  IntColumn get minJlptLevel => integer().nullable()();
  IntColumn get frequencyRank =>
      integer().customConstraint('NOT NULL CHECK (frequency_rank > 0)')();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}
