import 'package:flutter_test/flutter_test.dart';
import 'package:pasdedeux/data/repositories/game_repository.dart';
import 'package:pasdedeux/data/repositories/settings_repository.dart';
import 'package:pasdedeux/domain/settings.dart';

import '../fakes.dart';

void main() {
  test('treats values it cannot read as never saved', () async {
    final store = MemoryStore();
    // Cut off, wrong types inside, wrong shape: what an update that changes
    // a format or an interrupted write could leave behind.
    await store.write('savedGame', '{"names": ["Lena", "Max"], "firstSt');
    await store.write('settings', '{"stages": ["1"], "ownName": ""}');
    await store.write('weights', '["s1-q01"]');
    await store.write('lastGame', '{"s1-q01": true}');
    final games = GameRepository(store);

    expect(await games.loadSavedGame(), isNull);
    expect(await games.loadWeights(), isEmpty);
    expect(await games.loadLastGame(), isEmpty);
    expect(
      (await SettingsRepository(store).load()).toJson(),
      const Settings().toJson(),
    );
  });
}
