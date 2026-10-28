import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:pasdedeux/data/repositories/key_value_store.dart';
import 'package:pasdedeux/data/services/ads_service.dart';
import 'package:pasdedeux/data/services/device_service.dart';
import 'package:pasdedeux/data/services/purchase_service.dart';

/// Keeps the values in memory instead of on the device.
class MemoryStore implements KeyValueStore {
  final values = <String, String>{};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;

  @override
  Future<void> delete(String key) async => values.remove(key);
}

/// Counts instead of keeping the screen on, ringing and vibrating.
class FakeDevice implements DeviceService {
  int awake = 0;
  final rings = <bool>[];

  @override
  void stayAwake() => awake++;

  @override
  void allowSleep() => awake--;

  @override
  void prepareSound() {}

  @override
  Future<void> ring({required bool sound}) async => rings.add(sound);
}

/// Never talks to the ads SDK.
class FakeAds extends AdsService {
  bool started = false;

  @override
  Future<void> start() async => started = true;
}

class FakeStore extends Fake implements InAppPurchase {
  final updates = StreamController<List<PurchaseDetails>>.broadcast();
  bool failToComplete = false;
  bool offline = false;
  int completed = 0;

  @override
  Future<void> restorePurchases({String? applicationUserName}) async {
    if (offline) throw StateError('offline');
  }

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => updates.stream;

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<ProductDetailsResponse> queryProductDetails(Set<String> ids) async =>
      offline
      ? throw StateError('offline')
      : ProductDetailsResponse(
          productDetails: [
            ProductDetails(
              id: PurchaseService.productId,
              title: 'Werbefrei',
              description: '',
              price: '1,99 €',
              rawPrice: 1.99,
              currencyCode: 'EUR',
            ),
          ],
          notFoundIDs: const [],
        );

  @override
  Future<void> completePurchase(PurchaseDetails purchase) async {
    completed++;
    if (failToComplete) throw StateError('no transaction ID');
  }
}

/// A stopwatch whose time the test sets.
class FakeStopwatch extends Fake implements Stopwatch {
  @override
  Duration elapsed = Duration.zero;

  @override
  bool isRunning = false;

  @override
  void start() => isRunning = true;

  @override
  void stop() => isRunning = false;
}
