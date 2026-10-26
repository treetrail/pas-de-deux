import 'package:flutter/material.dart';

const languageNames = {
  'de': 'Deutsch',
  'en': 'English',
  'es': 'Español',
  'it': 'Italiano',
  'fr': 'Français',
};

/// The second language, unless it equals the app language.
String? effectiveSecondLanguage(BuildContext context, String? second) =>
    second == Localizations.localeOf(context).languageCode ? null : second;

/// A text in the app language and, if chosen, in a second language below it
/// (US-19). Both are equally large, separated by a line and marked with
/// their code. Each part carries its locale, so VoiceOver and TalkBack read
/// it with the matching voice.
class BilingualText extends StatelessWidget {
  const BilingualText({
    super.key,
    required this.textIn,
    required this.secondLanguage,
    this.style,
  });

  final String Function(String language) textIn;
  final String? secondLanguage;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final language = Localizations.localeOf(context).languageCode;
    final second = effectiveSecondLanguage(context, secondLanguage);
    if (second == null) return Text(textIn(language), style: style);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Part(language: language, text: textIn(language), style: style),
        const Divider(height: 32),
        _Part(language: second, text: textIn(second), style: style),
      ],
    );
  }
}

class _Part extends StatelessWidget {
  const _Part({required this.language, required this.text, this.style});

  final String language;
  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExcludeSemantics(
          child: Text(
            language.toUpperCase(),
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text.rich(
          TextSpan(text: text, locale: Locale(language)),
          style: style,
        ),
      ],
    );
  }
}
