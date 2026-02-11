import 'package:drift/drift.dart';

class SourceJlptLevelEntries extends Table {
  TextColumn get character => text()();
  IntColumn get level =>
      integer().customConstraint('NOT NULL CHECK (level BETWEEN 1 AND 5)')();
  TextColumn get source => text().withDefault(const Constant('tanos'))();

  @override
  Set<Column> get primaryKey => {character};
}
