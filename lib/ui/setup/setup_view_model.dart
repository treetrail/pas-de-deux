import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../data/repositories/game_repository.dart';
import '../../domain/catalog.dart';
import '../../domain/game.dart';
import '../../domain/selection.dart';
import '../settings/settings_view_model.dart';

class SetupViewModel extends ChangeNotifier {
  SetupViewModel({
    required SettingsViewModel settings,
    required this._games,
    required this._catalog,
    required String appLanguage,
    Random? random,
  }) : _settings = settings,
       _random = random ?? Random(),
       _stages = {...settings.settings.stages},
       _count = settings.settings.questionCount,
       _secondLanguage = settings.settings.secondLanguage == appLanguage
           ? null
           : settings.settings.secondLanguage;

  final SettingsViewModel _settings;
  final GameRepository _games;
  final Catalog _catalog;
  final Random _random;
  final Set<int> _stages;

  /// Null plays all questions of the chosen stages (US-05).
  int? _count;
  String? _secondLanguage;

  List<int> get stages => [..._stages]..sort();

  String? get secondLanguage => _secondLanguage;

  bool get canStart => _stages.isNotEmpty;

  int get minCount => _stages.length;

  int get maxCount => _stages.length * 12;

  int get count =>
      canStart ? (_count ?? maxCount).clamp(minCount, maxCount) : 0;

  /// 75 seconds per question, 45 minutes for all 36.
  int get minutes => (count * 75 / 60).round();

  Map<int, int> get distribution =>
      canStart ? distribute(count, stages) : const {};

  void toggleStage(int stage) {
    if (!_stages.remove(stage)) _stages.add(stage);
    notifyListeners();
  }

  void setCount(int count) {
    _count = count == maxCount ? null : count;
    notifyListeners();
  }

  void setSecondLanguage(String? language) {
    _secondLanguage = language;
    notifyListeners();
  }

  /// Saves the choices and draws the new game. A saved game that is replaced
  /// counts like a finished one for weights and "last game".
  Future<GameState> start({
    required String ownName,
    required String otherName,
    required String defaultOwnName,
    required String defaultOtherName,
  }) async {
    await _settings.update(
      _settings.settings.copyWith(
        ownName: ownName,
        stages: stages,
        questionCount: _count,
        secondLanguage: _secondLanguage,
      ),
    );
    final saved = await _games.loadSavedGame();
    if (saved != null) await _games.finishGame(saved);
    final game = GameState.start(
      catalog: _catalog,
      names: [
        ownName.isEmpty ? defaultOwnName : ownName,
        otherName.isEmpty ? defaultOtherName : otherName,
      ],
      stages: stages,
      count: count,
      weights: await _games.loadWeights(),
      lastGame: await _games.loadLastGame(),
      random: _random,
    );
    await _games.saveGame(game);
    return game;
  }
}
