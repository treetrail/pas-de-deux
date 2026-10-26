// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Pas de deux';

  @override
  String get appSubtitle => '36 questions pour apprendre à se connaître';

  @override
  String get newGame => 'Nouvelle partie';

  @override
  String get resumeGame => 'Reprendre la partie';

  @override
  String get settings => 'Réglages';

  @override
  String get setupTitle => 'Préparer la partie';

  @override
  String get yourName => 'Ton prénom';

  @override
  String get otherName => 'Prénom de l\'autre';

  @override
  String get personA => 'Personne A';

  @override
  String get personB => 'Personne B';

  @override
  String get stagesTitle => 'Niveaux';

  @override
  String stageLabel(int number, String name, String intro) {
    return 'Niveau $number – $name : $intro';
  }

  @override
  String questionCount(int count, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count questions',
      one: '1 question',
    );
    return '$_temp0 · environ $minutes min';
  }

  @override
  String distribution(String value) {
    return 'Répartition : $value';
  }

  @override
  String get secondLanguage => 'Deuxième langue';

  @override
  String get off => 'Désactivée';

  @override
  String get startGame => 'C\'est parti';

  @override
  String answersFirst(String answerer, String holder) {
    return '$answerer répond en premier. $holder tient le téléphone.';
  }

  @override
  String answersNow(String answerer, String holder) {
    return 'Maintenant, c\'est $answerer qui répond. Passe le téléphone à $holder.';
  }

  @override
  String get next => 'Continuer';

  @override
  String get skip => 'Passer';

  @override
  String get back => 'Retour';

  @override
  String progress(int number, int total) {
    return '$number sur $total';
  }

  @override
  String progressSemantics(int number, int total) {
    return 'Question $number sur $total';
  }

  @override
  String ratingPrompt(String rater, String answerer) {
    return '$rater, qu\'as-tu ressenti en écoutant la réponse de $answerer ?';
  }

  @override
  String get ratingMoved => 'Ça m\'a parlé';

  @override
  String get ratingInteresting => 'Intéressant';

  @override
  String get ratingOkay => 'Ça va';

  @override
  String get continueWithoutRating => 'Continuer sans noter';

  @override
  String get endGame => 'Terminer la partie';

  @override
  String get endGameQuestion => 'Terminer la partie ?';

  @override
  String get endGameBody =>
      'Vous passez au bilan avec les questions jouées jusqu\'ici.';

  @override
  String get cancel => 'Annuler';

  @override
  String get confirmEnd => 'Terminer';

  @override
  String stageTitle(int number, String name) {
    return 'Niveau $number : $name';
  }

  @override
  String get finishTitle => 'Vos plus beaux moments';

  @override
  String momentLine(String answerer, String rater) {
    return 'La réponse de $answerer a touché $rater.';
  }

  @override
  String get noMoments => 'C\'est beau de s\'accorder du temps.';

  @override
  String get toStart => 'Retour à l\'accueil';

  @override
  String get language => 'Langue';

  @override
  String get systemLanguage => 'Comme l\'appareil';

  @override
  String get privacyOptions => 'Options de confidentialité';

  @override
  String get adFreeTitle => 'Sans publicité';

  @override
  String get adFreeHint => 'Jouer sans publicité';

  @override
  String buyAdFree(String price) {
    return 'Sans publicité pour $price';
  }

  @override
  String get restorePurchases => 'Restaurer les achats';

  @override
  String get purchasePending => 'Achat en cours de traitement…';

  @override
  String get adFreeActive => 'Sans publicité activé. Merci !';

  @override
  String get storeUnavailable =>
      'La boutique n\'est pas disponible pour le moment.';

  @override
  String get purchaseFailed => 'L\'achat n\'a pas abouti.';

  @override
  String get aboutTitle => 'À propos de l\'app';

  @override
  String get aboutSource =>
      'D\'après une idée de l\'étude d\'Aron et al. (1997) : « The Experimental Generation of Interpersonal Closeness: A Procedure and Some Preliminary Findings », Personality and Social Psychology Bulletin 23 (4), 363–377. Les questions sont formulées par nos soins. Les auteurs de l\'étude n\'ont aucun lien avec cette app.';

  @override
  String get resetConsent => 'Réinitialiser le consentement (test)';

  @override
  String get introTitle1 => 'Deux personnes, 36 questions';

  @override
  String get introBody1 =>
      'D\'après une idée de l\'étude d\'Aron et al. (1997) : deux personnes se posent à tour de rôle des questions de plus en plus personnelles, niveau après niveau. Les questions de cette app sont formulées par nos soins. Vous rapprocher ou non ne dépend que de vous.';

  @override
  String get introTitle2 => 'Comment se déroule un tour';

  @override
  String get introBody2 =>
      'Vous partagez un seul téléphone. Une personne répond à la question, l\'autre tient le téléphone puis indique ce que la réponse lui a fait ressentir. Ensuite, vous échangez les rôles. La note est facultative et reste cachée jusqu\'à ce qu\'elle apparaisse parmi vos plus beaux moments.';

  @override
  String get introTitle3 => 'Prenez votre temps';

  @override
  String get introBody3 =>
      'Les 36 questions prennent environ 45 minutes. Vous pouvez choisir moins de questions, en passer et faire une pause à tout moment. À la fin, vous pouvez vous regarder dans les yeux pendant quatre minutes.';

  @override
  String introPage(int number, int total) {
    return 'Page $number sur $total';
  }

  @override
  String get showIntro => 'Revoir l\'introduction';

  @override
  String get lookTitle => 'Le regard de quatre minutes';

  @override
  String get lookOffer =>
      'Pour finir, regardez-vous dans les yeux en silence pendant quatre minutes.';

  @override
  String get lookStart => 'Commencer';

  @override
  String lookRemaining(String time) {
    return 'Temps restant : $time';
  }

  @override
  String get lookDone => 'Les quatre minutes sont écoulées.';

  @override
  String get soundSetting => 'Son à la fin du regard';
}
