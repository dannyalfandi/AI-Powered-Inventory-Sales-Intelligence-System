import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/locale/locale_provider.dart';

/// Settings: today only the language.
///
/// It is reached from the Dashboard app bar rather than a sixth tab — five
/// destinations already fill the bottom bar on a phone, and settings are
/// something you open now and then, not a place you navigate between.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final selected = ref.watch(languageControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(
              l10n.settingsLanguageSection,
              style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              l10n.settingsLanguageSubtitle,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ),
          RadioGroup<AppLanguage>(
            groupValue: selected,
            onChanged: (value) {
              if (value != null) ref.read(languageControllerProvider.notifier).select(value);
            },
            child: Column(
              children: [
                for (final language in AppLanguage.values)
                  RadioListTile<AppLanguage>(
                    key: ValueKey('language_option_${language.code}'),
                    value: language,
                    title: Text(_label(l10n, language)),
                    secondary: const Icon(Icons.translate),
                  ),
              ],
            ),
          ),
          const Divider(height: 32),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
            child: Text(
              l10n.settingsAboutSection,
              style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary),
            ),
          ),
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
  String _label(AppLocalizations l10n, AppLanguage language) => switch (language) {
    AppLanguage.english => l10n.settingsLanguageEnglish,
    AppLanguage.indonesian => l10n.settingsLanguageIndonesian,
  };
}
