import 'package:flutter_test/flutter_test.dart';
import 'package:pasdedeux/domain/catalog.dart';

import 'helpers.dart';

void main() {
  final catalog = loadCatalog();

  test('has 36 distinct questions, 12 per stage', () {
    expect(catalog.questions, hasLength(36));
    expect({for (final q in catalog.questions) q.id}, hasLength(36));
    for (final stage in [1, 2, 3]) {
      expect(catalog.idsOfStage(stage), hasLength(12));
    }
  });

  test('ids follow the study order', () {
    for (final question in catalog.questions) {
      expect(question.id, matches(RegExp(r'^s[123]-q(0[1-9]|1[0-2])$')));
      expect(question.id[1], '${question.stage}');
    }
  });

  test('every text exists in all five languages', () {
    for (final question in catalog.questions) {
      for (final language in supportedLanguages) {
        expect(question.text[language], isNotEmpty, reason: question.id);
      }
    }
    for (final stage in catalog.stages) {
      for (final language in supportedLanguages) {
        expect(stage.name[language], isNotEmpty);
        expect(stage.intro[language], isNotEmpty);
      }
    }
  });
}
