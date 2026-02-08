import 'package:get_it/get_it.dart';

import '../data/local/admin_database.dart';
import '../data/repositories/drift_data_import_repository.dart';
import '../data/repositories/drift_raw_jmdict_repository.dart';
import '../data/repositories/drift_raw_kanjidic_repository.dart';
import '../data/repositories/drift_raw_kanjivg_repository.dart';
import '../data/services/ingestion_service.dart';
import '../domain/repositories/data_import_repository.dart';
import '../domain/repositories/raw_jmdict_repository.dart';
import '../domain/repositories/raw_kanjidic_repository.dart';
import '../domain/repositories/raw_kanjivg_repository.dart';
import '../presentation/bloc/data_import_bloc.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Singletons
  getIt.registerLazySingleton<AdminDatabase>(() => AdminDatabase());
  getIt.registerLazySingleton<DataImportRepository>(
    () => DriftDataImportRepository(getIt<AdminDatabase>()),
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
  getIt.registerLazySingleton<IngestionService>(
    () => IngestionService(
      importRepository: getIt<DataImportRepository>(),
      kanjiVgRepository: getIt<RawKanjiVgRepository>(),
      kanjidicRepository: getIt<RawKanjidicRepository>(),
      jmdictRepository: getIt<RawJmdictRepository>(),
    ),
  );

  // Factories (new instance each time)
  getIt.registerFactory<DataImportBloc>(
    () => DataImportBloc(
      importRepository: getIt<DataImportRepository>(),
      ingestionService: getIt<IngestionService>(),
    ),
  );
}
