import 'package:drift/drift.dart';

class KanjiEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get character => text().unique()();
  IntColumn get strokeCount =>
      integer().customConstraint('NOT NULL CHECK (stroke_count > 0)')();
  IntColumn get minJlptLevel => integer().nullable()();
  IntColumn get minGrade => integer().nullable()();
  IntColumn get frequencyRank =>
      integer().customConstraint('NOT NULL CHECK (frequency_rank > 0)')();
  TextColumn get svgFileName => text()();
  TextColumn get svgFileUrl => text()();
  TextColumn get svgHash => text()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}
