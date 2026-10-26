import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:pasdedeux/domain/catalog.dart';
import 'package:pasdedeux/domain/game.dart';

Catalog loadCatalog() => Catalog.fromJson(
  jsonDecode(File('assets/questions.json').readAsStringSync())
      as Map<String, dynamic>,
);

GameState startGame({
  List<int> stages = const [1, 2, 3],
  int count = 10,
  Map<String, double> weights = const {},
  Set<String> lastGame = const {},
  int seed = 1,
}) => GameState.start(
  catalog: loadCatalog(),
  names: const ['Lena', 'Max'],
  stages: stages,
  count: count,
  weights: weights,
  lastGame: lastGame,
  random: Random(seed),
);
