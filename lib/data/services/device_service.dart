import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'chime_stub.dart' if (dart.library.js_interop) 'chime_web.dart';

/// Screen, sound and vibration: the only place that calls wakelock_plus and
/// audioplayers.
class DeviceService {
  late final _player = AudioPlayer();
  final _chime = Chime();
  int _awake = 0;
  bool _audioConfigured = false;
  AppLifecycleListener? _lifecycle;

  /// Keeps the screen on until a matching [allowSleep]. Calls may nest: the
  /// four-minute look opens on top of the running game.
  void stayAwake() {
    // Browsers drop the wake lock when the page is hidden, for example during
    // a short switch to another app, and do not take it back by themselves.
    if (kIsWeb) _lifecycle ??= AppLifecycleListener(onResume: _keepOnAgain);
    if (_awake++ == 0) _keepScreenOn(true);
  }

  void _keepOnAgain() {
    if (_awake > 0) _keepScreenOn(true);
  }

  void allowSleep() {
    if (_awake > 0 && --_awake == 0) _keepScreenOn(false);
  }

  /// Called from the tap on "Starten": the browser only plays the tone at
  /// the end if sound was unlocked by a tap.
  void prepareSound() {
    if (kIsWeb) _chime.prepare().catchError(_log);
  }

  /// End of the four-minute look (US-14): a soft tone and a vibration. The
  /// vibration stays when the tone is switched off.
  Future<void> ring({required bool sound}) async {
    await HapticFeedback.vibrate();
    if (!sound) return;
    if (kIsWeb) return _chime.play().catchError(_log);
    if (!_audioConfigured) {
      // iOS "ambient": the silent switch applies and music keeps playing.
      // Android: a notification sound that takes no audio focus.
      await _player.setAudioContext(
        AudioContext(
          iOS: AudioContextIOS(category: AVAudioSessionCategory.ambient),
          android: const AudioContextAndroid(
            contentType: AndroidContentType.sonification,
            usageType: AndroidUsageType.notificationEvent,
            audioFocus: AndroidAudioFocus.none,
          ),
        ),
      );
      _audioConfigured = true;
    }
    await _player.play(AssetSource('sounds/look_end.wav'));
  }

  /// Browsers refuse the wake lock while the page is hidden. The screen may
  /// then turn off; the game goes on.
  void _keepScreenOn(bool on) =>
      WakelockPlus.toggle(enable: on).catchError(_log);

  void _log(Object error) => debugPrint('Device: $error');
}
