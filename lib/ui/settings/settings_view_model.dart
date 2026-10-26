import 'package:flutter/widgets.dart';

import '../../data/repositories/settings_repository.dart';
import '../../domain/settings.dart';

class SettingsViewModel extends ChangeNotifier {
  SettingsViewModel({required this._repository, required this._settings});

  final SettingsRepository _repository;
  Settings _settings;

  Settings get settings => _settings;

  /// Null lets Flutter pick the device language.
  Locale? get locale {
    final language = _settings.appLanguage;
    return language == null ? null : Locale(language);
  }

  /// Choosing the second language as app language switches it off (US-19).
  Future<void> setAppLanguage(String? language) => update(
    _settings.copyWith(
      appLanguage: language,
      secondLanguage: _settings.secondLanguage == language
          ? null
          : _settings.secondLanguage,
    ),
  );

  Future<void> setSoundOn(bool on) => update(_settings.copyWith(soundOn: on));

  Future<void> markIntroSeen() => update(_settings.copyWith(introSeen: true));

  /// Part of "Alle Daten zurücksetzen": back to the state of the first start,
  /// including the introduction.
  Future<void> reset() => update(const Settings());

  Future<void> update(Settings settings) async {
    _settings = settings;
    notifyListeners();
    await _repository.save(settings);
  }
}
