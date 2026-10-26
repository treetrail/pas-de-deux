import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Ad unit IDs. Debug builds always use Google's test IDs, release builds
/// get the real ones via `--dart-define-from-file=config/prod.json`.
abstract final class AdUnits {
  static String get banner => kReleaseMode
      ? (Platform.isIOS
            ? const String.fromEnvironment('ADMOB_BANNER_IOS')
            : const String.fromEnvironment('ADMOB_BANNER_ANDROID'))
      : (Platform.isIOS
            ? 'ca-app-pub-3940256099942544/2435281174'
            : 'ca-app-pub-3940256099942544/9214589741');

  static String get interstitial => kReleaseMode
      ? (Platform.isIOS
            ? const String.fromEnvironment('ADMOB_INTERSTITIAL_IOS')
            : const String.fromEnvironment('ADMOB_INTERSTITIAL_ANDROID'))
      : (Platform.isIOS
            ? 'ca-app-pub-3940256099942544/4411468910'
            : 'ca-app-pub-3940256099942544/1033173712');
}

/// Consent, banner and interstitial (US-16, US-18).
///
/// Everything here may fail quietly: without network or consent the game
/// runs unchanged, and the next attempt comes with the next app start.
class AdsService extends ChangeNotifier {
  static const request = AdRequest(nonPersonalizedAds: true);

  /// Hashed IDs of real test devices, comma-separated, for the consent
  /// dialog in debug builds. The SDK logs the ID of each new device.
  static const _testDevices = String.fromEnvironment('CONSENT_TEST_DEVICES');

  bool _canRequestAds = false;
  bool _privacyOptionsRequired = false;
  bool _sdkStarted = false;
  bool _disabled = false;
  InterstitialAd? _interstitial;

  bool get canShowAds => _canRequestAds && !_disabled;

  bool get privacyOptionsRequired => _privacyOptionsRequired && !_disabled;

  /// Shows the consent dialog if needed, then starts the SDK.
  Future<void> start() async {
    if (_disabled) return;
    final updated = Completer<void>();
    ConsentInformation.instance.requestConsentInfoUpdate(
      _consentParameters(),
      () async {
        await ConsentForm.loadAndShowConsentFormIfRequired(_logFormError);
        updated.complete();
      },
      (error) {
        _logFormError(error);
        updated.complete();
      },
    );
    await updated.future;
    await _refresh();
  }

  /// "Datenschutz-Optionen" in the settings (US-18).
  Future<void> showPrivacyOptions() async {
    await ConsentForm.showPrivacyOptionsForm(_logFormError);
    await _refresh();
  }

  /// Debug builds only: forget the consent so the dialog appears again.
  Future<void> resetConsent() async {
    await ConsentInformation.instance.reset();
    _canRequestAds = false;
    notifyListeners();
    await start();
  }

  /// After buying "Werbefrei": no banner, no consent dialog, no SDK calls.
  void disable() {
    if (_disabled) return;
    _disabled = true;
    _interstitial?.dispose();
    _interstitial = null;
    notifyListeners();
  }

  /// Loads the interstitial in the background on the finish screen.
  void preloadInterstitial() {
    if (!canShowAds || _interstitial != null) return;
    InterstitialAd.load(
      adUnitId: AdUnits.interstitial,
      request: request,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitial = ad,
        onAdFailedToLoad: (error) => debugPrint('Interstitial: $error'),
      ),
    );
  }

  /// Shows the interstitial if it is ready by now. The app never waits.
  void showInterstitialIfReady() {
    final ad = _interstitial;
    _interstitial = null;
    if (ad == null || !canShowAds) {
      ad?.dispose();
      return;
    }
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) => ad.dispose(),
      onAdFailedToShowFullScreenContent: (ad, error) => ad.dispose(),
    );
    ad.show();
  }

  Future<void> _refresh() async {
    _canRequestAds = await ConsentInformation.instance.canRequestAds();
    _privacyOptionsRequired =
        await ConsentInformation.instance
            .getPrivacyOptionsRequirementStatus() ==
        PrivacyOptionsRequirementStatus.required;
    if (_canRequestAds && !_sdkStarted && !_disabled) {
      _sdkStarted = true;
      await MobileAds.instance.initialize();
    }
    notifyListeners();
  }

  ConsentRequestParameters _consentParameters() => ConsentRequestParameters(
    consentDebugSettings: kDebugMode
        ? ConsentDebugSettings(
            debugGeography: DebugGeography.debugGeographyEea,
            testIdentifiers: _testDevices.isEmpty
                ? null
                : _testDevices.split(','),
          )
        : null,
  );

  void _logFormError(FormError? error) {
    if (error != null) {
      debugPrint('Consent: ${error.errorCode} ${error.message}');
    }
  }
}
