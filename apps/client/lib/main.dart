import 'package:flutter/material.dart';

import 'di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const KanjiCraftClient());
}

class KanjiCraftClient extends StatelessWidget {
  const KanjiCraftClient({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kanji Craft',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF6750A4),
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: const Color(0xFF6750A4),
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Kanji Craft'),
        ),
      ),
    );
  }
}
