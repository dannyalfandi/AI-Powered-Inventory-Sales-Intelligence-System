import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/permissions.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/l10n/field_issue_text.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../../../shared/widgets/state_views.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../domain/entities/role.dart';
import '../providers/role_form_provider.dart';

/// Create a role (`roleId == null`), or view/edit one: name, description,
/// and the way into its permissions. What is editable follows the user's
/// permissions; the system role's name is locked.
class RoleFormScreen extends ConsumerWidget {
  const RoleFormScreen({super.key, this.roleId});

  final int? roleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(roleFormProvider(roleId));
    return Scaffold(
      appBar: AppBar(title: Text(role.value?.name ?? (roleId == null ? context.l10n.roleNew : context.l10n.roleEdit))),
      body: role.when(
        skipLoadingOnRefresh: true,
        skipLoadingOnReload: true,
        loading: () => const SkeletonForm(fields: 2),
        error: (e, _) =>
            ErrorView(message: errorMessage(context, e), onRetry: () => ref.invalidate(roleFormProvider(roleId))),
        data: (r) => _RoleForm(roleId: roleId, initial: r),
      ),
    );
  }
}

class _RoleForm extends ConsumerStatefulWidget {
  const _RoleForm({required this.roleId, required this.initial});

  final int? roleId;
  final Role? initial;

  @override
  ConsumerState<_RoleForm> createState() => _RoleFormState();
}

class _RoleFormState extends ConsumerState<_RoleForm> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.initial?.name);
  late final _description = TextEditingController(text: widget.initial?.description);

  Map<String, String> _serverErrors = const {};
  bool _submitting = false;

  bool get _isEdit => widget.roleId != null;

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  void _clearServerError(String field) {
    if (_serverErrors.containsKey(field)) setState(() => _serverErrors = {..._serverErrors}..remove(field));
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() => _serverErrors = const {});
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    try {
      final saved = await ref
          .read(roleFormProvider(widget.roleId).notifier)
          .save(RoleInput(name: _name.text, description: _description.text));
      if (!mounted) return;
      unawaited(HapticFeedback.lightImpact());
      if (_isEdit) {
        messenger.showSnackBar(SnackBar(content: Text(l10n.roleUpdated)));
      } else {
        messenger.showSnackBar(SnackBar(content: Text(l10n.roleCreated(saved.name))));
        // A new role has no permissions yet: continue on its page, where
        // they are assigned, rather than back to the list.
        context.pushReplacementNamed(AppRoutes.roleEdit, pathParameters: {'id': '${saved.id}'});
      }
    } on ValidationFailure catch (f) {
      setState(() => _serverErrors = {
        ...f.messages,
        for (final e in f.issues.entries) e.key: context.messageFor(e.value) ?? '',
      });
      _formKey.currentState!.validate();
    } on Failure catch (f) {
      if (!mounted) return;
      if (f is ServerFailure && f.isConflict) {
        // Duplicate name, or the system role's lock: the backend's sentence.
        setState(() => _serverErrors = {'name': f.message});
        _formKey.currentState!.validate();
        return;
      }
      messenger.showSnackBar(SnackBar(content: Text(l10n.roleSaveFailed(errorMessage(context, f)))));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final role = widget.initial;
    final isSystem = role?.isSystem ?? false;
    final canSave = _isEdit ? ref.hasPermission(Permissions.rolesUpdate) : ref.hasPermission(Permissions.rolesCreate);
    final canAssign = ref.hasPermission(Permissions.rolesAssignPermissions);

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          if (isSystem) ...[
            Card(
              key: const Key('role_system_note'),
              child: ListTile(leading: const Icon(Icons.verified_user_outlined), title: Text(l10n.roleSystemNote)),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          TextFormField(
            key: const Key('role_form_name'),
            controller: _name,
            readOnly: !canSave || isSystem,
            decoration: InputDecoration(labelText: l10n.roleFieldName),
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            inputFormatters: [LengthLimitingTextInputFormatter(RoleRules.nameMaxLength)],
            onChanged: (_) => _clearServerError('name'),
            validator: (v) => context.messageFor(RoleRules.validateName(v ?? '')) ?? _serverErrors['name'],
          ),
          const SizedBox(height: AppSpacing.lg),
          TextFormField(
            key: const Key('role_form_description'),
            controller: _description,
            readOnly: !canSave,
            decoration: InputDecoration(labelText: l10n.roleFieldDescription),
            minLines: 2,
            maxLines: 4,
            onChanged: (_) => _clearServerError('description'),
            validator: (_) => _serverErrors['description'],
          ),
          if (canSave) ...[
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              key: const Key('role_form_submit'),
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(_isEdit ? l10n.commonSaveChanges : l10n.rolesAdd),
            ),
          ],
          if (role != null) ...[
            const SizedBox(height: AppSpacing.xl),
            _PermissionSummary(role: role, canAssign: canAssign && !isSystem),
          ],
        ],
      ),
    );
  }
}

/// What the role grants, and — for users who may — the way to change it.
class _PermissionSummary extends StatelessWidget {
  const _PermissionSummary({required this.role, required this.canAssign});

  final Role role;
  final bool canAssign;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final keys = role.permissions;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.rolePermissionsSection, style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              role.isSystem ? l10n.roleAllPermissions : l10n.rolePermissionCount(keys.length),
              key: const Key('role_permission_count'),
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            if (!role.isSystem && keys.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [for (final k in keys) Chip(label: Text(k), visualDensity: VisualDensity.compact)],
              ),
            ],
            if (canAssign) ...[
              const SizedBox(height: AppSpacing.md),
              OutlinedButton.icon(
                key: const Key('role_edit_permissions'),
                onPressed: () => context.pushNamed(AppRoutes.rolePermissions, pathParameters: {'id': '${role.id}'}),
                icon: const Icon(Icons.checklist),
                label: Text(l10n.roleEditPermissions),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
