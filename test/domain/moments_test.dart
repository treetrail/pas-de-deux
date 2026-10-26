import 'package:flutter_test/flutter_test.dart';
import 'package:pasdedeux/domain/game.dart';
import 'package:pasdedeux/domain/moments.dart';
import 'package:pasdedeux/domain/rating.dart';

GameState gameWith(List<List<Rating?>> ratings) => GameState(
  names: const ['Lena', 'Max'],
  firstStarter: 0,
  turns: [
    for (var i = 0; i < ratings.length; i++)
      Turn(questionId: 'q$i', stage: 1, ratings: ratings[i]),
  ],
  reserves: const {1: []},
  shown: const [],
  turnIndex: 0,
  phase: Phase.firstAnswer,
  finished: true,
);

void main() {
  test('shows up to three questions with the highest sum', () {
    final moments = bestMoments(
      gameWith([
        [Rating.moved, null],
        [Rating.moved, Rating.moved],
        [Rating.interesting, Rating.interesting],
        [Rating.moved, Rating.interesting],
        [null, Rating.moved],
      ]),
    );
    expect([for (final m in moments) m.questionId], ['q1', 'q3', 'q0']);
  });

  test('needs at least one "Hat mich berührt"', () {
    final moments = bestMoments(
      gameWith([
        [Rating.interesting, Rating.interesting],
        [Rating.okay, null],
      ]),
    );
    expect(moments, isEmpty);
  });

  test('says whose answer moved whom', () {
    // Lena starts turn 0, Max starts turn 1.
    final moments = bestMoments(
      gameWith([
        [Rating.moved, null],
        [null, Rating.moved],
      ]),
    );
    expect(moments[0].moved, [(answerer: 'Lena', rater: 'Max')]);
    expect(moments[1].moved, [(answerer: 'Lena', rater: 'Max')]);
  });
}
