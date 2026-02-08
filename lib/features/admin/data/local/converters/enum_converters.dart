import 'package:drift/drift.dart';

import '../../../domain/entities/import_source.dart';
import '../../../domain/entities/import_status.dart';
import '../../../domain/entities/verification_status.dart';

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
