import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// Screen, sound and vibration: the only place that calls wakelock_plus and
/// audioplayers.
class DeviceService {
  late final _player = AudioPlayer();
  int _awake = 0;
  bool _audioConfigured = false;

  /// Keeps the screen on until a matching [allowSleep]. Calls may nest: the
  /// four-minute look opens on top of the running game.
  void stayAwake() {
    if (_awake++ == 0) WakelockPlus.enable();
  }

  void allowSleep() {
    if (_awake > 0 && --_awake == 0) WakelockPlus.disable();
  }

  /// End of the four-minute look (US-14): a soft tone and a vibration. The
  /// vibration stays when the tone is switched off.
  Future<void> ring({required bool sound}) async {
    await HapticFeedback.vibrate();
    if (!sound) return;
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
}
