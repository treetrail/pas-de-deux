import 'dart:math';

/// Splits [count] questions over the chosen [stages] (US-06).
///
/// Each stage gets count ÷ k, the remainder goes to the lowest stages first:
/// 10 questions on three stages give 4, 3 and 3.
Map<int, int> distribute(int count, List<int> stages) {
  final sorted = [...stages]..sort();
  final base = count ~/ sorted.length;
  final rest = count % sorted.length;
  return {
    for (var i = 0; i < sorted.length; i++)
      sorted[i]: base + (i < rest ? 1 : 0),
  };
}

/// Draws all [ids] one after another without replacement (US-13).
///
/// Each open id is picked with probability w · f divided by the sum over all
/// open ids. w comes from [weights] (1.0 if missing), f is 0.5 for ids shown
/// in the last game and 1.0 otherwise. The result is a complete order: the
/// first ids are played, the rest replace skipped questions.
List<String> drawOrder(
  List<String> ids, {
  required Map<String, double> weights,
  required Set<String> lastGame,
  required Random random,
}) {
  double score(String id) =>
      (weights[id] ?? 1.0) * (lastGame.contains(id) ? 0.5 : 1.0);

  final open = [...ids];
  final order = <String>[];
  while (open.isNotEmpty) {
    final total = open.fold(0.0, (sum, id) => sum + score(id));
    var pick = random.nextDouble() * total;
    var index = 0;
    while (index < open.length - 1) {
      pick -= score(open[index]);
      if (pick < 0) break;
      index++;
    }
    order.add(open.removeAt(index));
  }
  return order;
}
