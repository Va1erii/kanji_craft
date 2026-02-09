import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kanji_craft_admin/domain/entities/data_import.dart';
import 'package:kanji_craft_admin/domain/usecases/ingest_source_data.dart';

part 'data_import_state.freezed.dart';

@freezed
sealed class DataImportState with _$DataImportState {
  const factory DataImportState.initial() = _Initial;
  const factory DataImportState.loaded({
    required List<DataImport> imports,
    @Default({}) Map<int, IngestionProgress?> activeIngestions,
  }) = DataImportLoaded;
  const factory DataImportState.error(String message) = _Error;
}
