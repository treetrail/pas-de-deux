# Pas de deux

36 questions to get to know each other, turn by turn, on one phone. Based on
the idea of the study by Aron et al. (1997). For iOS and Android, in German,
English, Spanish, Italian and French.

## Status

Prototype ("Durchstich"): it checks the risky parts on both platforms before
the rest of the app is built: the question screen in two languages and at
large font sizes, ads with the consent dialog, the purchase "Werbefrei" and
the back gesture during a game.

## Development

Flutter 3.47.8 (stable). Minimum iOS 18, Android 7.0 (API 24), target API 36.

```bash
flutter test
flutter run
```

Debug builds always use Google's test ad IDs and show the consent dialog as
in the EEA. Release builds read the real ad unit IDs from a file that is not
in the repository:

```bash
flutter build appbundle --dart-define-from-file=config/prod.json
```

with the keys `ADMOB_BANNER_ANDROID`, `ADMOB_BANNER_IOS`,
`ADMOB_INTERSTITIAL_ANDROID` and `ADMOB_INTERSTITIAL_IOS`.

To test the purchase on iOS, run the app from Xcode (`ios/Runner.xcworkspace`):
the scheme uses the StoreKit configuration `ios/Runner/Configuration.storekit`.

## License

The source code is licensed under the [Apache License 2.0](LICENSE). The
questions, app texts and other content are not: all rights reserved, see
[LICENSE-CONTENT](LICENSE-CONTENT).
