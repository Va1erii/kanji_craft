import 'dart:io';

import '../../data/services/ingestion_service.dart';
import '../entities/data_import.dart';
import '../entities/import_source.dart';
import '../repositories/data_import_repository.dart';

/// Thrown when pre-ingestion validation fails.
class IngestionValidationException implements Exception {
  IngestionValidationException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Source-specific config for folder/file detection.
typedef _SourceConfig = ({
  RegExp folderPattern,
  bool Function(String) isRequiredFile,
  bool Function(String)? isOptionalFile,
});

_SourceConfig _sourceConfig(ImportSource source) => switch (source) {
      ImportSource.kanjivg => (
          folderPattern: RegExp(r'kanjivg[_-](.+)'),
          isRequiredFile: (String name) => name.endsWith('.xml.gz'),
          isOptionalFile: (String name) =>
              name.endsWith('.zip') && name.contains('main'),
        ),
      ImportSource.kanjidic => (
          folderPattern: RegExp(r'kanjidic[_-]?(.+)'),
          isRequiredFile: (String name) => name.endsWith('.xml.gz'),
          isOptionalFile: null,
        ),
      ImportSource.jmdict => (
          folderPattern: RegExp(r'jmdict[_-]?(.+)'),
          isRequiredFile: (String name) =>
              name.endsWith('.zip') && name.contains('english'),
          isOptionalFile: null,
        ),
    };

class IngestSourceData {
  IngestSourceData({
    required DataImportRepository importRepository,
    required IngestionService ingestionService,
  })  : _importRepository = importRepository,
        _ingestionService = ingestionService;

  final DataImportRepository _importRepository;
  final IngestionService _ingestionService;

  Future<DataImport> call({
    required String folderPath,
    required ImportSource source,
    void Function(int inserted, int total)? onProgress,
  }) async {
    final dir = Directory(folderPath);
    if (!dir.existsSync()) {
      throw IngestionValidationException(
        'Folder does not exist: $folderPath',
      );
    }

    // Extract version from folder name.
    final config = _sourceConfig(source);
    final folderName = dir.uri.pathSegments
        .lastWhere((s) => s.isNotEmpty, orElse: () => '');
    final match = config.folderPattern.firstMatch(folderName);
    if (match == null || match.groupCount < 1) {
      throw IngestionValidationException(
        'Folder name "$folderName" does not match expected pattern '
        'for ${source.name}',
      );
    }
    final sourceVersion = match.group(1)!;

    // Scan for required file.
    final files = dir.listSync().whereType<File>().toList();
    String? requiredFilePath;
    for (final file in files) {
      final name = file.uri.pathSegments.last;
      if (config.isRequiredFile(name)) {
        requiredFilePath = file.path;
        break;
      }
    }
    if (requiredFilePath == null) {
      throw IngestionValidationException(
        'No required data file found in folder "$folderName"',
      );
    }

    // Check for active import.
    final active = await _importRepository.getActiveBySource(source);
    if (active != null) {
      throw IngestionValidationException(
        'An active ${source.name} import already exists (id=${active.id})',
      );
    }

    // Check for processed duplicate.
    final hasProcessed = await _importRepository.hasProcessedVersion(
      source: source,
      sourceVersion: sourceVersion,
    );
    if (hasProcessed) {
      throw IngestionValidationException(
        'A processed ${source.name} import with version "$sourceVersion" '
        'already exists',
      );
    }

    // Delegate to the appropriate ingestion method.
    final ingest = switch (source) {
      ImportSource.kanjivg => _ingestionService.ingestKanjiVg,
      ImportSource.kanjidic => _ingestionService.ingestKanjidic,
      ImportSource.jmdict => _ingestionService.ingestJmdict,
    };

    return ingest(
      filePath: requiredFilePath,
      sourceVersion: sourceVersion,
      onProgress: onProgress,
    );
  }
}
