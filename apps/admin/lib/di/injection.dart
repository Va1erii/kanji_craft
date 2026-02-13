import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/database/admin_database.dart';
import '../data/repositories/data_import/drift_data_import_repository.dart';
import '../data/repositories/data_import/supabase_data_import_datasource.dart';
import '../data/repositories/kanji_component_review/drift_kanji_component_review_repository.dart';
import '../data/repositories/kanji_component_review/supabase_kanji_component_review_datasource.dart';
import '../data/repositories/raw_jmdict/drift_raw_jmdict_repository.dart';
import '../data/repositories/raw_kanjidic/drift_raw_kanjidic_repository.dart';
import '../data/repositories/kanji/drift_kanji_repository.dart';
import '../data/repositories/kanji_component/drift_kanji_component_repository.dart';
import '../data/repositories/radical/drift_radical_repository.dart';
import '../data/repositories/raw_kanjivg/drift_raw_kanjivg_repository.dart';
import '../data/repositories/vocabulary/drift_vocabulary_repository.dart';
import '../data/repositories/jmdict_furigana/drift_jmdict_furigana_repository.dart';
import '../data/repositories/source_jlpt_level/drift_source_jlpt_level_repository.dart';
import '../data/repositories/source_vocab_level/drift_source_vocab_level_repository.dart';
import '../data/services/csv_service.dart';
import '../data/services/drift_admin_state_writer.dart';
import '../data/services/file_svg_cache.dart';
import '../data/services/source_parser_impl.dart';
import '../data/services/supabase_admin_state_reader.dart';
import '../domain/repositories/data_import_repository.dart';
import '../domain/repositories/kanji_component_review_repository.dart';
import '../domain/repositories/raw_jmdict_repository.dart';
import '../domain/repositories/raw_kanjidic_repository.dart';
import '../domain/repositories/kanji_component_repository.dart';
import '../domain/repositories/kanji_repository.dart';
import '../domain/repositories/radical_repository.dart';
import '../domain/repositories/raw_kanjivg_repository.dart';
import '../domain/repositories/vocabulary_repository.dart';
import '../domain/repositories/jmdict_furigana_repository.dart';
import '../domain/repositories/source_jlpt_level_repository.dart';
import '../domain/repositories/source_vocab_level_repository.dart';
import '../domain/services/admin_state_reader.dart';
import '../domain/services/admin_state_writer.dart';
import '../domain/services/svg_cache.dart';
import '../data/services/radical_scanner.dart';
import '../domain/services/source_parser.dart';
import '../domain/usecases/compose_kanji.dart';
import '../domain/usecases/export_radical_mnemonics.dart';
import '../domain/usecases/extract_radicals.dart';
import '../domain/usecases/estimate_logic_hints.dart';
import '../domain/usecases/import_radical_mnemonics.dart';
import '../domain/usecases/link_components.dart';
import '../domain/usecases/extract_vocabulary.dart';
import '../domain/usecases/hydrate_local_db.dart';
import '../domain/usecases/clear_import.dart';
import '../domain/usecases/ingest_source_data.dart';
import '../domain/usecases/process_svgs.dart';
import '../presentation/data_import/bloc/data_import_bloc.dart';
import '../presentation/data_import/bloc/enrichment_bloc.dart';
import '../presentation/data_import/bloc/extraction_bloc.dart';
import '../presentation/hydration/bloc/hydration_bloc.dart';

const _supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const _supabaseServiceRoleKey =
    String.fromEnvironment('SUPABASE_SERVICE_ROLE_KEY');

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  assert(_supabaseUrl.isNotEmpty, 'SUPABASE_URL required via --dart-define');
  assert(
    _supabaseServiceRoleKey.isNotEmpty,
    'SUPABASE_SERVICE_ROLE_KEY required via --dart-define',
  );
  await Supabase.initialize(
    url: _supabaseUrl,
    anonKey: _supabaseServiceRoleKey,
  );

  // -- Database --
  getIt.registerLazySingleton<AdminDatabase>(() => AdminDatabase());

  // -- Repositories --
  getIt.registerLazySingleton<DataImportRepository>(
    () => DriftDataImportRepository(getIt<AdminDatabase>()),
  );
  getIt.registerLazySingleton<KanjiComponentReviewRepository>(
    () => DriftKanjiComponentReviewRepository(getIt<AdminDatabase>()),
  );
  getIt.registerLazySingleton<RawKanjiVgRepository>(
    () => DriftRawKanjiVgRepository(getIt<AdminDatabase>()),
  );
  getIt.registerLazySingleton<RawKanjidicRepository>(
    () => DriftRawKanjidicRepository(getIt<AdminDatabase>()),
  );
  getIt.registerLazySingleton<RawJmdictRepository>(
    () => DriftRawJmdictRepository(getIt<AdminDatabase>()),
  );
  getIt.registerLazySingleton<SourceJlptLevelRepository>(
    () => DriftSourceJlptLevelRepository(getIt<AdminDatabase>()),
  );
  getIt.registerLazySingleton<SourceVocabLevelRepository>(
    () => DriftSourceVocabLevelRepository(getIt<AdminDatabase>()),
  );
  getIt.registerLazySingleton<JmdictFuriganaRepository>(
    () => DriftJmdictFuriganaRepository(getIt<AdminDatabase>()),
  );
  getIt.registerLazySingleton<RadicalRepository>(
    () => DriftRadicalRepository(getIt<AdminDatabase>()),
  );
  getIt.registerLazySingleton<KanjiRepository>(
    () => DriftKanjiRepository(getIt<AdminDatabase>()),
  );
  getIt.registerLazySingleton<VocabularyRepository>(
    () => DriftVocabularyRepository(getIt<AdminDatabase>()),
  );
  getIt.registerLazySingleton<KanjiComponentRepository>(
    () => DriftKanjiComponentRepository(getIt<AdminDatabase>()),
  );

  // -- Supabase datasources --
  getIt.registerLazySingleton<SupabaseDataImportDataSource>(
    () => SupabaseDataImportDataSource(Supabase.instance.client),
  );
  getIt.registerLazySingleton<SupabaseKanjiComponentReviewDataSource>(
    () => SupabaseKanjiComponentReviewDataSource(Supabase.instance.client),
  );

  // -- Services --
  final appSupportDir = await getApplicationSupportDirectory();
  getIt.registerLazySingleton<SvgCache>(
    () => FileSvgCache(Directory(p.join(appSupportDir.path, 'svg_cache'))),
  );
  getIt.registerLazySingleton<RadicalScanner>(
    () => RadicalScanner(),
  );
  getIt.registerLazySingleton<SourceParser>(
    () => SourceParserImpl(),
  );
  getIt.registerLazySingleton<CsvService>(
    () => CsvService(),
  );
  getIt.registerLazySingleton<AdminStateReader>(
    () => SupabaseAdminStateReader(
      imports: getIt<SupabaseDataImportDataSource>(),
      reviews: getIt<SupabaseKanjiComponentReviewDataSource>(),
    ),
  );
  getIt.registerLazySingleton<AdminStateWriter>(
    () => DriftAdminStateWriter(
      imports: getIt<DataImportRepository>(),
      reviews: getIt<KanjiComponentReviewRepository>(),
    ),
  );

  // -- Use cases --
  getIt.registerLazySingleton<IngestSourceData>(
    () => IngestSourceData(
      importRepository: getIt<DataImportRepository>(),
      kanjiVgRepository: getIt<RawKanjiVgRepository>(),
      kanjidicRepository: getIt<RawKanjidicRepository>(),
      jmdictRepository: getIt<RawJmdictRepository>(),
      jmdictFuriganaRepository: getIt<JmdictFuriganaRepository>(),
      sourceParser: getIt<SourceParser>(),
    ),
  );
  getIt.registerLazySingleton<ClearImport>(
    () => ClearImport(
      importRepository: getIt<DataImportRepository>(),
      kanjiVgRepository: getIt<RawKanjiVgRepository>(),
      kanjidicRepository: getIt<RawKanjidicRepository>(),
      jmdictRepository: getIt<RawJmdictRepository>(),
      jmdictFuriganaRepository: getIt<JmdictFuriganaRepository>(),
      svgCache: getIt<SvgCache>(),
      supabaseDataImportDataSource: getIt<SupabaseDataImportDataSource>(),
    ),
  );
  getIt.registerLazySingleton<ExtractRadicals>(
    () => ExtractRadicals(
      rawKanjiVgRepository: getIt<RawKanjiVgRepository>(),
      radicalRepository: getIt<RadicalRepository>(),
      scanner: getIt<RadicalScanner>(),
    ),
  );
  getIt.registerLazySingleton<ComposeKanji>(
    () => ComposeKanji(
      rawKanjidicRepository: getIt<RawKanjidicRepository>(),
      kanjiRepository: getIt<KanjiRepository>(),
      sourceJlptLevelRepository: getIt<SourceJlptLevelRepository>(),
    ),
  );
  getIt.registerLazySingleton<ProcessSvgs>(
    () => ProcessSvgs(
      radicalRepository: getIt<RadicalRepository>(),
      kanjiRepository: getIt<KanjiRepository>(),
      svgCache: getIt<SvgCache>(),
      supabaseUrl: _supabaseUrl,
    ),
  );
  getIt.registerLazySingleton<ExtractVocabulary>(
    () => ExtractVocabulary(
      rawJmdictRepository: getIt<RawJmdictRepository>(),
      kanjiRepository: getIt<KanjiRepository>(),
      sourceVocabLevelRepository: getIt<SourceVocabLevelRepository>(),
      jmdictFuriganaRepository: getIt<JmdictFuriganaRepository>(),
      vocabularyRepository: getIt<VocabularyRepository>(),
    ),
  );
  getIt.registerLazySingleton<LinkComponents>(
    () => LinkComponents(
      rawKanjiVgRepository: getIt<RawKanjiVgRepository>(),
      kanjiComponentRepository: getIt<KanjiComponentRepository>(),
      radicalRepository: getIt<RadicalRepository>(),
      kanjiRepository: getIt<KanjiRepository>(),
    ),
  );
  getIt.registerLazySingleton<EstimateLogicHints>(
    () => EstimateLogicHints(
      kanjiComponentRepository: getIt<KanjiComponentRepository>(),
      rawKanjidicRepository: getIt<RawKanjidicRepository>(),
      reviewRepository: getIt<KanjiComponentReviewRepository>(),
      radicalRepository: getIt<RadicalRepository>(),
    ),
  );
  getIt.registerLazySingleton<ExportRadicalMnemonics>(
    () => ExportRadicalMnemonics(
      radicalRepository: getIt<RadicalRepository>(),
      rawKanjidicRepository: getIt<RawKanjidicRepository>(),
      csvService: getIt<CsvService>(),
    ),
  );
  getIt.registerLazySingleton<ImportRadicalMnemonics>(
    () => ImportRadicalMnemonics(
      radicalRepository: getIt<RadicalRepository>(),
      csvService: getIt<CsvService>(),
    ),
  );
  getIt.registerLazySingleton<HydrateLocalDb>(
    () => HydrateLocalDb(
      reader: getIt<AdminStateReader>(),
      writer: getIt<AdminStateWriter>(),
    ),
  );

  // -- BLoCs (factory = new instance each time) --
  getIt.registerFactory<DataImportBloc>(
    () => DataImportBloc(
      importRepository: getIt<DataImportRepository>(),
      ingestSourceData: getIt<IngestSourceData>(),
      clearImport: getIt<ClearImport>(),
    ),
  );
  getIt.registerFactory<HydrationBloc>(
    () => HydrationBloc(hydrateLocalDb: getIt<HydrateLocalDb>()),
  );
  getIt.registerFactory<ExtractionBloc>(
    () => ExtractionBloc(
      extractRadicals: getIt<ExtractRadicals>(),
      composeKanji: getIt<ComposeKanji>(),
      processSvgs: getIt<ProcessSvgs>(),
      extractVocabulary: getIt<ExtractVocabulary>(),
      linkComponents: getIt<LinkComponents>(),
      estimateLogicHints: getIt<EstimateLogicHints>(),
    ),
  );
  getIt.registerFactory<EnrichmentBloc>(
    () => EnrichmentBloc(
      exportRadicalMnemonics: getIt<ExportRadicalMnemonics>(),
      importRadicalMnemonics: getIt<ImportRadicalMnemonics>(),
    ),
  );
}
