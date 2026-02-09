import 'dart:io';

import '../entities/data_import.dart';
import '../entities/import_source.dart';
import '../entities/import_status.dart';
import '../entities/raw_jmdict.dart';
import '../entities/raw_kanjidic.dart';
import '../entities/raw_kanjivg.dart';
import '../repositories/data_import_repository.dart';
import '../repositories/raw_jmdict_repository.dart';
import '../repositories/raw_kanjidic_repository.dart';
import '../repositories/raw_kanjivg_repository.dart';
import '../services/source_parser.dart';

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

/// Orchestrates the full ingestion pipeline for a source data folder.
///
/// Steps:
/// 1. Validate the folder structure, extract the source version, and resolve
///    the primary data file path.
/// 2. Guard against duplicate or concurrent imports.
/// 3. Create a [DataImport] record via [DataImportRepository].
/// 4. Parse the source file via [SourceParser].
/// 5. Batch-insert parsed entities into the appropriate raw repository.
/// 6. Update the import status to [ImportStatus.ingested] on success, or
///    [ImportStatus.failed] on error (after cleaning up partial raw rows).
class IngestSourceData {
  IngestSourceData({
    required DataImportRepository importRepository,
    required RawKanjiVgRepository kanjiVgRepository,
    required RawKanjidicRepository kanjidicRepository,
    required RawJmdictRepository jmdictRepository,
    required SourceParser sourceParser,
  })  : _importRepository = importRepository,
        _kanjiVgRepository = kanjiVgRepository,
        _kanjidicRepository = kanjidicRepository,
        _jmdictRepository = jmdictRepository,
        _sourceParser = sourceParser;

  final DataImportRepository _importRepository;
  final RawKanjiVgRepository _kanjiVgRepository;
  final RawKanjidicRepository _kanjidicRepository;
  final RawJmdictRepository _jmdictRepository;
  final SourceParser _sourceParser;

  static const _batchSize = 500;

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

    // Create import record.
    final dataImport = await _importRepository.create(
      source: source,
      sourceVersion: sourceVersion,
    );

    // Parse → insert → update status (with cleanup on failure).
    try {
      final result = _sourceParser.parseFile(
        source: source,
        filePath: primaryFilePath,
        importId: dataImport.id,
      );

      await _insertEntries(
        source: source,
        entries: result.entries,
        onProgress: onProgress,
      );

      return await _importRepository.updateStatus(
        id: dataImport.id,
        status: ImportStatus.ingested,
        recordCount: result.parsedCount,
        metadata: result.toMetadata(),
      );
    } catch (e) {
      await _deleteRawRows(source: source, importId: dataImport.id);
      await _importRepository.updateStatus(
        id: dataImport.id,
        status: ImportStatus.failed,
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> _insertEntries({
    required ImportSource source,
    required List<Object> entries,
    void Function(int inserted, int total)? onProgress,
  }) async {
    switch (source) {
      case ImportSource.kanjivg:
        await _batchInsert(
          entries.cast<RawKanjiVg>(),
          (batch) => _kanjiVgRepository.insertBatch(batch),
          onProgress: onProgress,
        );
      case ImportSource.kanjidic:
        await _batchInsert(
          entries.cast<RawKanjidic>(),
          (batch) => _kanjidicRepository.insertBatch(batch),
          onProgress: onProgress,
        );
      case ImportSource.jmdict:
        await _batchInsert(
          entries.cast<RawJmdict>(),
          (batch) => _jmdictRepository.insertBatch(batch),
          onProgress: onProgress,
        );
    }
  }

  Future<void> _deleteRawRows({
    required ImportSource source,
    required int importId,
  }) async {
    switch (source) {
      case ImportSource.kanjivg:
        await _kanjiVgRepository.deleteByImportId(importId);
      case ImportSource.kanjidic:
        await _kanjidicRepository.deleteByImportId(importId);
      case ImportSource.jmdict:
        await _jmdictRepository.deleteByImportId(importId);
    }
  }

  Future<void> _batchInsert<T>(
    List<T> entries,
    Future<void> Function(List<T> batch) insert, {
    void Function(int inserted, int total)? onProgress,
  }) async {
    for (var i = 0; i < entries.length; i += _batchSize) {
      final end =
          (i + _batchSize > entries.length) ? entries.length : i + _batchSize;
      await insert(entries.sublist(i, end));
      onProgress?.call(end, entries.length);
    }
  }
}
