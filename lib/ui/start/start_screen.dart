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

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  GameState? _savedGame;

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
    unawaited(_dependencies.ads.start());
    await _loadSavedGame(resume: true);
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
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: l10n.settings,
            onPressed: _openSettings,
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
                          const Logo(),
                          const SizedBox(height: 28),
                          Text(
                            l10n.appTitle,
                            textAlign: TextAlign.center,
                            style: textTheme.displayMedium,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            l10n.appSubtitle,
                            textAlign: TextAlign.center,
                            style: textTheme.bodyLarge?.copyWith(
                              color: palette.muted,
                            ),
                          ),
                          const SizedBox(height: 48),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          FilledButton(
                            onPressed: _setUp,
                            child: Text(l10n.newGame),
                          ),
                          if (savedGame != null) ...[
                            const SizedBox(height: 12),
                            OutlinedButton(
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
                          Text(
                            l10n.startTagline,
                            textAlign: TextAlign.center,
                            style: textTheme.bodyMedium?.copyWith(
                              color: palette.muted,
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
