import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/dependencies.dart';
import '../../app/features.dart';
import '../../app/theme.dart';
import '../../data/services/purchase_service.dart';
import '../../domain/game.dart';
import '../../l10n/app_localizations.dart';
import '../game/game_screen.dart';
import '../game/game_view_model.dart';
import '../intro/intro_screen.dart';
import '../settings/settings_screen.dart';
import '../setup/setup_screen.dart';
import '../widgets/banner_slot.dart';
import '../widgets/design.dart';

/// The start screen opens every other screen and comes back here. On the
/// first start the introduction comes first (US-02), then the consent
/// dialog. If a game was interrupted, the app goes straight back into it
/// (US-11).
class StartScreen extends StatefulWidget {
  const StartScreen({super.key, required this.dependencies});

  final Dependencies dependencies;

  /// Whether the opening has played since the app started.
  @visibleForTesting
  static bool opened = false;

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with SingleTickerProviderStateMixin {
  GameState? _savedGame;

  /// The opening plays once per start of the app: the two circles dance in,
  /// meet, and the rest of the screen follows.
  late final _opening = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3500),
    value: StartScreen.opened ? 1 : 0,
  );
  late final _dance = _part(0, 1300, const Cubic(0.25, 0.8, 0.25, 1));
  late final _meet = _part(1150, 1850, Curves.easeOutBack);
  late final _digits = _part(1550, 2050);
  late final _title = _part(1700, 2400);
  late final _subtitle = _part(1900, 2600);
  late final _newGame = _part(2100, 2700);
  late final _resume = _part(2200, 2800);
  late final _rest = _part(2400, 3200);
  late final _leftLoop = _part(2500, 3200, Curves.easeInOut);
  late final _rightLoop = _part(2800, 3500, Curves.easeInOut);

  Animation<double> _part(
    int from,
    int to, [
    Curve curve = const Cubic(0.2, 0.8, 0.2, 1),
  ]) => CurvedAnimation(
    parent: _opening,
    curve: Interval(from / 3500, to / 3500, curve: curve),
  );

  Dependencies get _dependencies => widget.dependencies;

  @override
  void initState() {
    super.initState();
    // The start screen comes first, nothing waits for the network.
    WidgetsBinding.instance.addPostFrameCallback((_) => _firstFrame());
  }

  Future<void> _firstFrame() async {
    if (!_dependencies.settings.settings.introSeen) {
      await Navigator.push<void>(
        context,
        MaterialPageRoute(
          builder: (_) => IntroScreen(settings: _dependencies.settings),
        ),
      );
    }
    if (!mounted) return;
    _open();
    unawaited(_dependencies.ads.start());
    await _loadSavedGame(resume: true);
  }

  void _open() {
    if (StartScreen.opened) return;
    StartScreen.opened = true;
    // "Reduce motion" shows the screen at once.
    if (MediaQuery.disableAnimationsOf(context)) {
      _opening.value = 1;
    } else {
      _opening.forward();
    }
  }

  @override
  void dispose() {
    _opening.dispose();
    super.dispose();
  }

  Future<void> _loadSavedGame({bool resume = false}) async {
    final saved = await _dependencies.games.loadSavedGame();
    if (!mounted) return;
    setState(() => _savedGame = saved);
    if (resume && saved != null) await _play(saved);
  }

  Future<void> _play(GameState game) async {
    final action = await Navigator.push<FinishAction>(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(
          catalog: _dependencies.catalog,
          settings: _dependencies.settings,
          ads: _dependencies.ads,
          device: _dependencies.device,
          viewModel: GameViewModel(repository: _dependencies.games, game: game),
        ),
      ),
    );
    await _loadSavedGame();
    if (action == FinishAction.newGame) await _setUp();
  }

  Future<void> _setUp() async {
    final game = await Navigator.push<GameState>(
      context,
      MaterialPageRoute(
        builder: (_) => SetupScreen(dependencies: _dependencies),
      ),
    );
    if (game != null) await _play(game);
  }

  Future<void> _openSettings() async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => SettingsScreen(dependencies: _dependencies),
      ),
    );
    // "Alle Daten zurücksetzen" deletes an interrupted game.
    await _loadSavedGame();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final palette = Palette.of(context);
    final purchases = _dependencies.purchases;
    final savedGame = _savedGame;
    return Scaffold(
      appBar: AppBar(
        // A little something for the two of them, without a function.
        leading: Center(
          child: InfinitySign(left: _leftLoop, right: _rightLoop),
        ),
        leadingWidth: 64,
        actions: [
          FadeTransition(
            opacity: _rest,
            child: IconButton(
              icon: const Icon(Icons.tune),
              tooltip: l10n.settings,
              onPressed: _openSettings,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(28, 0, 28, 32),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 32,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 24),
                          Logo(dance: _dance, meet: _meet, digits: _digits),
                          const SizedBox(height: 28),
                          _Rise(
                            animation: _title,
                            child: Text(
                              l10n.appTitle,
                              textAlign: TextAlign.center,
                              style: textTheme.displayMedium,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _Rise(
                            animation: _subtitle,
                            child: Text(
                              l10n.appSubtitle,
                              textAlign: TextAlign.center,
                              style: textTheme.bodyLarge?.copyWith(
                                color: palette.muted,
                              ),
                            ),
                          ),
                          const SizedBox(height: 48),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _Rise(
                            animation: _newGame,
                            child: FilledButton(
                              onPressed: _setUp,
                              child: Text(l10n.newGame),
                            ),
                          ),
                          if (savedGame != null) ...[
                            const SizedBox(height: 12),
                            _Rise(
                              animation: _resume,
                              child: OutlinedButton(
                                onPressed: () => _play(savedGame),
                                child: Text.rich(
                                  TextSpan(
                                    text: l10n.resumeGame,
                                    children: [
                                      TextSpan(
                                        text:
                                            ' · ${l10n.progress(savedGame.turnIndex + 1, savedGame.turns.length)}',
                                        style: TextStyle(
                                          color: palette.muted,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                          ListenableBuilder(
                            listenable: purchases,
                            builder: (context, _) =>
                                !storeFeatures ||
                                    purchases.adFree ||
                                    purchases.state == StoreState.unavailable
                                ? const SizedBox.shrink()
                                : Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: TextButton(
                                      onPressed: _openSettings,
                                      child: Text(l10n.adFreeHint),
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 26),
                          FadeTransition(
                            opacity: _rest,
                            child: Text(
                              l10n.startTagline,
                              textAlign: TextAlign.center,
                              style: textTheme.bodyMedium?.copyWith(
                                color: palette.muted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BannerSlot(
        ads: _dependencies.ads,
        purchases: purchases,
      ),
    );
  }
}

/// Fades in while rising a little.
class _Rise extends StatelessWidget {
  const _Rise({required this.animation, required this.child});

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: animation,
    child: AnimatedBuilder(
      animation: animation,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, 18 * (1 - animation.value)),
        child: child,
      ),
      child: child,
    ),
  );
}
