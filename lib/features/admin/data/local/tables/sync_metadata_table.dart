import 'package:drift/drift.dart';

class SyncMetadataEntries extends Table {
  TextColumn get key => text()();
  DateTimeColumn get lastSyncedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {key};
}
