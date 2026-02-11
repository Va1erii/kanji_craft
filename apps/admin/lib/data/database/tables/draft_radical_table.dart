import 'package:drift/drift.dart';

class DraftRadicalEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get masterSymbol => text().unique()();
  IntColumn get strokeCount => integer().nullable()();
  IntColumn get impactScore => integer().nullable()();
  IntColumn get minJlptLevel => integer().nullable()();
  IntColumn get minGrade => integer().nullable()();
  TextColumn get svgFileName => text().nullable()();
  TextColumn get svgFileUrl => text().nullable()();
  TextColumn get svgHash => text().nullable()();
  BoolColumn get isOfficial => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}
