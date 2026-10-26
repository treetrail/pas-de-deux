import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pasdedeux/data/repositories/game_repository.dart';
import 'package:pasdedeux/data/repositories/settings_repository.dart';
import 'package:pasdedeux/data/services/ads_service.dart';
import 'package:pasdedeux/domain/catalog.dart';
import 'package:pasdedeux/domain/game.dart';
import 'package:pasdedeux/domain/rating.dart';
import 'package:pasdedeux/domain/settings.dart';
import 'package:pasdedeux/l10n/app_localizations.dart';
import 'package:pasdedeux/ui/game/game_screen.dart';
import 'package:pasdedeux/ui/game/game_view_model.dart';
import 'package:pasdedeux/ui/settings/settings_view_model.dart';

import '../fakes.dart';
import '../helpers.dart';

final catalog = loadCatalog();

/// Pushes the game on top of a start page, as the app does.
Future<GameViewModel> pumpGame(
  WidgetTester tester, {
  required GameState game,
  MemoryStore? store,
  String language = 'de',
  String? secondLanguage = 'es',
  double textScale = 1,
}) async {
  tester.view.physicalSize = const Size(360, 640) * 3;
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  store ??= MemoryStore();
  final viewModel = GameViewModel(
    repository: GameRepository(store),
    game: game,
  );
  final settings = SettingsViewModel(
    repository: SettingsRepository(store),
    settings: Settings(secondLanguage: secondLanguage),
  );
  await tester.pumpWidget(
    MaterialApp(
      locale: Locale(language),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(textScale)),
        child: child!,
      ),
      home: const Scaffold(body: Text('start')),
    ),
  );
  tester
      .state<NavigatorState>(find.byType(Navigator))
      .push(
        MaterialPageRoute<void>(
          builder: (_) => GameScreen(
            catalog: catalog,
            settings: settings,
            ads: AdsService(),
            viewModel: viewModel,
          ),
        ),
      );
  await tester.pumpAndSettle();
  return viewModel;
}

/// A game whose first question is [questionId], followed by a stage change.
GameState gameAt(String questionId) => GameState(
  names: const ['Lena', 'Max'],
  firstStarter: 0,
  turns: [
    Turn(questionId: questionId, stage: int.parse(questionId[1])),
    questionId.startsWith('s3')
        ? const Turn(questionId: 's1-q01', stage: 1)
        : const Turn(questionId: 's3-q01', stage: 3),
  ],
  reserves: const {1: [], 2: [], 3: []},
  shown: [questionId],
  turnIndex: 0,
  phase: Phase.firstAnswer,
);

String longestQuestion(String language) =>
    (catalog.questions.toList()..sort(
          (a, b) => b.textIn(language).length - a.textIn(language).length,
        ))
        .first
        .id;

void main() {
  testWidgets('marks the second language for screen readers', (tester) async {
    final semantics = tester.ensureSemantics();
    final game = startGame();
    await pumpGame(tester, game: game);

    final question = catalog.question(game.turns.first.questionId);
    final node = tester.getSemantics(find.text(question.textIn('es')));
    final locales = [
      for (final attribute in node.attributedLabel.attributes)
        if (attribute is LocaleStringAttribute) attribute.locale,
    ];
    expect(locales, [const Locale('es')]);
    expect(find.text(question.textIn('de')), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('fits the longest questions at double font size', (tester) async {
    for (final language in supportedLanguages) {
      final second = language == 'de' ? 'fr' : 'de';
      final viewModel = await pumpGame(
        tester,
        game: gameAt(longestQuestion(language)),
        language: language,
        secondLanguage: second,
        textScale: 2,
      );
      expect(tester.takeException(), isNull, reason: 'question, $language');

      viewModel.next();
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'rating, $language');

      viewModel.rate(null);
      viewModel.next();
      viewModel.rate(null);
      await tester.pumpAndSettle();
      expect(viewModel.step, isA<StageIntroStep>());
      expect(tester.takeException(), isNull, reason: 'stage, $language');
    }
  });

  testWidgets('meets the accessibility guidelines', (tester) async {
    final semantics = tester.ensureSemantics();
    final viewModel = await pumpGame(tester, game: startGame());
    for (var i = 0; i < 2; i++) {
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      viewModel.next();
      await tester.pumpAndSettle();
    }
    semantics.dispose();
  });

  testWidgets('reads the progress as "Frage 1 von 10"', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpGame(tester, game: startGame());
    expect(find.bySemanticsLabel('Frage 1 von 10'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('Android back goes one step back, on the first question to '
      'the start', (tester) async {
    final viewModel = await pumpGame(tester, game: startGame());
    viewModel.next();
    await tester.pumpAndSettle();
    expect(viewModel.step, isA<RatingStep>());

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(viewModel.step, isA<AnswerStep>());
    expect(find.byType(GameScreen), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(GameScreen), findsNothing);
    expect(find.text('start'), findsOneWidget);
  });

  testWidgets(
    'iOS edge swipe is blocked inside the game, allowed on the first question',
    (tester) async {
      final viewModel = await pumpGame(tester, game: startGame());
      viewModel.next();
      await tester.pumpAndSettle();

      await tester.dragFrom(const Offset(5, 300), const Offset(300, 0));
      await tester.pumpAndSettle();
      expect(find.byType(GameScreen), findsOneWidget);
      expect(viewModel.step, isA<RatingStep>());

      viewModel.back();
      await tester.pumpAndSettle();
      await tester.dragFrom(const Offset(5, 300), const Offset(300, 0));
      await tester.pumpAndSettle();
      expect(find.byType(GameScreen), findsNothing);
    },
    variant: TargetPlatformVariant.only(TargetPlatform.iOS),
  );

  testWidgets('saves after every step and cleans up at the end', (
    tester,
  ) async {
    final store = MemoryStore();
    final repository = GameRepository(store);
    final viewModel = await pumpGame(
      tester,
      game: startGame(stages: [1], count: 1),
      store: store,
    );
    final id = viewModel.game.turns.first.questionId;

    viewModel.next();
    await tester.runAsync(() => viewModel.pendingWrites);
    expect((await repository.loadSavedGame())!.phase, Phase.firstRating);

    viewModel.rate(Rating.moved);
    viewModel.next();
    viewModel.rate(Rating.interesting);
    await tester.pumpAndSettle();
    await tester.runAsync(() => viewModel.pendingWrites);

    expect(viewModel.step, isA<FinishedStep>());
    expect(await repository.loadSavedGame(), isNull);
    expect((await repository.loadWeights())[id], closeTo(1.2, 1e-9));
    expect(await repository.loadLastGame(), {id});
    expect(find.textContaining('hat'), findsOneWidget);
    expect(debugDefaultTargetPlatformOverride, isNull);
  });
}
