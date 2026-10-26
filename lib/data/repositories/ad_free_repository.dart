import 'key_value_store.dart';

/// Purchase status of "Werbefrei". "Alle Daten zurücksetzen" keeps it.
class AdFreeRepository {
  AdFreeRepository(this._store);

  final KeyValueStore _store;

  Future<bool> load() async => await _store.read('adFree') == 'true';

  Future<void> save() => _store.write('adFree', 'true');
}
