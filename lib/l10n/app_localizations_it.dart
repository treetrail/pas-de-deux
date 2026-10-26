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

  @override
  String get introTitle1 => 'Due persone, 36 domande';

  @override
  String get introBody1 =>
      'Da un\'idea dello studio di Aron et al. (1997): due persone si fanno a turno domande sempre più personali, livello dopo livello. Le domande di questa app sono formulate in modo originale. Se vi avvicinerete, dipende solo da voi.';

  @override
  String get introTitle2 => 'Come funziona un turno';

  @override
  String get introBody2 =>
      'Condividete un solo telefono. Una persona risponde alla domanda, l\'altra tiene il telefono e poi indica quanto l\'ha toccata la risposta. Poi vi scambiate. La valutazione è facoltativa e resta nascosta finché non compare tra i vostri momenti più belli.';

  @override
  String get introTitle3 => 'Prendetevi il vostro tempo';

  @override
  String get introBody3 =>
      'Tutte le 36 domande richiedono circa 45 minuti. Potete scegliere meno domande, saltarle e fare una pausa in qualsiasi momento. Alla fine potete guardarvi negli occhi per quattro minuti.';

  @override
  String introPage(int number, int total) {
    return 'Pagina $number di $total';
  }

  @override
  String get showIntro => 'Mostra l\'introduzione';

  @override
  String get lookTitle => 'Lo sguardo di quattro minuti';

  @override
  String get lookOffer =>
      'Per finire, guardatevi negli occhi in silenzio per quattro minuti.';

  @override
  String get lookStart => 'Inizia';

  @override
  String lookRemaining(String time) {
    return 'Tempo rimasto $time';
  }

  @override
  String get lookDone => 'I quattro minuti sono finiti.';

  @override
  String get soundSetting => 'Suono alla fine dello sguardo';

  @override
  String get dataTitle => 'Dati';

  @override
  String get resetWeights => 'Reimposta i pesi';

  @override
  String get resetWeightsQuestion => 'Reimpostare i pesi?';

  @override
  String get resetWeightsBody =>
      'Le valutazioni precedenti non influenzeranno più quali domande escono.';

  @override
  String get resetWeightsDone => 'I pesi sono stati reimpostati.';

  @override
  String get resetAll => 'Reimposta tutti i dati';

  @override
  String get resetAllQuestion => 'Reimpostare tutti i dati?';

  @override
  String get resetAllBody =>
      'Verranno cancellati il tuo nome, le impostazioni, i pesi e una partita interrotta. L\'acquisto di «Senza pubblicità» resta valido.';

  @override
  String get resetAllDone => 'Tutti i dati sono stati cancellati.';

  @override
  String get confirmReset => 'Reimposta';

  @override
  String get errorTitle => 'Qui qualcosa è andato storto.';

  @override
  String get errorBody =>
      'La partita in corso è salvata e si può riprendere dalla schermata iniziale.';

  @override
  String get errorRestart => 'Chiudi l\'app e riaprila.';
}
