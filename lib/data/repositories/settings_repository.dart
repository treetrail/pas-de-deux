import 'dart:convert';

import '../../domain/settings.dart';
import 'key_value_store.dart';

class SettingsRepository {
  SettingsRepository(this._store);

  final KeyValueStore _store;

  Future<Settings> load() async {
    final json = await _store.read('settings');
    return json == null
        ? const Settings()
        : Settings.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  Future<void> save(Settings settings) =>
      _store.write('settings', jsonEncode(settings.toJson()));
}
