// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_import_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DataImportDto _$DataImportDtoFromJson(Map<String, dynamic> json) =>
    _DataImportDto(
      id: (json['id'] as num).toInt(),
      source: $enumDecode(_$ImportSourceEnumMap, json['source']),
      sourceVersion: json['source_version'] as String,
      status: $enumDecode(_$ImportStatusEnumMap, json['status']),
      recordCount: (json['record_count'] as num?)?.toInt(),
      startedAt: DateTime.parse(json['started_at'] as String),
      ingestedAt: json['ingested_at'] == null
          ? null
          : DateTime.parse(json['ingested_at'] as String),
      processedAt: json['processed_at'] == null
          ? null
          : DateTime.parse(json['processed_at'] as String),
      promotedAt: json['promoted_at'] == null
          ? null
          : DateTime.parse(json['promoted_at'] as String),
      errorMessage: json['error_message'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$DataImportDtoToJson(_DataImportDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'source': _$ImportSourceEnumMap[instance.source]!,
      'source_version': instance.sourceVersion,
      'status': _$ImportStatusEnumMap[instance.status]!,
      'record_count': instance.recordCount,
      'started_at': instance.startedAt.toIso8601String(),
      'ingested_at': instance.ingestedAt?.toIso8601String(),
      'processed_at': instance.processedAt?.toIso8601String(),
      'promoted_at': instance.promotedAt?.toIso8601String(),
      'error_message': instance.errorMessage,
      'metadata': instance.metadata,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$ImportSourceEnumMap = {
  ImportSource.kanjivg: 'kanjivg',
  ImportSource.kanjidic: 'kanjidic',
  ImportSource.jmdict: 'jmdict',
};

const _$ImportStatusEnumMap = {
  ImportStatus.pending: 'pending',
  ImportStatus.ingested: 'ingested',
  ImportStatus.processing: 'processing',
  ImportStatus.processed: 'processed',
  ImportStatus.promoted: 'promoted',
  ImportStatus.failed: 'failed',
};
