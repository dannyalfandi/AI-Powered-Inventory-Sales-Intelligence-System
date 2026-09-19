import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/error/failure.dart';
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
      appBar: AppBar(title: Text(customerId != null ? 'Edit Pelanggan' : 'Tambah Pelanggan')),
      body: customer.when(
        skipLoadingOnRefresh: true,
        skipLoadingOnReload: true,
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          message: errorMessage(e),
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
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(customerFormProvider(widget.customerId).notifier).save(
            CustomerInput(name: _name.text, email: _email.text, phone: _phone.text, address: _address.text),
          );
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(_isEdit ? 'Pelanggan diperbarui' : 'Pelanggan ditambahkan')));
      context.pop(true);
    } on ValidationFailure catch (f) {
      _showServerErrors(f.messages);
      if (f.messages.isEmpty) messenger.showSnackBar(SnackBar(content: Text(f.message)));
    } on Failure catch (f) {
      if (f is ServerFailure && f.isConflict) {
        // The only unique field besides the id.
        _showServerErrors({'email': 'Email sudah dipakai pelanggan lain'});
        return;
      }
      messenger.showSnackBar(SnackBar(content: Text(f.message)));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            key: const Key('customer_form_name'),
            controller: _name,
            decoration: const InputDecoration(labelText: 'Nama'),
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            inputFormatters: [LengthLimitingTextInputFormatter(CustomerRules.nameMaxLength)],
            onChanged: (_) => _clearServerError('name'),
            validator: (v) => CustomerRules.validateName(v ?? '') ?? _serverErrors['name'],
          ),
          const SizedBox(height: 16),
          TextFormField(
            key: const Key('customer_form_email'),
            controller: _email,
            decoration: const InputDecoration(labelText: 'Email (opsional)'),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autocorrect: false,
            onChanged: (_) => _clearServerError('email'),
            validator: (v) => CustomerRules.validateEmail(v ?? '') ?? _serverErrors['email'],
          ),
          const SizedBox(height: 16),
          TextFormField(
            key: const Key('customer_form_phone'),
            controller: _phone,
            decoration: const InputDecoration(labelText: 'Telepon (opsional)', hintText: '+62 812-3456-7890'),
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            inputFormatters: [LengthLimitingTextInputFormatter(CustomerRules.phoneMaxLength)],
            onChanged: (_) => _clearServerError('phone'),
            validator: (v) => CustomerRules.validatePhone(v ?? '') ?? _serverErrors['phone'],
          ),
          const SizedBox(height: 16),
          TextFormField(
            key: const Key('customer_form_address'),
            controller: _address,
            decoration: const InputDecoration(labelText: 'Alamat (opsional)'),
            minLines: 2,
            maxLines: 4,
            inputFormatters: [LengthLimitingTextInputFormatter(CustomerRules.addressMaxLength)],
            onChanged: (_) => _clearServerError('address'),
            validator: (v) => CustomerRules.validateAddress(v ?? '') ?? _serverErrors['address'],
          ),
          const SizedBox(height: 24),
          FilledButton(
            key: const Key('customer_form_submit'),
            onPressed: _submitting ? null : _submit,
            child: _submitting
                ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : Text(_isEdit ? 'Simpan perubahan' : 'Tambah pelanggan'),
          ),
        ],
      ),
    );
  }
}
