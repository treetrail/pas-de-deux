import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:pasdedeux/data/repositories/ad_free_repository.dart';
import 'package:pasdedeux/data/services/purchase_service.dart';

import '../fakes.dart';

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

  test('shows the store as unavailable if the product fails to load', () async {
    final offline = PurchaseService(
      repository: AdFreeRepository(MemoryStore()),
      store: FakeStore()..offline = true,
    );
    await offline.start();
    await pumpEventQueue();

    expect(offline.state, StoreState.unavailable);
    expect(offline.price, isNull);
  });

  test('shows a failed restore', () async {
    store.offline = true;
    await service.restore();

    expect(service.state, StoreState.failed);
  });
}
