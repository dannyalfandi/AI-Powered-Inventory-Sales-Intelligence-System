import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/permissions.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/widgets/app_refresh_indicator.dart';
import '../../../../shared/widgets/paged_list.dart';
import '../../../../shared/widgets/press_effect.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../../../shared/widgets/state_views.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../domain/entities/role.dart';
import '../providers/role_list_provider.dart';

/// Every role with how much it grants and how many users have it. Opened
/// from Settings → Administration.
class RoleListScreen extends ConsumerStatefulWidget {
  const RoleListScreen({super.key});

  @override
  ConsumerState<RoleListScreen> createState() => _RoleListScreenState();
}

class _RoleListScreenState extends ConsumerState<RoleListScreen> {
  Future<void> _refresh() async {
    ref.invalidate(roleListProvider);
    try {
      await ref.read(roleListProvider.future);
    } on Failure {
      // Shown by the error state of roleListProvider.
    }
  }

  Future<bool> _confirmAndDelete(Role role) async {
    final l10n = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.roleDeleteConfirmTitle),
        content: Text(l10n.roleDeleteConfirmBody(role.name)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.commonCancel)),
          FilledButton(
            key: const Key('role_delete_confirm'),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return false;

    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(roleListProvider.notifier).delete(role.id);
      unawaited(HapticFeedback.lightImpact());
      messenger.showSnackBar(SnackBar(content: Text(l10n.roleDeleted(role.name))));
      return true;
    } on Failure catch (f) {
      if (!mounted) return false;
      final message = roleDeleteErrorMessage(context, f);
      if (f is ServerFailure && f.isConflict) {
        // The backend's sentence, as it wrote it (already in the app's
        // language): which users still hold the role, or the system lock.
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            icon: const Icon(Icons.link),
            title: Text(l10n.roleDeleteBlockedTitle),
            content: Text(message, key: const Key('role_delete_blocked_message')),
            actions: [FilledButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.commonUnderstood))],
          ),
        );
      } else {
        messenger.showSnackBar(SnackBar(content: Text(message)));
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final roles = ref.watch(roleListProvider);
    final canCreate = ref.hasPermission(Permissions.rolesCreate);
    final canDelete = ref.hasPermission(Permissions.rolesDelete);
    // The user count comes from GET /users, which needs users.view.
    final canCountUsers = ref.hasPermission(Permissions.usersView);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.rolesTitle)),
      floatingActionButton: canCreate
          ? FloatingActionButton.extended(
              heroTag: 'role_fab',
              onPressed: () => context.pushNamed(AppRoutes.roleCreate),
              icon: const Icon(Icons.add),
              label: Text(l10n.rolesAdd),
            )
          : null,
      body: roles.when(
        loading: () => const SkeletonList(),
        error: (e, _) => RefreshableView(
          onRefresh: _refresh,
          child: ErrorView(message: errorMessage(context, e), onRetry: () => ref.invalidate(roleListProvider)),
        ),
        data: (items) {
          if (items.isEmpty) {
            return RefreshableView(
              onRefresh: _refresh,
              child: EmptyView(icon: Icons.admin_panel_settings_outlined, message: l10n.rolesEmpty),
            );
          }
          return AppRefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: AppSpacing.listBottomInset),
              itemCount: items.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final role = items[i];
                final tile = PressEffect(
                  child: _RoleTile(
                    role: role,
                    showUserCount: canCountUsers,
                    onTap: () => context.pushNamed(AppRoutes.roleEdit, pathParameters: {'id': '${role.id}'}),
                  ),
                );
                // The system role can never be deleted: no swipe to offer.
                if (!canDelete || role.isSystem) return KeyedSubtree(key: ValueKey(role.id), child: tile);
                return Dismissible(
                  key: ValueKey(role.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Theme.of(context).colorScheme.errorContainer,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                    child: const Icon(Icons.delete_outline),
                  ),
                  // The provider already removed the row once the server confirmed.
                  confirmDismiss: (_) => _confirmAndDelete(role),
                  child: tile,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _RoleTile extends ConsumerWidget {
  const _RoleTile({required this.role, required this.showUserCount, required this.onTap});

  final Role role;
  final bool showUserCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final permissions = role.isSystem ? l10n.roleAllPermissions : l10n.rolePermissionCount(role.permissions.length);
    final users = showUserCount ? ref.watch(roleUserCountProvider(role.id)).value : null;
    return ListTile(
      key: ValueKey('role_tile_${role.id}'),
      leading: Icon(role.isSystem ? Icons.verified_user_outlined : Icons.badge_outlined),
      title: Row(
        children: [
          Flexible(child: Text(role.name, maxLines: 1, overflow: TextOverflow.ellipsis)),
          if (role.isSystem) ...[
            const SizedBox(width: AppSpacing.sm),
            Chip(
              label: Text(l10n.roleSystemBadge),
              visualDensity: VisualDensity.compact,
              labelStyle: theme.textTheme.labelSmall,
            ),
          ],
        ],
      ),
      subtitle: Text(users == null ? permissions : '$permissions · ${l10n.roleUserCount(users)}'),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
