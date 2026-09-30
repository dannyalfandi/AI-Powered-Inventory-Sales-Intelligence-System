import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/l10n/field_issue_text.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/widgets/state_views.dart';
import '../../domain/entities/auth_user.dart';
import '../providers/auth_controller.dart';

/// Email + password login. On success it does not navigate: the auth state
/// changes and the router's guard moves the user to the Dashboard.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _submitting = false;
  bool _obscure = true;

  /// A problem with the attempt as a whole (wrong credentials, offline),
  /// shown above the button rather than under one field: the backend never
  /// says which of the two was wrong.
  String? _formError;

  /// Field errors from a backend 422.
  Map<String, String> _serverErrors = const {};

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _clearErrors() {
    if (_formError != null || _serverErrors.isNotEmpty) {
      setState(() {
        _formError = null;
        _serverErrors = const {};
      });
    }
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _formError = null;
      _serverErrors = const {};
    });
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    final l10n = context.l10n;
    try {
      await ref.read(authControllerProvider.notifier).login(email: _email.text, password: _password.text);
      TextInput.finishAutofillContext(); // let a password manager offer to save
    } on ValidationFailure catch (f) {
      setState(() => _serverErrors = f.messages);
      _formKey.currentState!.validate();
    } on Failure catch (f) {
      if (!mounted) return;
      final wrongCredentials = f is ServerFailure && (f.code == 'invalid_credentials' || f.statusCode == 401);
      setState(() => _formError = wrongCredentials ? l10n.loginInvalidCredentials : l10n.loginFailed(errorMessage(context, f)));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: AutofillGroup(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 48, color: theme.colorScheme.primary),
                      const SizedBox(height: AppSpacing.lg),
                      Text(l10n.appTitle, textAlign: TextAlign.center, style: theme.textTheme.titleMedium),
                      const SizedBox(height: AppSpacing.xs),
                      Text(l10n.loginTitle, textAlign: TextAlign.center, style: theme.textTheme.headlineSmall),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        l10n.loginSubtitle,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      TextFormField(
                        key: const Key('login_email'),
                        controller: _email,
                        enabled: !_submitting,
                        decoration: InputDecoration(
                          labelText: l10n.loginEmail,
                          prefixIcon: const Icon(Icons.alternate_email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.username, AutofillHints.email],
                        autocorrect: false,
                        textInputAction: TextInputAction.next,
                        onChanged: (_) => _clearErrors(),
                        validator: (v) => context.messageFor(LoginRules.validateEmail(v ?? '')) ?? _serverErrors['email'],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      TextFormField(
                        key: const Key('login_password'),
                        controller: _password,
                        enabled: !_submitting,
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          labelText: l10n.loginPassword,
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            key: const Key('login_toggle_password'),
                            tooltip: _obscure ? l10n.loginShowPassword : l10n.loginHidePassword,
                            icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                            onPressed: () => setState(() => _obscure = !_obscure),
                          ),
                        ),
                        autofillHints: const [AutofillHints.password],
                        textInputAction: TextInputAction.done,
                        onChanged: (_) => _clearErrors(),
                        onFieldSubmitted: (_) => _submitting ? null : _submit(),
                        validator: (v) =>
                            context.messageFor(LoginRules.validatePassword(v ?? '')) ?? _serverErrors['password'],
                      ),
                      if (_formError != null) ...[
                        const SizedBox(height: AppSpacing.lg),
                        _FormErrorBanner(message: _formError!),
                      ],
                      const SizedBox(height: AppSpacing.xl),
                      FilledButton(
                        key: const Key('login_submit'),
                        onPressed: _submitting ? null : _submit,
                        child: _submitting
                            ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                            : Text(l10n.loginSubmit),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FormErrorBanner extends StatelessWidget {
  const _FormErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      liveRegion: true, // announced when it appears
      child: Container(
        key: const Key('login_error'),
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
