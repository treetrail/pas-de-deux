import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// The tone at the end of the four-minute look in the browser. Safari plays
/// sound only after a tap, but the tone comes four minutes later. An
/// AudioContext resumed during the tap on "Starten" stays unlocked until then.
class Chime {
  web.AudioContext? _context;
  web.AudioBuffer? _buffer;

  /// Must be called synchronously from the tap.
  Future<void> prepare() async {
    final context = _context ??= web.AudioContext();
    await context.resume().toDart;
    if (_buffer != null) return;
    final response = await web.window
        .fetch('assets/assets/sounds/look_end.wav'.toJS)
        .toDart;
    final bytes = await response.arrayBuffer().toDart;
    _buffer = await context.decodeAudioData(bytes).toDart;
  }

  Future<void> play() async {
    final context = _context;
    final buffer = _buffer;
    if (context == null || buffer == null) return;
    await context.resume().toDart;
    final source = context.createBufferSource()..buffer = buffer;
    source.connect(context.destination);
    source.start();
  }
}
