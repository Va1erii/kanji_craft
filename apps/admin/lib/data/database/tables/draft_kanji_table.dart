import 'package:drift/drift.dart';

class DraftKanjiEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get character => text().unique()();
  IntColumn get strokeCount =>
      integer().customConstraint('NOT NULL CHECK (stroke_count > 0)')();
  IntColumn get frequencyRank =>
      integer().customConstraint('NOT NULL CHECK (frequency_rank > 0)')();
  IntColumn get minJlptLevel => integer().nullable()();
  IntColumn get minGrade => integer().nullable()();
  TextColumn get svgFileName => text().nullable()();
  TextColumn get svgFileUrl => text().nullable()();
  TextColumn get svgHash => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}
