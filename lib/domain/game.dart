import 'dart:math';

import 'catalog.dart';
import 'rating.dart';
import 'selection.dart';

/// One question of a game. Both people answer it, one after the other.
class Turn {
  const Turn({
    required this.questionId,
    required this.stage,
    this.ratings = const [null, null],
  });

  final String questionId;
  final int stage;

  /// Rating of the first answer (given by the second person) and of the
  /// second answer (given by the person who started the turn).
  final List<Rating?> ratings;

  bool get isRated => ratings.any((rating) => rating != null);

  Turn withRating(int answer, Rating? rating) => Turn(
    questionId: questionId,
    stage: stage,
    ratings: [for (var i = 0; i < 2; i++) i == answer ? rating : ratings[i]],
  );
}

/// The four steps of a turn, plus the screen before a new stage (US-08).
enum Phase { stageIntro, firstAnswer, firstRating, secondAnswer, secondRating }

/// What the game screen shows, derived from [GameState.step].
sealed class GameStep {
  const GameStep();
}

final class StageIntroStep extends GameStep {
  const StageIntroStep(this.stage);

  final int stage;
}

/// A step within a turn: who acts (an index into [GameState.names], so the
/// screen can give each person a color) and the stage of the question.
sealed class TurnStep extends GameStep {
  const TurnStep({required this.stage, required this.person});

  final int stage;

  /// The person who answers or rates.
  final int person;
}

final class AnswerStep extends TurnStep {
  const AnswerStep({
    required super.stage,
    required super.person,
    required this.questionId,
    required this.answerer,
    required this.holder,
    required this.isFirstAnswer,
    required this.number,
    required this.total,
    required this.canSkip,
  });

  final String questionId;
  final String answerer;

  /// Who holds the phone and rates the answer afterwards.
  final String holder;
  final bool isFirstAnswer;
  final int number;
  final int total;
  final bool canSkip;
}

final class RatingStep extends TurnStep {
  const RatingStep({
    required super.stage,
    required super.person,
    required this.questionId,
    required this.rater,
    required this.answerer,
  });

  final String questionId;
  final String rater;
  final String answerer;
}

final class FinishedStep extends GameStep {
  const FinishedStep();
}

/// A game as an immutable value. Every action returns a new state, so the
/// state can be saved after each step (US-11) and tested without Flutter.
class GameState {
  const GameState({
    required this.names,
    required this.firstStarter,
    required this.turns,
    required this.reserves,
    required this.shown,
    required this.turnIndex,
    required this.phase,
    this.finished = false,
  });

  /// Draws the plan for a new game: all questions of each stage in weighted
  /// order, the first ones are played, the rest are replacements (US-13).
  factory GameState.start({
    required Catalog catalog,
    required List<String> names,
    required List<int> stages,
    required int count,
    required Map<String, double> weights,
    required Set<String> lastGame,
    required Random random,
  }) {
    final turns = <Turn>[];
    final reserves = <int, List<String>>{};
    distribute(count, stages).forEach((stage, stageCount) {
      final order = drawOrder(
        catalog.idsOfStage(stage),
        weights: weights,
        lastGame: lastGame,
        random: random,
      );
      turns.addAll([
        for (final id in order.take(stageCount))
          Turn(questionId: id, stage: stage),
      ]);
      reserves[stage] = order.skip(stageCount).toList();
    });
    return GameState(
      names: names,
      firstStarter: random.nextInt(2),
      turns: turns,
      reserves: reserves,
      shown: [turns.first.questionId],
      turnIndex: 0,
      phase: Phase.firstAnswer,
    );
  }

  factory GameState.fromJson(Map<String, dynamic> json) => GameState(
    names: List<String>.from(json['names'] as List),
    firstStarter: json['firstStarter'] as int,
    turns: [
      for (final turn in json['turns'] as List)
        Turn(
          questionId: turn['id'] as String,
          stage: turn['stage'] as int,
          ratings: [
            for (final rating in turn['ratings'] as List)
              rating == null ? null : Rating.values.byName(rating as String),
          ],
        ),
    ],
    reserves: {
      for (final entry in (json['reserves'] as Map<String, dynamic>).entries)
        int.parse(entry.key): List<String>.from(entry.value as List),
    },
    shown: List<String>.from(json['shown'] as List),
    turnIndex: json['turn'] as int,
    phase: Phase.values.byName(json['phase'] as String),
    finished: json['finished'] as bool,
  );

  /// Both names. Index 0 is the person who owns the phone.
  final List<String> names;

  /// Index into [names] of who answers first in the first turn.
  final int firstStarter;
  final List<Turn> turns;

  /// Replacement questions per stage, in draw order (US-09).
  final Map<int, List<String>> reserves;

  /// Ids of all questions shown so far, skipped ones included. They count
  /// as "last game" for the next draw.
  final List<String> shown;
  final int turnIndex;
  final Phase phase;
  final bool finished;

  int starterOf(int turn) => (firstStarter + turn) % 2;

  GameStep get step {
    if (finished) return const FinishedStep();
    final turn = turns[turnIndex];
    final starter = starterOf(turnIndex);
    final other = 1 - starter;
    AnswerStep answer(int answerer) => AnswerStep(
      stage: turn.stage,
      person: answerer,
      questionId: turn.questionId,
      answerer: names[answerer],
      holder: names[1 - answerer],
      isFirstAnswer: answerer == starter,
      number: turnIndex + 1,
      total: turns.length,
      canSkip: !turn.isRated,
    );
    RatingStep rating(int rater) => RatingStep(
      stage: turn.stage,
      person: rater,
      questionId: turn.questionId,
      rater: names[rater],
      answerer: names[1 - rater],
    );
    return switch (phase) {
      Phase.stageIntro => StageIntroStep(turn.stage),
      Phase.firstAnswer => answer(starter),
      Phase.firstRating => rating(other),
      Phase.secondAnswer => answer(other),
      Phase.secondRating => rating(starter),
    };
  }

  /// "Zurück" goes back at most to the first question (US-10).
  bool get canGoBack =>
      !finished && !(turnIndex == 0 && phase == Phase.firstAnswer);

  /// From an answer to its rating, from a rating to the next answer.
  GameState next() => switch (phase) {
    Phase.stageIntro => _at(turnIndex, Phase.firstAnswer),
    Phase.firstAnswer => _at(turnIndex, Phase.firstRating),
    Phase.firstRating => _at(turnIndex, Phase.secondAnswer),
    Phase.secondAnswer => _at(turnIndex, Phase.secondRating),
    Phase.secondRating => _startTurn(turnIndex + 1),
  };

  /// Stores [rating] for the current answer and moves on. A new choice
  /// replaces an earlier one, null removes it.
  GameState rate(Rating? rating) {
    assert(step is RatingStep);
    final answer = phase == Phase.firstRating ? 0 : 1;
    final rated = [...turns];
    rated[turnIndex] = turns[turnIndex].withRating(answer, rating);
    return _copy(turns: rated).next();
  }

  /// Replaces the current question with the next replacement of its stage,
  /// or drops the turn if there is none left (US-09).
  GameState skip() {
    assert(step is AnswerStep && (step as AnswerStep).canSkip);
    final turn = turns[turnIndex];
    final reserve = reserves[turn.stage]!;
    if (reserve.isNotEmpty) {
      final replaced = [...turns];
      replaced[turnIndex] = Turn(questionId: reserve.first, stage: turn.stage);
      return _copy(
        turns: replaced,
        reserves: {...reserves, turn.stage: reserve.sublist(1)},
      )._at(turnIndex, Phase.firstAnswer);
    }
    final remaining = [...turns]..removeAt(turnIndex);
    final shortened = _copy(turns: remaining);
    if (turnIndex >= remaining.length) {
      return shortened._copy(
        turnIndex: max(0, remaining.length - 1),
        finished: true,
      );
    }
    // The intro of the current stage has been shown already.
    final intro =
        shortened._needsIntro(turnIndex) &&
        remaining[turnIndex].stage != turn.stage;
    return shortened._at(
      turnIndex,
      intro ? Phase.stageIntro : Phase.firstAnswer,
    );
  }

  /// One step back. Ratings stay stored (US-10).
  GameState back() {
    assert(canGoBack);
    return switch (phase) {
      Phase.secondRating => _at(turnIndex, Phase.secondAnswer),
      Phase.secondAnswer => _at(turnIndex, Phase.firstRating),
      Phase.firstRating => _at(turnIndex, Phase.firstAnswer),
      Phase.firstAnswer when _needsIntro(turnIndex) => _at(
        turnIndex,
        Phase.stageIntro,
      ),
      Phase.firstAnswer ||
      Phase.stageIntro => _at(turnIndex - 1, Phase.secondRating),
    };
  }

  /// "Partie beenden" (US-11): the summary uses the turns played so far.
  GameState end() => _copy(finished: true);

  Map<String, Object?> toJson() => {
    'names': names,
    'firstStarter': firstStarter,
    'turns': [
      for (final turn in turns)
        {
          'id': turn.questionId,
          'stage': turn.stage,
          'ratings': [for (final rating in turn.ratings) rating?.name],
        },
    ],
    'reserves': {
      for (final entry in reserves.entries) '${entry.key}': entry.value,
    },
    'shown': shown,
    'turn': turnIndex,
    'phase': phase.name,
    'finished': finished,
  };

  bool _needsIntro(int turn) =>
      turn > 0 && turns[turn].stage != turns[turn - 1].stage;

  GameState _startTurn(int turn) {
    if (turn >= turns.length) return _copy(finished: true);
    return _at(turn, _needsIntro(turn) ? Phase.stageIntro : Phase.firstAnswer);
  }

  GameState _at(int turn, Phase phase) {
    final id = turns[turn].questionId;
    final isQuestion =
        phase == Phase.firstAnswer || phase == Phase.secondAnswer;
    return _copy(
      turnIndex: turn,
      phase: phase,
      shown: isQuestion && !shown.contains(id) ? [...shown, id] : shown,
    );
  }

  GameState _copy({
    List<Turn>? turns,
    Map<int, List<String>>? reserves,
    List<String>? shown,
    int? turnIndex,
    Phase? phase,
    bool? finished,
  }) => GameState(
    names: names,
    firstStarter: firstStarter,
    turns: turns ?? this.turns,
    reserves: reserves ?? this.reserves,
    shown: shown ?? this.shown,
    turnIndex: turnIndex ?? this.turnIndex,
    phase: phase ?? this.phase,
    finished: finished ?? this.finished,
  );
}
