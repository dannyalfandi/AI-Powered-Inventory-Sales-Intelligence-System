import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/l10n/field_issue_text.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../../../shared/widgets/state_views.dart';
import '../../domain/entities/customer.dart';
import '../providers/customer_form_provider.dart';

/// Create (`customerId == null`) or edit a customer.
class CustomerFormScreen extends ConsumerWidget {
  const CustomerFormScreen({super.key, this.customerId});

  final int? customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customer = ref.watch(customerFormProvider(customerId));

    return Scaffold(
      appBar: AppBar(title: Text(customerId != null ? context.l10n.customerEdit : context.l10n.customerNew)),
      body: customer.when(
        skipLoadingOnRefresh: true,
        skipLoadingOnReload: true,
        loading: () => const SkeletonForm(),
        error: (e, _) => ErrorView(
          message: errorMessage(context, e),
          onRetry: () => ref.invalidate(customerFormProvider(customerId)),
        ),
        data: (c) => _CustomerForm(customerId: customerId, initial: c),
      ),
    );
  }
}

class _CustomerForm extends ConsumerStatefulWidget {
  const _CustomerForm({required this.customerId, required this.initial});

  final int? customerId;
  final Customer? initial;

  @override
  ConsumerState<_CustomerForm> createState() => _CustomerFormState();
}

class _CustomerFormState extends ConsumerState<_CustomerForm> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.initial?.name);
  late final _email = TextEditingController(text: widget.initial?.email);
  late final _phone = TextEditingController(text: widget.initial?.phone);
  late final _address = TextEditingController(text: widget.initial?.address);

  /// Field errors returned by the backend (422 details, 409 duplicate email).
  Map<String, String> _serverErrors = const {};
  bool _submitting = false;

  bool get _isEdit => widget.customerId != null;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _address.dispose();
    super.dispose();
  }

  void _clearServerError(String field) {
    if (_serverErrors.containsKey(field)) {
      setState(() => _serverErrors = {..._serverErrors}..remove(field));
      _formKey.currentState?.validate();
    }
  }

  void _showServerErrors(Map<String, String> errors) {
    setState(() => _serverErrors = errors);
    _formKey.currentState!.validate();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() => _serverErrors = const {});
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(customerFormProvider(widget.customerId).notifier).save(
            CustomerInput(name: _name.text, email: _email.text, phone: _phone.text, address: _address.text),
          );
      if (!mounted) return;
      unawaited(HapticFeedback.lightImpact());
      messenger.showSnackBar(SnackBar(content: Text(_isEdit ? l10n.customerUpdated : l10n.customerCreated)));
      context.pop(true);
    } on ValidationFailure catch (f) {
      _showServerErrors(f.messages);
      if (f.messages.isEmpty) {
        messenger.showSnackBar(SnackBar(content: Text(l10n.customerSaveFailed(f.message))));
      }
    } on Failure catch (f) {
      if (f is ServerFailure && f.isConflict) {
        // The only unique field besides the id.
        _showServerErrors({'email': l10n.customerEmailTaken});
        return;
      }
      messenger.showSnackBar(SnackBar(content: Text(l10n.customerSaveFailed(f.message))));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          TextFormField(
            key: const Key('customer_form_name'),
            controller: _name,
            decoration: InputDecoration(labelText: l10n.customerFieldName),
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            inputFormatters: [LengthLimitingTextInputFormatter(CustomerRules.nameMaxLength)],
            onChanged: (_) => _clearServerError('name'),
            validator: (v) => context.messageFor(CustomerRules.validateName(v ?? '')) ?? _serverErrors['name'],
          ),
          const SizedBox(height: AppSpacing.lg),
          TextFormField(
            key: const Key('customer_form_email'),
            controller: _email,
            decoration: InputDecoration(labelText: l10n.customerFieldEmailOptional),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autocorrect: false,
            onChanged: (_) => _clearServerError('email'),
            validator: (v) => context.messageFor(CustomerRules.validateEmail(v ?? '')) ?? _serverErrors['email'],
          ),
          const SizedBox(height: AppSpacing.lg),
          TextFormField(
            key: const Key('customer_form_phone'),
            controller: _phone,
            decoration: InputDecoration(
              labelText: l10n.customerFieldPhoneOptional,
              hintText: l10n.customerPhoneHint,
            ),
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            inputFormatters: [LengthLimitingTextInputFormatter(CustomerRules.phoneMaxLength)],
            onChanged: (_) => _clearServerError('phone'),
            validator: (v) => context.messageFor(CustomerRules.validatePhone(v ?? '')) ?? _serverErrors['phone'],
          ),
          const SizedBox(height: AppSpacing.lg),
          TextFormField(
            key: const Key('customer_form_address'),
            controller: _address,
            decoration: InputDecoration(labelText: l10n.customerFieldAddressOptional),
            minLines: 2,
            maxLines: 4,
            inputFormatters: [LengthLimitingTextInputFormatter(CustomerRules.addressMaxLength)],
            onChanged: (_) => _clearServerError('address'),
            validator: (v) => context.messageFor(CustomerRules.validateAddress(v ?? '')) ?? _serverErrors['address'],
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            key: const Key('customer_form_submit'),
            onPressed: _submitting ? null : _submit,
            child: _submitting
                ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : Text(_isEdit ? l10n.commonSaveChanges : l10n.customersAdd),
          ),
        ],
      ),
    );
  }
}
