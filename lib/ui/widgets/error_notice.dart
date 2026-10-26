import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// Shown in release builds instead of a widget that failed to build
/// (Fehlerbehandlung). It may stand for a whole screen or a small part of
/// one, even above the MaterialApp, so it needs nothing from above.
class ErrorNotice extends StatelessWidget {
  const ErrorNotice({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n =
        Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        lookupAppLocalizations(const Locale('en'));
    final navigator = Navigator.maybeOf(context);
    final route = ModalRoute.of(context);
    // The game is saved after every step, so the start can resume it.
    final canGoToStart = navigator != null && route != null && !route.isFirst;
    return Directionality(
      textDirection: Directionality.maybeOf(context) ?? TextDirection.ltr,
      child: Material(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.errorTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  canGoToStart ? l10n.errorBody : l10n.errorRestart,
                  textAlign: TextAlign.center,
                ),
                if (canGoToStart) ...[
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () =>
                        navigator.popUntil((route) => route.isFirst),
                    child: Text(l10n.toStart),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
