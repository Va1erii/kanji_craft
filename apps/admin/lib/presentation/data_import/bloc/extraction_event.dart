import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/data_import.dart';
import '../../../domain/entities/extraction_phase.dart';

part 'extraction_event.freezed.dart';

@freezed
sealed class ExtractionEvent with _$ExtractionEvent {
  const factory ExtractionEvent.importsUpdated({
    required List<DataImport> imports,
  }) = _ImportsUpdated;

  const factory ExtractionEvent.runPhase({
    required ExtractionPhase phase,
  }) = _RunPhase;
}
