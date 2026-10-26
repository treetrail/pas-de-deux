import 'package:flutter/material.dart';

import '../../app/dependencies.dart';
import '../../domain/catalog.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/bilingual_text.dart';
import 'setup_view_model.dart';

/// "Partie einstellen" (US-03 to US-06, US-19). Pops with the new game.
class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key, required this.dependencies});

  final Dependencies dependencies;

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  late final _ownName = TextEditingController(
    text: widget.dependencies.settings.settings.ownName,
  );
  final _otherName = TextEditingController();
  SetupViewModel? _viewModel;
  bool _starting = false;

  SetupViewModel get viewModel => _viewModel ??= SetupViewModel(
    settings: widget.dependencies.settings,
    games: widget.dependencies.games,
    catalog: widget.dependencies.catalog,
    appLanguage: Localizations.localeOf(context).languageCode,
  );

  @override
  void dispose() {
    _ownName.dispose();
    _otherName.dispose();
    _viewModel?.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _starting = true);
    final game = await viewModel.start(
      ownName: _ownName.text.trim(),
      otherName: _otherName.text.trim(),
      defaultOwnName: l10n.personA,
      defaultOtherName: l10n.personB,
    );
    if (mounted) Navigator.pop(context, game);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final language = Localizations.localeOf(context).languageCode;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.setupTitle)),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) => ListView(
            padding: const EdgeInsets.all(24),
            children: [
              TextField(
                controller: _ownName,
                maxLength: 20,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: l10n.yourName,
                  hintText: l10n.personA,
                ),
              ),
              TextField(
                controller: _otherName,
                maxLength: 20,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: l10n.otherName,
                  hintText: l10n.personB,
                ),
              ),
              const SizedBox(height: 16),
              Text(l10n.stagesTitle, style: textTheme.titleMedium),
              for (final stage in widget.dependencies.catalog.stages)
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: viewModel.stages.contains(stage.stage),
                  onChanged: (_) => viewModel.toggleStage(stage.stage),
                  title: Text(
                    l10n.stageLabel(
                      stage.stage,
                      stage.nameIn(language),
                      stage.introIn(language),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              if (viewModel.canStart) ...[
                Text(
                  l10n.questionCount(viewModel.count, viewModel.minutes),
                  style: textTheme.titleMedium,
                ),
                if (viewModel.maxCount > viewModel.minCount)
                  Slider(
                    value: viewModel.count.toDouble(),
                    min: viewModel.minCount.toDouble(),
                    max: viewModel.maxCount.toDouble(),
                    divisions: viewModel.maxCount - viewModel.minCount,
                    label: '${viewModel.count}',
                    onChanged: (value) => viewModel.setCount(value.round()),
                  ),
                Text(
                  l10n.distribution(viewModel.distribution.values.join(' · ')),
                ),
              ],
              const SizedBox(height: 24),
              DropdownButtonFormField<String?>(
                initialValue: viewModel.secondLanguage,
                decoration: InputDecoration(labelText: l10n.secondLanguage),
                items: [
                  DropdownMenuItem(value: null, child: Text(l10n.off)),
                  for (final code in supportedLanguages)
                    if (code != language)
                      DropdownMenuItem(
                        value: code,
                        child: Text(languageNames[code]!),
                      ),
                ],
                onChanged: viewModel.setSecondLanguage,
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: viewModel.canStart && !_starting ? _start : null,
                child: Text(l10n.startGame),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
