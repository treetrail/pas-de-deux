import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const _seed = Color(0xFF8C3B5E);

  static final light = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: _seed),
  );

  static final dark = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
    ),
  );

  /// The four-minute look is calm and dark, whatever the system mode (US-14).
  static final look = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
      surface: Colors.black,
    ),
  );
}
