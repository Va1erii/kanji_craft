import 'package:drift/drift.dart';

import '../converters/enum_converters.dart';
import 'kanji_table.dart';
import 'radical_table.dart';

class KanjiComponentEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get kanjiId =>
      integer().references(KanjiEntries, #id, onDelete: KeyAction.cascade)();
  IntColumn get radicalId =>
      integer().references(RadicalEntries, #id, onDelete: KeyAction.cascade)();
  TextColumn get position => text().map(const PositionConverter())();
  TextColumn get logicHint => text().map(const LogicHintConverter())();
  TextColumn get radicalType => text().map(const RadicalTypeConverter())();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {kanjiId, radicalId, position},
      ];
}
