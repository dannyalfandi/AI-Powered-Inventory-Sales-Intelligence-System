import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/l10n/field_issue_text.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/widgets/state_views.dart';
import '../../../customer/presentation/widgets/customer_picker.dart';
import '../../../product/presentation/widgets/product_picker.dart';
import '../../domain/entities/sales_order.dart';
import '../providers/order_form_provider.dart';

/// Create an order: pick a customer, add products with quantities, see the
/// running total. The order is saved as PENDING; stock changes on confirm.
class SalesOrderFormScreen extends ConsumerStatefulWidget {
  const SalesOrderFormScreen({super.key});

  @override
  ConsumerState<SalesOrderFormScreen> createState() => _SalesOrderFormScreenState();
}

class _SalesOrderFormScreenState extends ConsumerState<SalesOrderFormScreen> {
  /// Local and backend validation errors, keyed like the backend
  /// (`customer_id`, `items`, `items[1].quantity`, `items[0].product_id`, `notes`).
  Map<String, String> _errors = const {};
  bool _submitting = false;

  void _clearErrors(bool Function(String key) test) {
    if (_errors.keys.any(test)) setState(() => _errors = {..._errors}..removeWhere((k, _) => test(k)));
  }

  Future<void> _pickCustomer() async {
    final c = await pickCustomer(context);
    if (c == null) return;
    ref.read(orderFormProvider.notifier).setCustomer(c);
    _clearErrors((k) => k == 'customer_id');
  }

  Future<void> _addProduct() async {
    final form = ref.read(orderFormProvider);
    final p = await pickProduct(context, alreadyAdded: {for (final l in form.lines) l.product.id});
    if (p == null || !mounted) return;
    final added = ref.read(orderFormProvider.notifier).addProduct(p);
    if (!added) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.orderFormAlreadyAdded(p.name))),
      );
      return;
    }
    _clearErrors((k) => k == 'items');
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _errors = const {};
      _submitting = true;
    });
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    try {
      final order = await ref.read(orderFormProvider.notifier).submit();
      if (!mounted) return;
      unawaited(HapticFeedback.lightImpact());
      messenger.showSnackBar(SnackBar(content: Text(l10n.orderCreated(order.orderNumber))));
      context.pushReplacementNamed(AppRoutes.salesOrderDetail, pathParameters: {'id': '${order.id}'});
    } on ValidationFailure catch (f) {
      // Local issues are typed and rendered here; backend messages arrive
      // already translated. Both land under the same field keys.
      final rendered = {
        for (final MapEntry(:key, :value) in f.issues.entries) key: ?context.messageFor(value),
        ...f.messages,
      };
      setState(() => _errors = rendered.isEmpty ? {'items': errorMessage(context, f)} : rendered);
    } on Failure catch (f) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.orderCreateFailed(errorMessage(context, f)))));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(orderFormProvider);
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final customer = form.customer;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.orderFormTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xl),
        children: [
          Text(l10n.orderFormCustomer, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Card(
            margin: EdgeInsets.zero,
            shape: _errors['customer_id'] == null
                ? null
                : RoundedRectangleBorder(
                    side: BorderSide(color: theme.colorScheme.error),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
            child: ListTile(
              key: const Key('order_form_customer'),
              leading: const Icon(Icons.person_outline),
              title: Text(customer?.name ?? l10n.orderFormPickCustomer),
              subtitle: customer == null
                  ? null
                  : Text([customer.email, customer.phone].whereType<String>().where((s) => s.isNotEmpty).join(' · ')),
              trailing: const Icon(Icons.chevron_right),
              onTap: _submitting ? null : _pickCustomer,
            ),
          ),
          _ErrorText(_errors['customer_id']),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(child: Text(l10n.orderFormItemsHeading(form.lines.length), style: theme.textTheme.titleMedium)),
              TextButton.icon(
                key: const Key('order_form_add_product'),
                onPressed: _submitting ? null : _addProduct,
                icon: const Icon(Icons.add),
                label: Text(l10n.orderFormAddProduct),
              ),
            ],
          ),
          if (form.lines.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Text(l10n.orderFormNoItems, style: theme.textTheme.bodyMedium),
            ),
          for (final (i, line) in form.lines.indexed)
            _LineCard(
              key: ValueKey('order_line_${line.product.id}'),
              index: i,
              line: line,
              error: _errors['items[$i].product_id'] ?? _errors['items[$i].quantity'],
              enabled: !_submitting,
              onQuantity: (q) {
                ref.read(orderFormProvider.notifier).setQuantity(i, q);
                _clearErrors((k) => k.startsWith('items[$i]'));
              },
              onRemove: () {
                ref.read(orderFormProvider.notifier).removeLine(i);
                // Indexes shift: drop every line error.
                _clearErrors((k) => k.startsWith('items['));
              },
            ),
          _ErrorText(_errors['items']),
          const SizedBox(height: AppSpacing.lg),
          TextFormField(
            key: const Key('order_form_notes'),
            decoration: InputDecoration(labelText: l10n.orderFormNotesOptional, errorText: _errors['notes']),
            minLines: 1,
            maxLines: 3,
            enabled: !_submitting,
            inputFormatters: [LengthLimitingTextInputFormatter(OrderRules.notesMaxLength)],
            onChanged: ref.read(orderFormProvider.notifier).setNotes,
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.md),
          decoration: BoxDecoration(border: Border(top: BorderSide(color: theme.dividerColor))),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.orderFormTotalCurrent, style: theme.textTheme.bodySmall),
                    Text(
                      formatRupiah(form.total),
                      key: const Key('order_form_total'),
                      style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary),
                    ),
                  ],
                ),
              ),
              FilledButton(
                key: const Key('order_form_submit'),
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(l10n.orderFormSubmit),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LineCard extends StatelessWidget {
  const _LineCard({
    super.key,
    required this.index,
    required this.line,
    required this.error,
    required this.enabled,
    required this.onQuantity,
    required this.onRemove,
  });

  final int index;
  final OrderFormLine line;
  final String? error;
  final bool enabled;
  final ValueChanged<int?> onQuantity;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = line.product;
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.xs, AppSpacing.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.name, style: theme.textTheme.titleSmall),
                  Text('${p.sku} · ${formatRupiah(p.price)}', style: theme.textTheme.bodySmall),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    context.l10n.orderFormSubtotal(formatRupiah(line.subtotal)),
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 110,
              child: TextFormField(
                key: Key('order_line_qty_$index'),
                initialValue: line.quantity?.toString() ?? '',
                enabled: enabled,
                decoration: InputDecoration(
                  labelText: context.l10n.movementFieldQuantity,
                  isDense: true,
                  errorText: error,
                  errorMaxLines: 4,
                ),
                keyboardType: TextInputType.number,
                // Digits only: negative or decimal quantities can't be typed.
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(7)],
                onChanged: (v) => onQuantity(int.tryParse(v)),
              ),
            ),
            IconButton(
              key: Key('order_line_remove_$index'),
              tooltip: context.l10n.orderFormRemoveProduct,
              onPressed: enabled ? onRemove : null,
              icon: const Icon(Icons.close),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorText extends StatelessWidget {
  const _ErrorText(this.message);

  final String? message;

  @override
  Widget build(BuildContext context) {
    if (message == null) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs, left: AppSpacing.md),
      child: Text(message!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error)),
    );
  }
}
