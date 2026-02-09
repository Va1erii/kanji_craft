import '../../domain/entities/data_import.dart';
import '../../domain/entities/import_source.dart';
import '../../domain/entities/import_status.dart';
import '../../domain/repositories/data_import_repository.dart';
import '../../domain/repositories/raw_jmdict_repository.dart';
import '../../domain/repositories/raw_kanjidic_repository.dart';
import '../../domain/repositories/raw_kanjivg_repository.dart';
import '../parsers/jmdict_parser.dart';
import '../parsers/kanjidic_parser.dart';
import '../parsers/kanjivg_parser.dart';

class IngestionService {
  IngestionService({
    required DataImportRepository importRepository,
    required RawKanjiVgRepository kanjiVgRepository,
    required RawKanjidicRepository kanjidicRepository,
    required RawJmdictRepository jmdictRepository,
    KanjiVgParser? kanjiVgParser,
    KanjidicParser? kanjidicParser,
    JmdictParser? jmdictParser,
  })  : _importRepository = importRepository,
        _kanjiVgRepository = kanjiVgRepository,
        _kanjidicRepository = kanjidicRepository,
        _jmdictRepository = jmdictRepository,
        _kanjiVgParser = kanjiVgParser ?? KanjiVgParser(),
        _kanjidicParser = kanjidicParser ?? KanjidicParser(),
        _jmdictParser = jmdictParser ?? JmdictParser();

  final DataImportRepository _importRepository;
  final RawKanjiVgRepository _kanjiVgRepository;
  final RawKanjidicRepository _kanjidicRepository;
  final RawJmdictRepository _jmdictRepository;
  final KanjiVgParser _kanjiVgParser;
  final KanjidicParser _kanjidicParser;
  final JmdictParser _jmdictParser;

  static const _batchSize = 500;

  Future<DataImport> ingestKanjiVg({
    required String filePath,
    required String sourceVersion,
    void Function(int inserted, int total)? onProgress,
  }) async {
    final active =
        await _importRepository.getActiveBySource(ImportSource.kanjivg);
    if (active != null) {
      throw StateError(
        'Active KanjiVG import already exists (id=${active.id})',
      );
    }

    final dataImport = await _importRepository.create(
      source: ImportSource.kanjivg,
      sourceVersion: sourceVersion,
    );

    try {
      final entries = _kanjiVgParser.parseFile(
        filePath: filePath,
        importId: dataImport.id,
      );

      await _batchInsert(
        entries,
        (batch) => _kanjiVgRepository.insertBatch(batch),
        onProgress: onProgress,
      );

      return await _importRepository.updateStatus(
        id: dataImport.id,
        status: ImportStatus.ingested,
        recordCount: entries.length,
      );
    } catch (e) {
      await _kanjiVgRepository.deleteByImportId(dataImport.id);
      await _importRepository.updateStatus(
        id: dataImport.id,
        status: ImportStatus.failed,
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }

  Future<DataImport> ingestKanjidic({
    required String filePath,
    required String sourceVersion,
    void Function(int inserted, int total)? onProgress,
  }) async {
    final active =
        await _importRepository.getActiveBySource(ImportSource.kanjidic);
    if (active != null) {
      throw StateError(
        'Active KANJIDIC import already exists (id=${active.id})',
      );
    }

    final dataImport = await _importRepository.create(
      source: ImportSource.kanjidic,
      sourceVersion: sourceVersion,
    );

    try {
      final entries = _kanjidicParser.parseFile(
        filePath: filePath,
        importId: dataImport.id,
      );

      await _batchInsert(
        entries,
        (batch) => _kanjidicRepository.insertBatch(batch),
        onProgress: onProgress,
      );

      return await _importRepository.updateStatus(
        id: dataImport.id,
        status: ImportStatus.ingested,
        recordCount: entries.length,
      );
    } catch (e) {
      await _kanjidicRepository.deleteByImportId(dataImport.id);
      await _importRepository.updateStatus(
        id: dataImport.id,
        status: ImportStatus.failed,
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }

  Future<DataImport> ingestJmdict({
    required String filePath,
    required String sourceVersion,
    void Function(int inserted, int total)? onProgress,
  }) async {
    final active =
        await _importRepository.getActiveBySource(ImportSource.jmdict);
    if (active != null) {
      throw StateError(
        'Active JMDict import already exists (id=${active.id})',
      );
    }

    final dataImport = await _importRepository.create(
      source: ImportSource.jmdict,
      sourceVersion: sourceVersion,
    );

    try {
      final entries = _jmdictParser.parseFile(
        filePath: filePath,
        importId: dataImport.id,
      );

      await _batchInsert(
        entries,
        (batch) => _jmdictRepository.insertBatch(batch),
        onProgress: onProgress,
      );

      return await _importRepository.updateStatus(
        id: dataImport.id,
        status: ImportStatus.ingested,
        recordCount: entries.length,
      );
    } catch (e) {
      await _jmdictRepository.deleteByImportId(dataImport.id);
      await _importRepository.updateStatus(
        id: dataImport.id,
        status: ImportStatus.failed,
        errorMessage: e.toString(),
      );
      rethrow;
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
