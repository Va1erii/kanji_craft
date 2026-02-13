import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/bookmark_service.dart';
import '../../../domain/entities/data_import.dart';
import '../../../domain/entities/enrichment_batch_type.dart';
import '../../../domain/entities/import_source.dart';
import '../../../domain/entities/import_status.dart';
import '../../../domain/usecases/export_radical_mnemonics.dart';
import '../../../domain/usecases/import_radical_mnemonics.dart';
import 'enrichment_event.dart';
import 'enrichment_state.dart';

/// Bookmark key for persisting the CSV output directory across app launches.
const _outputDirBookmarkKey = 'enrichment_output_dir';

class EnrichmentBloc extends Bloc<EnrichmentEvent, EnrichmentState> {
  EnrichmentBloc({
    required ExportRadicalMnemonics exportRadicalMnemonics,
    required ImportRadicalMnemonics importRadicalMnemonics,
    required BookmarkService bookmarkService,
  })  : _exportRadicalMnemonics = exportRadicalMnemonics,
        _importRadicalMnemonics = importRadicalMnemonics,
        _bookmarkService = bookmarkService,
        super(const EnrichmentState()) {
    on<EnrichmentEvent>(_onEvent);
    _restoreOutputDir();
  }

  final ExportRadicalMnemonics _exportRadicalMnemonics;
  final ImportRadicalMnemonics _importRadicalMnemonics;
  final BookmarkService _bookmarkService;
  List<DataImport> _imports = const [];

  /// Restore the persisted output directory bookmark on startup.
  Future<void> _restoreOutputDir() async {
    try {
      final path =
          await _bookmarkService.resolveBookmark(_outputDirBookmarkKey);
      if (path != null) {
        // ignore: invalid_use_of_visible_for_testing_member
        emit(state.copyWith(outputDir: path));
      }
    } catch (e, st) {
      log(
        'Failed to restore output directory bookmark',
        error: e,
        stackTrace: st,
        name: 'EnrichmentBloc',
      );
    }
  }

  Future<void> _onEvent(
    EnrichmentEvent event,
    Emitter<EnrichmentState> emit,
  ) async {
    await event.when(
      importsUpdated: (imports) => _onImportsUpdated(imports, emit),
      setOutputDir: (path) => _onSetOutputDir(path, emit),
      exportBatch: (batchType) => _onExportBatch(batchType, emit),
      importBatch: (batchType, filePath) =>
          _onImportBatch(batchType, filePath, emit),
      refreshStatus: () => _onRefreshStatus(emit),
    );
  }

  Future<void> _onImportsUpdated(
    List<DataImport> imports,
    Emitter<EnrichmentState> emit,
  ) async {
    _imports = imports;
    await _recomputeStatuses(emit);
  }

  Future<void> _onSetOutputDir(
    String path,
    Emitter<EnrichmentState> emit,
  ) async {
    try {
      await _bookmarkService.saveBookmark(_outputDirBookmarkKey, path);
      await _bookmarkService.startAccess(path);
    } catch (e, st) {
      log(
        'Failed to save output directory bookmark',
        error: e,
        stackTrace: st,
        name: 'EnrichmentBloc',
      );
    }
    emit(state.copyWith(outputDir: path));
  }

  Future<void> _onExportBatch(
    EnrichmentBatchType batchType,
    Emitter<EnrichmentState> emit,
  ) async {
    emit(state.copyWith(
      batches: {...state.batches, batchType: const BatchExporting()},
    ));

    try {
      switch (batchType) {
        case EnrichmentBatchType.radicalMnemonics:
          final offset =
              state.exportOffsets[EnrichmentBatchType.radicalMnemonics] ?? 0;
          final result = await _exportRadicalMnemonics.call(
            outputDir: state.outputDir,
            kanjidicImportId: _importIdFor(ImportSource.kanjidic),
            batchSize: state.batchSize,
            offset: offset,
          );
          // Advance offset after successful export.
          final newOffset = offset + result.rowCount;
          emit(state.copyWith(
            batches: {
              ...state.batches,
              batchType: BatchExported(
                exportedCount: newOffset,
                totalCount: result.totalCount,
                lastFilePath: result.filePath,
                warnings: result.warnings,
              ),
            },
            exportOffsets: {
              ...state.exportOffsets,
              EnrichmentBatchType.radicalMnemonics: newOffset,
            },
          ));
        case EnrichmentBatchType.kanjiMnemonics:
        case EnrichmentBatchType.sentenceTranslation:
        case EnrichmentBatchType.sentenceFurigana:
          emit(state.copyWith(
            batches: {
              ...state.batches,
              batchType: const BatchFailed('Not yet implemented'),
            },
          ));
      }
    } on Exception catch (e, st) {
      log(
        'Export ${batchType.label} failed',
        error: e,
        stackTrace: st,
        name: 'EnrichmentBloc',
      );
      emit(state.copyWith(
        batches: {
          ...state.batches,
          batchType: BatchFailed(e.toString()),
        },
      ));
    }
  }

  Future<void> _onImportBatch(
    EnrichmentBatchType batchType,
    String filePath,
    Emitter<EnrichmentState> emit,
  ) async {
    emit(state.copyWith(
      batches: {...state.batches, batchType: const BatchImporting()},
    ));

    try {
      switch (batchType) {
        case EnrichmentBatchType.radicalMnemonics:
          final result = await _importRadicalMnemonics.call(filePath);
          emit(state.copyWith(
            batches: {
              ...state.batches,
              batchType: BatchImported(
                importedCount: result.importedCount,
                rejectedCount: result.rejectedCount,
                warnings: result.warnings,
              ),
            },
          ));
        case EnrichmentBatchType.kanjiMnemonics:
        case EnrichmentBatchType.sentenceTranslation:
        case EnrichmentBatchType.sentenceFurigana:
          emit(state.copyWith(
            batches: {
              ...state.batches,
              batchType: const BatchFailed('Not yet implemented'),
            },
          ));
      }
    } on Exception catch (e, st) {
      log(
        'Import ${batchType.label} failed',
        error: e,
        stackTrace: st,
        name: 'EnrichmentBloc',
      );
      emit(state.copyWith(
        batches: {
          ...state.batches,
          batchType: BatchFailed(e.toString()),
        },
      ));
    }
  }

  Future<void> _onRefreshStatus(Emitter<EnrichmentState> emit) async {
    await _recomputeStatuses(emit);
  }

  Future<void> _recomputeStatuses(Emitter<EnrichmentState> emit) async {
    final ingestedSources = _imports
        .where((i) => i.status == ImportStatus.ingested)
        .map((i) => i.source)
        .toSet();

    final batches = <EnrichmentBatchType, BatchStatus>{};

    for (final batchType in EnrichmentBatchType.values) {
      final current = state.batches[batchType];

      // Preserve terminal/active states.
      if (current is BatchExported ||
          current is BatchImported ||
          current is BatchExporting ||
          current is BatchImporting ||
          current is BatchFailed) {
        batches[batchType] = current!;
        continue;
      }

      // Check if required sources are ingested.
      final ready = switch (batchType) {
        EnrichmentBatchType.radicalMnemonics =>
          ingestedSources.contains(ImportSource.kanjidic),
        EnrichmentBatchType.kanjiMnemonics =>
          ingestedSources.contains(ImportSource.kanjidic),
        EnrichmentBatchType.sentenceTranslation =>
          ingestedSources.contains(ImportSource.jmdict),
        EnrichmentBatchType.sentenceFurigana =>
          ingestedSources.contains(ImportSource.jmdict),
      };

      if (!ready) {
        batches[batchType] = const BatchIdle();
        continue;
      }

      // Check for existing enrichment data.
      final existing = await _checkExistingResult(batchType);
      if (existing != null) {
        batches[batchType] = BatchReady(existing);
        continue;
      }

      batches[batchType] = const BatchReady(0);
    }

    emit(state.copyWith(batches: batches));
  }

  Future<int?> _checkExistingResult(EnrichmentBatchType batchType) async {
    switch (batchType) {
      case EnrichmentBatchType.radicalMnemonics:
        final count =
            await _exportRadicalMnemonics.checkExistingExportResult();
        if (count == null) return null;
        return 0; // Has data, return non-null to indicate ready.
      case EnrichmentBatchType.kanjiMnemonics:
      case EnrichmentBatchType.sentenceTranslation:
      case EnrichmentBatchType.sentenceFurigana:
        return null;
    }
  }

  int _importIdFor(ImportSource source) {
    return _imports
        .where((i) => i.source == source && i.status == ImportStatus.ingested)
        .first
        .id;
  }

  @override
  Future<void> close() async {
    await _bookmarkService.stopAll();
    return super.close();
  }
}
