import 'package:drift/drift.dart';

import '../../../domain/entities/import_status.dart';
import '../converters/enum_converters.dart';
import '../converters/json_converters.dart';

class DataImportEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get source => text().map(const ImportSourceConverter())();
  TextColumn get sourceVersion => text()();
  TextColumn get status =>
      text().map(const ImportStatusConverter()).withDefault(
            Constant(const ImportStatusConverter().toSql(ImportStatus.pending)),
          )();
  IntColumn get recordCount => integer().nullable()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get ingestedAt => dateTime().nullable()();
  DateTimeColumn get processedAt => dateTime().nullable()();
  DateTimeColumn get promotedAt => dateTime().nullable()();
  TextColumn get errorMessage => text().nullable()();
  TextColumn get metadata => text().map(const JsonMapConverter()).nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}
