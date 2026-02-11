import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/datasources/supabase_data_import_datasource.dart';
import '../data/datasources/supabase_kanji_component_review_datasource.dart';
import '../data/local/admin_database.dart';
import '../data/repositories/drift_data_import_repository.dart';
import '../data/repositories/drift_kanji_component_review_repository.dart';
import '../data/repositories/drift_raw_jmdict_repository.dart';
import '../data/repositories/drift_raw_kanjidic_repository.dart';
import '../data/repositories/drift_raw_kanjivg_repository.dart';
import '../data/repositories/drift_source_jlpt_level_repository.dart';
import '../data/services/drift_admin_state_writer.dart';
import '../data/services/source_parser_impl.dart';
import '../data/services/supabase_admin_state_reader.dart';
import '../domain/repositories/data_import_repository.dart';
import '../domain/repositories/kanji_component_review_repository.dart';
import '../domain/repositories/raw_jmdict_repository.dart';
import '../domain/repositories/raw_kanjidic_repository.dart';
import '../domain/repositories/raw_kanjivg_repository.dart';
import '../domain/repositories/source_jlpt_level_repository.dart';
import '../domain/services/admin_state_reader.dart';
import '../domain/services/admin_state_writer.dart';
import '../domain/services/source_parser.dart';
import '../domain/usecases/hydrate_local_db.dart';
import '../domain/usecases/ingest_source_data.dart';
import '../presentation/bloc/data_import_bloc.dart';
import '../presentation/bloc/hydration_bloc.dart';

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

  // -- Supabase datasources --
  getIt.registerLazySingleton<SupabaseDataImportDataSource>(
    () => SupabaseDataImportDataSource(Supabase.instance.client),
  );
  getIt.registerLazySingleton<SupabaseKanjiComponentReviewDataSource>(
    () => SupabaseKanjiComponentReviewDataSource(Supabase.instance.client),
  );

  // -- Services --
  getIt.registerLazySingleton<SourceParser>(
    () => SourceParserImpl(),
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
      sourceParser: getIt<SourceParser>(),
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
    ),
  );
  getIt.registerFactory<HydrationBloc>(
    () => HydrationBloc(hydrateLocalDb: getIt<HydrateLocalDb>()),
  );
}
