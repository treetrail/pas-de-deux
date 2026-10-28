import 'package:flutter/material.dart';

import '../../data/services/ads_service.dart';
import '../../data/services/device_service.dart';
import '../../domain/catalog.dart';
import '../../domain/game.dart';
import '../../domain/moments.dart';
import '../../domain/rating.dart';
import '../../l10n/app_localizations.dart';
import '../look/look_screen.dart';
import '../settings/settings_view_model.dart';
import '../widgets/bilingual_text.dart';
import '../widgets/keep_screen_on.dart';
import 'game_view_model.dart';

/// What the person on the finish view chose. Returned when the route pops.
enum FinishAction { newGame, toStart }

/// The whole game is one screen. What it shows follows from the game state:
/// stage intro, answer or rating, at the end the offer of the four-minute
/// look and the summary. "Zurück" is a step in the state, not a change of
/// route. The screen stays on while the game runs.
class GameScreen extends StatelessWidget {
  const GameScreen({
    super.key,
    required this.catalog,
    required this.settings,
    required this.ads,
    required this.device,
    required this.viewModel,
  });

  final Catalog catalog;
  final SettingsViewModel settings;
  final AdsService ads;
  final DeviceService device;
  final GameViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final step = viewModel.step;
        // Android's back gesture and the back button go one step back.
        // On iOS the edge swipe is blocked while canPop is false. On the
        // first question both leave to the start, the game stays saved.
        return PopScope(
          canPop: !viewModel.canGoBack,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop && viewModel.canGoBack) viewModel.back();
          },
          child: KeepScreenOn(
            device: device,
            enabled: step is! FinishedStep,
            child: Scaffold(
              appBar: AppBar(
                title: switch (step) {
                  AnswerStep(:final number, :final total) => Semantics(
                    label: l10n.progressSemantics(number, total),
                    child: ExcludeSemantics(
                      child: Text(l10n.progress(number, total)),
                    ),
                  ),
                  FinishedStep() when viewModel.offersLook => Text(
                    l10n.lookTitle,
                  ),
                  FinishedStep() => Text(l10n.finishTitle),
                  _ => null,
                },
                actions: [
                  if (step is! FinishedStep)
                    IconButton(
                      icon: const Icon(Icons.flag_outlined),
                      tooltip: l10n.endGame,
                      onPressed: () => _confirmEnd(context),
                    ),
                ],
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: switch (step) {
                    StageIntroStep() => _StageIntroView(this, step),
                    AnswerStep() => _AnswerView(this, step),
                    RatingStep() => _RatingView(this, step),
                    FinishedStep() when viewModel.offersLook => _LookOfferView(
                      this,
                    ),
                    FinishedStep() => _FinishView(this),
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String? get _secondLanguage => settings.settings.secondLanguage;

  Future<void> _confirmEnd(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final end = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.endGameQuestion),
        content: Text(l10n.endGameBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.confirmEnd),
          ),
        ],
      ),
    );
    if (end ?? false) viewModel.end();
  }
}

/// Scrollable content above a fixed row of buttons, so long texts and large
/// fonts never get cut off.
class _Layout extends StatelessWidget {
  const _Layout({required this.content, required this.buttons});

  final List<Widget> content;
  final List<Widget> buttons;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: content,
          ),
        ),
      ),
      const SizedBox(height: 16),
      ...buttons,
    ],
  );
}

class _StageIntroView extends StatelessWidget {
  const _StageIntroView(this.screen, this.step);

  final GameScreen screen;
  final StageIntroStep step;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final stage = screen.catalog.stage(step.stage);
    final language = Localizations.localeOf(context).languageCode;
    final second = effectiveSecondLanguage(context, screen._secondLanguage);
    return _Layout(
      content: [
        const SizedBox(height: 32),
        Text(
          l10n.stageTitle(step.stage, stage.nameIn(language)),
          style: textTheme.headlineMedium,
        ),
        if (second != null)
          Text.rich(
            TextSpan(text: stage.nameIn(second), locale: Locale(second)),
            style: textTheme.titleLarge,
          ),
        const SizedBox(height: 24),
        BilingualText(
          textIn: (language) => _capitalized(stage.introIn(language)),
          secondLanguage: second,
          style: textTheme.titleLarge,
        ),
      ],
      buttons: [
        FilledButton(onPressed: screen.viewModel.next, child: Text(l10n.next)),
      ],
    );
  }

  static String _capitalized(String text) =>
      text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);
}

class _AnswerView extends StatelessWidget {
  const _AnswerView(this.screen, this.step);

  final GameScreen screen;
  final AnswerStep step;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final question = screen.catalog.question(step.questionId);
    return _Layout(
      content: [
        Text(
          step.isFirstAnswer
              ? l10n.answersFirst(step.answerer, step.holder)
              : l10n.answersNow(step.answerer, step.holder),
          style: textTheme.titleMedium,
        ),
        const SizedBox(height: 24),
        BilingualText(
          textIn: question.textIn,
          secondLanguage: screen._secondLanguage,
          style: textTheme.headlineSmall,
        ),
      ],
      buttons: [
        FilledButton(onPressed: screen.viewModel.next, child: Text(l10n.next)),
        if (step.canSkip)
          TextButton(onPressed: screen.viewModel.skip, child: Text(l10n.skip)),
      ],
    );
  }
}

class _RatingView extends StatelessWidget {
  const _RatingView(this.screen, this.step);

  final GameScreen screen;
  final RatingStep step;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final second = effectiveSecondLanguage(context, screen._secondLanguage);
    final secondL10n = second == null
        ? null
        : lookupAppLocalizations(Locale(second));
    return _Layout(
      content: [
        Text(
          l10n.ratingPrompt(step.rater, step.answerer),
          style: textTheme.headlineSmall,
        ),
        const SizedBox(height: 32),
        // No level is preselected: after "Zurück" the phone may be with the
        // other person.
        for (final rating in Rating.values)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: FilledButton.tonal(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              onPressed: () => screen.viewModel.rate(rating),
              child: Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                  text: _label(l10n, rating),
                  children: [
                    if (secondL10n != null)
                      TextSpan(
                        text: '\n${_label(secondL10n, rating)}',
                        locale: Locale(second!),
                        style: textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
            ),
          ),
      ],
      buttons: [
        TextButton(
          onPressed: () => screen.viewModel.rate(null),
          child: Text(l10n.continueWithoutRating),
        ),
      ],
    );
  }

  static String _label(AppLocalizations l10n, Rating rating) =>
      switch (rating) {
        Rating.moved => l10n.ratingMoved,
        Rating.interesting => l10n.ratingInteresting,
        Rating.okay => l10n.ratingOkay,
      };
}

/// After the last question (US-14): one sentence, then the look or skip.
class _LookOfferView extends StatefulWidget {
  const _LookOfferView(this.screen);

  final GameScreen screen;

  @override
  State<_LookOfferView> createState() => _LookOfferViewState();
}

class _LookOfferViewState extends State<_LookOfferView> {
  @override
  void initState() {
    super.initState();
    // Four minutes are enough for the interstitial to be ready at the end.
    widget.screen.ads.preloadInterstitial();
  }

  Future<void> _startLook() async {
    final screen = widget.screen;
    if (screen.settings.settings.soundOn) screen.device.prepareSound();
    await Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => LookScreen(
          device: screen.device,
          sound: screen.settings.settings.soundOn,
        ),
      ),
    );
    screen.viewModel.finishLook();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    return _Layout(
      content: [
        const SizedBox(height: 32),
        Text(l10n.lookOffer, style: textTheme.headlineSmall),
      ],
      buttons: [
        FilledButton(onPressed: _startLook, child: Text(l10n.lookStart)),
        TextButton(
          onPressed: widget.screen.viewModel.finishLook,
          child: Text(l10n.skip),
        ),
      ],
    );
  }
}

class _FinishView extends StatefulWidget {
  const _FinishView(this.screen);

  final GameScreen screen;

  @override
  State<_FinishView> createState() => _FinishViewState();
}

class _FinishViewState extends State<_FinishView> {
  @override
  void initState() {
    super.initState();
    widget.screen.ads.preloadInterstitial();
  }

  void _leave(FinishAction action) {
    widget.screen.ads.showInterstitialIfReady();
    Navigator.pop(context, action);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final catalog = widget.screen.catalog;
    final moments = bestMoments(widget.screen.viewModel.game);
    return _Layout(
      content: [
        if (moments.isEmpty)
          Text(l10n.noMoments, style: textTheme.titleLarge)
        else
          for (final moment in moments)
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    BilingualText(
                      textIn: catalog.question(moment.questionId).textIn,
                      secondLanguage: widget.screen._secondLanguage,
                      style: textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    for (final pair in moment.moved)
                      Text(
                        l10n.momentLine(pair.answerer, pair.rater),
                        style: textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                  ],
                ),
              ),
            ),
      ],
      buttons: [
        FilledButton(
          onPressed: () => _leave(FinishAction.newGame),
          child: Text(l10n.newGame),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () => _leave(FinishAction.toStart),
          child: Text(l10n.toStart),
        ),
      ],
    );
  }
}
