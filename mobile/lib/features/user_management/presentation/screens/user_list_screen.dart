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
import '../../domain/entities/managed_user.dart';
import '../../domain/grant_scope.dart';
import '../providers/user_list_provider.dart';
import '../providers/user_scope_provider.dart';

/// Every account: name, email, role and whether it can sign in. Opened from
/// Settings → Administration.
class UserListScreen extends ConsumerStatefulWidget {
  const UserListScreen({super.key});

  @override
  ConsumerState<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends ConsumerState<UserListScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.text = ref.read(userSearchQueryProvider);
    listenNearEnd(_scrollController, () => ref.read(userListProvider.notifier).loadMore());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {}); // toggles the clear button
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () => ref.read(userSearchQueryProvider.notifier).set(value));
  }

  Future<void> _refresh() async {
    ref.invalidate(userListProvider);
    try {
      await ref.read(userListProvider.future);
    } on Failure {
      // Shown by the error state of userListProvider.
    }
  }

  Future<bool> _confirmAndDelete(ManagedUser user, {required bool isSelf}) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    if (isSelf) {
      // The backend refuses it too (409); saying so here avoids the round
      // trip and makes clear it is a rule, not an error.
      messenger.showSnackBar(SnackBar(content: Text(l10n.userSelfDelete)));
      return false;
    }
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.userDeleteConfirmTitle),
        content: Text(l10n.userDeleteConfirmBody(user.name, user.email)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.commonCancel)),
          FilledButton(
            key: const Key('user_delete_confirm'),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return false;
    try {
      await ref.read(userListProvider.notifier).delete(user.id);
      unawaited(HapticFeedback.lightImpact());
      messenger.showSnackBar(SnackBar(content: Text(l10n.userDeleted(user.name))));
      return true;
    } on Failure catch (f) {
      if (!mounted) return false;
      // 403 (a Super Admin or a user beyond the caller's permissions, for a
      // non-Super-Admin) and 409 carry the backend's own sentence, already
      // in the app's language: shown as is, never matched on.
      final reason = errorMessage(context, f);
      final forbiddenOrConflict = f is ServerFailure && (f.isConflict || f.isForbidden);
      messenger.showSnackBar(SnackBar(content: Text(forbiddenOrConflict ? reason : l10n.userDeleteFailed(reason))));
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final users = ref.watch(userListProvider);
    final search = ref.watch(userSearchQueryProvider);
    final canCreate = ref.hasPermission(Permissions.usersCreate);
    final canDelete = ref.hasPermission(Permissions.usersDelete);
    final actor = ref.watch(currentUserProvider);
    final me = actor?.id;
    // Roles by id, to tell which users the caller may manage; null while
    // unknown, and then nothing is locked (the backend still decides).
    final knownRoles = ref.watch(knownRolesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.usersTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
            child: SearchBar(
              controller: _searchController,
              hintText: l10n.usersSearchHint,
              leading: const Icon(Icons.search),
              elevation: const WidgetStatePropertyAll(0),
              onChanged: _onSearchChanged,
              onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
              trailing: [
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    tooltip: l10n.commonClearSearch,
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _onSearchChanged('');
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: canCreate
          ? FloatingActionButton.extended(
              heroTag: 'user_fab',
              onPressed: () => context.pushNamed(AppRoutes.userCreate),
              icon: const Icon(Icons.person_add_alt),
              label: Text(l10n.usersAdd),
            )
          : null,
      body: users.when(
        loading: () => const SkeletonList(),
        error: (e, _) => RefreshableView(
          onRefresh: _refresh,
          child: ErrorView(message: errorMessage(context, e), onRetry: () => ref.invalidate(userListProvider)),
        ),
        data: (state) {
          if (state.items.isEmpty) {
            return RefreshableView(
              onRefresh: _refresh,
              child: EmptyView(
                icon: search.isEmpty ? Icons.people_outline : Icons.search_off,
                message: search.isEmpty ? l10n.usersEmpty : l10n.usersEmptyForSearch(search),
              ),
            );
          }
          return AppRefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: AppSpacing.listBottomInset),
              itemCount: state.items.length + 1,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) {
                if (i == state.items.length) {
                  return PagedListFooter(
                    state: state,
                    onLoadMore: () => ref.read(userListProvider.notifier).loadMore(),
                    totalLabel: (n) => l10n.usersCount(n),
                  );
                }
                final u = state.items[i];
                final isSelf = u.id == me;
                // Beyond the caller's permissions (a Super Admin, or a role
                // they don't hold in full): the backend would refuse any
                // change or delete (403), so the row is locked instead.
                final locked = actor != null && canManageUser(actor, u, knownRoles) == ManageAccess.denied;
                final tile = PressEffect(
                  child: UserTile(
                    user: u,
                    isSelf: isSelf,
                    locked: locked,
                    onTap: locked
                        ? () => ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(SnackBar(content: Text(l10n.userOutOfScope)))
                        : () => context.pushNamed(AppRoutes.userEdit, pathParameters: {'id': '${u.id}'}),
                  ),
                );
                if (!canDelete || locked) return KeyedSubtree(key: ValueKey(u.id), child: tile);
                return Dismissible(
                  key: ValueKey(u.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Theme.of(context).colorScheme.errorContainer,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                    child: const Icon(Icons.delete_outline),
                  ),
                  confirmDismiss: (_) => _confirmAndDelete(u, isSelf: isSelf),
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

class UserTile extends StatelessWidget {
  const UserTile({super.key, required this.user, required this.isSelf, this.locked = false, this.onTap});

  final ManagedUser user;
  final bool isSelf;

  /// Out of the caller's scope: a lock and a short note under the role.
  final bool locked;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      key: ValueKey('user_tile_${user.id}'),
      leading: CircleAvatar(child: Text(user.name.isEmpty ? '?' : user.name.characters.first.toUpperCase())),
      title: Row(
        children: [
          Flexible(child: Text(user.name, maxLines: 1, overflow: TextOverflow.ellipsis)),
          if (isSelf) ...[
            const SizedBox(width: AppSpacing.sm),
            Text('(${l10n.userYou})', style: TextStyle(color: scheme.primary)),
          ],
          if (locked) ...[
            const SizedBox(width: AppSpacing.sm),
            Icon(
              Icons.lock_outline,
              key: ValueKey('user_locked_${user.id}'),
              size: 16,
              color: scheme.onSurfaceVariant,
              semanticLabel: l10n.userOutOfScope,
            ),
          ],
        ],
      ),
      subtitle: Text(
        locked ? '${user.email}\n${user.roleName} · ${l10n.userOutOfScope}' : '${user.email}\n${user.roleName}',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      isThreeLine: true,
      trailing: Chip(
        key: ValueKey('user_status_${user.id}'),
        avatar: Icon(user.isActive ? Icons.check_circle_outline : Icons.block, size: 16),
        label: Text(user.isActive ? l10n.userActive : l10n.userInactive),
        visualDensity: VisualDensity.compact,
        backgroundColor: user.isActive ? null : scheme.surfaceContainerHighest,
      ),
      onTap: onTap,
    );
  }
}
