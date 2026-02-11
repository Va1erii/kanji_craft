import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/data_import.dart';
import '../../../domain/entities/extraction_phase.dart';
import '../../../domain/entities/import_source.dart';
import '../../../domain/entities/import_status.dart';
import '../../../domain/entities/warning.dart';
import '../../../domain/usecases/compose_kanji.dart';
import '../../../domain/usecases/extract_radicals.dart';
import 'extraction_event.dart';
import 'extraction_state.dart';

class ExtractionBloc extends Bloc<ExtractionEvent, ExtractionState> {
  ExtractionBloc({
    required ExtractRadicals extractRadicals,
    required ComposeKanji composeKanji,
  })  : _extractRadicals = extractRadicals,
        _composeKanji = composeKanji,
        super(const ExtractionState()) {
    on<ExtractionEvent>(_onEvent);
  }

  final ExtractRadicals _extractRadicals;
  final ComposeKanji _composeKanji;
  List<DataImport> _imports = const [];

  Future<void> _onEvent(
    ExtractionEvent event,
    Emitter<ExtractionState> emit,
  ) async {
    await event.when(
      importsUpdated: (imports) => _onImportsUpdated(imports, emit),
      runPhase: (phase) => _onRunPhase(phase, emit),
    );
  }

  Future<void> _onImportsUpdated(
    List<DataImport> imports,
    Emitter<ExtractionState> emit,
  ) async {
    _imports = imports;
    emit(ExtractionState(phases: await _recomputeStatuses()));
  }

  Future<void> _onRunPhase(
    ExtractionPhase phase,
    Emitter<ExtractionState> emit,
  ) async {
    emit(ExtractionState(
      phases: {...state.phases, phase: const PhaseRunning()},
    ));

    try {
      final (:summary, :warnings) = await _runPhase(phase);
      emit(ExtractionState(
        phases: {
          ...state.phases,
          phase: PhaseCompleted(summary, warnings: warnings),
        },
      ));
      // Recompute downstream phases — a completed phase may unblock others.
      emit(ExtractionState(phases: await _recomputeStatuses()));
    } on Exception catch (e, st) {
      log(
        'Extraction phase ${phase.label} failed',
        error: e,
        stackTrace: st,
        name: 'ExtractionBloc',
      );
      emit(ExtractionState(
        phases: {...state.phases, phase: PhaseFailed(e.toString())},
      ));
    }
  }

  Future<({String summary, List<Warning> warnings})> _runPhase(
    ExtractionPhase phase,
  ) async {
    switch (phase) {
      case ExtractionPhase.radicalExtraction:
        final importId = _importIdFor(ImportSource.kanjivg);
        final result = await _extractRadicals.call(importId);
        return (
          summary: '${result.radicalCount} radicals, '
              '${result.variantCount} variants',
          warnings: result.warnings,
        );
      case ExtractionPhase.kanjiComposition:
        final importId = _importIdFor(ImportSource.kanjidic);
        final result = await _composeKanji.call(importId);
        return (
          summary: '${result.kanjiCount} kanji, '
              '${result.readingCount} readings, '
              '${result.i18nCount} i18n',
          warnings: result.warnings,
        );
      default:
        throw UnimplementedError('${phase.label} is not implemented');
    }
  }

  int _importIdFor(ImportSource source) {
    return _imports
        .where((i) => i.source == source && i.status == ImportStatus.ingested)
        .first
        .id;
  }

  /// Recompute statuses for all phases in enum order.
  ///
  /// Preserves completed / running / failed states — only idle phases
  /// get re-evaluated for readiness. Phases that would be "ready" are
  /// checked for existing draft data to detect previous completions.
  Future<Map<ExtractionPhase, PhaseStatus>> _recomputeStatuses() async {
    final ingestedSources = _imports
        .where((i) => i.status == ImportStatus.ingested)
        .map((i) => i.source)
        .toSet();

    final result = <ExtractionPhase, PhaseStatus>{};

    for (final phase in ExtractionPhase.values) {
      final current = state.phases[phase];

      // Preserve terminal/active states.
      if (current is PhaseCompleted ||
          current is PhaseRunning ||
          current is PhaseFailed) {
        result[phase] = current!;
        continue;
      }

      if (!phase.isImplemented) {
        result[phase] = const PhaseBlocked('Not implemented');
        continue;
      }

      // Check required sources.
      final missingSources = phase.requiredSources.difference(ingestedSources);
      if (missingSources.isNotEmpty) {
        final labels = missingSources.map((s) => s.name).join(', ');
        result[phase] = PhaseBlocked('Needs $labels');
        continue;
      }

      // Check required phases.
      final pendingPhases = phase.requiredPhases
          .where((dep) => result[dep] is! PhaseCompleted)
          .toList();
      if (pendingPhases.isNotEmpty) {
        final labels = pendingPhases.map((p) => p.label).join(', ');
        result[phase] = PhaseBlocked('Needs $labels');
        continue;
      }

      // Detect previous completion from existing draft data.
      final existing = await _checkExistingResult(phase);
      if (existing != null) {
        result[phase] = PhaseCompleted(existing);
        continue;
      }

      result[phase] = const PhaseReady();
    }

    return result;
  }

  /// Returns a summary string if the phase's draft data already exists.
  Future<String?> _checkExistingResult(ExtractionPhase phase) async {
    switch (phase) {
      case ExtractionPhase.radicalExtraction:
        return _extractRadicals.checkExistingResult();
      case ExtractionPhase.kanjiComposition:
        return _composeKanji.checkExistingResult();
      default:
        return null;
    }
  }
}
