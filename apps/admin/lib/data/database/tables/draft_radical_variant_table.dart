import 'package:drift/drift.dart';

import '../converters/enum_converters.dart';
import 'draft_radical_table.dart';

class DraftRadicalVariantEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get draftRadicalId => integer()
      .references(DraftRadicalEntries, #id, onDelete: KeyAction.cascade)();
  TextColumn get shape => text()();
  TextColumn get position => text().map(const PositionConverter())();
  BoolColumn get isLocked => boolean().withDefault(const Constant(false))();
  TextColumn get svgFileName => text().nullable()();
  TextColumn get svgFileUrl => text().nullable()();
  TextColumn get svgHash => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {draftRadicalId, shape},
      ];
}
