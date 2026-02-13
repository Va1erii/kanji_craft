import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/enrichment_batch_type.dart';
import '../../../domain/entities/warning.dart';

part 'enrichment_state.freezed.dart';

sealed class BatchStatus {
  const BatchStatus();
}

final class BatchIdle extends BatchStatus {
  const BatchIdle();
}

final class BatchReady extends BatchStatus {
  const BatchReady(this.totalCount);
  final int totalCount;
}

final class BatchExporting extends BatchStatus {
  const BatchExporting();
}

final class BatchExported extends BatchStatus {
  const BatchExported({
    required this.exportedCount,
    required this.totalCount,
    required this.lastFilePath,
    this.warnings = const [],
  });
  final int exportedCount;
  final int totalCount;
  final String lastFilePath;
  final List<Warning> warnings;
}

final class BatchImporting extends BatchStatus {
  const BatchImporting();
}

final class BatchImported extends BatchStatus {
  const BatchImported({
    required this.importedCount,
    required this.rejectedCount,
    this.warnings = const [],
  });
  final int importedCount;
  final int rejectedCount;
  final List<Warning> warnings;
}

final class BatchFailed extends BatchStatus {
  const BatchFailed(this.error);
  final String error;
}

@freezed
sealed class EnrichmentState with _$EnrichmentState {
  const factory EnrichmentState({
    @Default('') String outputDir,
    @Default({}) Map<EnrichmentBatchType, BatchStatus> batches,
    @Default(150) int batchSize,
    @Default({}) Map<EnrichmentBatchType, int> exportOffsets,
  }) = _EnrichmentState;
}
