import 'package:drift/drift.dart';
import 'package:kanji_craft_core/kanji_craft_core.dart';

import '../../../domain/entities/import_source.dart';
import '../../../domain/entities/import_status.dart';

class ImportSourceConverter extends TypeConverter<ImportSource, String> {
  const ImportSourceConverter();

  @override
  ImportSource fromSql(String fromDb) => ImportSource.values.byName(fromDb);

  @override
  String toSql(ImportSource value) => value.name;
}

class ImportStatusConverter extends TypeConverter<ImportStatus, String> {
  const ImportStatusConverter();

  @override
  ImportStatus fromSql(String fromDb) => ImportStatus.values.byName(fromDb);

  @override
  String toSql(ImportStatus value) => value.name;
}

class VerificationStatusConverter
    extends TypeConverter<VerificationStatus, String> {
  const VerificationStatusConverter();

  @override
  VerificationStatus fromSql(String fromDb) =>
      VerificationStatus.values.byName(fromDb);

  @override
  String toSql(VerificationStatus value) => value.name;
}

class PositionConverter extends TypeConverter<Position, String> {
  const PositionConverter();

  @override
  Position fromSql(String fromDb) => Position.values.byName(fromDb);

  @override
  String toSql(Position value) => value.name;
}

class LogicHintConverter extends TypeConverter<LogicHint, String> {
  const LogicHintConverter();

  @override
  LogicHint fromSql(String fromDb) => LogicHint.values.byName(fromDb);

  @override
  String toSql(LogicHint value) => value.name;
}

class RadicalTypeConverter extends TypeConverter<RadicalType, String> {
  const RadicalTypeConverter();

  @override
  RadicalType fromSql(String fromDb) => RadicalType.values.byName(fromDb);

  @override
  String toSql(RadicalType value) => value.name;
}

class ReadingTypeConverter extends TypeConverter<ReadingType, String> {
  const ReadingTypeConverter();

  @override
  ReadingType fromSql(String fromDb) => ReadingType.values.byName(fromDb);

  @override
  String toSql(ReadingType value) => value.name;
}

class ReadingPriorityConverter extends TypeConverter<ReadingPriority, String> {
  const ReadingPriorityConverter();

  @override
  ReadingPriority fromSql(String fromDb) =>
      ReadingPriority.values.byName(fromDb);

  @override
  String toSql(ReadingPriority value) => value.name;
}
