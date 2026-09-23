import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/locale/locale_provider.dart';
import '../../../../core/theme/appearance_provider.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/theme/app_accent.dart';
import '../../../../shared/theme/app_motion.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_status_colors.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/theme/app_typography.dart';

/// Settings: language and appearance.
///
/// It is reached from the Dashboard app bar rather than a sixth tab — five
/// destinations already fill the bottom bar on a phone, and settings are
/// something you open now and then, not a place you navigate between.
///
/// Every control here applies immediately. None of them is destructive or
/// costly to undo, so an "Apply" step would only add a tap between the user
/// and the thing they are trying to see; the preview card exists so they can
/// see the accent on a real card without hunting for one.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final language = ref.watch(languageControllerProvider);
    final themeMode = ref.watch(themeModeControllerProvider);
    final accent = ref.watch(accentControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xl),
        children: [
          _SectionHeader(title: l10n.settingsLanguageSection, subtitle: l10n.settingsLanguageSubtitle),
          RadioGroup<AppLanguage>(
            groupValue: language,
            onChanged: (value) {
              if (value != null) ref.read(languageControllerProvider.notifier).select(value);
            },
            child: Column(
              children: [
                for (final option in AppLanguage.values)
                  RadioListTile<AppLanguage>(
                    key: ValueKey('language_option_${option.code}'),
                    value: option,
                    title: Text(_languageLabel(l10n, option)),
                    secondary: const Icon(Icons.translate),
                  ),
              ],
            ),
          ),

          const Divider(height: AppSpacing.xl),

          _SectionHeader(title: l10n.settingsAppearanceSection),
          const Padding(
            padding: EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
            child: _AccentPreview(),
          ),

          _Subheading(l10n.settingsThemeMode, subtitle: l10n.settingsThemeSubtitle),
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
            child: SegmentedButton<ThemeMode>(
              key: const Key('theme_mode_selector'),
              showSelectedIcon: false,
              segments: [
                ButtonSegment(
                  value: ThemeMode.system,
                  icon: const Icon(Icons.brightness_auto_outlined),
                  label: Text(l10n.settingsThemeSystem),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  icon: const Icon(Icons.light_mode_outlined),
                  label: Text(l10n.settingsThemeLight),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  icon: const Icon(Icons.dark_mode_outlined),
                  label: Text(l10n.settingsThemeDark),
                ),
              ],
              selected: {themeMode},
              onSelectionChanged: (s) => ref.read(themeModeControllerProvider.notifier).select(s.first),
            ),
          ),

          _Subheading(l10n.settingsAccent, subtitle: l10n.settingsAccentSubtitle),
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
            child: Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: [
                for (final option in AppAccent.values)
                  _AccentSwatch(
                    accent: option,
                    selected: option == accent,
                    label: _accentLabel(l10n, option),
                    onTap: () => ref.read(accentControllerProvider.notifier).select(option),
                  ),
              ],
            ),
          ),

          const Divider(height: AppSpacing.xl),

          _SectionHeader(title: l10n.settingsAboutSection),
          ListTile(
            leading: const Icon(Icons.payments_outlined),
            title: Text(l10n.settingsCurrencyNote),
            dense: true,
          ),
        ],
      ),
    );
  }

  /// Each language is written in its own language, the way language pickers
  /// usually are: "English" stays English even while the app is Indonesian.
  String _languageLabel(AppLocalizations l10n, AppLanguage language) => switch (language) {
        AppLanguage.english => l10n.settingsLanguageEnglish,
        AppLanguage.indonesian => l10n.settingsLanguageIndonesian,
      };

  String _accentLabel(AppLocalizations l10n, AppAccent accent) => switch (accent) {
        AppAccent.teal => l10n.settingsAccentTeal,
        AppAccent.indigo => l10n.settingsAccentIndigo,
        AppAccent.violet => l10n.settingsAccentViolet,
        AppAccent.magenta => l10n.settingsAccentMagenta,
        AppAccent.amber => l10n.settingsAccentAmber,
        AppAccent.slate => l10n.settingsAccentSlate,
      };
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        subtitle == null ? AppSpacing.sm : AppSpacing.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary)),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}

class _Subheading extends StatelessWidget {
  const _Subheading(this.title, {this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleSmall),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}

/// A miniature of the things the accent actually touches: a metric, a filled
/// button and a status badge. Cheaper to read than repainting the whole app in
/// your head, and it shows the one thing people get wrong about accent
/// pickers — that the green "up" badge is *not* part of the accent.
class _AccentPreview extends StatelessWidget {
  const _AccentPreview();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final positive = AppStatusColors.of(context).positive;

    return AnimatedContainer(
      key: const Key('accent_preview'),
      duration: AppMotion.durationOf(context, AppMotion.normal),
      curve: AppMotion.emphasized,
      padding: AppSpacing.allMd,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: AppRadius.mdAll,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.settingsPreviewMetric,
                  style: theme.textTheme.metricLabel?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  formatRupiah(12450000),
                  style: theme.textTheme.metric?.copyWith(color: theme.colorScheme.onSurface),
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
                  decoration: BoxDecoration(color: positive.container, borderRadius: AppRadius.smAll),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.trending_up, size: 14, color: positive.onContainer),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        l10n.settingsPreviewPositive,
                        style: theme.textTheme.labelSmall?.copyWith(color: positive.onContainer),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          FilledButton(
            onPressed: () {},
            child: Text(l10n.settingsPreviewAction),
          ),
        ],
      ),
    );
  }
}

/// One accent option: a circle of the colour it produces, with the check mark
/// drawn in that palette's own `onPrimary` so the tick is always legible.
class _AccentSwatch extends StatelessWidget {
  const _AccentSwatch({
    required this.accent,
    required this.selected,
    required this.label,
    required this.onTap,
  });

  final AppAccent accent;
  final bool selected;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // The swatch shows the primary the seed actually resolves to, not the raw
    // seed — that is the colour the buttons will be.
    final preview = AppTheme.light(accent).colorScheme;
    final dark = theme.brightness == Brightness.dark;
    final scheme = dark ? AppTheme.dark(accent).colorScheme : preview;

    return Semantics(
      button: true,
      selected: selected,
      label: selected ? context.l10n.settingsAccentSelected(label) : label,
      child: Tooltip(
        message: label,
        child: InkWell(
          key: ValueKey('accent_option_${accent.code}'),
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          child: AnimatedContainer(
            duration: AppMotion.durationOf(context, AppMotion.fast),
            curve: AppMotion.enter,
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: scheme.primary,
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? theme.colorScheme.onSurface : Colors.transparent,
                width: 3,
              ),
            ),
            child: selected ? Icon(Icons.check, size: 22, color: scheme.onPrimary) : null,
          ),
        ),
      ),
    );
  }
}
