import 'package:flutter_test/flutter_test.dart';
import 'package:pasdedeux/app/app.dart';
import 'package:pasdedeux/app/dependencies.dart';
import 'package:pasdedeux/data/repositories/ad_free_repository.dart';
import 'package:pasdedeux/data/repositories/game_repository.dart';
import 'package:pasdedeux/data/repositories/settings_repository.dart';
import 'package:pasdedeux/data/services/purchase_service.dart';
import 'package:pasdedeux/domain/settings.dart';
import 'package:pasdedeux/ui/settings/settings_view_model.dart';

import '../fakes.dart';
import '../helpers.dart';

/// Starts the whole app with fakes instead of plugins.
Future<({SettingsViewModel settings, FakeAds ads})> pumpApp(
  WidgetTester tester, {
  Settings settings = const Settings(appLanguage: 'de'),
  MemoryStore? store,
}) async {
  store ??= MemoryStore();
  final settingsViewModel = SettingsViewModel(
    repository: SettingsRepository(store),
    settings: settings,
  );
  final ads = FakeAds();
  await tester.pumpWidget(
    PasDeDeuxApp(
      dependencies: Dependencies(
        catalog: loadCatalog(),
        settings: settingsViewModel,
        games: GameRepository(store),
        ads: ads,
        purchases: PurchaseService(
          repository: AdFreeRepository(store),
          store: FakeStore(),
        ),
        device: FakeDevice(),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return (settings: settingsViewModel, ads: ads);
}
