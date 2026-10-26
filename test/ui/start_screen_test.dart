import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pasdedeux/domain/settings.dart';

import 'pump_app.dart';

void main() {
  testWidgets('shows the introduction first, then asks for consent', (
    tester,
  ) async {
    final app = await pumpApp(tester);
    expect(find.text('Zwei Menschen, 36 Fragen'), findsOneWidget);
    expect(find.textContaining('Aron et al. (1997)'), findsOneWidget);
    expect(app.ads.started, isFalse);

    await tester.tap(find.text('Überspringen'));
    await tester.pumpAndSettle();
    expect(find.text('Neue Partie'), findsOneWidget);
    expect(app.settings.settings.introSeen, isTrue);
    expect(app.ads.started, isTrue);
  });

  testWidgets('leads through three pages', (tester) async {
    final app = await pumpApp(tester);
    await tester.tap(find.text('Weiter'));
    await tester.pumpAndSettle();
    expect(find.text('So läuft ein Zug'), findsOneWidget);
    await tester.tap(find.text('Weiter'));
    await tester.pumpAndSettle();
    expect(find.text('Nehmt euch Zeit'), findsOneWidget);

    await tester.tap(find.text("Los geht's"));
    await tester.pumpAndSettle();
    expect(find.text('Neue Partie'), findsOneWidget);
    expect(app.settings.settings.introSeen, isTrue);
  });

  testWidgets('skips the introduction once it was seen', (tester) async {
    final app = await pumpApp(
      tester,
      settings: const Settings(appLanguage: 'de', introSeen: true),
    );
    expect(find.text('Neue Partie'), findsOneWidget);
    expect(find.text('Zwei Menschen, 36 Fragen'), findsNothing);
    expect(app.ads.started, isTrue);
  });

  testWidgets('fits the introduction at double font size', (tester) async {
    tester.view.physicalSize = const Size(360, 640) * 3;
    tester.view.devicePixelRatio = 3;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await pumpApp(tester);
    for (var page = 0; page < 3; page++) {
      expect(tester.takeException(), isNull, reason: 'page ${page + 1}');
      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();
    }
  });
}
