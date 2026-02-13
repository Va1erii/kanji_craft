import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/enrichment_batch_type.dart';
import '../../../domain/entities/warning.dart';

part 'enrichment_state.freezed.dart';

// -- Sub-batch status (per chunk) --

sealed class SubBatchStatus {
  const SubBatchStatus();
}

final class SubBatchPending extends SubBatchStatus {
  const SubBatchPending();
}

final class SubBatchExporting extends SubBatchStatus {
  const SubBatchExporting();
}

final class SubBatchExported extends SubBatchStatus {
  const SubBatchExported({
    required this.filePath,
    this.warnings = const [],
  });
  final String filePath;
  final List<Warning> warnings;
}

final class SubBatchImporting extends SubBatchStatus {
  const SubBatchImporting();
}

final class SubBatchImported extends SubBatchStatus {
  const SubBatchImported({
    required this.importedCount,
    required this.rejectedCount,
    this.warnings = const [],
  });
  final int importedCount;
  final int rejectedCount;
  final List<Warning> warnings;
}

final class SubBatchFailed extends SubBatchStatus {
  const SubBatchFailed(this.error);
  final String error;
}

// -- Batch type status (top-level, per EnrichmentBatchType) --

sealed class BatchTypeStatus {
  const BatchTypeStatus();
}

final class BatchTypeIdle extends BatchTypeStatus {
  const BatchTypeIdle();
}

final class BatchTypeReady extends BatchTypeStatus {
  const BatchTypeReady({
    required this.totalCount,
    required this.subBatches,
  });
  final int totalCount;
  final List<SubBatchStatus> subBatches;
}

// -- Top-level enrichment state --

@freezed
sealed class EnrichmentState with _$EnrichmentState {
  const factory EnrichmentState({
    @Default('') String outputDir,
    @Default({}) Map<EnrichmentBatchType, BatchTypeStatus> batches,
    @Default(150) int batchSize,
  }) = _EnrichmentState;
}
