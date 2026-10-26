import 'dart:convert';

import '../../domain/settings.dart';
import 'key_value_store.dart';

class SettingsRepository {
  SettingsRepository(this._store);

  final KeyValueStore _store;

  Future<Settings> load() async =>
      await _store.readJson(
        'settings',
        (json) => Settings.fromJson(json as Map<String, dynamic>),
      ) ??
      const Settings();

  Future<void> save(Settings settings) =>
      _store.write('settings', jsonEncode(settings.toJson()));
}
