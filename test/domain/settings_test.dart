import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pasdedeux/domain/settings.dart';

void main() {
  test('reads settings saved before sound and introduction existed', () {
    final settings = Settings.fromJson(
      jsonDecode(
        '{"appLanguage":"de","secondLanguage":null,"stages":[1,2],'
        '"questionCount":8,"ownName":"Lena"}',
      ) as Map<String, dynamic>,
    );
    expect(settings.soundOn, isTrue);
    expect(settings.introSeen, isFalse);
    expect(settings.stages, [1, 2]);
  });

  test('survives a JSON round trip', () {
    const settings = Settings(
      appLanguage: 'fr',
      secondLanguage: 'de',
      stages: [3],
      questionCount: 5,
      ownName: 'Max',
      soundOn: false,
      introSeen: true,
    );
    final copy = Settings.fromJson(
      jsonDecode(jsonEncode(settings.toJson())) as Map<String, dynamic>,
    );
    expect(copy.toJson(), settings.toJson());
  });
}
