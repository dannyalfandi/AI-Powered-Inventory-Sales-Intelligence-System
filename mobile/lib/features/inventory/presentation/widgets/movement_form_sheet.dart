import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/l10n/field_issue_text.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../shared/widgets/state_views.dart';
import '../../domain/entities/inventory.dart';
import '../providers/inventory_provider.dart';
import 'movement_tile.dart';

/// Opens the "record movement" form. Resolves to the result on success, or
/// null if the sheet was dismissed.
Future<MovementResult?> showMovementFormSheet(BuildContext context, {required int productId}) {
  return showModalBottomSheet<MovementResult>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => MovementFormSheet(productId: productId),
  );
}

/// Form for an IN / OUT / ADJUSTMENT movement. Local rules are checked first;
/// backend 422 messages (e.g. "insufficient stock: 20 available, 21
/// requested" for an OUT larger than the stock) appear under their field.
class MovementFormSheet extends ConsumerStatefulWidget {
  const MovementFormSheet({super.key, required this.productId});

  final int productId;

  @override
  ConsumerState<MovementFormSheet> createState() => _MovementFormSheetState();
}

class _MovementFormSheetState extends ConsumerState<MovementFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _quantity = TextEditingController();
  final _reason = TextEditingController();
  MovementType _type = MovementType.stockIn;

  /// Field errors from the backend (422 details), keyed by JSON field name.
  Map<String, String> _serverErrors = const {};
  String? _generalError;
  bool _submitting = false;

  @override
  void dispose() {
    _quantity.dispose();
    _reason.dispose();
    super.dispose();
  }

  /// Drops the backend error of [field] once the user edits it. Re-validates
  /// so the field stops showing it (FormField keeps its last error otherwise).
  void _clearServerError(String field) {
    final hadFieldError = _serverErrors.containsKey(field);
    if (!hadFieldError && _generalError == null) return;
    setState(() {
      _serverErrors = {..._serverErrors}..remove(field);
      _generalError = null;
    });
    if (hadFieldError) _formKey.currentState?.validate();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _serverErrors = const {};
      _generalError = null;
    });
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    try {
      final result = await ref.read(productInventoryProvider(widget.productId).notifier).recordMovement(
            MovementInput(type: _type, quantity: int.tryParse(_quantity.text), reason: _reason.text),
          );
      if (mounted) Navigator.of(context).pop(result);
    } on ValidationFailure catch (f) {
      setState(() {
        _serverErrors = f.messages;
        // `type` has no text field; show it (and message-only 422s) above the button.
        _generalError = f.messages['type'] ?? (f.messages.isEmpty ? errorMessage(context, f) : null);
      });
      _formKey.currentState!.validate();
    } on Failure catch (f) {
      setState(() => _generalError = errorMessage(context, f));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  String _quantityLabel(BuildContext context) => switch (_type) {
        MovementType.stockIn => context.l10n.movementQuantityIn,
        MovementType.stockOut => context.l10n.movementQuantityOut,
        MovementType.adjustment => context.l10n.movementQuantityAdjustment,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    // Hint only; the backend decides whether the stock suffices for an OUT.
    final current = ref.watch(productInventoryProvider(widget.productId)).value?.quantity;

    return Padding(
      // Keep the form above the keyboard.
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16 + MediaQuery.viewInsetsOf(context).bottom),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.movementFormTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            SegmentedButton<MovementType>(
              key: const Key('movement_form_type'),
              segments: [
                for (final t in MovementType.values)
                  ButtonSegment(value: t, label: Text(t.label(context)), icon: Icon(t.icon)),
              ],
              selected: {_type},
              showSelectedIcon: false,
              onSelectionChanged: (s) {
                setState(() => _type = s.first);
                _clearServerError('quantity');
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const Key('movement_form_quantity'),
              controller: _quantity,
              autofocus: true,
              decoration: InputDecoration(
                labelText: _quantityLabel(context),
                helperText: current == null ? null : l10n.movementCurrentStock(current),
              ),
              keyboardType: TextInputType.number,
              // Digits only: negative or decimal quantities can't be typed.
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              onChanged: (_) => _clearServerError('quantity'),
              validator: (v) =>
                  context.messageFor(MovementRules.validateQuantity(_type, int.tryParse(v ?? ''))) ?? _serverErrors['quantity'],
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const Key('movement_form_reason'),
              controller: _reason,
              decoration: InputDecoration(
                labelText: l10n.movementFieldReasonOptional,
                hintText: l10n.movementReasonHint,
              ),
              maxLines: 2,
              inputFormatters: [LengthLimitingTextInputFormatter(MovementRules.reasonMaxLength)],
              onChanged: (_) => _clearServerError('reason'),
              validator: (v) => context.messageFor(MovementRules.validateReason(v ?? '')) ?? _serverErrors['reason'],
            ),
            if (_generalError != null) ...[
              const SizedBox(height: 12),
              Text(
                _generalError!,
                key: const Key('movement_form_error'),
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
              ),
            ],
            const SizedBox(height: 20),
            FilledButton(
              key: const Key('movement_form_submit'),
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(l10n.commonSave),
            ),
          ],
        ),
      ),
    );
  }
}
