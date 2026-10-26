import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../app/dependencies.dart';
import '../../data/services/purchase_service.dart';
import '../../domain/catalog.dart';
import '../../l10n/app_localizations.dart';
import '../intro/intro_screen.dart';
import '../widgets/bilingual_text.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.dependencies});

  final Dependencies dependencies;

  static const _deviceLanguage = 'device';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = dependencies.settings;
    final ads = dependencies.ads;
    final purchases = dependencies.purchases;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: Listenable.merge([settings, ads, purchases]),
          builder: (context, _) => ListView(
            children: [
              _Header(l10n.language),
              RadioGroup<String>(
                groupValue: settings.settings.appLanguage ?? _deviceLanguage,
                onChanged: (value) => settings.setAppLanguage(
                  value == _deviceLanguage ? null : value,
                ),
                child: Column(
                  children: [
                    RadioListTile(
                      value: _deviceLanguage,
                      title: Text(l10n.systemLanguage),
                    ),
                    for (final code in supportedLanguages)
                      RadioListTile(
                        value: code,
                        title: Text(languageNames[code]!),
                      ),
                  ],
                ),
              ),
              _Header(l10n.lookTitle),
              SwitchListTile(
                title: Text(l10n.soundSetting),
                value: settings.settings.soundOn,
                onChanged: settings.setSoundOn,
              ),
              _Header(l10n.adFreeTitle),
              if (purchases.adFree)
                ListTile(
                  leading: const Icon(Icons.check_circle_outline),
                  title: Text(l10n.adFreeActive),
                )
              else ...[
                ListTile(
                  title: Text(
                    purchases.price == null
                        ? l10n.adFreeTitle
                        : l10n.buyAdFree(purchases.price!),
                  ),
                  subtitle: switch (purchases.state) {
                    StoreState.pending => Text(l10n.purchasePending),
                    StoreState.failed => Text(l10n.purchaseFailed),
                    StoreState.unavailable => Text(l10n.storeUnavailable),
                    StoreState.loading || StoreState.ready => null,
                  },
                  enabled:
                      purchases.price != null &&
                      purchases.state != StoreState.pending,
                  onTap: purchases.buy,
                ),
                ListTile(
                  title: Text(l10n.restorePurchases),
                  enabled: purchases.state != StoreState.unavailable,
                  onTap: purchases.restore,
                ),
              ],
              if (ads.privacyOptionsRequired)
                ListTile(
                  title: Text(l10n.privacyOptions),
                  onTap: ads.showPrivacyOptions,
                ),
              if (kDebugMode && !purchases.adFree)
                ListTile(
                  title: Text(l10n.resetConsent),
                  onTap: ads.resetConsent,
                ),
              _Header(l10n.aboutTitle),
              ListTile(
                title: Text(l10n.showIntro),
                onTap: () => Navigator.push<void>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => IntroScreen(settings: settings),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                child: Text(l10n.aboutSource),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
    child: Text(
      text,
      style: Theme.of(context).textTheme.titleSmall
          ?.copyWith(color: Theme.of(context).colorScheme.primary),
    ),
  );
}
