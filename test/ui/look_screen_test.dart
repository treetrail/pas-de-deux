import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pasdedeux/l10n/app_localizations.dart';
import 'package:pasdedeux/ui/look/look_screen.dart';

import '../fakes.dart';

Future<FakeDevice> pumpLook(
  WidgetTester tester,
  FakeStopwatch stopwatch, {
  bool sound = true,
}) async {
  final device = FakeDevice();
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('de'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: LookScreen(device: device, sound: sound, stopwatch: stopwatch),
    ),
  );
  return device;
}

void main() {
  testWidgets('shows only the remaining time and keeps the screen on', (
    tester,
  ) async {
    final stopwatch = FakeStopwatch();
    final device = await pumpLook(tester, stopwatch);
    expect(stopwatch.isRunning, isTrue);
    expect(find.text('4:00'), findsOneWidget);
    expect(device.awake, 1);

    stopwatch.elapsed = const Duration(minutes: 1, seconds: 30);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('2:30'), findsOneWidget);
  });

  testWidgets('rings with sound and vibration after four minutes', (
    tester,
  ) async {
    final stopwatch = FakeStopwatch();
    final device = await pumpLook(tester, stopwatch);

    stopwatch.elapsed = const Duration(minutes: 4);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Die vier Minuten sind um.'), findsOneWidget);
    expect(device.rings, [true]);
    expect(device.awake, 0);
  });

  testWidgets('only vibrates when the sound is off', (tester) async {
    final stopwatch = FakeStopwatch();
    final device = await pumpLook(tester, stopwatch, sound: false);

    stopwatch.elapsed = const Duration(minutes: 4);
    await tester.pump(const Duration(seconds: 1));
    expect(device.rings, [false]);
  });

  testWidgets('ends silently when the time runs out in the background', (
    tester,
  ) async {
    final stopwatch = FakeStopwatch();
    final device = await pumpLook(tester, stopwatch);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    stopwatch.elapsed = const Duration(minutes: 5);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Die vier Minuten sind um.'), findsNothing);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    expect(find.text('Die vier Minuten sind um.'), findsOneWidget);
    expect(device.rings, isEmpty);
  });
}
