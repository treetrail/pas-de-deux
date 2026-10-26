import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../ui/widgets/error_notice.dart';

/// Without a crash SDK an error only reaches the device log, and a Flutter app
/// rarely crashes from one (Fehlerbehandlung). Errors from async code count
/// as handled, so they show up in the log like errors in the framework.
/// Release builds show [ErrorNotice] instead of a grey area; debug builds keep
/// the red error screen.
void handleErrors() {
  PlatformDispatcher.instance.onError = (error, stack) {
    FlutterError.presentError(
      FlutterErrorDetails(exception: error, stack: stack, library: 'app'),
    );
    return true;
  };
  if (kReleaseMode) ErrorWidget.builder = (_) => const ErrorNotice();
}
