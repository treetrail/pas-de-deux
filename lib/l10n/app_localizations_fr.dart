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
}
