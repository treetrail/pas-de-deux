# Technisches Konzept – Version 1

25.10.2026 · Christoph

> Abschrift aus dem Projektdokument, Stand 28.10.2026. Maßgeblich ist das Dokument; Änderungen kommen per Pull Request hierher. Die Spezifikation steht als Auszug in [spezifikation.md](spezifikation.md).

Dieses Konzept beschreibt, wie Version 1 von „Pas de deux“ gebaut wird. Was die App können soll, steht in der [Spezifikation](spezifikation.md). Bei Widersprüchen gilt die Spezifikation.

## Web-App (PWA)

Am 28.10.2026 hat Christoph entschieden, die App nicht im App Store und nicht im Play Store zu veröffentlichen: Die Kosten stehen in keinem guten Verhältnis zum Nutzen. Version 1 geht als Progressive Web App an Freunde, unter [treetrail.github.io/pas-de-deux](https://treetrail.github.io/pas-de-deux/). Die Kapitel zu iOS, Android, Werbung, Kauf und Stores weiter unten beschreiben einen späteren Store-Release. Was davon für die Web-App gilt, steht hier und in kurzen Hinweisen unter den Kapiteln.

### Ausliefern

- **Build:** `flutter build web --release --no-web-resources-cdn --base-href /pas-de-deux/`, mit dart2js und dem Renderer CanvasKit.
- **Veröffentlichen:** Der Workflow `.github/workflows/web.yml` baut bei jedem Push auf `main` und stellt die App auf GitHub Pages (Quelle „GitHub Actions“). Die Actions sind per Commit-SHA gepinnt wie in der CI.
- **Installieren:** Das Manifest nennt Name, Farben und `display: standalone`. Unter iOS legt man die App über „Zum Home-Bildschirm“ in Safari ab, unter Android über „App installieren“ in Chrome. Sie öffnet sich dann ohne Adressleiste.
- **Icon:** „36“ in Georgia, hell auf dem Pflaumenrot der App. `tool/icon.swift` erzeugt Icons, maskierbare Icons für Android und das Favicon.
- **Suchmaschinen:** `noindex`. Die Seite ist öffentlich erreichbar, aber für Freunde gedacht.

### Offline und Updates

- **Service Worker:** `web/sw.js` fragt zuerst das Netz, sonst den Cache. Mit Internet kommt eine neue Version sofort, ohne Internet startet die zuletzt geladene.
- **Erster Besuch:** Die Seite lädt, bevor der Service Worker läuft. `index.html` meldet ihm deshalb die geladenen Dateien. Was die App erst später braucht, das Skript für den Wake Lock und den Ton, lädt er bei seiner Installation.
- **Kein Flutter-Service-Worker:** Ein eigenes `web/flutter_bootstrap.js` startet die App ohne Flutters veralteten Service Worker. `sw.js` ersetzt ihn bei Besuchern, die ihn schon hatten.
- **iOS:** Eine App auf dem Home-Bildschirm hat einen eigenen Speicher, getrennt von Safari. Offline bereit ist sie nach dem ersten Start von dort.

### Keine fremden Server

- CanvasKit und die Schrift Roboto kommen aus der App, nicht von Googles CDN (`--no-web-resources-cdn`). So startet die App offline, und keine IP-Adresse geht an Google. Google Fonts von Google-Servern zu laden, ist für öffentliche Seiten in Deutschland datenschutzrechtlich heikel.
- Ohne Werbung, Kauf und Analyse sendet die App selbst nichts. GitHub Pages protokolliert Zugriffe wie jeder Webserver.

### Werbung und Kauf

- **Abgeschaltet, nicht entfernt:** Der Schalter `STORE_FEATURES` (`--dart-define=STORE_FEATURES=true`) ist standardmäßig aus. Dann startet weder das Werbe-SDK noch die Verbindung zum Store, und es gibt keinen Einwilligungsdialog.
- **Oberfläche:** Start und Einstellungen blenden „Werbefrei“, „Käufe wiederherstellen“ und den Hinweis „Ohne Werbung spielen“ aus. „Datenschutz-Optionen“ entfällt von selbst.

### Gerätefunktionen im Browser

- **Bildschirm an:** wakelock_plus nutzt im Browser die Wake-Lock-API. Der Browser gibt die Sperre frei, sobald die Seite verborgen ist, etwa bei einem kurzen Wechsel in eine andere App, und das Plugin holt sie nicht zurück. `DeviceService` fordert sie deshalb beim Zurückkehren neu an. Ein abgelehnter Wake Lock wird nur protokolliert.
- **Ton:** Safari spielt Ton nur nach einem Tipp, der Ton am Ende des Blicks kommt aber vier Minuten später. Der Tipp auf „Starten“ schaltet deshalb einen AudioContext frei, über den der Ton läuft (`chime_web.dart`, Paket `web`). Die Apps nutzen weiter audioplayers.
- **Vibration:** HapticFeedback wirkt in Chrome unter Android, nicht in Safari unter iOS.
- **Speicher:** shared_preferences legt die Daten im Browser ab (localStorage). Wer die App vom Home-Bildschirm löscht oder die Websitedaten leert, verliert Einstellungen, Gewichte und eine unterbrochene Partie.

### Geprüft

- **Chrome in Handygröße:** ganzer Ablauf mit 4-Minuten-Blick und Ton am Ende, Start ohne Server aus dem Cache, keine Anfrage an fremde Server, Wake Lock nach Verbergen und Zeigen der Seite.
- **Christophs Handy, 28.10.2026:** Ablegen auf dem Home-Bildschirm und Spielen funktionieren.
- **Offen:** VoiceOver und TalkBack in der Web-App.

## Leitlinien

- **Wenige Abhängigkeiten.** Jedes Paket muss sich rechtfertigen. Einmal im Jahr steht ein Pflicht-Update für Ziel-API und Xcode an, und jedes Paket kann es verzögern.
- **Spiellogik in reinem Dart.** Partie, Fragenauswahl und Gewichte kennen weder Flutter noch Plugins. So lassen sie sich ohne Gerät testen.
- **Alles auf dem Gerät.** Kein Server, kein Konto, keine Analyse.
- **Werbung und Kauf am Rand.** Fallen sie aus, etwa ohne Internet oder ohne Einwilligung, läuft das Spiel unverändert.

## Rahmen und Werkzeuge

> **Web-App:** Dazu kommt die Plattform Web (`web/`), ausgeliefert über GitHub Pages. iOS, Android und der Paketname zählen erst für einen Store-Release. Siehe „Web-App (PWA)“.

| Bereich | Festlegung |
| --- | --- |
| Flutter | Stabiler Kanal, derzeit 3.47.8 mit Dart 3.13. Die CI nutzt dieselbe feste Version; sie steigt nur mit Absicht. |
| iOS | Deployment Target 18.0 im Xcode-Projekt. Flutter bindet die Plugins über Swift Package Manager ein, auch `google_mobile_ads`; ein Podfile gibt es nicht. |
| Android | minSdk 24, targetSdk 36, compileSdk 36. Gradle mit Kotlin DSL, wie Flutter es anlegt. |
| Entwicklung | IntelliJ mit Flutter-Plugin und Android-Emulator „pixel_8_api36“. Xcode für Simulator, Signieren und Upload. |
| Paketname | `io.github.treetrail``.pasdedeux` für Bundle-ID (iOS) und applicationId (Android), passend zur Maven-Gruppe `io.github.treetrail`. Festgelegt am 25.10.2026, nach der ersten Veröffentlichung nicht mehr änderbar. |
| Repository | Öffentlich als treetrail/pas-de-deux. Die App ist ein Projekt der GitHub-Organisation TreeTrail. |
| Gestaltung | Material 3 mit eigenem Farbschema, eine Gestaltung für beide Plattformen. Systemschrift (San Francisco, Roboto), damit alle fünf Sprachen ohne eigene Schriftdateien funktionieren. |

## Abhängigkeiten

Versionen laut pub.dev am 25.10.2026. Die genauen Stände hält `pubspec.lock` fest, Dependabot schlägt Updates vor.

> **Web-App:** Neu als direkte Abhängigkeit ist `web` 1.1.2 (BSD-3-Clause, vom Dart-Team) für den Ton im Browser. google_mobile_ads und in_app_purchase bleiben im Build, laufen aber nicht, solange `STORE_FEATURES` aus ist.

| Paket | Version | Zweck |
| --- | --- | --- |
| google_mobile_ads | 9.2.0 | Banner, Vollbildanzeige, Einwilligungsdialog (UMP) |
| in_app_purchase | 3.3.1 | Einmalkauf „Werbefrei“, Wiederherstellen |
| shared_preferences | 2.5.6 | Einstellungen, Gewichte, laufende Partie |
| flutter_localizations, intl | SDK, 0.20.3 | Sprachdateien (ARB) und Formate |
| wakelock_plus | 1.8.2 | Bildschirm bleibt während der Partie an |
| audioplayers | 6.8.1 | Ton am Ende des 4-Minuten-Blicks |
| flutter_lints | 6.0.0 | Lint-Regeln, nur in der Entwicklung |

Bewusst nicht dabei:

- **Kein Router-Paket.** Sechs Bildschirme ohne Deep Links, dafür reicht der Navigator von Flutter.
- **Kein State-Management-Paket** wie Riverpod oder Bloc. ChangeNotifier aus dem Flutter-SDK reicht für diese Größe.
- **Keine Datenbank.** Alle Daten zusammen sind wenige Kilobyte.
- **Kein Analyse- oder Crash-SDK**, wie in der Spezifikation festgelegt.
- **Kein Vibrations-Paket.** HapticFeedback aus dem Flutter-SDK reicht.

## Architektur

Die App folgt dem Architekturleitfaden des Flutter-Teams: MVVM mit Views, ViewModels, Repositories und Services. Dazu kommt eine Domänenschicht in reinem Dart.

*[Grafik im Projektdokument: Schichten der App · Pfeile zeigen, wer wen kennt]*

- **Oberfläche.** Je Bildschirm ein Widget und ein ViewModel. Das ViewModel ist ein `ChangeNotifier`, das Widget hört über `ListenableBuilder` zu. Das entspricht ViewModel und StateFlow unter Android.
- **Domäne.** Unveränderliche Wertklassen und reine Funktionen: Partie-Zustand, Fragenauswahl, Gewichte, schönste Momente. Sie kennt weder Flutter noch Plugins, ihre Tests brauchen keinen Emulator.
- **Daten.** Repositories kapseln Speicher, Fragenkatalog, Werbung und Kauf. Nur hier werden Plugins aufgerufen. Zu jedem Repository gibt es für Tests eine Fake-Fassung.
- **Zusammenbau.** `main.dart` erzeugt alle Repositories einmal und reicht sie per Konstruktor weiter. Kein Service-Locator, keine globalen Objekte.

```
lib/
  main.dart            Zusammenbau und Start
  app/                 App-Widget, Theme, Routen
  domain/              reines Dart: Modelle, Partie, Auswahl, Gewichte
  data/
    repositories/      Katalog, Einstellungen, Partie, Werbefrei
    services/          Werbung und Einwilligung, Kauf, Ton
  ui/
    intro/ start/ setup/ game/ finish/ settings/
                       je ein View und ein ViewModel
  l10n/                app_de.arb … app_fr.arb
assets/
  questions.json       36 Fragen in fünf Sprachen
  sounds/              Ton für den 4-Minuten-Blick
test/                  Unit- und Widget-Tests
integration_test/      eine Partie auf Emulator und Simulator
```

## Navigation und Spielablauf

Die App hat sechs Bildschirme mit festen Routen: Einführung, Start, Partie einstellen, Partie, Abschluss, Einstellungen.

- **Beim Öffnen** gilt: Einführung noch nicht gesehen → Einführung. Unterbrochene Partie gespeichert → direkt in die Partie (US-11). Sonst → Start.
- **Die Partie ist ein einziger Bildschirm.** Was er zeigt, bestimmt der Partie-Zustand: Stufenübergang, Frage oder Bewertung. „Zurück“ ist daher ein Schritt im Zustand, kein Wechsel der Route.
- **Der Zustand ist ein unveränderlicher Wert.** Die Schritte sind eine `sealed class` mit vollständigem `switch`, wie eine sealed class in Kotlin.

Ein Zug hat vier Schritte. A ist die beginnende Person:

| Schritt | Antwortet | Hält das Handy | Danach |
| --- | --- | --- | --- |
| 1 Frage | A | B | B bewertet |
| 2 Bewertung | – | B | „Jetzt antwortet B. Gib das Handy an A.“ |
| 3 Frage | B | A | A bewertet |
| 4 Bewertung | – | A | nächster Zug: B beginnt, A hält das Handy noch |

- **Position** in der Partie ist Zug plus Schritt. „Zurück“ (US-10) setzt sie einen Schritt zurück. Abgegebene Bewertungen bleiben gespeichert.
- **Bewertung nach „Zurück“:** Keine Stufe ist vorausgewählt, denn das Handy kann gerade beim Gegenüber sein. Eine neue Wahl ersetzt die alte, „Weiter ohne Bewertung“ löscht sie.
- **Überspringen** (US-09) setzt die nächste Ersatzfrage derselben Stufe in den Zug oder streicht ihn.
- **Zurück-Geste:** Unter Android löst die Systemgeste in der Partie „Zurück“ aus, unter iOS ist die Wischgeste vom Rand gesperrt. Beides über `PopScope`, dessen `canPop` nur auf der ersten Frage wahr ist. Dort führt die Geste zum Start, und die Partie bleibt gespeichert. Flutter verlangt, dass vor der Geste feststeht, ob sie die Seite verlassen darf; mitten in der Geste lässt sie sich nicht mehr abbrechen.

## Fragenauswahl und Gewichte

Die Regeln stehen in US-06 und US-13. Technisch läuft es so:

1. **Verteilung.** n Fragen auf k gewählte Stufen: Jede Stufe bekommt n ÷ k (ganzzahlig), der Rest geht der Reihe nach an die niedrigsten gewählten Stufen.
2. **Ziehen beim Start.** Für jede gewählte Stufe zieht die App alle 12 Fragen nacheinander ohne Zurücklegen, jede mit der Wahrscheinlichkeit w · f geteilt durch die Summe über die noch nicht gezogenen. Das ergibt eine vollständige Reihenfolge. Gespielt werden die ersten Fragen laut Verteilung, die übrigen sind die Ersatzfragen in dieser Reihenfolge.
3. **Überspringen.** Die nächste Ersatzfrage der Stufe rückt nach. Ist keine mehr da, entfällt der Zug.
4. **Verrechnung am Ende.** Beim Abschluss, auch nach „Partie beenden“, wendet die App die Regeln aus US-13 auf jeden Zug mit mindestens einer Bewertung an und begrenzt danach auf 0,3 bis 3,0.
5. **Letzte Partie merken.** Zugleich speichert sie die Kennungen aller gezeigten Fragen, auch der übersprungenen. In der nächsten Partie gilt für sie f = 0,5.

Warum so:

- Die ganze Reihenfolge vorab zu ziehen ergibt dieselben Wahrscheinlichkeiten wie ein Nachziehen beim Überspringen. Der Plan ist aber eine einfache Liste von Kennungen: Er lässt sich speichern (US-11) und testen, und kein Zufallszustand muss mit.
- Am Ende zu verrechnen ergibt dieselben Gewichte wie eine Verrechnung nach jedem Zug, weil jede Frage nur einmal pro Partie vorkommt. Dafür muss „Zurück“ keine Gewichte rückgängig machen.
- Der Zufall kommt aus `Random` von `dart:math` und wird hineingereicht. Tests nutzen einen festen Startwert.

## Speicher

> **Web-App:** shared_preferences schreibt dort in den localStorage des Browsers. Die Angaben zur Sicherung unter Android und iOS betreffen nur die Apps.

Alles liegt über `SharedPreferencesAsync` aus `shared_preferences` auf dem Gerät, als JSON unter wenigen Schlüsseln:

| Schlüssel | Inhalt | Von „Alle Daten zurücksetzen“ gelöscht |
| --- | --- | --- |
| `schema` | Version des Speicherformats, für spätere Umstellungen | nein |
| `settings` | App-Sprache, zweite Sprache, Stufen, Zahl der Fragen, Ton an oder aus, Einführung gesehen, eigener Name | ja |
| `weights` | Gewicht je Kennung; fehlt eine Kennung, gilt 1,0 | ja |
| `lastGame` | Kennungen der zuletzt gezeigten Fragen | ja |
| `savedGame` | laufende Partie: beide Namen, Plan, Position, Bewertungen | ja |
| `adFree` | Kaufstatus „Werbefrei“ | nein |

- `savedGame` wird nach jedem Schritt geschrieben, das sind wenige hundert Byte. So überlebt die Partie auch, wenn das System die App beendet. Am Ende der Partie wird der Eintrag gelöscht und mit ihm der zweite Name.
- „Gewichte zurücksetzen“ löscht nur `weights`.
- Unter Android ist die Cloud-Sicherung aus (`android:allowBackup="false"`), damit Namen und Gewichte nicht in Google-Sicherungen landen. Unter iOS liegen sie im Geräte-Backup des Nutzers; das bleibt so. Folge: Nach einem Gerätewechsel beginnen die Gewichte unter Android neu, den Kauf holt „Käufe wiederherstellen“ zurück.

## Fragen und Sprachen

**Fragen.** Die 36 Fragen liegen in `assets/questions.json`, einmal aus dem Tab Fragen erzeugt. Danach ist die Datei im Repository maßgeblich. Textänderungen gehen zuerst dorthin und werden im Tab nachgetragen.

```json
{
  "version": 1,
  "stages": [
    { "stage": 1, "name": { "de": "…", "en": "…" }, "intro": { "de": "…", "en": "…" } }
  ],
  "questions": [
    { "id": "s1-q01", "stage": 1,
      "text": { "de": "…", "en": "…", "es": "…", "it": "…", "fr": "…" } }
  ]
}
```

Die Fragen stehen nicht in den ARB-Dateien, aus zwei Gründen: Die zweisprachige Anzeige (US-19) braucht zwei Sprachen gleichzeitig, ARB liefert über den Kontext aber nur die App-Sprache. Und die Gewichte hängen an der Kennung, die so direkt in der Datei steht.

**App-Texte.** ARB-Dateien in `lib/l10n`, eine je Sprache. Vorlage ist `app_de.arb`, weil Deutsch die Referenzsprache ist. Flutter erzeugt daraus den Code (gen-l10n).

- **Sprachwechsel ohne Neustart:** `MaterialApp.locale` folgt dem Einstellungs-ViewModel.
- **Zweite Sprache:** Die Bewertungsknöpfe holen ihre Texte über `lookupAppLocalizations(Locale(…))`, das die Texte jeder unterstützten Sprache liefert. Stufennamen und -sätze kommen aus `questions.json`.
- **Screenreader:** Der Text in der zweiten Sprache ist ein `TextSpan` mit eigener `locale`. Flutter gibt diese Sprache an VoiceOver und TalkBack weiter. Ob beide dann mit der passenden Stimme lesen, prüft der Durchstich.
- **Prüfungen:** Ein Test prüft den Katalog: 36 Kennungen, 12 je Stufe, alle fünf Sprachen gefüllt, keine Kennung doppelt. Die CI bricht ab, wenn gen-l10n fehlende Übersetzungen meldet.

## Werbung und Einwilligung

> **Ruht:** In der Web-App ist Werbung abgeschaltet (`STORE_FEATURES` aus). Dieses Kapitel gilt erst wieder für einen Store-Release.

Das gilt nur, solange „Werbefrei“ nicht gekauft ist. Danach startet die App das Werbe-SDK gar nicht mehr.

Ablauf beim Start:

1. Der Startbildschirm erscheint sofort. Nichts wartet auf das Netz.
2. `ConsentInformation.requestConsentInfoUpdate`, danach `ConsentForm.loadAndShowConsentFormIfRequired`. Beim ersten Start geschieht das erst nach der Einführung.
3. Meldet `canRequestAds()` ja, startet `MobileAds.instance.initialize()`, dann lädt das Banner.
4. Ohne Netz passiert nichts. Der nächste Versuch kommt beim nächsten Start der App.

Weitere Festlegungen:

- **Banner:** adaptives, verankertes Banner unten auf dem Startbildschirm. Es nimmt erst Platz ein, wenn eine Anzeige geladen ist.
- **Vollbildanzeige:** lädt auf dem Abschlussbildschirm im Hintergrund und erscheint nach „Neue Partie“ oder „Zum Start“, wenn sie bis dahin bereitsteht. Die App wartet nie auf sie. Ein Merker im Partie-Zustand sorgt für höchstens eine pro Partie.
- **Keine Videos:** Im Anzeigenblock der AdMob-Konsole sind Videoanzeigen abgeschaltet. Das ist eine Einstellung, kein Code.
- **Nicht personalisiert:** Jede Anfrage ist `AdRequest(nonPersonalizedAds: true)`.
- **Datenschutz-Optionen** (US-18): Der Eintrag erscheint, wenn `getPrivacyOptionsRequirementStatus()` „required“ meldet, und öffnet `ConsentForm.showPrivacyOptionsForm`.
- **IDs:** Die AdMob-App-ID steht fest in `AndroidManifest.xml` und `Info.plist`. Die IDs der Anzeigenblöcke kommen beim Bauen über `--dart-define-from-file`. Debug-Builds nutzen immer Googles Test-IDs, damit beim Entwickeln keine echten Anzeigen gezählt werden.
- **iOS:** keine `NSUserTrackingUsageDescription`, also keine ATT-Abfrage. Die SKAdNetwork-Kennungen von Google kommen in die `Info.plist`.
- **Testen:** `ConsentDebugSettings` mit der Region EWR. Emulator und Simulator gelten ohne weitere Angabe als Testgeräte, echte Geräte brauchen ihre gehashte ID über `--dart-define=CONSENT_TEST_DEVICES=…`. Mit Googles Beispiel-App-ID zeigt der Dialog eine Testmitteilung, dafür ist kein AdMob-Konto nötig. Für die eigene App-ID muss in der AdMob-Konsole unter „Datenschutz und Mitteilungen“ eine DSGVO-Mitteilung veröffentlicht sein.

## Kauf „Werbefrei“

> **Ruht:** In der Web-App gibt es keinen Kauf (`STORE_FEATURES` aus). Dieses Kapitel gilt erst wieder für einen Store-Release.

- **Produkt:** ein nicht verbrauchbarer Artikel mit der Produkt-ID `ad_free`, bei Apple „Non-Consumable“, bei Google ein Einmalkauf. Der Preis von 1,99 € steht in beiden Stores, nicht im Code.
- **Früh zuhören:** `main.dart` abonniert `purchaseStream`, bevor die Oberfläche steht. Sonst gehen Käufe verloren, die beim letzten Mal nicht fertig wurden.
- **Gekauft oder wiederhergestellt:** Die App speichert `adFree`, entfernt das Banner sofort und fragt keine Einwilligung mehr ab. Ist `pendingCompletePurchase` gesetzt, ruft sie `completePurchase` auf. Ohne diese Bestätigung erstattet Google Play den Kauf nach drei Tagen automatisch.
- **Reihenfolge:** Erst setzt die App den Zustand und aktualisiert die Oberfläche, dann speichert sie `adFree`, zuletzt ruft sie `completePurchase` auf. Ein Fehler dabei darf den Kauf nicht verschlucken: in_app_purchase_storekit 0.4.15 macht aus der Transaktions-ID 0 eine fehlende ID, dann bricht `completePurchase` ab. Die ID 0 bekommt der erste Testkauf in Xcode.
- **Testen unter iOS:** Die StoreKit-Datei `ios/Runner/Configuration.storekit` (Produkt `ad_free`, 1,99 €) gilt nur, wenn die App aus Xcode startet. Über `flutter run` oder `simctl` gestartet, meldet sie den Store als nicht erreichbar. Xcode wählt dabei seinen eigenen Simulator.
- **Ausstehend:** Manche Zahlarten brauchen Tage. Bis zur Bestätigung zeigt die App „Kauf wird bearbeitet“, und die Werbung bleibt.
- **Wiederherstellen:** Der Knopf in den Einstellungen ruft `restorePurchases()` auf. Unter Android läuft das zusätzlich still beim Start, wenn lokal kein Kaufstatus gespeichert ist, etwa nach einer Neuinstallation. Unter iOS nur auf Knopfdruck, weil Apple dabei nach der Anmeldung fragen kann.
- **Keine Belegprüfung auf einem Server**, denn es gibt keinen. Ein manipulierter oder später erstatteter Kauf bleibt so werbefrei. Bei 1,99 € ist das hinnehmbar.

## Bildschirm, Timer und Ton

> **Web-App:** Bildschirm an, Ton und Vibration verhalten sich im Browser anders. Siehe „Web-App (PWA)“, Gerätefunktionen im Browser.

- **Bildschirm an:** `wakelock_plus` hält ihn an, solange die Partie oder der 4-Minuten-Blick läuft, und gibt ihn danach frei.
- **Timer:** Beim Start merkt sich die App den Zeitpunkt auf einer monotonen Uhr (`Stopwatch`). Die Anzeige rechnet die Restzeit jede Sekunde neu aus, statt herunterzuzählen. So stimmt sie auch nach einem kurzen Wechsel in eine andere App.
- **Im Hintergrund** ertönt nichts, denn Version 1 hat keine Benachrichtigungen. Wer zurückkommt, sieht, dass die Zeit um ist.
- **Ton:** eine kurze eigene Tondatei, selbst erzeugt oder gemeinfrei, abgespielt über `audioplayers`. Unter iOS in der Audio-Kategorie „ambient“: Der Stummschalter gilt, und laufende Musik wird nicht unterbrochen. Dazu Vibration über `HapticFeedback`. Der Ton lässt sich abschalten (US-14), die Vibration bleibt.
- **Dunkel:** Der Timer hat ein eigenes dunkles Theme, unabhängig vom Systemmodus.

## Barrierefreiheit und Layout

- Die Schriftgröße des Systems gilt ohne Obergrenze. Kein Text hat eine feste Höhe, Fragen stehen in einem scrollbaren Bereich (US-19).
- Tippflächen sind mindestens 48 × 48 dp groß. Das erfüllt auch die 44 × 44 pt unter iOS.
- Jeder Bildschirm hält über `SafeArea` auch seitlich Abstand. Das faltbare „iPhone Duo“ im Simulator zeigt auf dem Außendisplay rechts eine Spalte mit Kamera, Uhrzeit und WLAN. Ohne seitlichen Abstand rutschen Inhalte darunter.
- Jeder Knopf hat eine Beschriftung für Screenreader, auch reine Symbole wie „Zurück“. Der Fortschritt wird als „Frage 7 von 12“ vorgelesen.
- Widget-Tests prüfen die Richtlinien, die Flutter mitbringt: Tippflächen für Android und iOS, beschriftete Tippflächen und Textkontrast.
- Golden-Tests halten den Fragebildschirm als Bild fest: längste Frage, alle fünf Sprachen, zweisprachig, doppelte Schriftgröße, hell und dunkel.

## Fehlerbehandlung

Ein Fehler im Dart-Code bringt eine Flutter-App meist nicht zum Absturz. Er erscheint deshalb weder in App Store Connect noch in der Play Console. Ohne Crash-SDK bleibt er unsichtbar.

- Darum liegt das Gewicht auf Tests, besonders in der Domäne.
- Im Release fangen `FlutterError.onError` und `PlatformDispatcher.instance.onError` Fehler ab. Statt einer grauen Fläche zeigt `ErrorWidget.builder` einen freundlichen Hinweis mit „Zum Start“.
- Die laufende Partie ist nach jedem Schritt gespeichert und übersteht so auch einen Fehler.

## Tests

> **Web-App:** Dazu kommt ein Test von Hand in Chrome und auf einem echten Handy: ablegen, offline starten, Ton am Ende des Blicks. Werbung und Kauf entfallen dort.

| Ebene | Was | Werkzeug |
| --- | --- | --- |
| Domäne | Verteilung, keine Wiederholung, Stufenreihenfolge, Wahrscheinlichkeiten (statistisch, mit festem Startwert), Gewichtsregeln und Grenzen, Überspringen, Zurück, schönste Momente | `flutter test` |
| Inhalte | Fragenkatalog vollständig, keine fehlenden Übersetzungen | `flutter test`, gen-l10n |
| Oberfläche | jeder Bildschirm mit Fake-Repositories, Barrierefreiheits-Richtlinien, Golden-Tests | `flutter test` |
| Ende zu Ende | kurze Partie mit Bewertung, Überspringen, Zurück, Unterbrechen und Fortsetzen | `integration_test` auf Emulator und Simulator |
| Von Hand | Werbung mit Einwilligung, Kauf, VoiceOver, TalkBack, große Schrift | Testgeräte, vor jedem Release |

Geräte: Android-Emulator mit API 24 und API 36, iOS-Simulator mit iOS 18 und 26, dazu je ein echtes Gerät für Kauf und Screenreader.

## Build, CI und Release

> **Web-App:** Ein Release ist jeder Push auf `main` (`web.yml`). Signieren, Versionsnummer im Store und Upload entfallen. Die CI baut Android und iOS weiter mit, damit ein Store-Release möglich bleibt.

- **Repository:** öffentlich unter `treetrail/pas-de-deux`, eingerichtet wie `treetrail/treetrail`: Rulesets „Protect main“ und „Protect release tags“, Dependabot-Warnungen und Sicherheitsupdates, private Meldung von Sicherheitslücken. Eine eigene `SECURITY.md` liegt im Repository, weil die Vorgaben aus `christoph-sens/.github` in anderen Organisationen nicht gelten.
- **CI:** GitHub Actions, per Commit-SHA gepinnt, Dependabot für `pub` und `github-actions` mit Wartezeit. Ein neuer wiederverwendbarer Workflow `flutter-ci.yml` kommt nach `christoph-sens/ci-workflows`. `treetrail/treetrail` ruft von dort schon `gradle-ci.yml` auf.
- **Jobs:** Format und `flutter analyze`, `flutter test`, Android-Build (`flutter build appbundle`), iOS-Build ohne Signatur (`flutter build ios --no-codesign`) auf einem macOS-Runner. Für öffentliche Repositories sind die Standard-Runner kostenlos, auch unter macOS. Alle Jobs laufen daher bei jedem Pull Request.
- **Keine Geheimnisse im Repository:** Upload-Schlüssel, `key.properties` und Store-Zugänge bleiben draußen. Die AdMob-App-ID darf hinein, sie steht ohnehin in jeder ausgelieferten App. Die IDs der echten Anzeigenblöcke liegen in einer nicht eingecheckten Datei `config/prod.json`. So rufen Nachbauten keine Anzeigen über das eigene AdMob-Konto ab; solche fremden Zugriffe können als ungültig gelten und das Konto gefährden.
- **Signieren:** Android mit einem Upload-Schlüssel und Play App Signing, iOS mit automatischer Signierung in Xcode.
- **Version:** `version: 1.0.0+1` in `pubspec.yaml`. Die Zahl nach dem Plus steigt mit jedem Upload.
- **Release von Hand:** `flutter build appbundle` und Upload in der Play Console, `flutter build ipa` und Upload mit Xcode oder Transporter. Automatisieren lohnt sich erst, wenn Releases häufiger werden.
- **Jährliches Pflicht-Update:** Flutter, Ziel-API und Xcode anheben, alle Tests laufen lassen, neu einreichen.

## Lizenz

Ein öffentliches Repository macht das Nachbauen leicht. Die Lizenz legt fest, was davon erlaubt ist.

- **Code:** Apache-2.0, wie bei `treetrail/treetrail`. Rechte am Namen „Pas de deux“ gibt diese Lizenz nicht (Abschnitt 6).
- **Inhalte:** Fragen, App-Texte, Ton, Icon und Screenshots stehen nicht unter Apache-2.0, alle Rechte bleiben vorbehalten. Das steht in einer eigenen Datei `LICENSE-CONTENT` und im README.
- **Grenze:** Gegen einen Nachbau mit eigenen Fragen hilft keine Lizenz. Der Vorsprung liegt im Erlebnis und in der Pflege, nicht im Code.

## Konten und Store-Voraussetzungen

> **Ruht:** Für die Web-App ist außer GitHub kein Konto nötig. Die Tabelle gilt für einen späteren Store-Release.

| Was | Wofür | Hinweis |
| --- | --- | --- |
| Apple Developer Program | Veröffentlichung unter iOS, Testkauf auf echten Geräten | 99 € im Jahr. Konto als Person. |
| Google Play Console | Veröffentlichung unter Android, jeder Testkauf | 25 USD einmalig. Konto als Person. Neue persönliche Konten brauchen vor der ersten Veröffentlichung einen geschlossenen Test mit mindestens 12 Testern über 14 Tage. Die Tester daher früh suchen. Vor der Anlage in der Hilfe der Play Console bestätigen. |
| AdMob | Anzeigenblöcke, DSGVO-Mitteilung für den Einwilligungsdialog | Echte Anzeigen erst, wenn die App mit ihrem Store-Eintrag verknüpft und von AdMob geprüft ist. |
| Website | Datenschutzerklärung (beide Stores), Support-Adresse (Apple), `app-ads.txt` (AdMob) | GitHub Pages der Organisation unter `treetrail.github.io`, aus dem Repository `treetrail/treetrail.github.io`. Die Datenschutzerklärung gibt es dort in allen fünf Sprachen. `app-ads.txt` muss im Stammverzeichnis der Domain liegen, die im Store-Eintrag steht. Ob AdMob die Datei dort findet, vor dem Start prüfen. |
| Händlerangaben EU | Pflicht für Apps mit Einnahmen | Name, Adresse, Telefon und E-Mail stehen öffentlich im Store. |
| Anbietername | Name unter dem App-Titel im Store | Bei Google steht „TreeTrail“ als Entwicklername. Bei Apple steht der eigene Name, weil das Konto einer Person gehört. |

## Durchstich

Der Durchstich baut noch nicht die App. Er prüft die riskanten Stellen auf beiden Plattformen, bevor der Rest entsteht, und füllt damit den offenen Punkt aus der Spezifikation aus.

1. **Projekt:** mit Paketname und Mindestversionen anlegen. Es läuft auf dem Emulator mit API 24 und im Simulator mit iOS 18.
2. **Fragebildschirm:** echter Katalog, zweisprachig, doppelte Schriftgröße. VoiceOver und TalkBack lesen die zweite Sprache mit der passenden Stimme.
3. **Werbung:** Testbanner und Test-Vollbildanzeige mit Einwilligungsdialog (Region EWR) und Datenschutz-Optionen.
4. **Kauf:** Testkauf und Wiederherstellen. Unter iOS im Simulator mit einer StoreKit-Konfigurationsdatei, unter Android nur über einen internen Test in der Play Console mit Lizenztestern.
5. **Zurück-Geste** in der Partie unter Android und iOS.

Fertig ist er, wenn alle fünf Punkte auf beiden Plattformen laufen und die Erkenntnisse hier stehen. Voraussetzungen: Xcode, ein AdMob-Konto und für den Android-Kauf ein Konto in der Play Console.

### Ergebnis vom 26.10.2026

Der Prototyp liegt in `~/dev/pas-de-deux` und ist noch nicht eingecheckt. Getestet auf dem Android-Emulator mit API 36 und im iOS-Simulator mit iOS 27.1.

| Punkt | Android | iOS |
| --- | --- | --- |
| 1 Projekt | läuft | läuft |
| 2 Fragebildschirm | zweisprachig geprüft; bei doppelter Schrift passt alles, die Frage scrollt | zweisprachig geprüft; doppelte Schrift im Widget-Test |
| 3 Werbung | Einwilligungsdialog, Banner, Vollbildanzeige, Datenschutz-Optionen | Einwilligungsdialog, Banner, Vollbildanzeige |
| 4 Kauf | offen, braucht die Play Console | Testkauf und Wiederherstellen laufen |
| 5 Zurück-Geste | geht einen Schritt zurück, auf der ersten Frage zum Start | in der Partie gesperrt, auf der ersten Frage zum Start |

Erkenntnisse:

- **Tests:** 46 Tests, die meisten für die Domäne. Auf dem Fragebildschirm prüfen Widget-Tests die Richtlinien von Flutter für Tippflächen und Kontrast sowie die längste Frage jeder Sprache bei doppelter Schrift.
- **Screenreader:** Der Text der zweiten Sprache gibt seine `locale` an die Barrierefreiheit weiter, das prüft ein Widget-Test. Ob VoiceOver und TalkBack damit die passende Stimme wählen, zeigt erst ein echtes Gerät.
- **Fortsetzen:** Beendet das System die App, geht die Partie an derselben Stelle weiter. Unter Android geprüft.
- **Ohne Play Store:** Der Android-Emulator ohne Play Store kennt keinen Kauf. Die App blendet „Ohne Werbung spielen“ dann aus und zeigt in den Einstellungen „Der Store ist gerade nicht erreichbar.“
- **Testkauf in Xcode:** Ein nicht abgeschlossener Testkauf kam beim nächsten Start nicht von selbst zurück. „Käufe wiederherstellen“ holte ihn zurück.
- **Banner:** Die Größe kommt aus `AdSize.getLargeAnchoredAdaptiveBannerAdSize`. Die bisherige Methode ist in google_mobile_ads 9 veraltet.
- **Erster Android-Build:** Gradle lädt NDK, CMake und SDK Platform 35 nach, das dauert rund 15 Minuten. Die CI sollte diese Pakete zwischenspeichern.
- **Lange Fragen:** Bei doppelter Schrift scrollt die Frage, aber nichts zeigt an, dass noch Text folgt. Eine Scrollleiste oder ein Verlauf fehlt noch.

Noch offen: der Kauf unter Android, Geräte mit API 24 und iOS 18, VoiceOver und TalkBack auf echten Geräten.

## Präzisierungen gegenüber der Spezifikation

Diese Punkte legt die Spezifikation nicht fest. Das Konzept schlägt vor:

1. Gewichte werden am Ende der Partie verrechnet statt nach jedem Zug. Das Ergebnis ist dasselbe.
2. Wird eine unterbrochene Partie durch eine neue ersetzt, zählt sie für Gewichte und „letzte Partie“ wie eine beendete.
3. Nach „Zurück“ zu einer Bewertung ist keine Stufe vorausgewählt, damit das Gegenüber sie nicht sieht.
4. Die Zurück-Geste auf der ersten Frage führt zum Start, die Partie bleibt gespeichert.
5. Unter Android gibt es keine Cloud-Sicherung der App-Daten.
6. Läuft der Timer im Hintergrund ab, gibt es keinen Ton.

## Offene Entscheidungen

Am 25.10.2026 entschieden: Paketname `io.github.treetrail.pasdedeux`, Entwicklerkonten als Person, Website auf GitHub Pages unter `treetrail.github.io`, Apache-2.0 für den Code und alle Rechte vorbehalten für die Inhalte.

Am 28.10.2026 entschieden: keine Veröffentlichung in den Stores, sondern eine Web-App über GitHub Pages. Werbung und Kauf sind abgeschaltet, nicht entfernt.

Offen: ob die Web-App ein Impressum oder eine Datenschutzerklärung braucht. Das prüft Christoph.
