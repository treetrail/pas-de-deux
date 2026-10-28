import 'dart:math';

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
          final palette = Palette.of(context);
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
                          if (running) ...[
                            Semantics(
                              label: l10n.lookRemaining(clock),
                              child: ExcludeSemantics(
                                child: _Ring(
                                  share:
                                      _viewModel.remaining.inMilliseconds /
                                      _viewModel.duration.inMilliseconds,
                                  clock: clock,
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                            Text(
                              l10n.lookPrompt,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontStyle: FontStyle.italic,
                                color: palette.muted,
                              ),
                            ),
                          ] else
                            Text(
                              l10n.lookDone,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.headlineLarge,
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

/// The remaining time as a thin ring that empties clockwise. A dot in each
/// person's color marks its ends; they meet when the time is up.
class _Ring extends StatelessWidget {
  const _Ring({required this.share, required this.clock});

  final double share;
  final String clock;

  @override
  Widget build(BuildContext context) {
    final palette = Palette.of(context);
    final side = min(MediaQuery.sizeOf(context).width - 48, 320.0);
    return Center(
      child: SizedBox.square(
        dimension: side,
        child: CustomPaint(
          painter: _RingPainter(share: share, palette: palette),
          child: Center(
            child: Text(
              clock,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 64,
                color: const Color(0xFFC9B5BE),
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.share, required this.palette});

  final double share;
  final Palette palette;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 8;
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, stroke..color = palette.track);
    final sweep = 2 * pi * share.clamp(0, 1);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweep,
      false,
      stroke..color = palette.primary,
    );
    Offset at(double angle) => center + Offset(cos(angle), sin(angle)) * radius;
    final dot = Paint();
    canvas.drawCircle(at(-pi / 2), 6, dot..color = palette.people[0]);
    canvas.drawCircle(at(-pi / 2 + sweep), 6, dot..color = palette.people[1]);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.share != share || old.palette != palette;
}
