import 'package:drift/drift.dart';

import '../converters/enum_converters.dart';
import 'radical_table.dart';

class RadicalVariantEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get radicalId =>
      integer().references(RadicalEntries, #id, onDelete: KeyAction.cascade)();
  TextColumn get shape => text()();
  TextColumn get position => text().map(const PositionConverter())();
  BoolColumn get isLocked => boolean().withDefault(const Constant(false))();
  TextColumn get svgFileName => text()();
  TextColumn get svgFileUrl => text()();
  TextColumn get svgHash => text()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {radicalId, position},
      ];
}
