import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/data_import.dart';
import '../../../domain/entities/extraction_phase.dart';
import '../../../domain/entities/import_source.dart';
import '../../../domain/entities/import_status.dart';
import '../../../domain/entities/warning.dart';
import '../../../domain/usecases/compose_kanji.dart';
import '../../../domain/usecases/estimate_logic_hints.dart';
import '../../../domain/usecases/extract_radicals.dart';
import '../../../domain/usecases/extract_vocabulary.dart';
import '../../../domain/usecases/link_components.dart';
import '../../../domain/usecases/process_svgs.dart';
import 'extraction_event.dart';
import 'extraction_state.dart';

class ExtractionBloc extends Bloc<ExtractionEvent, ExtractionState> {
  ExtractionBloc({
    required ExtractRadicals extractRadicals,
    required ComposeKanji composeKanji,
    required ProcessSvgs processSvgs,
    required ExtractVocabulary extractVocabulary,
    required LinkComponents linkComponents,
    required EstimateLogicHints estimateLogicHints,
  })  : _extractRadicals = extractRadicals,
        _composeKanji = composeKanji,
        _processSvgs = processSvgs,
        _extractVocabulary = extractVocabulary,
        _linkComponents = linkComponents,
        _estimateLogicHints = estimateLogicHints,
        super(const ExtractionState()) {
    on<ExtractionEvent>(_onEvent);
  }

  final ExtractRadicals _extractRadicals;
  final ComposeKanji _composeKanji;
  final ProcessSvgs _processSvgs;
  final ExtractVocabulary _extractVocabulary;
  final LinkComponents _linkComponents;
  final EstimateLogicHints _estimateLogicHints;
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
        final kanjidicImportId = _importIdFor(ImportSource.kanjidic);
        final composeResult = await _composeKanji.call(kanjidicImportId);
        final kanjivgImportId = _importIdFor(ImportSource.kanjivg);
        final linkResult = await _linkComponents.call(kanjivgImportId);
        return (
          summary: '${composeResult.kanjiCount} kanji, '
              '${composeResult.readingCount} readings, '
              '${composeResult.i18nCount} i18n, '
              '${linkResult.componentCount} components, '
              '${linkResult.radicalsUpdated} radicals updated',
          warnings: [...composeResult.warnings, ...linkResult.warnings],
        );
      case ExtractionPhase.svgProcessing:
        final archivePath = _resolveKanjiVgZipPath();
        final result = await _processSvgs.call(archivePath);
        return (
          summary: '${result.radicalCount} radicals, '
              '${result.variantCount} variants, '
              '${result.kanjiCount} kanji',
          warnings: result.warnings,
        );
      case ExtractionPhase.vocabularyExtraction:
        final jmdictImportId = _importIdFor(ImportSource.jmdict);
        final furiganaImportId = _importIdFor(ImportSource.jmdictFurigana);
        final result =
            await _extractVocabulary.call(jmdictImportId, furiganaImportId);
        return (
          summary: '${result.vocabularyCount} vocabulary, '
              '${result.readingCount} readings, '
              '${result.i18nCount} i18n, '
              '${result.kanjiLinkCount} kanji links, '
              '${result.sentenceCount} sentences',
          warnings: result.warnings,
        );
      case ExtractionPhase.aiEnrichment:
        final kanjidicImportId = _importIdFor(ImportSource.kanjidic);
        final result = await _estimateLogicHints.call(kanjidicImportId);
        return (
          summary: '${result.componentCount} components, '
              '${result.phoneticCount} phonetic, '
              '${result.semanticCount} semantic, '
              '${result.skippedCount} skipped',
          warnings: result.warnings,
        );
    }
  }

  int _importIdFor(ImportSource source) {
    return _imports
        .where((i) => i.source == source && i.status == ImportStatus.ingested)
        .first
        .id;
  }

  /// Resolves the KanjiVG ZIP file path from the import's folder_path metadata.
  String _resolveKanjiVgZipPath() {
    final import = _imports.firstWhere(
      (i) => i.source == ImportSource.kanjivg &&
          i.status == ImportStatus.ingested,
    );
    final folderPath = import.metadata?['folder_path'] as String?;
    if (folderPath == null) {
      throw Exception(
        'KanjiVG import is missing folder_path in metadata. '
        'Please re-ingest the KanjiVG source to populate it.',
      );
    }
    final dir = Directory(folderPath);
    if (!dir.existsSync()) {
      throw Exception(
        'KanjiVG folder no longer exists: $folderPath\n'
        'Please re-ingest the KanjiVG source.',
      );
    }
    final zipFile = dir
        .listSync()
        .whereType<File>()
        .where((f) {
          final name = f.uri.pathSegments.last;
          return name.endsWith('.zip') && name.contains('main');
        })
        .firstOrNull;
    if (zipFile == null) {
      throw Exception('No ZIP file found in KanjiVG folder: $folderPath');
    }
    return zipFile.path;
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
        final kanjiResult = await _composeKanji.checkExistingResult();
        if (kanjiResult == null) return null;
        final componentResult = await _linkComponents.checkExistingResult();
        if (componentResult != null) return '$kanjiResult, $componentResult';
        return kanjiResult;
      case ExtractionPhase.svgProcessing:
        return _processSvgs.checkExistingResult();
      case ExtractionPhase.vocabularyExtraction:
        return _extractVocabulary.checkExistingResult();
      case ExtractionPhase.aiEnrichment:
        return _estimateLogicHints.checkExistingResult();
    }
  }
}
