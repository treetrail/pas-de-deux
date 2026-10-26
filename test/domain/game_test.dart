import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pasdedeux/domain/game.dart';
import 'package:pasdedeux/domain/rating.dart';

import '../helpers.dart';

/// Plays one full turn without ratings.
GameState playTurn(GameState game) => game.next().rate(null).next().rate(null);

void main() {
  group('start', () {
    test('plans the questions per stage in order 1, 2, 3', () {
      final game = startGame(count: 10);
      expect(
        [for (final turn in game.turns) turn.stage],
        [
          1, 1, 1, 1, 2, 2, 2, 3, 3, 3, //
        ],
      );
      expect({for (final turn in game.turns) turn.questionId}, hasLength(10));
      expect(game.reserves.map((s, r) => MapEntry(s, r.length)), {
        1: 8,
        2: 9,
        3: 9,
      });
    });

    test('never repeats a question, replacements included', () {
      final game = startGame(count: 6);
      final all = [
        for (final turn in game.turns) turn.questionId,
        for (final reserve in game.reserves.values) ...reserve,
      ];
      expect(all, hasLength(36));
      expect(all.toSet(), hasLength(36));
    });

    test('starts with the first question, which counts as shown', () {
      final game = startGame();
      expect(game.step, isA<AnswerStep>());
      expect(game.shown, [game.turns.first.questionId]);
      expect(game.canGoBack, isFalse);
    });
  });

  group('a turn', () {
    test('lets both answer and passes the phone once', () {
      final game = startGame();
      final starter = game.names[game.starterOf(0)];
      final other = game.names[1 - game.starterOf(0)];

      final first = game.step as AnswerStep;
      expect((first.answerer, first.holder), (starter, other));
      expect(first.isFirstAnswer, isTrue);
      expect((first.number, first.total), (1, 10));

      final firstRating = game.next().step as RatingStep;
      expect((firstRating.rater, firstRating.answerer), (other, starter));

      final second = game.next().rate(Rating.moved).step as AnswerStep;
      expect((second.answerer, second.holder), (other, starter));
      expect(second.isFirstAnswer, isFalse);

      final secondRating = game.next().rate(null).next().step as RatingStep;
      expect((secondRating.rater, secondRating.answerer), (starter, other));
    });

    test('lets the other person begin the next turn', () {
      final game = playTurn(startGame());
      final step = game.step as AnswerStep;
      expect(step.answerer, game.names[1 - game.starterOf(0)]);
      expect(step.number, 2);
    });
  });

  group('stage intro', () {
    test('appears between stages, not before the first', () {
      var game = startGame(stages: [1, 3], count: 2);
      expect(game.step, isA<AnswerStep>());
      game = playTurn(game);
      expect(game.step, isA<StageIntroStep>());
      expect((game.step as StageIntroStep).stage, 3);
      expect(game.next().step, isA<AnswerStep>());
    });

    test('never appears with one stage', () {
      var game = startGame(stages: [2], count: 3);
      for (var i = 0; i < 2; i++) {
        game = playTurn(game);
        expect(game.step, isA<AnswerStep>());
      }
    });
  });

  group('back', () {
    test('keeps a rating, and a new choice replaces it', () {
      var game = startGame().next().rate(Rating.moved);
      expect(game.turns.first.ratings, [Rating.moved, null]);

      game = game.back();
      expect(game.step, isA<RatingStep>());
      expect(game.turns.first.ratings, [Rating.moved, null]);

      expect(game.rate(Rating.okay).turns.first.ratings, [Rating.okay, null]);
    });

    test('"Weiter ohne Bewertung" removes a rating', () {
      final game = startGame().next().rate(Rating.moved).back().rate(null);
      expect(game.turns.first.ratings, [null, null]);
    });

    test('goes through the stage intro into the previous turn', () {
      var game = playTurn(startGame(stages: [1, 2], count: 2)).next();
      expect(game.step, isA<AnswerStep>());
      game = game.back();
      expect(game.step, isA<StageIntroStep>());
      game = game.back();
      expect(game.step, isA<RatingStep>());
      expect(game.turnIndex, 0);
      expect(game.phase, Phase.secondRating);
    });

    test('stops at the first question', () {
      final game = startGame().next().back();
      expect(game.turnIndex, 0);
      expect(game.phase, Phase.firstAnswer);
      expect(game.canGoBack, isFalse);
    });
  });

  group('skip', () {
    test('replaces the question with the next one of the same stage', () {
      final game = startGame();
      final skipped = game.turns.first.questionId;
      final replacement = game.reserves[1]!.first;

      final after = game.skip();
      expect(after.turns.first.questionId, replacement);
      expect(after.turns.first.stage, 1);
      expect(after.reserves[1], hasLength(7));
      expect(after.shown, [skipped, replacement]);
      expect(after.turns, hasLength(10));
    });

    test('drops the turn when the stage has no replacement left', () {
      final game = startGame(stages: [1], count: 12);
      expect(game.reserves[1], isEmpty);
      final after = game.skip();
      expect(after.turns, hasLength(11));
      expect((after.step as AnswerStep).total, 11);
    });

    test('ends the game when the last turn is dropped', () {
      var game = startGame(stages: [1], count: 12);
      for (var i = 0; i < 11; i++) {
        game = playTurn(game);
      }
      expect(game.skip().step, isA<FinishedStep>());
    });

    test('is not possible once someone has rated', () {
      final game = startGame().next().rate(Rating.interesting);
      expect((game.step as AnswerStep).canSkip, isFalse);
    });
  });

  test('ends early and keeps the ratings so far', () {
    final game = startGame().next().rate(Rating.moved).end();
    expect(game.step, isA<FinishedStep>());
    expect(game.turns.first.ratings, [Rating.moved, null]);
  });

  test('survives a JSON round trip', () {
    final game = playTurn(startGame()).skip().next().rate(Rating.interesting);
    final copy = GameState.fromJson(
      jsonDecode(jsonEncode(game.toJson())) as Map<String, dynamic>,
    );
    expect(copy.toJson(), game.toJson());
  });
}
