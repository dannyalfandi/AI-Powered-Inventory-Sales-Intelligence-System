import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../providers/auth_controller.dart';

/// Shown to a logged-in user whose role opens no tab at all (no `*.view`
/// permission). Rather than a row of 403s: what is going on, and the two
/// things they can still do — Settings (language, appearance, and any admin
/// area their role does open) and signing out.
///
/// The router leaves this screen by itself as soon as a tab opens up, e.g.
/// after the permissions are refreshed when the app comes back to the
/// foreground.
class NoAccessScreen extends ConsumerWidget {
  const NoAccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock_person_outlined, size: 64, color: theme.colorScheme.primary),
                const SizedBox(height: AppSpacing.lg),
                Text(l10n.noAccessTitle, style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.noAccessMessage(user?.role.name ?? ''),
                  key: const Key('no_access_message'),
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),
                FilledButton.icon(
                  key: const Key('no_access_settings'),
                  onPressed: () => context.pushNamed(AppRoutes.settings),
                  icon: const Icon(Icons.settings_outlined),
                  label: Text(l10n.settingsTitle),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextButton.icon(
                  key: const Key('no_access_logout'),
                  onPressed: () => ref.read(authControllerProvider.notifier).logout(),
                  icon: const Icon(Icons.logout),
                  label: Text(l10n.settingsLogout),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
