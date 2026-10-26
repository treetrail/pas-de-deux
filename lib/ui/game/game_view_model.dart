import 'package:flutter/foundation.dart';

import '../../data/repositories/game_repository.dart';
import '../../domain/game.dart';
import '../../domain/rating.dart';

class GameViewModel extends ChangeNotifier {
  GameViewModel({required this._repository, required this._game});

  final GameRepository _repository;
  GameState _game;
  Future<void> _writes = Future.value();
  bool _endedEarly = false;
  bool _lookDone = false;

  GameState get game => _game;

  GameStep get step => _game.step;

  bool get canGoBack => _game.canGoBack;

  /// The four-minute look follows the last question, not "Partie beenden"
  /// (US-11, US-14).
  bool get offersLook => _game.finished && !_endedEarly && !_lookDone;

  /// After the look or after skipping it: on to the summary.
  void finishLook() {
    _lookDone = true;
    notifyListeners();
  }

  void next() => _update(_game.next());

  void rate(Rating? rating) => _update(_game.rate(rating));

  void skip() => _update(_game.skip());

  void back() => _update(_game.back());

  void end() {
    _endedEarly = true;
    _update(_game.end());
  }

  /// Saves after every step (US-11). Writes run one after another, so the
  /// final cleanup never races an older save.
  void _update(GameState game) {
    _game = game;
    notifyListeners();
    _writes = _writes.then(
      (_) => game.finished
          ? _repository.finishGame(game)
          : _repository.saveGame(game),
    );
  }

  /// For tests: completes when all writes so far are done.
  @visibleForTesting
  Future<void> get pendingWrites => _writes;
}
