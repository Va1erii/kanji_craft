import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kanji_craft_core/design_system/theme/app_theme.dart';

import 'app_router.dart';
import 'di/injection.dart';
import 'presentation/bloc/data_import_bloc.dart';
import 'presentation/bloc/data_import_event.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const KanjiCraftAdmin());
}

class KanjiCraftAdmin extends StatelessWidget {
  const KanjiCraftAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DataImportBloc>()
        ..add(const DataImportEvent.load()),
      child: MaterialApp.router(
        title: 'Kanji Craft Admin',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        routerConfig: appRouter,
      ),
    );
  }
}
