import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanji_craft_admin/data/services/ingestion_service.dart';
import 'package:kanji_craft_admin/domain/entities/import_source.dart';
import 'package:kanji_craft_admin/domain/repositories/data_import_repository.dart';

import 'data_import_event.dart';
import 'data_import_state.dart';

class DataImportBloc extends Bloc<DataImportEvent, DataImportState> {
  DataImportBloc({
    required DataImportRepository importRepository,
    required IngestionService ingestionService,
  })  : _importRepository = importRepository,
        _ingestionService = ingestionService,
        super(const DataImportState.initial()) {
    on<DataImportEvent>(_onEvent);
  }

  final DataImportRepository _importRepository;
  final IngestionService _ingestionService;

  Future<void> _onEvent(
    DataImportEvent event,
    Emitter<DataImportState> emit,
  ) async {
    await event.when(
      load: () => _onLoad(emit),
      startIngestion: (source, sourceVersion, filePath) =>
          _onStartIngestion(source, sourceVersion, filePath, emit),
    );
  }

  Future<void> _onLoad(Emitter<DataImportState> emit) async {
    try {
      final imports = await _importRepository.listAll();
      final activeIngestions = state is DataImportLoaded
          ? (state as DataImportLoaded).activeIngestions
          : <int, IngestionProgress>{};
      emit(DataImportState.loaded(
        imports: imports,
        activeIngestions: activeIngestions,
      ));
    } on Exception catch (e) {
      emit(DataImportState.error(e.toString()));
    }
  }

  Future<void> _onStartIngestion(
    ImportSource source,
    String sourceVersion,
    String filePath,
    Emitter<DataImportState> emit,
  ) async {
    try {
      final ingest = switch (source) {
        ImportSource.kanjivg => _ingestionService.ingestKanjiVg,
        ImportSource.kanjidic => _ingestionService.ingestKanjidic,
        ImportSource.jmdict => _ingestionService.ingestJmdict,
      };

      // Temporary import ID for tracking progress before we know the real one.
      // We use a negative hash to avoid collision with real DB IDs.
      final trackingKey = -source.index - 1;

      if (state is DataImportLoaded) {
        final current = state as DataImportLoaded;
        emit(current.copyWith(
          activeIngestions: {
            ...current.activeIngestions,
            trackingKey: const IngestionProgress(inserted: 0, total: 0),
          },
        ));
      }

      final result = await ingest(
        filePath: filePath,
        sourceVersion: sourceVersion,
        onProgress: (inserted, total) {
          if (state is DataImportLoaded) {
            final current = state as DataImportLoaded;
            emit(current.copyWith(
              activeIngestions: {
                ...current.activeIngestions,
                trackingKey: IngestionProgress(inserted: inserted, total: total),
              },
            ));
          }
        },
      );

      // Reload and clear progress entry.
      final imports = await _importRepository.listAll();
      final activeIngestions = state is DataImportLoaded
          ? Map<int, IngestionProgress>.from(
              (state as DataImportLoaded).activeIngestions)
          : <int, IngestionProgress>{};
      activeIngestions.remove(trackingKey);

      emit(DataImportState.loaded(
        imports: imports,
        activeIngestions: activeIngestions,
      ));

      // Ignore the result variable lint — we need the await.
      result;
    } on Exception catch (e) {
      // Reload to get the failed import record, clear progress.
      final imports = await _importRepository.listAll();
      final activeIngestions = state is DataImportLoaded
          ? Map<int, IngestionProgress>.from(
              (state as DataImportLoaded).activeIngestions)
          : <int, IngestionProgress>{};
      activeIngestions.remove(-source.index - 1);

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
}
