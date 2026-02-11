import 'package:drift/drift.dart';

class RadicalEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get masterSymbol => text().unique()();
  IntColumn get strokeCount =>
      integer().customConstraint('NOT NULL CHECK (stroke_count > 0)')();
  IntColumn get impactScore => integer()
      .customConstraint('NOT NULL CHECK (impact_score BETWEEN 1 AND 10)')();
  IntColumn get minJlptLevel => integer()
      .customConstraint('NOT NULL CHECK (min_jlpt_level BETWEEN 1 AND 5)')();
  IntColumn get minGrade => integer()
      .customConstraint('NOT NULL CHECK (min_grade BETWEEN 1 AND 8)')();
  TextColumn get svgFileName => text()();
  TextColumn get svgFileUrl => text()();
  TextColumn get svgHash => text()();
  BoolColumn get isOfficial => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}
