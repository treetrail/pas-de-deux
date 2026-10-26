import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The few JSON values the app keeps on the device.
abstract interface class KeyValueStore {
  Future<String?> read(String key);

  Future<void> write(String key, String value);

  Future<void> delete(String key);
}

extension JsonValues on KeyValueStore {
  /// Null if the value is missing or cannot be read any more, for example
  /// after an update changed its format. The app then starts as if the value
  /// had never been saved, instead of not starting at all.
  Future<T?> readJson<T>(String key, T Function(Object? json) decode) async {
    final text = await read(key);
    if (text == null) return null;
    try {
      return decode(jsonDecode(text));
    } catch (error) {
      debugPrint('Unreadable $key: $error');
      return null;
    }
  }
}

class PreferencesStore implements KeyValueStore {
  final _preferences = SharedPreferencesAsync();

  @override
  Future<String?> read(String key) => _preferences.getString(key);

  @override
  Future<void> write(String key, String value) =>
      _preferences.setString(key, value);

  @override
  Future<void> delete(String key) => _preferences.remove(key);
}
