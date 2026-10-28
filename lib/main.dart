import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'app/app.dart';
import 'app/dependencies.dart';
import 'app/error_handling.dart';
import 'app/features.dart';
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
  handleErrors();
  LicenseRegistry.addLicense(_fontLicenses);
  final store = PreferencesStore();

  // Listen to the purchase stream before the UI exists (US-17).
  final purchases = PurchaseService(
    repository: AdFreeRepository(store),
    store: InAppPurchase.instance,
  );
  if (storeFeatures) await purchases.start();

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
    if (!storeFeatures || purchases.adFree) dependencies.ads.disable();
  }

  disableAdsOnceAdFree();
  purchases.addListener(disableAdsOnceAdFree);

  // The start screen asks for consent, after the introduction on the first
  // start.
  runApp(PasDeDeuxApp(dependencies: dependencies));
}

/// The bundled fonts are under the SIL Open Font License, which asks for the
/// license to travel with them.
Stream<LicenseEntry> _fontLicenses() async* {
  for (final font in ['Fraunces', 'Figtree']) {
    final text = await rootBundle.loadString('assets/fonts/$font-OFL.txt');
    yield LicenseEntryWithLineBreaks([font], text);
  }
}
