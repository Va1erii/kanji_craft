import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanji_craft_admin/domain/entities/import_source.dart';
import 'package:kanji_craft_admin/domain/repositories/data_import_repository.dart';
import 'package:kanji_craft_admin/domain/usecases/clear_import.dart';
import 'package:kanji_craft_admin/domain/usecases/ingest_source_data.dart';

import 'data_import_event.dart';
import 'data_import_state.dart';

class DataImportBloc extends Bloc<DataImportEvent, DataImportState> {
  DataImportBloc({
    required DataImportRepository importRepository,
    required IngestSourceData ingestSourceData,
    required ClearImport clearImport,
  })  : _importRepository = importRepository,
        _ingestSourceData = ingestSourceData,
        _clearImport = clearImport,
        super(const DataImportState.initial()) {
    on<DataImportEvent>(_onEvent);
  }

  final DataImportRepository _importRepository;
  final IngestSourceData _ingestSourceData;
  final ClearImport _clearImport;

  Future<void> _onEvent(
    DataImportEvent event,
    Emitter<DataImportState> emit,
  ) async {
    await event.when(
      load: () => _onLoad(emit),
      startIngestion: (source, folderPath) =>
          _onStartIngestion(source, folderPath, emit),
      clearImport: (importId) => _onClearImport(importId, emit),
    );
  }

  Future<void> _onLoad(Emitter<DataImportState> emit) async {
    try {
      final imports = await _importRepository.listAll();
      final activeIngestions = state is DataImportLoaded
          ? (state as DataImportLoaded).activeIngestions
          : <int, IngestionProgress?>{};
      emit(DataImportState.loaded(
        imports: imports,
        activeIngestions: activeIngestions,
      ));
    } on Exception catch (e, st) {
      log('Failed to load imports', error: e, stackTrace: st, name: 'DataImportBloc');
      emit(DataImportState.error(e.toString()));
    }
  }

  Future<void> _onStartIngestion(
    ImportSource source,
    String folderPath,
    Emitter<DataImportState> emit,
  ) async {
    // Temporary tracking key using a negative hash to avoid collision
    // with real DB IDs.
    final trackingKey = -source.index - 1;

    try {
      if (state is DataImportLoaded) {
        final current = state as DataImportLoaded;
        emit(current.copyWith(
          activeIngestions: {
            ...current.activeIngestions,
            trackingKey: null, // null = parsing phase
          },
        ));
      }

      await for (final event in _ingestSourceData.call(
        folderPath: folderPath,
        source: source,
      )) {
        switch (event) {
          case IngestionStarted():
            if (state is DataImportLoaded) {
              final current = state as DataImportLoaded;
              emit(current.copyWith(
                imports: [...current.imports, event.dataImport],
              ));
            }
          case IngestionProgress():
            if (state is DataImportLoaded) {
              final current = state as DataImportLoaded;
              emit(current.copyWith(
                activeIngestions: {
                  ...current.activeIngestions,
                  trackingKey: event,
                },
              ));
            }
            // Drift batch inserts resolve as microtasks, starving the event
            // loop. Yield so the framework can render the progress update.
            await Future<void>.delayed(Duration.zero);
          case IngestionComplete():
            final imports = await _importRepository.listAll();
            final activeIngestions = state is DataImportLoaded
                ? Map<int, IngestionProgress?>.from(
                    (state as DataImportLoaded).activeIngestions)
                : <int, IngestionProgress?>{};
            activeIngestions.remove(trackingKey);
            emit(DataImportState.loaded(
              imports: imports,
              activeIngestions: activeIngestions,
            ));
        }
      }
    } on Exception catch (e, st) {
      log('Ingestion failed', error: e, stackTrace: st, name: 'DataImportBloc');
      // Reload to get the failed import record, clear progress.
      final imports = await _importRepository.listAll();
      final activeIngestions = state is DataImportLoaded
          ? Map<int, IngestionProgress?>.from(
              (state as DataImportLoaded).activeIngestions)
          : <int, IngestionProgress?>{};
      activeIngestions.remove(trackingKey);

      emit(DataImportState.loaded(
        imports: imports,
        activeIngestions: activeIngestions,
      ));

      // Re-emit as error briefly so UI can show a snackbar, then reload.
      emit(DataImportState.error(e.toString()));
      final refreshed = await _importRepository.listAll();
      emit(DataImportState.loaded(imports: refreshed));
    }
  }

  Future<void> _onClearImport(
    int importId,
    Emitter<DataImportState> emit,
  ) async {
    try {
      await _clearImport.call(importId);
      final imports = await _importRepository.listAll();
      emit(DataImportState.loaded(imports: imports));
    } on Exception catch (e, st) {
      log('Failed to clear import', error: e, stackTrace: st, name: 'DataImportBloc');
      emit(DataImportState.error(e.toString()));
      final imports = await _importRepository.listAll();
      emit(DataImportState.loaded(imports: imports));
    }
  }
}
