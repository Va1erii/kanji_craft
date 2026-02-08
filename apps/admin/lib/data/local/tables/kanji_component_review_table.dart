import 'package:drift/drift.dart';

import '../converters/enum_converters.dart';

class KanjiComponentReviewEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get kanjiComponentId => integer().unique()();
  TextColumn get verificationStatus =>
      text().map(const VerificationStatusConverter())();
  RealColumn get aiConfidence => real().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}
