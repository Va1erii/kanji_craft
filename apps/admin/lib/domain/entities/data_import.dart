import 'package:freezed_annotation/freezed_annotation.dart';

import 'import_source.dart';
import 'import_status.dart';

part 'data_import.freezed.dart';

@freezed
abstract class DataImport with _$DataImport {
  const factory DataImport({
    required int id,
    required ImportSource source,
    required String sourceVersion,
    required ImportStatus status,
    int? recordCount,
    required DateTime startedAt,
    DateTime? ingestedAt,
    DateTime? processedAt,
    DateTime? promotedAt,
    String? errorMessage,
    Map<String, Object?>? metadata,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _DataImport;
}
