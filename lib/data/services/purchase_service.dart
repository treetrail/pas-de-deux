import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../repositories/ad_free_repository.dart';

enum StoreState { loading, ready, unavailable, pending, failed }

/// The one-time purchase "Werbefrei" (US-17).
class PurchaseService extends ChangeNotifier {
  PurchaseService({required this._repository, required this._store});

  static const productId = 'ad_free';

  final AdFreeRepository _repository;
  final InAppPurchase _store;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  ProductDetails? _product;
  bool _adFree = false;
  StoreState _state = StoreState.loading;

  bool get adFree => _adFree;

  StoreState get state => _state;

  /// Localized price from the store, null until the product is loaded.
  String? get price => _product?.price;

  /// Runs before the first frame. Purchases that did not finish last time
  /// arrive on the stream right away and would otherwise be lost.
  Future<void> start() async {
    _adFree = await _repository.load();
    _subscription = _store.purchaseStream.listen(
      _onPurchases,
      onError: (Object error) => _setState(StoreState.failed),
    );
    unawaited(_loadProduct());
  }

  Future<void> buy() async {
    final product = _product;
    if (product == null) return;
    try {
      await _store.buyNonConsumable(
        purchaseParam: PurchaseParam(productDetails: product),
      );
    } catch (error) {
      debugPrint('Purchase: $error');
      _setState(StoreState.failed);
    }
  }

  /// "Käufe wiederherstellen" in the settings, as Apple requires.
  Future<void> restore() async {
    try {
      await _store.restorePurchases();
    } catch (error) {
      debugPrint('Restore: $error');
      _setState(StoreState.failed);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _loadProduct() async {
    try {
      if (await _store.isAvailable()) {
        final response = await _store.queryProductDetails({productId});
        _product = response.productDetails
            .where((product) => product.id == productId)
            .firstOrNull;
      }
    } catch (error) {
      // Otherwise "Werbefrei" would stay in "loading" for good.
      debugPrint('Load product: $error');
    }
    _setState(_product == null ? StoreState.unavailable : StoreState.ready);
    // On Android, restore quietly after a reinstall. On iOS only on request,
    // because Apple may ask the user to sign in.
    if (_product != null && !_adFree && Platform.isAndroid) {
      await _store.restorePurchases();
    }
  }

  Future<void> _onPurchases(List<PurchaseDetails> purchases) async {
    final ours = [
      for (final purchase in purchases)
        if (purchase.productID == productId) purchase,
    ];
    for (final purchase in ours) {
      switch (purchase.status) {
        case PurchaseStatus.pending:
          _state = StoreState.pending;
        case PurchaseStatus.purchased || PurchaseStatus.restored:
          _adFree = true;
          _state = StoreState.ready;
        case PurchaseStatus.error:
          _state = StoreState.failed;
        case PurchaseStatus.canceled:
          _state = StoreState.ready;
      }
    }
    // The app reacts first: banner gone, no more consent dialog.
    notifyListeners();
    if (_adFree) await _repository.save();
    for (final purchase in ours) {
      // Without this, Google Play refunds the purchase after three days.
      if (!purchase.pendingCompletePurchase) continue;
      try {
        await _store.completePurchase(purchase);
      } catch (error) {
        // in_app_purchase_storekit 0.4.15 cannot finish a transaction with
        // ID 0, which the first test purchase in Xcode gets. StoreKit then
        // delivers it again at the next start.
        debugPrint('Complete purchase: $error');
      }
    }
  }

  void _setState(StoreState state) {
    _state = state;
    notifyListeners();
  }
}
