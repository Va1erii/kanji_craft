import 'dart:io';

import '../entities/data_import.dart';
import '../entities/import_source.dart';
import '../entities/import_status.dart';
import '../entities/jmdict_furigana.dart';
import '../entities/raw_jmdict.dart';
import '../entities/raw_kanjidic.dart';
import '../entities/raw_kanjivg.dart';
import '../repositories/data_import_repository.dart';
import '../repositories/jmdict_furigana_repository.dart';
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

/// Events yielded by [IngestSourceData] to report pipeline progress.
sealed class IngestionEvent {
  const IngestionEvent();
}

/// Batch insert progress: [inserted] of [total] entries written so far.
class IngestionProgress extends IngestionEvent {
  const IngestionProgress(this.inserted, this.total);
  final int inserted;
  final int total;
}

/// Import record created, parsing is about to begin.
class IngestionStarted extends IngestionEvent {
  const IngestionStarted(this.dataImport);
  final DataImport dataImport;
}

/// Terminal event: ingestion succeeded and the import record is updated.
class IngestionComplete extends IngestionEvent {
  const IngestionComplete(this.dataImport);
  final DataImport dataImport;
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
      ImportSource.jmdictFurigana => (
          folderPattern: RegExp(r'jmdictfurigana[_-](.+)'),
          requiredFiles: [
            (String name) => name == 'JmdictFurigana.json.tar.gz',
          ],
          isOptionalFile: null,
        ),
    };

/// Orchestrates the full ingestion pipeline for a source data folder.
///
/// Returns a [Stream] of [IngestionEvent]s reporting progress. The stream
/// ends with [IngestionComplete] on success, or an error on failure (after
/// cleaning up partial raw rows and marking the import as failed).
///
/// Pipeline steps:
/// 1. Validate the folder structure, extract the source version, and resolve
///    the primary data file path.
/// 2. Guard against duplicate or concurrent imports.
/// 3. Create a [DataImport] record via [DataImportRepository].
/// 4. Parse the source file via [SourceParser].
/// 5. Batch-insert parsed entities, yielding [IngestionProgress] per batch.
/// 6. Update the import status to [ImportStatus.ingested].
class IngestSourceData {
  IngestSourceData({
    required DataImportRepository importRepository,
    required RawKanjiVgRepository kanjiVgRepository,
    required RawKanjidicRepository kanjidicRepository,
    required RawJmdictRepository jmdictRepository,
    required JmdictFuriganaRepository jmdictFuriganaRepository,
    required SourceParser sourceParser,
  })  : _importRepository = importRepository,
        _kanjiVgRepository = kanjiVgRepository,
        _kanjidicRepository = kanjidicRepository,
        _jmdictRepository = jmdictRepository,
        _jmdictFuriganaRepository = jmdictFuriganaRepository,
        _sourceParser = sourceParser;

  final DataImportRepository _importRepository;
  final RawKanjiVgRepository _kanjiVgRepository;
  final RawKanjidicRepository _kanjidicRepository;
  final RawJmdictRepository _jmdictRepository;
  final JmdictFuriganaRepository _jmdictFuriganaRepository;
  final SourceParser _sourceParser;

  static const _batchSize = 500;

  Stream<IngestionEvent> call({
    required String folderPath,
    required ImportSource source,
  }) async* {
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
    yield IngestionStarted(dataImport);

    // Parse → insert → update status (with cleanup on failure).
    try {
      final result = await _sourceParser.parseFile(
        source: source,
        filePath: primaryFilePath,
        importId: dataImport.id,
      );

      yield* _insertEntries(
        source: source,
        entries: result.entries,
        importId: dataImport.id,
      );

      final updated = await _importRepository.updateStatus(
        id: dataImport.id,
        status: ImportStatus.ingested,
        recordCount: result.parsedCount,
        metadata: {...result.toMetadata(), 'folder_path': folderPath},
      );

      yield IngestionComplete(updated);
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

  Stream<IngestionProgress> _insertEntries({
    required ImportSource source,
    required List<Object> entries,
    required int importId,
  }) =>
      switch (source) {
        ImportSource.kanjivg => _batchInsert(
            entries.cast<RawKanjiVg>(),
            (batch) => _kanjiVgRepository.insertBatch(batch),
          ),
        ImportSource.kanjidic => _batchInsert(
            entries.cast<RawKanjidic>(),
            (batch) => _kanjidicRepository.insertBatch(batch),
          ),
        ImportSource.jmdict => _batchInsert(
            entries.cast<RawJmdict>(),
            (batch) => _jmdictRepository.insertBatch(batch),
          ),
        ImportSource.jmdictFurigana => _batchInsert(
            entries.cast<JmdictFurigana>(),
            (batch) => _jmdictFuriganaRepository.insertBatch(
                  batch,
                  importId: importId,
                ),
          ),
      };

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
      case ImportSource.jmdictFurigana:
        await _jmdictFuriganaRepository.deleteByImportId(importId);
    }
  }

  Stream<IngestionProgress> _batchInsert<T>(
    List<T> entries,
    Future<void> Function(List<T> batch) insert,
  ) async* {
    for (var i = 0; i < entries.length; i += _batchSize) {
      final end =
          (i + _batchSize > entries.length) ? entries.length : i + _batchSize;
      await insert(entries.sublist(i, end));
      yield IngestionProgress(end, entries.length);
    }
  }
}
