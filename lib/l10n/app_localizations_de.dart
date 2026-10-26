// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Pas de deux';

  @override
  String get appSubtitle => '36 Fragen zum Kennenlernen';

  @override
  String get newGame => 'Neue Partie';

  @override
  String get resumeGame => 'Partie fortsetzen';

  @override
  String get settings => 'Einstellungen';

  @override
  String get setupTitle => 'Partie einstellen';

  @override
  String get yourName => 'Dein Name';

  @override
  String get otherName => 'Name deines Gegenübers';

  @override
  String get personA => 'Person A';

  @override
  String get personB => 'Person B';

  @override
  String get stagesTitle => 'Stufen';

  @override
  String stageLabel(int number, String name, String intro) {
    return 'Stufe $number – $name: $intro';
  }

  @override
  String questionCount(int count, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Fragen',
      one: '1 Frage',
    );
    return '$_temp0 · etwa $minutes Min.';
  }

  @override
  String distribution(String value) {
    return 'Verteilung: $value';
  }

  @override
  String get secondLanguage => 'Zweite Sprache';

  @override
  String get off => 'Aus';

  @override
  String get startGame => 'Los geht\'s';

  @override
  String answersFirst(String answerer, String holder) {
    return '$answerer antwortet zuerst. $holder hält das Handy.';
  }

  @override
  String answersNow(String answerer, String holder) {
    return 'Jetzt antwortet $answerer. Gib das Handy an $holder.';
  }

  @override
  String get next => 'Weiter';

  @override
  String get skip => 'Überspringen';

  @override
  String get back => 'Zurück';

  @override
  String progress(int number, int total) {
    return '$number von $total';
  }

  @override
  String progressSemantics(int number, int total) {
    return 'Frage $number von $total';
  }

  @override
  String ratingPrompt(String rater, String answerer) {
    return '$rater, wie hat dich die Antwort von $answerer berührt?';
  }

  @override
  String get ratingMoved => 'Hat mich berührt';

  @override
  String get ratingInteresting => 'Interessant';

  @override
  String get ratingOkay => 'Okay';

  @override
  String get continueWithoutRating => 'Weiter ohne Bewertung';

  @override
  String get endGame => 'Partie beenden';

  @override
  String get endGameQuestion => 'Partie beenden?';

  @override
  String get endGameBody =>
      'Ihr kommt zum Abschluss mit den bisher gespielten Fragen.';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get confirmEnd => 'Beenden';

  @override
  String stageTitle(int number, String name) {
    return 'Stufe $number: $name';
  }

  @override
  String get finishTitle => 'Eure schönsten Momente';

  @override
  String momentLine(String answerer, String rater) {
    return 'Die Antwort von $answerer hat $rater berührt.';
  }

  @override
  String get noMoments =>
      'Schön, dass ihr euch Zeit füreinander genommen habt.';

  @override
  String get toStart => 'Zum Start';

  @override
  String get language => 'Sprache';

  @override
  String get systemLanguage => 'Wie das Gerät';

  @override
  String get privacyOptions => 'Datenschutz-Optionen';

  @override
  String get adFreeTitle => 'Werbefrei';

  @override
  String get adFreeHint => 'Ohne Werbung spielen';

  @override
  String buyAdFree(String price) {
    return 'Werbefrei für $price';
  }

  @override
  String get restorePurchases => 'Käufe wiederherstellen';

  @override
  String get purchasePending => 'Kauf wird bearbeitet …';

  @override
  String get adFreeActive => 'Werbefrei ist aktiv. Danke!';

  @override
  String get storeUnavailable => 'Der Store ist gerade nicht erreichbar.';

  @override
  String get purchaseFailed => 'Der Kauf hat nicht geklappt.';

  @override
  String get aboutTitle => 'Über die App';

  @override
  String get aboutSource =>
      'Nach einer Idee aus der Studie von Aron et al. (1997): „The Experimental Generation of Interpersonal Closeness: A Procedure and Some Preliminary Findings“, Personality and Social Psychology Bulletin 23 (4), 363–377. Die Fragen sind eigene Formulierungen. Die Autoren der Studie stehen in keiner Verbindung zu dieser App.';

  @override
  String get resetConsent => 'Einwilligung zurücksetzen (Test)';

  @override
  String get introTitle1 => 'Zwei Menschen, 36 Fragen';

  @override
  String get introBody1 =>
      'Nach einer Idee aus der Studie von Aron et al. (1997): Zwei Menschen stellen sich abwechselnd Fragen, die Stufe für Stufe persönlicher werden. Die Fragen dieser App sind eigene Formulierungen. Ob ihr euch dabei näherkommt, liegt ganz bei euch.';

  @override
  String get introTitle2 => 'So läuft ein Zug';

  @override
  String get introBody2 =>
      'Ihr teilt euch ein Handy. Eine Person beantwortet die Frage, die andere hält das Handy und gibt danach an, wie sehr die Antwort sie berührt hat. Dann tauscht ihr. Die Bewertung ist freiwillig und bleibt verborgen, bis sie bei euren schönsten Momenten auftaucht.';

  @override
  String get introTitle3 => 'Nehmt euch Zeit';

  @override
  String get introBody3 =>
      'Alle 36 Fragen dauern etwa 45 Minuten. Ihr könnt weniger Fragen wählen, Fragen überspringen und jederzeit unterbrechen. Zum Schluss könnt ihr euch vier Minuten lang in die Augen sehen.';

  @override
  String introPage(int number, int total) {
    return 'Seite $number von $total';
  }

  @override
  String get showIntro => 'Einführung ansehen';

  @override
  String get lookTitle => 'Der 4-Minuten-Blick';

  @override
  String get lookOffer =>
      'Zum Schluss seht ihr euch vier Minuten lang schweigend in die Augen.';

  @override
  String get lookStart => 'Starten';

  @override
  String lookRemaining(String time) {
    return 'Restzeit $time';
  }

  @override
  String get lookDone => 'Die vier Minuten sind um.';

  @override
  String get soundSetting => 'Ton am Ende des Blicks';

  @override
  String get dataTitle => 'Daten';

  @override
  String get resetWeights => 'Gewichte zurücksetzen';

  @override
  String get resetWeightsQuestion => 'Gewichte zurücksetzen?';

  @override
  String get resetWeightsBody =>
      'Frühere Bewertungen beeinflussen dann nicht mehr, welche Fragen kommen.';

  @override
  String get resetWeightsDone => 'Die Gewichte sind zurückgesetzt.';

  @override
  String get resetAll => 'Alle Daten zurücksetzen';

  @override
  String get resetAllQuestion => 'Alle Daten zurücksetzen?';

  @override
  String get resetAllBody =>
      'Gelöscht werden dein Name, die Einstellungen, die Gewichte und eine unterbrochene Partie. Ein Kauf von „Werbefrei“ bleibt erhalten.';

  @override
  String get resetAllDone => 'Alle Daten sind gelöscht.';

  @override
  String get confirmReset => 'Zurücksetzen';
}
