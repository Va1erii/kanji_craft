import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kanji_craft_admin/domain/entities/import_source.dart';

part 'data_import_event.freezed.dart';

@freezed
sealed class DataImportEvent with _$DataImportEvent {
  const factory DataImportEvent.load() = _Load;
  const factory DataImportEvent.startIngestion({
    required ImportSource source,
    required String sourceVersion,
    required String filePath,
  }) = _StartIngestion;
}
