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
  List<bool Function(String)> requiredFiles,
  bool Function(String)? isOptionalFile,
});

_SourceConfig _sourceConfig(ImportSource source) => switch (source) {
      ImportSource.kanjivg => (
          folderPattern: RegExp(r'kanjivg[_-](.+)'),
          requiredFiles: [(String name) => name.endsWith('.xml.gz')],
          isOptionalFile: (String name) =>
              name.endsWith('.zip') && name.contains('main'),
        ),
      ImportSource.kanjidic => (
          folderPattern: RegExp(r'kanjidic2?[_-](.+)'),
          requiredFiles: [(String name) => name.endsWith('.xml.gz')],
          isOptionalFile: null,
        ),
      ImportSource.jmdict => (
          folderPattern: RegExp(r'jmdict[_-](.+)'),
          requiredFiles: [
            (String name) => name == 'JMdict.gz',
            (String name) => name == 'JMdict_e_examp.gz',
          ],
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

    // Scan for required files.
    final files = dir.listSync().whereType<File>().toList();
    final resolvedPaths = <String?>[];
    for (final matcher in config.requiredFiles) {
      String? found;
      for (final file in files) {
        final name = file.uri.pathSegments.last;
        if (matcher(name)) {
          found = file.path;
          break;
        }
      }
      resolvedPaths.add(found);
    }
    if (resolvedPaths.any((p) => p == null)) {
      throw IngestionValidationException(
        'No required data file found in folder "$folderName"',
      );
    }
    final primaryFilePath = resolvedPaths.first!;

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
    return switch (source) {
      ImportSource.kanjivg => _ingestionService.ingestKanjiVg(
          filePath: primaryFilePath,
          sourceVersion: sourceVersion,
          onProgress: onProgress,
        ),
      ImportSource.kanjidic => _ingestionService.ingestKanjidic(
          filePath: primaryFilePath,
          sourceVersion: sourceVersion,
          onProgress: onProgress,
        ),
      ImportSource.jmdict => _ingestionService.ingestJmdict(
          filePath: primaryFilePath,
          sourceVersion: sourceVersion,
          onProgress: onProgress,
        ),
    };
  }
}
