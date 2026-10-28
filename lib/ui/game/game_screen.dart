import 'package:flutter/material.dart';

import '../../app/theme.dart';
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
import '../widgets/design.dart';
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
            // The deeper the stage, the darker the screen.
            child: AnimatedTheme(
              data: switch (step) {
                StageIntroStep(:final stage) || TurnStep(:final stage) =>
                  AppTheme.stage(stage, Theme.of(context).brightness),
                FinishedStep() =>
                  Theme.of(context).brightness == Brightness.light
                      ? AppTheme.light
                      : AppTheme.dark,
              },
              duration: const Duration(milliseconds: 600),
              child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  titleSpacing: 24,
                  title: switch (step) {
                    AnswerStep(:final number, :final total) => Semantics(
                      label: l10n.progressSemantics(number, total),
                      child: ExcludeSemantics(
                        child: _Progress(
                          label: l10n.progress(number, total),
                          game: viewModel.game,
                        ),
                      ),
                    ),
                    StageIntroStep() ||
                    RatingStep() => _Progress(game: viewModel.game),
                    FinishedStep() when viewModel.offersLook => Text(
                      l10n.lookTitle,
                    ),
                    FinishedStep() => null,
                  },
                  actions: [
                    if (step is! FinishedStep)
                      IconButton(
                        icon: const Icon(Icons.flag_outlined),
                        tooltip: l10n.endGame,
                        onPressed: () => _confirmEnd(context),
                      ),
                    const SizedBox(width: 8),
                  ],
                ),
                body: SafeArea(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                        child: switch (step) {
                          StageIntroStep() => _StageIntroView(this, step),
                          AnswerStep() => _AnswerView(this, step),
                          RatingStep() => _RatingView(this, step),
                          FinishedStep() when viewModel.offersLook =>
                            _LookOfferView(this),
                          FinishedStep() => _FinishView(this),
                        },
                      ),
                    ),
                  ),
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
/// fonts never get cut off. [footer] sits at the bottom of the scrollable
/// part while there is room, and scrolls with the content when there is not.
class _Layout extends StatelessWidget {
  const _Layout({
    required this.content,
    required this.buttons,
    this.footer = const [],
  });

  final List<Widget> content;
  final List<Widget> footer;
  final List<Widget> buttons;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Expanded(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ...content,
                    if (footer.isNotEmpty) ...[
                      const Spacer(),
                      const SizedBox(height: 24),
                      ...footer,
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      const SizedBox(height: 16),
      ...buttons,
    ],
  );
}

/// "4 von 24" above one bar segment per stage.
class _Progress extends StatelessWidget {
  const _Progress({required this.game, this.label});

  final GameState game;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final label = this.label;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: Palette.of(context).muted,
            ),
          ),
          const SizedBox(height: 8),
        ],
        StageProgress(game: game),
      ],
    );
  }
}

class _StageIntroView extends StatelessWidget {
  const _StageIntroView(this.screen, this.step);

  final GameScreen screen;
  final StageIntroStep step;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final palette = Palette.of(context);
    final stage = screen.catalog.stage(step.stage);
    final language = Localizations.localeOf(context).languageCode;
    final second = effectiveSecondLanguage(context, screen._secondLanguage);
    return _Layout(
      content: [
        const SizedBox(height: 16),
        ExcludeSemantics(
          child: Text(
            '${step.stage}',
            textScaler: TextScaler.noScaling,
            style: textTheme.displayLarge?.copyWith(
              fontSize: 220,
              height: 0.9,
              color: palette.line,
            ),
          ),
        ),
        Semantics(
          header: true,
          label: l10n.stageTitle(step.stage, stage.nameIn(language)),
          excludeSemantics: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.stageNumber(step.stage).toUpperCase(),
                style: textTheme.labelMedium?.copyWith(color: palette.muted),
              ),
              const SizedBox(height: 8),
              Text(
                stage.nameIn(language),
                style: textTheme.displayLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        if (second != null)
          Text.rich(
            TextSpan(text: stage.nameIn(second), locale: Locale(second)),
            style: textTheme.displaySmall?.copyWith(
              fontStyle: FontStyle.italic,
              color: palette.muted,
            ),
          ),
        const SizedBox(height: 20),
        BilingualText(
          textIn: (language) => '${_capitalized(stage.introIn(language))}.',
          secondLanguage: second,
          style: textTheme.titleLarge?.copyWith(fontSize: 24),
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
    final palette = Palette.of(context);
    final question = screen.catalog.question(step.questionId);
    final sentence = step.isFirstAnswer
        ? l10n.answersFirst(step.answerer, step.holder)
        : l10n.answersNow(step.answerer, step.holder);
    // "Lena antwortet zuerst." in bold, "Jonas hält das Handy." below.
    final split = sentence.indexOf(
      '. ',
      sentence.indexOf(step.answerer) + step.answerer.length,
    );
    final (answers, holds) = split < 0
        ? (sentence, null)
        : (sentence.substring(0, split + 1), sentence.substring(split + 2));
    return _Layout(
      content: [
        const SizedBox(height: 12),
        Semantics(
          label: sentence,
          excludeSemantics: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PersonLine(
                avatar: PersonAvatar(name: step.answerer, person: step.person),
                text: Text(
                  answers,
                  style: textTheme.titleMedium?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (holds != null) ...[
                const SizedBox(height: 10),
                _PersonLine(
                  avatar: PersonAvatar(
                    name: step.holder,
                    person: 1 - step.person,
                    filled: false,
                  ),
                  text: Text(
                    holds,
                    style: textTheme.bodyLarge?.copyWith(color: palette.muted),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 40),
        ExcludeSemantics(
          child: Text(
            '“',
            textScaler: TextScaler.noScaling,
            style: textTheme.displayLarge?.copyWith(
              fontSize: 96,
              height: 0.6,
              color: palette.people[step.person],
            ),
          ),
        ),
        const SizedBox(height: 4),
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

class _PersonLine extends StatelessWidget {
  const _PersonLine({required this.avatar, required this.text});

  final Widget avatar;
  final Widget text;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      avatar,
      const SizedBox(width: 12),
      Expanded(child: text),
    ],
  );
}

class _RatingView extends StatelessWidget {
  const _RatingView(this.screen, this.step);

  final GameScreen screen;
  final RatingStep step;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final palette = Palette.of(context);
    final second = effectiveSecondLanguage(context, screen._secondLanguage);
    final secondL10n = second == null
        ? null
        : lookupAppLocalizations(Locale(second));
    Widget label(Rating rating) => Text.rich(
      textAlign: TextAlign.center,
      TextSpan(
        text: _label(l10n, rating),
        children: [
          if (secondL10n != null)
            TextSpan(
              text: '\n${_label(secondL10n, rating)}',
              locale: Locale(second!),
              style: textTheme.bodySmall?.copyWith(color: null),
            ),
        ],
      ),
    );
    // No level is preselected: after "Zurück" the phone may be with the
    // other person.
    return _Layout(
      content: [
        const SizedBox(height: 20),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: PersonAvatar(name: step.rater, person: step.person, size: 44),
        ),
        const SizedBox(height: 18),
        Text(
          l10n.ratingPrompt(step.rater, step.answerer),
          style: textTheme.headlineLarge,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(Icons.visibility_off_outlined, size: 18, color: palette.muted),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.ratingHidden,
                style: textTheme.bodyMedium?.copyWith(color: palette.muted),
              ),
            ),
          ],
        ),
      ],
      footer: [
        FilledButton.icon(
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(76),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            textStyle: textTheme.labelLarge?.copyWith(fontSize: 19),
          ),
          // Rose where the button is light, else the button's text color.
          icon: Icon(
            Icons.favorite,
            size: 24,
            color: palette.primary.computeLuminance() > 0.5
                ? palette.people[0]
                : palette.onPrimary,
          ),
          onPressed: () => screen.viewModel.rate(Rating.moved),
          label: label(Rating.moved),
        ),
        const SizedBox(height: 12),
        // Both buttons as tall as the taller one.
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (i, rating) in [
                Rating.interesting,
                Rating.okay,
              ].indexed) ...[
                if (i > 0) const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(64),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    onPressed: () => screen.viewModel.rate(rating),
                    child: label(rating),
                  ),
                ),
              ],
            ],
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
        const SizedBox(height: 48),
        const Center(child: Logo(width: 150)),
        const SizedBox(height: 40),
        Text(l10n.lookOffer, style: textTheme.headlineLarge),
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
    final palette = Palette.of(context);
    final catalog = widget.screen.catalog;
    final game = widget.screen.viewModel.game;
    final moments = bestMoments(game);
    return _Layout(
      content: [
        const SizedBox(height: 8),
        const Align(alignment: Alignment.centerLeft, child: Logo(width: 64)),
        const SizedBox(height: 12),
        Semantics(
          header: true,
          child: Text(l10n.finishTitle, style: textTheme.displaySmall),
        ),
        const SizedBox(height: 8),
        Text(
          game.names.join(' & '),
          style: textTheme.bodyMedium?.copyWith(color: palette.muted),
        ),
        const SizedBox(height: 24),
        if (moments.isEmpty)
          Text(l10n.noMoments, style: textTheme.titleLarge)
        else
          for (final (i, moment) in moments.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              // The best moment stands out in plum.
              child: Theme(
                data: i == 0
                    ? AppTheme.stage(2, Brightness.dark)
                    : Theme.of(context),
                child: _MomentCard(
                  highlighted: i == 0,
                  moment: moment,
                  question: catalog.question(moment.questionId).textIn,
                  secondLanguage: widget.screen._secondLanguage,
                ),
              ),
            ),
      ],
      buttons: [
        FilledButton(
          onPressed: () => _leave(FinishAction.newGame),
          child: Text(l10n.newGame),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => _leave(FinishAction.toStart),
          child: Text(l10n.toStart),
        ),
      ],
    );
  }
}

class _MomentCard extends StatelessWidget {
  const _MomentCard({
    required this.highlighted,
    required this.moment,
    required this.question,
    required this.secondLanguage,
  });

  final bool highlighted;
  final BestMoment moment;
  final String Function(String language) question;
  final String? secondLanguage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final palette = Palette.of(context);
    return Card(
      color: highlighted ? palette.ground : null,
      shape: highlighted
          ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(22))
          : null,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BilingualText(
              textIn: question,
              secondLanguage: secondLanguage,
              style: textTheme.titleLarge?.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 14),
            for (final pair in moment.moved)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    ExcludeSemantics(
                      child: SizedBox(
                        width: 20,
                        height: 12,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 8,
                              child: PersonDot(person: 1 - pair.person),
                            ),
                            PersonDot(person: pair.person),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        l10n.momentLine(pair.answerer, pair.rater),
                        style: textTheme.bodyMedium?.copyWith(
                          color: palette.muted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
