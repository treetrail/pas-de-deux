import 'game.dart';
import 'rating.dart';

/// A question for "Eure schönsten Momente" (US-15).
class BestMoment {
  const BestMoment({required this.questionId, required this.moved});

  final String questionId;

  /// Whose answer moved whom, one entry per "Hat mich berührt".
  final List<({String answerer, String rater})> moved;
}

/// Up to three questions with the highest sum of ratings, each with at least
/// one "Hat mich berührt". Ties keep the order of the game.
List<BestMoment> bestMoments(GameState game) {
  final candidates = <({int index, int sum, BestMoment moment})>[];
  for (var i = 0; i < game.turns.length; i++) {
    final turn = game.turns[i];
    if (!turn.ratings.contains(Rating.moved)) continue;
    final starter = game.names[game.starterOf(i)];
    final other = game.names[1 - game.starterOf(i)];
    candidates.add((
      index: i,
      sum: turn.ratings.fold(0, (sum, rating) => sum + (rating?.value ?? 0)),
      moment: BestMoment(
        questionId: turn.questionId,
        moved: [
          if (turn.ratings[0] == Rating.moved)
            (answerer: starter, rater: other),
          if (turn.ratings[1] == Rating.moved)
            (answerer: other, rater: starter),
        ],
      ),
    ));
  }
  candidates.sort(
    (a, b) => a.sum != b.sum ? b.sum.compareTo(a.sum) : a.index - b.index,
  );
  return [for (final candidate in candidates.take(3)) candidate.moment];
}
