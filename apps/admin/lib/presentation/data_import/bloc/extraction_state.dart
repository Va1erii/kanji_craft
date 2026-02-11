import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/extraction_phase.dart';

part 'extraction_state.freezed.dart';

// ---------------------------------------------------------------------------
// Phase status — plain sealed class (not Freezed)
// ---------------------------------------------------------------------------

sealed class PhaseStatus {
  const PhaseStatus();
}

final class PhaseIdle extends PhaseStatus {
  const PhaseIdle();
}

final class PhaseBlocked extends PhaseStatus {
  const PhaseBlocked(this.reason);
  final String reason;
}

final class PhaseReady extends PhaseStatus {
  const PhaseReady();
}

final class PhaseRunning extends PhaseStatus {
  const PhaseRunning([this.message]);
  final String? message;
}

final class PhaseCompleted extends PhaseStatus {
  const PhaseCompleted(this.summary);
  final String summary;
}

final class PhaseFailed extends PhaseStatus {
  const PhaseFailed(this.error);
  final String error;
}

// ---------------------------------------------------------------------------
// Extraction state — Freezed
// ---------------------------------------------------------------------------

@freezed
sealed class ExtractionState with _$ExtractionState {
  const factory ExtractionState({
    @Default({}) Map<ExtractionPhase, PhaseStatus> phases,
  }) = _ExtractionState;
}
