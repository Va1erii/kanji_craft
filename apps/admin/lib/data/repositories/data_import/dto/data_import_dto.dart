import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/entities/data_import.dart';
import '../../../../domain/entities/import_source.dart';
import '../../../../domain/entities/import_status.dart';

part 'data_import_dto.freezed.dart';
part 'data_import_dto.g.dart';

@freezed
abstract class DataImportDto with _$DataImportDto {
  const factory DataImportDto({
    required int id,
    required ImportSource source,
    @JsonKey(name: 'source_version') required String sourceVersion,
    required ImportStatus status,
    @JsonKey(name: 'record_count') int? recordCount,
    @JsonKey(name: 'started_at') required DateTime startedAt,
    @JsonKey(name: 'ingested_at') DateTime? ingestedAt,
    @JsonKey(name: 'processed_at') DateTime? processedAt,
    @JsonKey(name: 'error_message') String? errorMessage,
    Map<String, Object?>? metadata,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _DataImportDto;

  const DataImportDto._();

  factory DataImportDto.fromJson(Map<String, Object?> json) =>
      _$DataImportDtoFromJson(json);

  factory DataImportDto.fromDomain(DataImport entity) => DataImportDto(
        id: entity.id,
        source: entity.source,
        sourceVersion: entity.sourceVersion,
        status: entity.status,
        recordCount: entity.recordCount,
        startedAt: entity.startedAt,
        ingestedAt: entity.ingestedAt,
        processedAt: entity.processedAt,
        errorMessage: entity.errorMessage,
        metadata: entity.metadata,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );

  DataImport toDomain() => DataImport(
        id: id,
        source: source,
        sourceVersion: sourceVersion,
        status: status,
        recordCount: recordCount,
        startedAt: startedAt,
        ingestedAt: ingestedAt,
        processedAt: processedAt,
        errorMessage: errorMessage,
        metadata: metadata,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
