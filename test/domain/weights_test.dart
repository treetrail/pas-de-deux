import 'package:flutter_test/flutter_test.dart';
import 'package:pasdedeux/domain/game.dart';
import 'package:pasdedeux/domain/rating.dart';
import 'package:pasdedeux/domain/weights.dart';

Turn turn(Rating? first, Rating? second, {String id = 'q'}) =>
    Turn(questionId: id, stage: 1, ratings: [first, second]);

double weightAfter(Rating? first, Rating? second, {double start = 1.0}) =>
    applyRatings({'q': start}, [turn(first, second)])['q']!;

void main() {
  test('raises the weight from an average of 1.5', () {
    expect(weightAfter(Rating.moved, Rating.interesting), closeTo(1.2, 1e-9));
    expect(weightAfter(Rating.moved, null), closeTo(1.2, 1e-9));
  });

  test('lowers the weight when both chose "Okay"', () {
    expect(weightAfter(Rating.okay, Rating.okay), closeTo(0.7, 1e-9));
  });

  test('leaves everything else unchanged', () {
    expect(weightAfter(Rating.okay, null), 1.0);
    expect(weightAfter(Rating.moved, Rating.okay), 1.0);
    expect(weightAfter(Rating.interesting, Rating.interesting), 1.0);
    expect(weightAfter(null, null), 1.0);
  });

  test('keeps weights between 0.3 and 3.0', () {
    expect(weightAfter(Rating.moved, Rating.moved, start: 2.9), 3.0);
    expect(weightAfter(Rating.okay, Rating.okay, start: 0.35), 0.3);
  });

  test('starts unknown questions at 1.0', () {
    final weights = applyRatings({}, [turn(Rating.moved, Rating.moved)]);
    expect(weights['q'], closeTo(1.2, 1e-9));
  });
}
