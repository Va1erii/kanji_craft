import 'package:drift/drift.dart';

class SourceVocabLevelEntries extends Table {
  TextColumn get expression => text()();
  TextColumn get reading => text()();
  IntColumn get level =>
      integer().customConstraint('NOT NULL CHECK (level BETWEEN 1 AND 5)')();
  TextColumn get source => text().withDefault(const Constant('tanos'))();

  @override
  Set<Column> get primaryKey => {expression, reading};
}
