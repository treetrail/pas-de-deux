import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pasdedeux/data/repositories/game_repository.dart';
import 'package:pasdedeux/domain/settings.dart';

import '../fakes.dart';
import '../helpers.dart';
import 'pump_app.dart';

const owner = Settings(appLanguage: 'de', ownName: 'Lena', introSeen: true);

/// A device that has played before and bought "Werbefrei".
Future<MemoryStore> usedStore() async {
  final store = MemoryStore();
  await store.write('weights', '{"s1-q01":1.2}');
  await store.write('lastGame', '["s1-q01"]');
  await store.write('adFree', 'true');
  return store;
}

Future<void> openSettings(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Einstellungen'));
  await tester.pumpAndSettle();
}

Future<void> tapEntry(WidgetTester tester, String text) async {
  await tester.scrollUntilVisible(
    find.text(text),
    200,
    scrollable: find.descendant(
      of: find.byType(ListView),
      matching: find.byType(Scrollable),
    ),
  );
  await tester.tap(find.text(text));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    '"Gewichte zurücksetzen" deletes only the weights, after asking',
    (tester) async {
      final store = await usedStore();
      await pumpApp(tester, settings: owner, store: store);
      await openSettings(tester);

      await tapEntry(tester, 'Gewichte zurücksetzen');
      await tester.tap(find.text('Abbrechen'));
      await tester.pumpAndSettle();
      expect(store.values, contains('weights'));

      await tapEntry(tester, 'Gewichte zurücksetzen');
      await tester.tap(find.text('Zurücksetzen'));
      await tester.pumpAndSettle();
      expect(find.text('Die Gewichte sind zurückgesetzt.'), findsOneWidget);
      expect(store.values.keys, unorderedEquals(['lastGame', 'adFree']));
      expect(await GameRepository(store).loadWeights(), isEmpty);
    },
  );

  testWidgets('"Alle Daten zurücksetzen" deletes everything but the purchase', (
    tester,
  ) async {
    final store = await usedStore();
    await GameRepository(store).saveGame(startGame());
    final app = await pumpApp(tester, settings: owner, store: store);

    // The app goes straight into the interrupted game; back on its first
    // question leads to the start.
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Partie fortsetzen'), findsOneWidget);
    await openSettings(tester);

    await tapEntry(tester, 'Alle Daten zurücksetzen');
    await tester.tap(find.text('Zurücksetzen'));
    await tester.pumpAndSettle();
    expect(store.values.keys, unorderedEquals(['settings', 'adFree']));
    expect(app.settings.settings.toJson(), const Settings().toJson());
    // The app follows the device language again, the message too.
    expect(find.text('All data has been deleted.'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('New game'), findsOneWidget);
    expect(find.text('Resume game'), findsNothing);
  });
}
