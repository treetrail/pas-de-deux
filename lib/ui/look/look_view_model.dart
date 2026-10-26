import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/services/device_service.dart';

enum LookPhase { running, done }

/// The four-minute look (US-14). The remaining time comes from a monotonic
/// stopwatch and is computed anew every second instead of counted down, so
/// it is still right after a short switch to another app.
class LookViewModel extends ChangeNotifier {
  LookViewModel({
    required this._device,
    required this._sound,
    Stopwatch? stopwatch,
    this.duration = const Duration(minutes: 4),
  }) : _stopwatch = stopwatch ?? Stopwatch();

  final DeviceService _device;
  final bool _sound;
  final Stopwatch _stopwatch;
  final Duration duration;
  Timer? _ticker;
  bool _inBackground = false;
  LookPhase _phase = LookPhase.running;

  LookPhase get phase => _phase;

  Duration get remaining {
    final left = duration - _stopwatch.elapsed;
    return left.isNegative ? Duration.zero : left;
  }

  void start() {
    _stopwatch.start();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    notifyListeners();
  }

  /// Version 1 has no notifications: a look that ends while the app is in
  /// the background ends without sound. Whoever comes back sees that the
  /// time is up.
  void setInBackground(bool inBackground) {
    _inBackground = inBackground;
    if (!inBackground &&
        _phase == LookPhase.running &&
        remaining == Duration.zero) {
      _finish(ring: false);
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _tick() {
    if (_inBackground) return;
    if (remaining == Duration.zero) {
      _finish(ring: true);
    } else {
      notifyListeners();
    }
  }

  void _finish({required bool ring}) {
    _ticker?.cancel();
    _stopwatch.stop();
    _phase = LookPhase.done;
    notifyListeners();
    if (ring) unawaited(_device.ring(sound: _sound));
  }
}
