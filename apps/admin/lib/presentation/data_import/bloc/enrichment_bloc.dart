import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/bookmark_service.dart';
import '../../../domain/entities/data_import.dart';
import '../../../domain/entities/enrichment_batch_type.dart';
import '../../../domain/entities/import_source.dart';
import '../../../domain/entities/import_status.dart';
import '../../../domain/usecases/export_kanji_mnemonics.dart';
import '../../../domain/usecases/export_radical_mnemonics.dart';
import '../../../domain/usecases/import_kanji_mnemonics.dart';
import '../../../domain/usecases/import_radical_mnemonics.dart';
import 'enrichment_event.dart';
import 'enrichment_state.dart';

/// Bookmark key for persisting the CSV output directory across app launches.
const _outputDirBookmarkKey = 'enrichment_output_dir';

class EnrichmentBloc extends Bloc<EnrichmentEvent, EnrichmentState> {
  EnrichmentBloc({
    required ExportRadicalMnemonics exportRadicalMnemonics,
    required ImportRadicalMnemonics importRadicalMnemonics,
    required ExportKanjiMnemonics exportKanjiMnemonics,
    required ImportKanjiMnemonics importKanjiMnemonics,
    required BookmarkService bookmarkService,
  })  : _exportRadicalMnemonics = exportRadicalMnemonics,
        _importRadicalMnemonics = importRadicalMnemonics,
        _exportKanjiMnemonics = exportKanjiMnemonics,
        _importKanjiMnemonics = importKanjiMnemonics,
        _bookmarkService = bookmarkService,
        super(const EnrichmentState()) {
    on<EnrichmentEvent>(_onEvent);
    _restoreOutputDir();
  }

  final ExportRadicalMnemonics _exportRadicalMnemonics;
  final ImportRadicalMnemonics _importRadicalMnemonics;
  final ExportKanjiMnemonics _exportKanjiMnemonics;
  final ImportKanjiMnemonics _importKanjiMnemonics;
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
      exportSubBatch: (batchType, subBatchIndex) =>
          _onExportSubBatch(batchType, subBatchIndex, emit),
      importSubBatch: (batchType, subBatchIndex, filePath) =>
          _onImportSubBatch(batchType, subBatchIndex, filePath, emit),
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

  Future<void> _onExportSubBatch(
    EnrichmentBatchType batchType,
    int subBatchIndex,
    Emitter<EnrichmentState> emit,
  ) async {
    _emitSubBatchUpdate(
      batchType,
      subBatchIndex,
      const SubBatchExporting(),
      emit,
    );

    try {
      switch (batchType) {
        case EnrichmentBatchType.radicalMnemonics:
          final offset = subBatchIndex * batchType.batchSize;
          final result = await _exportRadicalMnemonics.call(
            outputDir: state.outputDir,
            kanjidicImportId: _importIdFor(ImportSource.kanjidic),
            batchSize: batchType.batchSize,
            offset: offset,
          );
          _emitSubBatchUpdate(
            batchType,
            subBatchIndex,
            SubBatchExported(
              filePath: result.filePath,
              warnings: result.warnings,
            ),
            emit,
          );
        case EnrichmentBatchType.kanjiMnemonics:
          final offset = subBatchIndex * batchType.batchSize;
          final result = await _exportKanjiMnemonics.call(
            outputDir: state.outputDir,
            batchSize: batchType.batchSize,
            offset: offset,
          );
          _emitSubBatchUpdate(
            batchType,
            subBatchIndex,
            SubBatchExported(
              filePath: result.filePath,
              warnings: result.warnings,
            ),
            emit,
          );
        case EnrichmentBatchType.sentenceTranslation:
        case EnrichmentBatchType.sentenceFurigana:
          _emitSubBatchUpdate(
            batchType,
            subBatchIndex,
            const SubBatchFailed('Not yet implemented'),
            emit,
          );
      }
    } on Exception catch (e, st) {
      log(
        'Export ${batchType.label} sub-batch $subBatchIndex failed',
        error: e,
        stackTrace: st,
        name: 'EnrichmentBloc',
      );
      _emitSubBatchUpdate(
        batchType,
        subBatchIndex,
        SubBatchFailed(e.toString()),
        emit,
      );
    }
  }

  Future<void> _onImportSubBatch(
    EnrichmentBatchType batchType,
    int subBatchIndex,
    String filePath,
    Emitter<EnrichmentState> emit,
  ) async {
    _emitSubBatchUpdate(
      batchType,
      subBatchIndex,
      const SubBatchImporting(),
      emit,
    );

    try {
      switch (batchType) {
        case EnrichmentBatchType.radicalMnemonics:
          final result = await _importRadicalMnemonics.call(filePath);
          _emitSubBatchUpdate(
            batchType,
            subBatchIndex,
            SubBatchImported(
              importedCount: result.importedCount,
              rejectedCount: result.rejectedCount,
              warnings: result.warnings,
            ),
            emit,
          );
        case EnrichmentBatchType.kanjiMnemonics:
          final result = await _importKanjiMnemonics.call(filePath);
          _emitSubBatchUpdate(
            batchType,
            subBatchIndex,
            SubBatchImported(
              importedCount: result.importedCount,
              rejectedCount: result.rejectedCount,
              warnings: result.warnings,
            ),
            emit,
          );
        case EnrichmentBatchType.sentenceTranslation:
        case EnrichmentBatchType.sentenceFurigana:
          _emitSubBatchUpdate(
            batchType,
            subBatchIndex,
            const SubBatchFailed('Not yet implemented'),
            emit,
          );
      }
    } on Exception catch (e, st) {
      log(
        'Import ${batchType.label} sub-batch $subBatchIndex failed',
        error: e,
        stackTrace: st,
        name: 'EnrichmentBloc',
      );
      _emitSubBatchUpdate(
        batchType,
        subBatchIndex,
        SubBatchFailed(e.toString()),
        emit,
      );
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

    final batches = <EnrichmentBatchType, BatchTypeStatus>{};

    for (final batchType in EnrichmentBatchType.values) {
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
        batches[batchType] = const BatchTypeIdle();
        continue;
      }

      // Query total count for this batch type.
      final totalCount = await _queryTotalCount(batchType);
      final subBatchCount =
          totalCount > 0 ? (totalCount + batchType.batchSize - 1) ~/ batchType.batchSize : 0;

      // Preserve existing sub-batch statuses where indices match.
      final existing = state.batches[batchType];
      final existingSubBatches =
          existing is BatchTypeReady ? existing.subBatches : const <SubBatchStatus>[];

      final subBatches = List.generate(subBatchCount, (i) {
        if (i < existingSubBatches.length) return existingSubBatches[i];
        return const SubBatchPending();
      });

      batches[batchType] = BatchTypeReady(
        totalCount: totalCount,
        subBatches: subBatches,
      );
    }

    emit(state.copyWith(batches: batches));
  }

  Future<int> _queryTotalCount(EnrichmentBatchType batchType) async {
    try {
      switch (batchType) {
        case EnrichmentBatchType.radicalMnemonics:
          return await _exportRadicalMnemonics.queryTotalCount();
        case EnrichmentBatchType.kanjiMnemonics:
          return await _exportKanjiMnemonics.queryTotalCount();
        case EnrichmentBatchType.sentenceTranslation:
        case EnrichmentBatchType.sentenceFurigana:
          return 0;
      }
    } catch (e, st) {
      log(
        'Failed to query total count for ${batchType.label}',
        error: e,
        stackTrace: st,
        name: 'EnrichmentBloc',
      );
      return 0;
    }
  }

  /// Immutably updates a single sub-batch status within the state map.
  void _emitSubBatchUpdate(
    EnrichmentBatchType batchType,
    int index,
    SubBatchStatus newStatus,
    Emitter<EnrichmentState> emit,
  ) {
    final current = state.batches[batchType];
    if (current is! BatchTypeReady) return;
    if (index < 0 || index >= current.subBatches.length) return;

    final updatedSubBatches = [...current.subBatches];
    updatedSubBatches[index] = newStatus;

    emit(state.copyWith(
      batches: {
        ...state.batches,
        batchType: BatchTypeReady(
          totalCount: current.totalCount,
          subBatches: updatedSubBatches,
        ),
      },
    ));
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
