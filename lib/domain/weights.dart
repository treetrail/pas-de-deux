import 'game.dart';
import 'rating.dart';

/// Applies the rules of US-13 to every turn with at least one rating.
///
/// Average of 1.5 or more: weight × 1.2. Both chose "Okay": weight × 0.7.
/// The result stays between 0.3 and 3.0, so no question drops out.
Map<String, double> applyRatings(
  Map<String, double> weights,
  Iterable<Turn> turns,
) {
  final result = {...weights};
  for (final turn in turns) {
    final given = turn.ratings.whereType<Rating>().toList();
    if (given.isEmpty) continue;
    final average =
        given.fold(0, (sum, rating) => sum + rating.value) / given.length;
    var weight = result[turn.questionId] ?? 1.0;
    if (average >= 1.5) {
      weight *= 1.2;
    } else if (given.length == 2 && given.every((r) => r == Rating.okay)) {
      weight *= 0.7;
    }
    result[turn.questionId] = weight.clamp(0.3, 3.0);
  }
  return result;
}
