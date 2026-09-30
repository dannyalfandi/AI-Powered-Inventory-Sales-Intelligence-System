import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../../../shared/widgets/state_views.dart';
import '../../../auth/domain/entities/auth_user.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../domain/entities/role.dart';
import '../providers/role_form_provider.dart';
import '../providers/role_list_provider.dart';

/// Checkboxes over the whole permission catalog, grouped the way the API
/// groups it (`resource_group`). Saving sends the complete desired list —
/// PUT /roles/:id/permissions replaces, it doesn't merge.
class RolePermissionEditorScreen extends ConsumerWidget {
  const RolePermissionEditorScreen({super.key, required this.roleId});

  final int roleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(roleFormProvider(roleId));
    final catalog = ref.watch(permissionCatalogProvider);

    Widget body;
    if (role.hasError || catalog.hasError) {
      body = ErrorView(
        message: errorMessage(context, (role.error ?? catalog.error)!),
        onRetry: () {
          ref.invalidate(roleFormProvider(roleId));
          ref.invalidate(permissionCatalogProvider);
        },
      );
    } else if (role.value case final r? when catalog.hasValue) {
      body = _Editor(role: r, catalog: catalog.requireValue, actor: ref.watch(currentUserProvider));
    } else {
      body = const SkeletonLines(lines: 12);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(role.value == null ? context.l10n.rolePermissionsSection : context.l10n.permissionEditorTitle(role.value!.name)),
      ),
      body: body,
    );
  }
}

class _Editor extends ConsumerStatefulWidget {
  const _Editor({required this.role, required this.catalog, required this.actor});

  final Role role;
  final List<CatalogPermission> catalog;

  /// The logged-in user: a non-system user can only grant what they hold.
  final AuthUser? actor;

  @override
  ConsumerState<_Editor> createState() => _EditorState();
}

class _EditorState extends ConsumerState<_Editor> {
  late final Set<String> _initial = widget.role.permissions.toSet();
  late final Set<String> _selected = {..._initial};
  bool _saving = false;

  late final List<PermissionGroup> _groups = groupPermissions(widget.catalog);

  bool get _dirty => _selected.length != _initial.length || !_selected.containsAll(_initial);

  /// Whether the actor may hand out [key]. The backend refuses (403) a list
  /// containing anything a non-system user doesn't hold, so those boxes are
  /// shown but locked instead of letting the save fail.
  bool _grantable(String key) => widget.actor?.can(key) ?? false;

  void _toggle(String key, bool on) => setState(() => on ? _selected.add(key) : _selected.remove(key));

  void _toggleGroup(PermissionGroup g, bool on) => setState(() {
    for (final p in g.permissions) {
      if (!_grantable(p.key)) continue;
      on ? _selected.add(p.key) : _selected.remove(p.key);
    }
  });

  Future<void> _save() async {
    setState(() => _saving = true);
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    // The full desired state, in catalog order.
    final keys = [
      for (final p in widget.catalog)
        if (_selected.contains(p.key)) p.key,
    ];
    try {
      await ref.read(roleFormProvider(widget.role.id).notifier).savePermissions(keys);
      if (!mounted) return;
      unawaited(HapticFeedback.lightImpact());
      messenger.showSnackBar(SnackBar(content: Text(l10n.permissionEditorSaved)));
      context.pop(true);
    } on Failure catch (f) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(l10n.permissionEditorSaveFailed(errorMessage(context, f)))));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final limited = widget.actor != null && !widget.actor!.role.isSystem;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            children: [
              if (limited)
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0),
                  child: Text(
                    l10n.permissionEditorNotHeld,
                    key: const Key('permission_editor_not_held'),
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ),
              for (final g in _groups) ...[
                _GroupHeader(
                  group: g,
                  label: permissionGroupLabel(l10n, g.code),
                  selected: g.permissions.where((p) => _selected.contains(p.key)).length,
                  enabled: g.permissions.any((p) => _grantable(p.key)),
                  onChanged: (on) => _toggleGroup(g, on),
                ),
                for (final p in g.permissions)
                  CheckboxListTile(
                    key: Key('permission_${p.key}'),
                    value: _selected.contains(p.key),
                    onChanged: _saving || !_grantable(p.key) ? null : (v) => _toggle(p.key, v ?? false),
                    title: Text(p.description),
                    subtitle: Text(p.key, style: theme.textTheme.bodySmall),
                    dense: true,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
              ],
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.md),
            decoration: BoxDecoration(border: Border(top: BorderSide(color: theme.dividerColor))),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.permissionEditorSelected(_selected.length, widget.catalog.length),
                    key: const Key('permission_editor_count'),
                  ),
                ),
                FilledButton(
                  key: const Key('permission_editor_save'),
                  onPressed: _saving || !_dirty ? null : _save,
                  child: _saving
                      ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(l10n.permissionEditorSave),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// A group title with a tri-state box: all / some / none of its permissions.
class _GroupHeader extends StatelessWidget {
  const _GroupHeader({
    required this.group,
    required this.label,
    required this.selected,
    required this.enabled,
    required this.onChanged,
  });

  final PermissionGroup group;
  final String label;
  final int selected;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final total = group.permissions.length;
    final bool? value = selected == 0 ? false : (selected == total ? true : null);
    return CheckboxListTile(
      key: Key('permission_group_${group.code}'),
      tristate: true,
      value: value,
      // Tapping a partly selected group selects the rest.
      onChanged: enabled ? (_) => onChanged(value != true) : null,
      title: Text(label, style: Theme.of(context).textTheme.titleSmall),
      subtitle: Text('$selected / $total'),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}

/// The label of a backend `resource_group`. The grouping itself comes from
/// the API; only the names are translated here, and a group the app doesn't
/// know yet is shown under its code rather than hidden.
String permissionGroupLabel(AppLocalizations l10n, String code) => switch (code) {
  'products' => l10n.permissionGroupProducts,
  'categories' => l10n.permissionGroupCategories,
  'inventory' => l10n.permissionGroupInventory,
  'customers' => l10n.permissionGroupCustomers,
  'sales_orders' => l10n.permissionGroupSalesOrders,
  'analytics' => l10n.permissionGroupAnalytics,
  'users' => l10n.permissionGroupUsers,
  'roles' => l10n.permissionGroupRoles,
  _ => code,
};
