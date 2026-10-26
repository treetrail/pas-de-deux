// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Pas de deux';

  @override
  String get appSubtitle => '36 questions to get to know each other';

  @override
  String get newGame => 'New game';

  @override
  String get resumeGame => 'Resume game';

  @override
  String get settings => 'Settings';

  @override
  String get setupTitle => 'Set up the game';

  @override
  String get yourName => 'Your name';

  @override
  String get otherName => 'The other person\'s name';

  @override
  String get personA => 'Person A';

  @override
  String get personB => 'Person B';

  @override
  String get stagesTitle => 'Levels';

  @override
  String stageLabel(int number, String name, String intro) {
    return 'Level $number – $name: $intro';
  }

  @override
  String questionCount(int count, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count questions',
      one: '1 question',
    );
    return '$_temp0 · about $minutes min';
  }

  @override
  String distribution(String value) {
    return 'Split: $value';
  }

  @override
  String get secondLanguage => 'Second language';

  @override
  String get off => 'Off';

  @override
  String get startGame => 'Let\'s go';

  @override
  String answersFirst(String answerer, String holder) {
    return '$answerer answers first. $holder holds the phone.';
  }

  @override
  String answersNow(String answerer, String holder) {
    return 'Now $answerer answers. Hand the phone to $holder.';
  }

  @override
  String get next => 'Continue';

  @override
  String get skip => 'Skip';

  @override
  String get back => 'Back';

  @override
  String progress(int number, int total) {
    return '$number of $total';
  }

  @override
  String progressSemantics(int number, int total) {
    return 'Question $number of $total';
  }

  @override
  String ratingPrompt(String rater, String answerer) {
    return '$rater, how did the answer from $answerer touch you?';
  }

  @override
  String get ratingMoved => 'Moved me';

  @override
  String get ratingInteresting => 'Interesting';

  @override
  String get ratingOkay => 'Okay';

  @override
  String get continueWithoutRating => 'Continue without rating';

  @override
  String get endGame => 'End game';

  @override
  String get endGameQuestion => 'End the game?';

  @override
  String get endGameBody =>
      'You\'ll go to the summary with the questions played so far.';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirmEnd => 'End';

  @override
  String stageTitle(int number, String name) {
    return 'Level $number: $name';
  }

  @override
  String get finishTitle => 'Your best moments';

  @override
  String momentLine(String answerer, String rater) {
    return 'The answer from $answerer moved $rater.';
  }

  @override
  String get noMoments => 'Lovely that you took time for each other.';

  @override
  String get toStart => 'Back to start';

  @override
  String get language => 'Language';

  @override
  String get systemLanguage => 'Same as device';

  @override
  String get privacyOptions => 'Privacy options';

  @override
  String get adFreeTitle => 'Ad-free';

  @override
  String get adFreeHint => 'Play without ads';

  @override
  String buyAdFree(String price) {
    return 'Go ad-free for $price';
  }

  @override
  String get restorePurchases => 'Restore purchases';

  @override
  String get purchasePending => 'Purchase is being processed…';

  @override
  String get adFreeActive => 'Ad-free is active. Thank you!';

  @override
  String get storeUnavailable => 'The store isn\'t available right now.';

  @override
  String get purchaseFailed => 'The purchase didn\'t go through.';

  @override
  String get aboutTitle => 'About the app';

  @override
  String get aboutSource =>
      'Based on an idea from the study by Aron et al. (1997): “The Experimental Generation of Interpersonal Closeness: A Procedure and Some Preliminary Findings”, Personality and Social Psychology Bulletin 23 (4), 363–377. The questions are our own wording. The authors of the study have no connection to this app.';

  @override
  String get resetConsent => 'Reset consent (test)';

  @override
  String get introTitle1 => 'Two people, 36 questions';

  @override
  String get introBody1 =>
      'Based on an idea from the study by Aron et al. (1997): two people take turns asking each other questions that get more personal level by level. The questions in this app are our own wording. Whether you grow closer is entirely up to you.';

  @override
  String get introTitle2 => 'How a turn works';

  @override
  String get introBody2 =>
      'You share one phone. One person answers the question, the other holds the phone and then indicates how much the answer moved them. Then you swap. Rating is optional and stays hidden until it shows up in your best moments.';

  @override
  String get introTitle3 => 'Take your time';

  @override
  String get introBody3 =>
      'All 36 questions take about 45 minutes. You can choose fewer questions, skip questions and pause at any time. At the end, you can look into each other\'s eyes for four minutes.';

  @override
  String introPage(int number, int total) {
    return 'Page $number of $total';
  }

  @override
  String get showIntro => 'Show the introduction';

  @override
  String get lookTitle => 'The four-minute look';

  @override
  String get lookOffer =>
      'To finish, look into each other\'s eyes in silence for four minutes.';

  @override
  String get lookStart => 'Start';

  @override
  String lookRemaining(String time) {
    return 'Time left $time';
  }

  @override
  String get lookDone => 'The four minutes are up.';

  @override
  String get soundSetting => 'Sound at the end of the look';

  @override
  String get dataTitle => 'Data';

  @override
  String get resetWeights => 'Reset weights';

  @override
  String get resetWeightsQuestion => 'Reset the weights?';

  @override
  String get resetWeightsBody =>
      'Earlier ratings will no longer affect which questions come up.';

  @override
  String get resetWeightsDone => 'The weights have been reset.';

  @override
  String get resetAll => 'Reset all data';

  @override
  String get resetAllQuestion => 'Reset all data?';

  @override
  String get resetAllBody =>
      'This deletes your name, the settings, the weights and an interrupted game. A purchase of “Ad-free” is kept.';

  @override
  String get resetAllDone => 'All data has been deleted.';

  @override
  String get confirmReset => 'Reset';
}
