import 'game.dart';
import 'rating.dart';

/// A question for "Eure schönsten Momente" (US-15).
class BestMoment {
  const BestMoment({required this.questionId, required this.moved});

  final String questionId;

  /// Whose answer moved whom, one entry per "Hat mich berührt". [person]
  /// is the index of the answerer in the game's names.
  final List<({String answerer, String rater, int person})> moved;
}

/// Up to three questions with the highest sum of ratings, each with at least
/// one "Hat mich berührt". Ties keep the order of the game.
List<BestMoment> bestMoments(GameState game) {
  final candidates = <({int index, int sum, BestMoment moment})>[];
  for (var i = 0; i < game.turns.length; i++) {
    final turn = game.turns[i];
    if (!turn.ratings.contains(Rating.moved)) continue;
    final starter = game.starterOf(i);
    final other = 1 - starter;
    candidates.add((
      index: i,
      sum: turn.ratings.fold(0, (sum, rating) => sum + (rating?.value ?? 0)),
      moment: BestMoment(
        questionId: turn.questionId,
        moved: [
          if (turn.ratings[0] == Rating.moved)
            (
              answerer: game.names[starter],
              rater: game.names[other],
              person: starter,
            ),
          if (turn.ratings[1] == Rating.moved)
            (
              answerer: game.names[other],
              rater: game.names[starter],
              person: other,
            ),
        ],
      ),
    ));
  }
  candidates.sort(
    (a, b) => a.sum != b.sum ? b.sum.compareTo(a.sum) : a.index - b.index,
  );
  return [for (final candidate in candidates.take(3)) candidate.moment];
}
