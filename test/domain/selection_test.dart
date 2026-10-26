import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:pasdedeux/domain/selection.dart';

void main() {
  group('distribute', () {
    test('gives the remainder to the lowest stages', () {
      expect(distribute(10, [1, 2, 3]), {1: 4, 2: 3, 3: 3});
      expect(distribute(11, [1, 2, 3]), {1: 4, 2: 4, 3: 3});
    });

    test('keeps stages in order 1, 2, 3, also with gaps', () {
      final counts = distribute(5, [3, 1]);
      expect(counts, {1: 3, 3: 2});
      expect(counts.keys, [1, 3]);
    });

    test('plays all 36 questions', () {
      expect(distribute(36, [1, 2, 3]), {1: 12, 2: 12, 3: 12});
    });
  });

  group('drawOrder', () {
    const ids = ['a', 'b', 'c', 'd'];

    test('returns every id exactly once', () {
      final order = drawOrder(
        ids,
        weights: const {},
        lastGame: const {},
        random: Random(7),
      );
      expect(order, unorderedEquals(ids));
    });

    double shareFirst(
      String id, {
      Map<String, double> weights = const {},
      Set<String> lastGame = const {},
    }) {
      final random = Random(42);
      const runs = 30000;
      var hits = 0;
      for (var i = 0; i < runs; i++) {
        final order = drawOrder(
          const ['a', 'b'],
          weights: weights,
          lastGame: lastGame,
          random: random,
        );
        if (order.first == id) hits++;
      }
      return hits / runs;
    }

    test('picks by weight', () {
      expect(shareFirst('a', weights: const {'a': 2.0}), closeTo(2 / 3, 0.02));
    });

    test('halves the chance of questions from the last game', () {
      expect(shareFirst('a', lastGame: const {'a'}), closeTo(1 / 3, 0.02));
    });

    test('combines weight and last game', () {
      expect(
        shareFirst('a', weights: const {'a': 2.0}, lastGame: const {'a'}),
        closeTo(1 / 2, 0.02),
      );
    });
  });
}
