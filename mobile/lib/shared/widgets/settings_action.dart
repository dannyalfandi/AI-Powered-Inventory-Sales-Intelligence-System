import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/l10n.dart';
import '../../core/router/app_router.dart';

/// The app-bar button to Settings, on every tab. Settings is not a tab, and
/// the Dashboard may be hidden for a role without analytics, so each tab
/// carries its own way there (language, appearance, administration, sign
/// out).
class SettingsAction extends StatelessWidget {
  const SettingsAction({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: context.l10n.settingsTitle,
    onPressed: () => context.pushNamed(AppRoutes.settings),
    icon: const Icon(Icons.settings_outlined),
  );
}
