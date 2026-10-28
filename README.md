# Pas de deux

36 questions to get to know each other, turn by turn, on one phone. Based on
the idea of the study by Aron et al. (1997). In German, English, Spanish,
Italian and French.

## Status

The app is shared with friends as a web app, not through the app stores:
<https://treetrail.github.io/pas-de-deux/>. Every push to `main` publishes it
([web.yml](.github/workflows/web.yml)). On the phone, "Add to Home Screen"
opens it like an app.

Ads and the purchase "Werbefrei" are switched off. Their code stays and comes
back with `--dart-define=STORE_FEATURES=true`, for example for a store
release later.

## Development

Flutter 3.47.8 (stable). Minimum iOS 18, Android 7.0 (API 24), target API 36.

```bash
flutter test
flutter run -d chrome
```

With `STORE_FEATURES=true`, debug builds always use Google's test ad IDs and show the consent dialog as
in the EEA. Store release builds read the real ad unit IDs from a file that is not
in the repository:

```bash
flutter build appbundle --dart-define=STORE_FEATURES=true \
  --dart-define-from-file=config/prod.json
```

with the keys `ADMOB_BANNER_ANDROID`, `ADMOB_BANNER_IOS`,
`ADMOB_INTERSTITIAL_ANDROID` and `ADMOB_INTERSTITIAL_IOS`.

To test the purchase on iOS, run the app from Xcode (`ios/Runner.xcworkspace`):
the scheme uses the StoreKit configuration `ios/Runner/Configuration.storekit`.

## License

The source code is licensed under the [Apache License 2.0](LICENSE). The
questions, app texts and other content are not: all rights reserved, see
[LICENSE-CONTENT](LICENSE-CONTENT).
