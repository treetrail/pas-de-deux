import '../data/repositories/game_repository.dart';
import '../data/services/ads_service.dart';
import '../data/services/purchase_service.dart';
import '../domain/catalog.dart';
import '../ui/settings/settings_view_model.dart';

/// Everything `main.dart` creates once and hands down by constructor.
class Dependencies {
  const Dependencies({
    required this.catalog,
    required this.settings,
    required this.games,
    required this.ads,
    required this.purchases,
  });

  final Catalog catalog;
  final SettingsViewModel settings;
  final GameRepository games;
  final AdsService ads;
  final PurchaseService purchases;
}
