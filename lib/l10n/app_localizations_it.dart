// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Pas de deux';

  @override
  String get appSubtitle => '36 domande per conoscersi';

  @override
  String get newGame => 'Nuova partita';

  @override
  String get resumeGame => 'Riprendi la partita';

  @override
  String get settings => 'Impostazioni';

  @override
  String get setupTitle => 'Prepara la partita';

  @override
  String get yourName => 'Il tuo nome';

  @override
  String get otherName => 'Nome dell\'altra persona';

  @override
  String get personA => 'Persona A';

  @override
  String get personB => 'Persona B';

  @override
  String get stagesTitle => 'Livelli';

  @override
  String stageLabel(int number, String name, String intro) {
    return 'Livello $number – $name: $intro';
  }

  @override
  String questionCount(int count, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count domande',
      one: '1 domanda',
    );
    return '$_temp0 · circa $minutes min';
  }

  @override
  String distribution(String value) {
    return 'Ripartizione: $value';
  }

  @override
  String get secondLanguage => 'Seconda lingua';

  @override
  String get off => 'Disattivata';

  @override
  String get startGame => 'Iniziamo';

  @override
  String answersFirst(String answerer, String holder) {
    return 'Inizia $answerer. $holder tiene il telefono.';
  }

  @override
  String answersNow(String answerer, String holder) {
    return 'Ora risponde $answerer. Passa il telefono a $holder.';
  }

  @override
  String get next => 'Avanti';

  @override
  String get skip => 'Salta';

  @override
  String get back => 'Indietro';

  @override
  String progress(int number, int total) {
    return '$number di $total';
  }

  @override
  String progressSemantics(int number, int total) {
    return 'Domanda $number di $total';
  }

  @override
  String ratingPrompt(String rater, String answerer) {
    return '$rater, quanto ti ha toccato la risposta di $answerer?';
  }

  @override
  String get ratingMoved => 'Mi ha toccato';

  @override
  String get ratingInteresting => 'Interessante';

  @override
  String get ratingOkay => 'Va bene';

  @override
  String get continueWithoutRating => 'Avanti senza valutare';

  @override
  String get endGame => 'Termina la partita';

  @override
  String get endGameQuestion => 'Terminare la partita?';

  @override
  String get endGameBody =>
      'Passerete al riepilogo con le domande giocate finora.';

  @override
  String get cancel => 'Annulla';

  @override
  String get confirmEnd => 'Termina';

  @override
  String stageTitle(int number, String name) {
    return 'Livello $number: $name';
  }

  @override
  String get finishTitle => 'I vostri momenti più belli';

  @override
  String momentLine(String answerer, String rater) {
    return 'La risposta di $answerer ha toccato $rater.';
  }

  @override
  String get noMoments => 'Che bello dedicarsi del tempo.';

  @override
  String get toStart => 'All\'inizio';

  @override
  String get language => 'Lingua';

  @override
  String get systemLanguage => 'Come il dispositivo';

  @override
  String get privacyOptions => 'Opzioni sulla privacy';

  @override
  String get adFreeTitle => 'Senza pubblicità';

  @override
  String get adFreeHint => 'Gioca senza pubblicità';

  @override
  String buyAdFree(String price) {
    return 'Senza pubblicità a $price';
  }

  @override
  String get restorePurchases => 'Ripristina acquisti';

  @override
  String get purchasePending => 'Acquisto in elaborazione…';

  @override
  String get adFreeActive => 'Senza pubblicità attivo. Grazie!';

  @override
  String get storeUnavailable => 'Lo store non è disponibile al momento.';

  @override
  String get purchaseFailed => 'L\'acquisto non è andato a buon fine.';

  @override
  String get aboutTitle => 'Informazioni sull\'app';

  @override
  String get aboutSource =>
      'Basata su un\'idea dello studio di Aron et al. (1997): «The Experimental Generation of Interpersonal Closeness: A Procedure and Some Preliminary Findings», Personality and Social Psychology Bulletin 23 (4), 363–377. Le domande sono formulate in modo originale. Gli autori dello studio non hanno alcun legame con questa app.';

  @override
  String get resetConsent => 'Reimposta consenso (test)';
}
