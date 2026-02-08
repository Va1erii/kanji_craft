import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const _seed = Color(0xFF6750A4);

  static final light = ThemeData(
    colorSchemeSeed: _seed,
    brightness: Brightness.light,
    useMaterial3: true,
    visualDensity: VisualDensity.compact,
  );

  static final dark = ThemeData(
    colorSchemeSeed: _seed,
    brightness: Brightness.dark,
    useMaterial3: true,
    visualDensity: VisualDensity.compact,
  );
}
