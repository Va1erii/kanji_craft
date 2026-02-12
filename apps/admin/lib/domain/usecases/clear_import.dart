import '../entities/import_source.dart';
import '../repositories/data_import_repository.dart';
import '../repositories/jmdict_furigana_repository.dart';
import '../repositories/raw_jmdict_repository.dart';
import '../repositories/raw_kanjidic_repository.dart';
import '../repositories/raw_kanjivg_repository.dart';
import '../services/svg_cache.dart';
import '../../data/repositories/data_import/supabase_data_import_datasource.dart';

/// Deletes an import and its associated raw rows from both local DB and
/// Supabase, allowing the source to be re-ingested.
class ClearImport {
  ClearImport({
    required DataImportRepository importRepository,
    required RawKanjiVgRepository kanjiVgRepository,
    required RawKanjidicRepository kanjidicRepository,
    required RawJmdictRepository jmdictRepository,
    required JmdictFuriganaRepository jmdictFuriganaRepository,
    required SvgCache svgCache,
    required SupabaseDataImportDataSource supabaseDataImportDataSource,
  })  : _importRepository = importRepository,
        _kanjiVgRepository = kanjiVgRepository,
        _kanjidicRepository = kanjidicRepository,
        _jmdictRepository = jmdictRepository,
        _jmdictFuriganaRepository = jmdictFuriganaRepository,
        _svgCache = svgCache,
        _supabaseDataImportDataSource = supabaseDataImportDataSource;

  final DataImportRepository _importRepository;
  final RawKanjiVgRepository _kanjiVgRepository;
  final RawKanjidicRepository _kanjidicRepository;
  final RawJmdictRepository _jmdictRepository;
  final JmdictFuriganaRepository _jmdictFuriganaRepository;
  final SvgCache _svgCache;
  final SupabaseDataImportDataSource _supabaseDataImportDataSource;

  Future<void> call(int importId) async {
    final dataImport = await _importRepository.getById(importId);
    if (dataImport == null) return;

    await _deleteRawRows(source: dataImport.source, importId: importId);
    await _importRepository.delete(importId);
    await _supabaseDataImportDataSource.delete(importId);
  }

  Future<void> _deleteRawRows({
    required ImportSource source,
    required int importId,
  }) async {
    switch (source) {
      case ImportSource.kanjivg:
        await _kanjiVgRepository.deleteByImportId(importId);
        await _svgCache.clear();
      case ImportSource.kanjidic:
        await _kanjidicRepository.deleteByImportId(importId);
      case ImportSource.jmdict:
        await _jmdictRepository.deleteByImportId(importId);
      case ImportSource.jmdictFurigana:
        await _jmdictFuriganaRepository.deleteByImportId(importId);
    }
  }
}
