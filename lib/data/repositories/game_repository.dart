import 'dart:convert';

import '../../domain/game.dart';
import '../../domain/weights.dart';
import 'key_value_store.dart';

/// The running game, the weights and the questions of the last game.
class GameRepository {
  GameRepository(this._store);

  final KeyValueStore _store;

  Future<GameState?> loadSavedGame() => _store.readJson(
    'savedGame',
    (json) => GameState.fromJson(json as Map<String, dynamic>),
  );

  /// Written after every step, so the game survives the app being killed.
  Future<void> saveGame(GameState game) =>
      _store.write('savedGame', jsonEncode(game.toJson()));

  Future<Map<String, double>> loadWeights() async =>
      await _store.readJson(
        'weights',
        (json) => (json as Map<String, dynamic>).map(
          (id, weight) => MapEntry(id, (weight as num).toDouble()),
        ),
      ) ??
      {};

  Future<Set<String>> loadLastGame() async =>
      await _store.readJson(
        'lastGame',
        (json) => {for (final id in json as List) id as String},
      ) ??
      {};

  /// Applies the ratings (US-13), remembers the shown questions for the next
  /// draw and deletes the saved game together with the second name.
  Future<void> finishGame(GameState game) async {
    final weights = applyRatings(await loadWeights(), game.turns);
    await _store.write('weights', jsonEncode(weights));
    await _store.write('lastGame', jsonEncode(game.shown));
    await _store.delete('savedGame');
  }

  /// "Gewichte zurücksetzen": every question starts again at 1.0 (US-13).
  Future<void> resetWeights() => _store.delete('weights');

  /// Part of "Alle Daten zurücksetzen": the weights, the questions of the
  /// last game and an interrupted game.
  Future<void> deleteAll() async {
    for (final key in ['weights', 'lastGame', 'savedGame']) {
      await _store.delete(key);
    }
  }
}
