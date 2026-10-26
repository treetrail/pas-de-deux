import 'package:flutter/material.dart';

import '../domain/catalog.dart';
import '../l10n/app_localizations.dart';
import '../ui/start/start_screen.dart';
import 'dependencies.dart';

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
}

class PasDeDeuxApp extends StatelessWidget {
  const PasDeDeuxApp({super.key, required this.dependencies});

  final Dependencies dependencies;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: dependencies.settings,
    builder: (context, _) => MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      // Language changes apply at once, without a restart (US-01).
      locale: dependencies.settings.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      localeListResolutionCallback: _deviceLanguageOrEnglish,
      home: StartScreen(dependencies: dependencies),
    ),
  );

  static Locale _deviceLanguageOrEnglish(
    List<Locale>? deviceLocales,
    Iterable<Locale> supported,
  ) {
    for (final locale in deviceLocales ?? const <Locale>[]) {
      if (supportedLanguages.contains(locale.languageCode)) {
        return Locale(locale.languageCode);
      }
    }
    return const Locale('en');
  }
}
