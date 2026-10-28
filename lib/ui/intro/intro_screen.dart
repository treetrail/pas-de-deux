import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../settings/settings_view_model.dart';

/// Introduction on the first start, again from the settings (US-02): where
/// the questions come from, how a turn works, how long it takes.
class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key, required this.settings});

  final SettingsViewModel settings;

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  static const _pageCount = 3;
  final _pages = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await widget.settings.markIntroSeen();
    if (mounted) Navigator.pop(context);
  }

  void _next() {
    if (_page == _pageCount - 1) {
      _finish();
    } else {
      _pages.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pages = [
      (l10n.introTitle1, l10n.introBody1),
      (l10n.introTitle2, l10n.introBody2),
      (l10n.introTitle3, l10n.introBody3),
    ];
    return PopScope(
      // Leaving by gesture counts as skipping.
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) widget.settings.markIntroSeen();
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // In the body rather than the app bar, so it may wrap at large
              // font sizes.
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: TextButton(onPressed: _finish, child: Text(l10n.skip)),
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pages,
                  onPageChanged: (page) => setState(() => _page = page),
                  children: [
                    for (final (title, body) in pages)
                      _IntroPage(title: title, body: body),
                  ],
                ),
              ),
              Semantics(
                label: l10n.introPage(_page + 1, _pageCount),
                child: ExcludeSemantics(
                  child: _PageDots(page: _page, count: _pageCount),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: FilledButton(
                  onPressed: _next,
                  child: Text(
                    _page == _pageCount - 1 ? l10n.startGame : l10n.next,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IntroPage extends StatelessWidget {
  const _IntroPage({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: textTheme.displaySmall),
          const SizedBox(height: 24),
          Text(body, style: textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.page, required this.count});

  final int page;
  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: i == page ? 20 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: i == page ? colors.primary : colors.outlineVariant,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
      ],
    );
  }
}
