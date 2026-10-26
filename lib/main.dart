import 'package:flutter/widgets.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'app/app.dart';
import 'app/dependencies.dart';
import 'data/repositories/ad_free_repository.dart';
import 'data/repositories/catalog_repository.dart';
import 'data/repositories/game_repository.dart';
import 'data/repositories/key_value_store.dart';
import 'data/repositories/settings_repository.dart';
import 'data/services/ads_service.dart';
import 'data/services/device_service.dart';
import 'data/services/purchase_service.dart';
import 'ui/settings/settings_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = PreferencesStore();

  // Listen to the purchase stream before the UI exists (US-17).
  final purchases = PurchaseService(
    repository: AdFreeRepository(store),
    store: InAppPurchase.instance,
  );
  await purchases.start();

  final settingsRepository = SettingsRepository(store);
  final dependencies = Dependencies(
    catalog: await CatalogRepository().load(),
    settings: SettingsViewModel(
      repository: settingsRepository,
      settings: await settingsRepository.load(),
    ),
    games: GameRepository(store),
    ads: AdsService(),
    purchases: purchases,
    device: DeviceService(),
  );

  void disableAdsOnceAdFree() {
    if (purchases.adFree) dependencies.ads.disable();
  }

  disableAdsOnceAdFree();
  purchases.addListener(disableAdsOnceAdFree);

  // The start screen asks for consent, after the introduction on the first
  // start.
  runApp(PasDeDeuxApp(dependencies: dependencies));
}
