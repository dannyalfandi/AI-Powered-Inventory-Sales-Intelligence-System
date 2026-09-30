import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/permissions.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/l10n/field_issue_text.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../../../shared/widgets/state_views.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../../role_management/domain/entities/role.dart';
import '../../../role_management/presentation/providers/role_list_provider.dart';
import '../../domain/entities/managed_user.dart';
import '../providers/user_form_provider.dart';

/// Create a user (`userId == null`), or view/edit one. Editable: name,
/// email, a new password (optional), role and whether the account is active
/// — everything PATCH /users/:id accepts.
class UserFormScreen extends ConsumerWidget {
  const UserFormScreen({super.key, this.userId});

  final int? userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userFormProvider(userId));
    return Scaffold(
      appBar: AppBar(title: Text(user.value?.name ?? (userId == null ? context.l10n.userNew : context.l10n.userEdit))),
      body: user.when(
        skipLoadingOnRefresh: true,
        skipLoadingOnReload: true,
        loading: () => const SkeletonForm(fields: 5),
        error: (e, _) =>
            ErrorView(message: errorMessage(context, e), onRetry: () => ref.invalidate(userFormProvider(userId))),
        data: (u) => _UserForm(userId: userId, initial: u),
      ),
    );
  }
}

class _UserForm extends ConsumerStatefulWidget {
  const _UserForm({required this.userId, required this.initial});

  final int? userId;
  final ManagedUser? initial;

  @override
  ConsumerState<_UserForm> createState() => _UserFormState();
}

class _UserFormState extends ConsumerState<_UserForm> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.initial?.name);
  late final _email = TextEditingController(text: widget.initial?.email);
  final _password = TextEditingController();
  late int? _roleId = widget.initial?.roleId;
  late bool _isActive = widget.initial?.isActive ?? true;

  Map<String, String> _serverErrors = const {};

  /// A refusal of the whole save (403, 409), in the backend's own words.
  String? _formError;
  bool _submitting = false;

  bool get _isEdit => widget.userId != null;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _clearServerError(String field) {
    if (_serverErrors.containsKey(field) || _formError != null) {
      setState(() {
        _serverErrors = {..._serverErrors}..remove(field);
        _formError = null;
      });
    }
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _serverErrors = const {};
      _formError = null;
    });
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final notifier = ref.read(userFormProvider(widget.userId).notifier);
    try {
      if (_isEdit) {
        await notifier.saveEdit((
          email: _email.text,
          name: _name.text,
          newPassword: _password.text,
          roleId: _roleId,
          isActive: _isActive,
        ));
        if (!mounted) return;
        messenger.showSnackBar(SnackBar(content: Text(l10n.userUpdated)));
      } else {
        final saved = await notifier.create(
          UserInput(email: _email.text, password: _password.text, name: _name.text, roleId: _roleId, isActive: _isActive),
        );
        if (!mounted) return;
        messenger.showSnackBar(SnackBar(content: Text(l10n.userCreated(saved.name))));
      }
      unawaited(HapticFeedback.lightImpact());
      context.pop(true);
    } on ValidationFailure catch (f) {
      setState(() => _serverErrors = {
        ...f.messages,
        for (final e in f.issues.entries) e.key: context.messageFor(e.value) ?? '',
      });
      _formKey.currentState!.validate();
    } on Failure catch (f) {
      if (!mounted) return;
      final refused = f is ServerFailure && (f.isConflict || f.statusCode == 403);
      setState(() => _formError = refused ? f.message : l10n.userSaveFailed(errorMessage(context, f)));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final actor = ref.watch(currentUserProvider);
    final isSelf = _isEdit && actor?.id == widget.userId;
    final canSave = _isEdit ? ref.hasPermission(Permissions.usersUpdate) : ref.hasPermission(Permissions.usersCreate);
    final editable = canSave && !_submitting;

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          TextFormField(
            key: const Key('user_form_name'),
            controller: _name,
            enabled: editable,
            decoration: InputDecoration(labelText: l10n.userFieldName),
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            onChanged: (_) => _clearServerError('name'),
            validator: (v) => context.messageFor(UserRules.validateName(v ?? '')) ?? _serverErrors['name'],
          ),
          const SizedBox(height: AppSpacing.lg),
          TextFormField(
            key: const Key('user_form_email'),
            controller: _email,
            enabled: editable,
            decoration: InputDecoration(labelText: l10n.userFieldEmail),
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            textInputAction: TextInputAction.next,
            onChanged: (_) => _clearServerError('email'),
            validator: (v) => context.messageFor(UserRules.validateEmail(v ?? '')) ?? _serverErrors['email'],
          ),
          const SizedBox(height: AppSpacing.lg),
          TextFormField(
            key: const Key('user_form_password'),
            controller: _password,
            enabled: editable,
            obscureText: true,
            decoration: InputDecoration(
              labelText: _isEdit ? l10n.userFieldNewPassword : l10n.userFieldPassword,
              helperText: _isEdit ? l10n.userFieldNewPasswordHelper : null,
              helperMaxLines: 3,
            ),
            autofillHints: const [AutofillHints.newPassword],
            onChanged: (_) => _clearServerError('password'),
            validator: (v) =>
                context.messageFor(UserRules.validatePassword(v ?? '', required: !_isEdit)) ?? _serverErrors['password'],
          ),
          const SizedBox(height: AppSpacing.lg),
          _RolePicker(
            value: _roleId,
            currentRoleName: widget.initial?.roleName,
            // Nobody can change their own role (the backend says 409): the
            // picker says why instead of failing on save.
            enabled: editable && !isSelf,
            helper: isSelf ? l10n.userSelfRole : null,
            allowSystemRoles: actor?.role.isSystem ?? false,
            onChanged: (id) => setState(() {
              _roleId = id;
              _serverErrors = {..._serverErrors}..remove('role_id');
            }),
            validator: (v) => context.messageFor(UserRules.validateRole(v)) ?? _serverErrors['role_id'],
          ),
          const SizedBox(height: AppSpacing.md),
          SwitchListTile(
            key: const Key('user_form_active'),
            contentPadding: EdgeInsets.zero,
            value: _isActive,
            onChanged: editable && !isSelf ? (v) => setState(() => _isActive = v) : null,
            title: Text(l10n.userFieldActive),
            // For yourself: why the switch doesn't move (avoids a lockout).
            subtitle: Text(isSelf ? l10n.userSelfDeactivate : l10n.userFieldActiveHelper,
                key: isSelf ? const Key('user_self_deactivate_note') : null),
          ),
          if (_formError != null) ...[
            const SizedBox(height: AppSpacing.md),
            _ErrorBanner(message: _formError!),
          ],
          if (canSave) ...[
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              key: const Key('user_form_submit'),
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(_isEdit ? l10n.commonSaveChanges : l10n.usersAdd),
            ),
          ],
        ],
      ),
    );
  }
}

/// The role dropdown, from GET /roles (needs `roles.view`). A non-system
/// user isn't offered the system role: the backend refuses (403) anyone but
/// a Super Admin granting it.
class _RolePicker extends ConsumerWidget {
  const _RolePicker({
    required this.value,
    required this.currentRoleName,
    required this.enabled,
    required this.helper,
    required this.allowSystemRoles,
    required this.onChanged,
    required this.validator,
  });

  final int? value;
  final String? currentRoleName;
  final bool enabled;
  final String? helper;
  final bool allowSystemRoles;
  final ValueChanged<int?> onChanged;
  final FormFieldValidator<int?> validator;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final options = ref.watch(roleOptionsProvider);
    final roles = <Role>[
      for (final r in options.value ?? const <Role>[])
        if (allowSystemRoles || !r.isSystem || r.id == value) r,
    ];
    final items = [for (final r in roles) DropdownMenuItem<int?>(value: r.id, child: Text(r.name))];
    // Keep the current role representable while loading or if it can't be
    // listed (DropdownButton asserts its value is one of the items).
    if (value != null && !items.any((i) => i.value == value)) {
      items.add(DropdownMenuItem(value: value, child: Text(currentRoleName ?? '#$value')));
    }

    return DropdownButtonFormField<int?>(
      key: const Key('user_form_role'),
      initialValue: value,
      items: items,
      isExpanded: true,
      onChanged: enabled ? onChanged : null,
      decoration: InputDecoration(
        labelText: l10n.userFieldRole,
        helperText: options.hasError ? l10n.userRolesLoadFailed : helper,
        suffixIcon: options.isLoading
            ? const Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2)),
              )
            : options.hasError
            ? IconButton(
                tooltip: l10n.userRolesReload,
                icon: const Icon(Icons.refresh),
                onPressed: () => ref.invalidate(roleOptionsProvider),
              )
            : null,
      ),
      validator: validator,
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      liveRegion: true,
      child: Container(
        key: const Key('user_form_error'),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(color: scheme.errorContainer, borderRadius: AppRadius.smAll),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: scheme.onErrorContainer),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: Text(message, style: TextStyle(color: scheme.onErrorContainer))),
          ],
        ),
      ),
    );
  }
}
