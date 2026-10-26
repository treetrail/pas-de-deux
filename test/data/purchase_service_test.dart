import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:pasdedeux/data/repositories/ad_free_repository.dart';
import 'package:pasdedeux/data/services/purchase_service.dart';

import '../fakes.dart';

class FakeStore extends Fake implements InAppPurchase {
  final updates = StreamController<List<PurchaseDetails>>.broadcast();
  bool failToComplete = false;
  int completed = 0;

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => updates.stream;

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<ProductDetailsResponse> queryProductDetails(Set<String> ids) async =>
      ProductDetailsResponse(
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

PurchaseDetails purchase(PurchaseStatus status) => PurchaseDetails(
  purchaseID: '1',
  productID: PurchaseService.productId,
  verificationData: PurchaseVerificationData(
    localVerificationData: '',
    serverVerificationData: '',
    source: 'test',
  ),
  transactionDate: null,
  status: status,
)..pendingCompletePurchase = status != PurchaseStatus.pending;

void main() {
  late MemoryStore values;
  late FakeStore store;
  late PurchaseService service;

  setUp(() async {
    values = MemoryStore();
    store = FakeStore();
    service = PurchaseService(
      repository: AdFreeRepository(values),
      store: store,
    );
    await service.start();
    await pumpEventQueue();
  });

  test('loads the localized price', () {
    expect(service.state, StoreState.ready);
    expect(service.price, '1,99 €');
  });

  test('turns ad-free, saves it and completes the purchase', () async {
    var notified = 0;
    service.addListener(() => notified++);
    store.updates.add([purchase(PurchaseStatus.purchased)]);
    await pumpEventQueue();

    expect(service.adFree, isTrue);
    expect(notified, greaterThan(0));
    expect(await AdFreeRepository(values).load(), isTrue);
    expect(store.completed, 1);
  });

  test('turns ad-free even if completing the purchase fails', () async {
    store.failToComplete = true;
    var notified = 0;
    service.addListener(() => notified++);
    store.updates.add([purchase(PurchaseStatus.restored)]);
    await pumpEventQueue();

    expect(service.adFree, isTrue);
    expect(notified, greaterThan(0));
  });

  test('shows a pending purchase and keeps the ads', () async {
    store.updates.add([purchase(PurchaseStatus.pending)]);
    await pumpEventQueue();

    expect(service.state, StoreState.pending);
    expect(service.adFree, isFalse);
    expect(store.completed, 0);
  });
}
