import 'package:flutter/material.dart';

import '../../app/dependencies.dart';
import '../../app/theme.dart';
import '../../domain/catalog.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/bilingual_text.dart';
import '../widgets/design.dart';
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
    final palette = Palette.of(context);
    final brightness = Theme.of(context).brightness;
    final language = Localizations.localeOf(context).languageCode;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.setupTitle)),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) => ListView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            children: [
              _NameField(
                controller: _ownName,
                person: 0,
                label: l10n.yourName,
                hint: l10n.personA,
              ),
              const SizedBox(height: 4),
              _NameField(
                controller: _otherName,
                person: 1,
                label: l10n.otherName,
                hint: l10n.personB,
              ),
              const SizedBox(height: 16),
              _SectionTitle(l10n.stagesTitle),
              const SizedBox(height: 10),
              for (final stage in widget.dependencies.catalog.stages)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _StageCard(
                    theme: AppTheme.stage(stage.stage, brightness),
                    number: stage.stage,
                    name: stage.nameIn(language),
                    intro: stage.introIn(language),
                    label: l10n.stageLabel(
                      stage.stage,
                      stage.nameIn(language),
                      stage.introIn(language),
                    ),
                    selected: viewModel.stages.contains(stage.stage),
                    onTap: () => viewModel.toggleStage(stage.stage),
                  ),
                ),
              const SizedBox(height: 24),
              if (viewModel.canStart) ...[
                Text(
                  l10n.questionCount(viewModel.count, viewModel.minutes),
                  style: textTheme.titleLarge,
                ),
                if (viewModel.maxCount > viewModel.minCount)
                  Slider(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    value: viewModel.count.toDouble(),
                    min: viewModel.minCount.toDouble(),
                    max: viewModel.maxCount.toDouble(),
                    divisions: viewModel.maxCount - viewModel.minCount,
                    label: '${viewModel.count}',
                    onChanged: (value) => viewModel.setCount(value.round()),
                  )
                else
                  const SizedBox(height: 12),
                ExcludeSemantics(
                  child: Row(
                    children: [
                      for (final (i, entry)
                          in viewModel.distribution.entries
                              .where((entry) => entry.value > 0)
                              .indexed) ...[
                        if (i > 0) const SizedBox(width: 6),
                        Expanded(
                          flex: entry.value,
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: _stageColor(entry.key, brightness),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.distribution(viewModel.distribution.values.join(' · ')),
                  style: textTheme.bodyMedium?.copyWith(color: palette.muted),
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

  /// Stage 1 is a light ground; its bar needs to stand out from the page.
  static Color _stageColor(int stage, Brightness brightness) {
    final palette = AppTheme.stage(stage, brightness).extension<Palette>()!;
    return stage == 1 ? palette.track : palette.ground;
  }
}

class _NameField extends StatelessWidget {
  const _NameField({
    required this.controller,
    required this.person,
    required this.label,
    required this.hint,
  });

  final TextEditingController controller;
  final int person;
  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    maxLength: 20,
    textCapitalization: TextCapitalization.words,
    style: Theme.of(context).textTheme.bodyLarge,
    decoration: InputDecoration(
      labelText: label,
      hintText: hint,
      counterText: '',
      prefixIcon: Center(
        widthFactor: 1,
        child: Padding(
          padding: const EdgeInsets.only(left: 18, right: 12),
          child: PersonDot(person: person, size: 14),
        ),
      ),
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Semantics(
    header: true,
    child: Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.labelMedium
          ?.copyWith(color: Palette.of(context).muted),
    ),
  );
}

/// A stage in its own colors, so the setup already shows how the game gets
/// darker.
class _StageCard extends StatelessWidget {
  const _StageCard({
    required this.theme,
    required this.number,
    required this.name,
    required this.intro,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final ThemeData theme;
  final int number;
  final String name;
  final String intro;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final page = Palette.of(context);
    final palette = theme.extension<Palette>()!;
    final text = theme.textTheme;
    return Semantics(
      label: label,
      checked: selected,
      onTap: onTap,
      excludeSemantics: true,
      child: Material(
        color: palette.ground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: selected ? page.ink : page.line,
            width: selected ? 2 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 12, 16, 12),
            child: Row(
              children: [
                SizedBox(
                  width: 36,
                  child: Text(
                    '$number',
                    style: text.displaySmall?.copyWith(fontSize: 32),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: text.titleSmall?.copyWith(fontSize: 16),
                      ),
                      Text(
                        intro,
                        style: text.bodyMedium?.copyWith(color: palette.muted),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  selected ? Icons.check_circle : Icons.radio_button_unchecked,
                  size: 24,
                  color: palette.ink,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
