import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../data/services/device_service.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/keep_screen_on.dart';
import 'look_view_model.dart';

/// Four minutes of looking at each other (US-14): a dark, calm screen that
/// shows only the remaining time. Leaving it ends the look early.
class LookScreen extends StatefulWidget {
  const LookScreen({
    super.key,
    required this.device,
    required this.sound,
    this.stopwatch,
  });

  final DeviceService device;
  final bool sound;

  /// For tests.
  final Stopwatch? stopwatch;

  @override
  State<LookScreen> createState() => _LookScreenState();
}

class _LookScreenState extends State<LookScreen> with WidgetsBindingObserver {
  late final _viewModel = LookViewModel(
    device: widget.device,
    sound: widget.sound,
    stopwatch: widget.stopwatch,
  )..start();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _viewModel.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _viewModel.setInBackground(false);
      case AppLifecycleState.hidden ||
          AppLifecycleState.paused ||
          AppLifecycleState.detached:
        _viewModel.setInBackground(true);
      case AppLifecycleState.inactive:
        // Still visible, e.g. under the notification shade.
        break;
    }
  }

  static String _clock(Duration time) {
    final seconds = (time.inMilliseconds / 1000).ceil();
    return '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Theme(
      data: AppTheme.look,
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          return ListenableBuilder(
            listenable: _viewModel,
            builder: (context, _) {
              final running = _viewModel.phase == LookPhase.running;
              final clock = _clock(_viewModel.remaining);
              return KeepScreenOn(
                device: widget.device,
                enabled: running,
                child: Scaffold(
                  backgroundColor: theme.colorScheme.surface,
                  body: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Spacer(),
                          if (running)
                            Semantics(
                              label: l10n.lookRemaining(clock),
                              child: ExcludeSemantics(
                                child: Text(
                                  clock,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            )
                          else
                            Text(
                              l10n.lookDone,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.headlineSmall,
                            ),
                          const Spacer(),
                          if (running)
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(l10n.cancel),
                            )
                          else
                            FilledButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(l10n.next),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
