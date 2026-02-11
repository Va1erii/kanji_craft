import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kanji_craft_core/design_system/theme/app_theme.dart';

import 'app_router.dart';
import 'data/services/jlpt_mapping_parser.dart';
import 'di/injection.dart';
import 'domain/repositories/source_jlpt_level_repository.dart';
import 'presentation/data_import/bloc/data_import_bloc.dart';
import 'presentation/hydration/bloc/hydration_bloc.dart';
import 'presentation/hydration/bloc/hydration_event.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await _loadJlptMappingIfNeeded();
  runApp(const KanjiCraftAdmin());
}

Future<void> _loadJlptMappingIfNeeded() async {
  final repo = getIt<SourceJlptLevelRepository>();
  final count = await repo.count();
  if (count > 0) return;

  final csv = await rootBundle.loadString('assets/jlpt_mapping.csv');
  final levels = JlptMappingParser.parse(csv);
  await repo.replaceAll(levels);
}

class KanjiCraftAdmin extends StatelessWidget {
  const KanjiCraftAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              getIt<HydrationBloc>()..add(const HydrationEvent.started()),
        ),
        BlocProvider(
          create: (_) => getIt<DataImportBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Kanji Craft Admin',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        routerConfig: appRouter,
      ),
    );
  }
}
