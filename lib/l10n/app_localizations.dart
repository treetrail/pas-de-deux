import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In de, this message translates to:
  /// **'Pas de deux'**
  String get appTitle;

  /// No description provided for @appSubtitle.
  ///
  /// In de, this message translates to:
  /// **'36 Fragen zum Kennenlernen'**
  String get appSubtitle;

  /// No description provided for @newGame.
  ///
  /// In de, this message translates to:
  /// **'Neue Partie'**
  String get newGame;

  /// No description provided for @resumeGame.
  ///
  /// In de, this message translates to:
  /// **'Partie fortsetzen'**
  String get resumeGame;

  /// No description provided for @settings.
  ///
  /// In de, this message translates to:
  /// **'Einstellungen'**
  String get settings;

  /// No description provided for @setupTitle.
  ///
  /// In de, this message translates to:
  /// **'Partie einstellen'**
  String get setupTitle;

  /// No description provided for @yourName.
  ///
  /// In de, this message translates to:
  /// **'Dein Name'**
  String get yourName;

  /// No description provided for @otherName.
  ///
  /// In de, this message translates to:
  /// **'Name deines Gegenübers'**
  String get otherName;

  /// No description provided for @personA.
  ///
  /// In de, this message translates to:
  /// **'Person A'**
  String get personA;

  /// No description provided for @personB.
  ///
  /// In de, this message translates to:
  /// **'Person B'**
  String get personB;

  /// No description provided for @stagesTitle.
  ///
  /// In de, this message translates to:
  /// **'Stufen'**
  String get stagesTitle;

  /// No description provided for @stageLabel.
  ///
  /// In de, this message translates to:
  /// **'Stufe {number} – {name}: {intro}'**
  String stageLabel(int number, String name, String intro);

  /// No description provided for @questionCount.
  ///
  /// In de, this message translates to:
  /// **'{count, plural, =1{1 Frage} other{{count} Fragen}} · etwa {minutes} Min.'**
  String questionCount(int count, int minutes);

  /// No description provided for @distribution.
  ///
  /// In de, this message translates to:
  /// **'Verteilung: {value}'**
  String distribution(String value);

  /// No description provided for @secondLanguage.
  ///
  /// In de, this message translates to:
  /// **'Zweite Sprache'**
  String get secondLanguage;

  /// No description provided for @off.
  ///
  /// In de, this message translates to:
  /// **'Aus'**
  String get off;

  /// No description provided for @startGame.
  ///
  /// In de, this message translates to:
  /// **'Los geht\'s'**
  String get startGame;

  /// No description provided for @answersFirst.
  ///
  /// In de, this message translates to:
  /// **'{answerer} antwortet zuerst. {holder} hält das Handy.'**
  String answersFirst(String answerer, String holder);

  /// No description provided for @answersNow.
  ///
  /// In de, this message translates to:
  /// **'Jetzt antwortet {answerer}. Gib das Handy an {holder}.'**
  String answersNow(String answerer, String holder);

  /// No description provided for @next.
  ///
  /// In de, this message translates to:
  /// **'Weiter'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In de, this message translates to:
  /// **'Überspringen'**
  String get skip;

  /// No description provided for @back.
  ///
  /// In de, this message translates to:
  /// **'Zurück'**
  String get back;

  /// No description provided for @progress.
  ///
  /// In de, this message translates to:
  /// **'{number} von {total}'**
  String progress(int number, int total);

  /// No description provided for @progressSemantics.
  ///
  /// In de, this message translates to:
  /// **'Frage {number} von {total}'**
  String progressSemantics(int number, int total);

  /// No description provided for @ratingPrompt.
  ///
  /// In de, this message translates to:
  /// **'{rater}, wie hat dich die Antwort von {answerer} berührt?'**
  String ratingPrompt(String rater, String answerer);

  /// No description provided for @ratingMoved.
  ///
  /// In de, this message translates to:
  /// **'Hat mich berührt'**
  String get ratingMoved;

  /// No description provided for @ratingInteresting.
  ///
  /// In de, this message translates to:
  /// **'Interessant'**
  String get ratingInteresting;

  /// No description provided for @ratingOkay.
  ///
  /// In de, this message translates to:
  /// **'Okay'**
  String get ratingOkay;

  /// No description provided for @continueWithoutRating.
  ///
  /// In de, this message translates to:
  /// **'Weiter ohne Bewertung'**
  String get continueWithoutRating;

  /// No description provided for @endGame.
  ///
  /// In de, this message translates to:
  /// **'Partie beenden'**
  String get endGame;

  /// No description provided for @endGameQuestion.
  ///
  /// In de, this message translates to:
  /// **'Partie beenden?'**
  String get endGameQuestion;

  /// No description provided for @endGameBody.
  ///
  /// In de, this message translates to:
  /// **'Ihr kommt zum Abschluss mit den bisher gespielten Fragen.'**
  String get endGameBody;

  /// No description provided for @cancel.
  ///
  /// In de, this message translates to:
  /// **'Abbrechen'**
  String get cancel;

  /// No description provided for @confirmEnd.
  ///
  /// In de, this message translates to:
  /// **'Beenden'**
  String get confirmEnd;

  /// No description provided for @stageTitle.
  ///
  /// In de, this message translates to:
  /// **'Stufe {number}: {name}'**
  String stageTitle(int number, String name);

  /// No description provided for @finishTitle.
  ///
  /// In de, this message translates to:
  /// **'Eure schönsten Momente'**
  String get finishTitle;

  /// No description provided for @momentLine.
  ///
  /// In de, this message translates to:
  /// **'Die Antwort von {answerer} hat {rater} berührt.'**
  String momentLine(String answerer, String rater);

  /// No description provided for @noMoments.
  ///
  /// In de, this message translates to:
  /// **'Schön, dass ihr euch Zeit füreinander genommen habt.'**
  String get noMoments;

  /// No description provided for @toStart.
  ///
  /// In de, this message translates to:
  /// **'Zum Start'**
  String get toStart;

  /// No description provided for @language.
  ///
  /// In de, this message translates to:
  /// **'Sprache'**
  String get language;

  /// No description provided for @systemLanguage.
  ///
  /// In de, this message translates to:
  /// **'Wie das Gerät'**
  String get systemLanguage;

  /// No description provided for @privacyOptions.
  ///
  /// In de, this message translates to:
  /// **'Datenschutz-Optionen'**
  String get privacyOptions;

  /// No description provided for @adFreeTitle.
  ///
  /// In de, this message translates to:
  /// **'Werbefrei'**
  String get adFreeTitle;

  /// No description provided for @adFreeHint.
  ///
  /// In de, this message translates to:
  /// **'Ohne Werbung spielen'**
  String get adFreeHint;

  /// No description provided for @buyAdFree.
  ///
  /// In de, this message translates to:
  /// **'Werbefrei für {price}'**
  String buyAdFree(String price);

  /// No description provided for @restorePurchases.
  ///
  /// In de, this message translates to:
  /// **'Käufe wiederherstellen'**
  String get restorePurchases;

  /// No description provided for @purchasePending.
  ///
  /// In de, this message translates to:
  /// **'Kauf wird bearbeitet …'**
  String get purchasePending;

  /// No description provided for @adFreeActive.
  ///
  /// In de, this message translates to:
  /// **'Werbefrei ist aktiv. Danke!'**
  String get adFreeActive;

  /// No description provided for @storeUnavailable.
  ///
  /// In de, this message translates to:
  /// **'Der Store ist gerade nicht erreichbar.'**
  String get storeUnavailable;

  /// No description provided for @purchaseFailed.
  ///
  /// In de, this message translates to:
  /// **'Der Kauf hat nicht geklappt.'**
  String get purchaseFailed;

  /// No description provided for @aboutTitle.
  ///
  /// In de, this message translates to:
  /// **'Über die App'**
  String get aboutTitle;

  /// No description provided for @aboutSource.
  ///
  /// In de, this message translates to:
  /// **'Nach einer Idee aus der Studie von Aron et al. (1997): „The Experimental Generation of Interpersonal Closeness: A Procedure and Some Preliminary Findings“, Personality and Social Psychology Bulletin 23 (4), 363–377. Die Fragen sind eigene Formulierungen. Die Autoren der Studie stehen in keiner Verbindung zu dieser App.'**
  String get aboutSource;

  /// No description provided for @resetConsent.
  ///
  /// In de, this message translates to:
  /// **'Einwilligung zurücksetzen (Test)'**
  String get resetConsent;

  /// No description provided for @introTitle1.
  ///
  /// In de, this message translates to:
  /// **'Zwei Menschen, 36 Fragen'**
  String get introTitle1;

  /// No description provided for @introBody1.
  ///
  /// In de, this message translates to:
  /// **'Nach einer Idee aus der Studie von Aron et al. (1997): Zwei Menschen stellen sich abwechselnd Fragen, die Stufe für Stufe persönlicher werden. Die Fragen dieser App sind eigene Formulierungen. Ob ihr euch dabei näherkommt, liegt ganz bei euch.'**
  String get introBody1;

  /// No description provided for @introTitle2.
  ///
  /// In de, this message translates to:
  /// **'So läuft ein Zug'**
  String get introTitle2;

  /// No description provided for @introBody2.
  ///
  /// In de, this message translates to:
  /// **'Ihr teilt euch ein Handy. Eine Person beantwortet die Frage, die andere hält das Handy und gibt danach an, wie sehr die Antwort sie berührt hat. Dann tauscht ihr. Die Bewertung ist freiwillig und bleibt verborgen, bis sie bei euren schönsten Momenten auftaucht.'**
  String get introBody2;

  /// No description provided for @introTitle3.
  ///
  /// In de, this message translates to:
  /// **'Nehmt euch Zeit'**
  String get introTitle3;

  /// No description provided for @introBody3.
  ///
  /// In de, this message translates to:
  /// **'Alle 36 Fragen dauern etwa 45 Minuten. Ihr könnt weniger Fragen wählen, Fragen überspringen und jederzeit unterbrechen. Zum Schluss könnt ihr euch vier Minuten lang in die Augen sehen.'**
  String get introBody3;

  /// No description provided for @introPage.
  ///
  /// In de, this message translates to:
  /// **'Seite {number} von {total}'**
  String introPage(int number, int total);

  /// No description provided for @showIntro.
  ///
  /// In de, this message translates to:
  /// **'Einführung ansehen'**
  String get showIntro;

  /// No description provided for @lookTitle.
  ///
  /// In de, this message translates to:
  /// **'Der 4-Minuten-Blick'**
  String get lookTitle;

  /// No description provided for @lookOffer.
  ///
  /// In de, this message translates to:
  /// **'Zum Schluss seht ihr euch vier Minuten lang schweigend in die Augen.'**
  String get lookOffer;

  /// No description provided for @lookStart.
  ///
  /// In de, this message translates to:
  /// **'Starten'**
  String get lookStart;

  /// No description provided for @lookRemaining.
  ///
  /// In de, this message translates to:
  /// **'Restzeit {time}'**
  String lookRemaining(String time);

  /// No description provided for @lookDone.
  ///
  /// In de, this message translates to:
  /// **'Die vier Minuten sind um.'**
  String get lookDone;

  /// No description provided for @soundSetting.
  ///
  /// In de, this message translates to:
  /// **'Ton am Ende des Blicks'**
  String get soundSetting;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'es', 'fr', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
