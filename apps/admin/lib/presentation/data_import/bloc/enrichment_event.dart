import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/data_import.dart';
import '../../../domain/entities/enrichment_batch_type.dart';

part 'enrichment_event.freezed.dart';

@freezed
sealed class EnrichmentEvent with _$EnrichmentEvent {
  const factory EnrichmentEvent.importsUpdated({
    required List<DataImport> imports,
  }) = _ImportsUpdated;

  const factory EnrichmentEvent.setOutputDir({
    required String path,
  }) = _SetOutputDir;

  const factory EnrichmentEvent.exportSubBatch({
    required EnrichmentBatchType batchType,
    required int subBatchIndex,
  }) = _ExportSubBatch;

  const factory EnrichmentEvent.importSubBatch({
    required EnrichmentBatchType batchType,
    required int subBatchIndex,
    required String filePath,
  }) = _ImportSubBatch;

  const factory EnrichmentEvent.refreshStatus() = _RefreshStatus;
}
