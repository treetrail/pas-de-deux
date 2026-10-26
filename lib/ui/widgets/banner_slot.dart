import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../data/services/ads_service.dart';
import '../../data/services/purchase_service.dart';

/// Adaptive anchored banner at the bottom of the start screen (US-16).
/// It takes up space only once an ad has loaded.
class BannerSlot extends StatefulWidget {
  const BannerSlot({super.key, required this.ads, required this.purchases});

  final AdsService ads;
  final PurchaseService purchases;

  @override
  State<BannerSlot> createState() => _BannerSlotState();
}

class _BannerSlotState extends State<BannerSlot> {
  late final _listenable = Listenable.merge([widget.ads, widget.purchases]);
  BannerAd? _banner;
  bool _loaded = false;

  bool get _wanted => widget.ads.canShowAds && !widget.purchases.adFree;

  @override
  void initState() {
    super.initState();
    _listenable.addListener(_update);
    WidgetsBinding.instance.addPostFrameCallback((_) => _update());
  }

  @override
  void dispose() {
    _listenable.removeListener(_update);
    _banner?.dispose();
    super.dispose();
  }

  void _update() {
    if (!mounted) return;
    if (!_wanted) {
      _banner?.dispose();
      setState(() {
        _banner = null;
        _loaded = false;
      });
    } else if (_banner == null) {
      _load();
    }
  }

  Future<void> _load() async {
    final width = MediaQuery.sizeOf(context).width.truncate();
    final size = await AdSize.getLargeAnchoredAdaptiveBannerAdSize(width);
    if (size == null || !mounted || _banner != null) return;
    _banner = BannerAd(
      size: size,
      adUnitId: AdUnits.banner,
      request: AdsService.request,
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => _loaded = true),
        onAdFailedToLoad: (ad, error) {
          debugPrint('Banner: $error');
          ad.dispose();
          _banner = null;
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    final banner = _banner;
    if (banner == null || !_loaded || !_wanted) return const SizedBox.shrink();
    return SafeArea(
      child: SizedBox(
        width: banner.size.width.toDouble(),
        height: banner.size.height.toDouble(),
        child: AdWidget(ad: banner),
      ),
    );
  }
}
