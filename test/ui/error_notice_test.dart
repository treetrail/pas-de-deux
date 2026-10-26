import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pasdedeux/domain/settings.dart';
import 'package:pasdedeux/l10n/app_localizations.dart';
import 'package:pasdedeux/ui/widgets/error_notice.dart';

import 'pump_app.dart';

void main() {
  testWidgets('leads from a broken screen back to the start', (tester) async {
    // What handleErrors() sets up in release builds.
    final errorWidget = ErrorWidget.builder;
    ErrorWidget.builder = (_) => const ErrorNotice();
    try {
      await pumpApp(
        tester,
        settings: const Settings(appLanguage: 'de', introSeen: true),
      );
      tester
          .state<NavigatorState>(find.byType(Navigator))
          .push(
            MaterialPageRoute<void>(builder: (_) => throw StateError('broken')),
          );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isStateError);
      expect(find.text('Hier ist etwas schiefgegangen.'), findsOneWidget);

      await tester.tap(find.text('Zum Start'));
      await tester.pumpAndSettle();
      expect(find.text('Neue Partie'), findsOneWidget);
    } finally {
      ErrorWidget.builder = errorWidget;
    }
  });

  testWidgets('asks for a restart when the start itself is broken', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('de'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: const ErrorNotice(),
      ),
    );
    expect(
      find.text('Bitte schließe die App und öffne sie neu.'),
      findsOneWidget,
    );
    expect(find.text('Zum Start'), findsNothing);
  });

  testWidgets('works above the MaterialApp, in English', (tester) async {
    await tester.pumpWidget(const ErrorNotice());
    expect(find.text('Something went wrong here.'), findsOneWidget);
  });
}
