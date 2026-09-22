import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/l10n/field_issue_text.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../shared/widgets/state_views.dart';
import '../../../category/presentation/providers/category_list_provider.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_input.dart';
import '../providers/product_form_provider.dart';

/// Create (`productId == null`) or edit a product.
class ProductFormScreen extends ConsumerWidget {
  const ProductFormScreen({super.key, this.productId});

  final int? productId;

  bool get isEdit => productId != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(productFormProvider(productId));

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? context.l10n.productEdit : context.l10n.productNew)),
      body: product.when(
        // Only the initial load; after a save the form keeps showing.
        skipLoadingOnRefresh: true,
        skipLoadingOnReload: true,
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          message: errorMessage(context, e),
          onRetry: () => ref.invalidate(productFormProvider(productId)),
        ),
        data: (p) => _ProductForm(productId: productId, initial: p),
      ),
    );
  }
}

class _ProductForm extends ConsumerStatefulWidget {
  const _ProductForm({required this.productId, required this.initial});

  final int? productId;
  final Product? initial;

  @override
  ConsumerState<_ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends ConsumerState<_ProductForm> {
  final _formKey = GlobalKey<FormState>();
  late final _sku = TextEditingController(text: widget.initial?.sku);
  late final _name = TextEditingController(text: widget.initial?.name);
  late final _description = TextEditingController(text: widget.initial?.description);
  late final _price = TextEditingController(text: widget.initial?.price.toString());

  /// Selected category; null = "Tanpa Kategori".
  late int? _categoryId = widget.initial?.categoryId;

  /// Field errors returned by the backend (422 details, 409 duplicate SKU).
  Map<String, String> _serverErrors = const {};
  bool _submitting = false;

  bool get _isEdit => widget.productId != null;

  @override
  void dispose() {
    _sku.dispose();
    _name.dispose();
    _description.dispose();
    _price.dispose();
    super.dispose();
  }

  void _clearServerError(String field) {
    if (_serverErrors.containsKey(field)) {
      setState(() => _serverErrors = {..._serverErrors}..remove(field));
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
      await ref.read(productFormProvider(widget.productId).notifier).save(
            ProductInput(
              sku: _sku.text,
              name: _name.text,
              description: _description.text,
              price: int.parse(_price.text),
              categoryId: _categoryId,
            ),
          );
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(_isEdit ? l10n.productUpdated : l10n.productCreated)),
      );
      context.pop(true);
    } on ValidationFailure catch (f) {
      _showServerErrors(f.messages);
      if (f.messages.isEmpty) {
        messenger.showSnackBar(SnackBar(content: Text(l10n.productSaveFailed(f.message))));
      }
    } on Failure catch (f) {
      if (f is ServerFailure && f.isConflict) {
        _showServerErrors({'sku': l10n.productSkuTaken});
        return;
      }
      messenger.showSnackBar(SnackBar(content: Text(l10n.productSaveFailed(f.message))));
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
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            key: const Key('product_form_sku'),
            controller: _sku,
            decoration: InputDecoration(labelText: l10n.productFieldSku, hintText: l10n.productSkuHint),
            textCapitalization: TextCapitalization.characters,
            textInputAction: TextInputAction.next,
            inputFormatters: [LengthLimitingTextInputFormatter(ProductRules.skuMaxLength)],
            onChanged: (_) => _clearServerError('sku'),
            validator: (v) => context.messageFor(ProductRules.validateSku(v ?? '')) ?? _serverErrors['sku'],
          ),
          const SizedBox(height: 16),
          TextFormField(
            key: const Key('product_form_name'),
            controller: _name,
            decoration: InputDecoration(labelText: l10n.productFieldName),
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
            inputFormatters: [LengthLimitingTextInputFormatter(ProductRules.nameMaxLength)],
            onChanged: (_) => _clearServerError('name'),
            validator: (v) => context.messageFor(ProductRules.validateName(v ?? '')) ?? _serverErrors['name'],
          ),
          const SizedBox(height: 16),
          TextFormField(
            key: const Key('product_form_description'),
            controller: _description,
            decoration: InputDecoration(labelText: l10n.productFieldDescriptionOptional),
            minLines: 2,
            maxLines: 4,
            onChanged: (_) => _clearServerError('description'),
            validator: (_) => _serverErrors['description'],
          ),
          const SizedBox(height: 16),
          TextFormField(
            key: const Key('product_form_price'),
            controller: _price,
            decoration: InputDecoration(labelText: l10n.productFieldPrice, prefixText: 'Rp '),
            keyboardType: TextInputType.number,
            // Digits only: negative or decimal prices can't be typed at all.
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(15),
            ],
            onChanged: (_) => _clearServerError('price'),
            validator: (v) =>
                context.messageFor(ProductRules.validatePrice(int.tryParse(v ?? ''))) ?? _serverErrors['price'],
            onFieldSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 16),
          _CategoryField(
            value: _categoryId,
            current: widget.initial?.category,
            // Reads state (not a captured value): validate() runs before the rebuild.
            validator: (_) => _serverErrors['category_id'],
            onChanged: (id) {
              _clearServerError('category_id');
              setState(() => _categoryId = id);
            },
          ),
          const SizedBox(height: 24),
          FilledButton(
            key: const Key('product_form_submit'),
            onPressed: _submitting ? null : _submit,
            child: _submitting
                ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : Text(_isEdit ? l10n.commonSaveChanges : l10n.productsAdd),
          ),
        ],
      ),
    );
  }
}

/// Category picker fed by GET /api/v1/categories. "Tanpa Kategori" (null) is
/// always available, so the form stays usable while categories load or fail.
class _CategoryField extends ConsumerWidget {
  const _CategoryField({
    required this.value,
    required this.current,
    required this.validator,
    required this.onChanged,
  });

  final int? value;

  /// The product's category as loaded, so it can be shown before (or
  /// without) the category list.
  final ProductCategory? current;
  final FormFieldValidator<int?> validator;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final options = ref.watch(categoryOptionsProvider);

    final items = <DropdownMenuItem<int?>>[
      DropdownMenuItem(value: null, child: Text(context.l10n.productNoCategory)),
      for (final c in options.value ?? const [])
        DropdownMenuItem(value: c.id, child: Text(c.name, overflow: TextOverflow.ellipsis)),
    ];
    // Keep the selection representable while loading, after a load failure,
    // or if the category disappeared from the list (DropdownButton asserts
    // that its value is one of the items).
    if (value != null && !items.any((i) => i.value == value)) {
      final label = current?.id == value ? current!.name : context.l10n.productCategoryFallback('$value');
      items.add(DropdownMenuItem(value: value, child: Text(label, overflow: TextOverflow.ellipsis)));
    }

    return DropdownButtonFormField<int?>(
      key: const Key('product_form_category'),
      initialValue: value,
      items: items,
      isExpanded: true,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: context.l10n.productFieldCategory,
        helperText: options.hasError ? context.l10n.productCategoryLoadFailed : null,
        suffixIcon: options.isLoading
            ? const Padding(
                padding: EdgeInsets.all(12),
                child: SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2)),
              )
            : options.hasError
                ? IconButton(
                    tooltip: context.l10n.productCategoryReload,
                    icon: const Icon(Icons.refresh),
                    onPressed: () => ref.invalidate(categoryOptionsProvider),
                  )
                : null,
      ),
      validator: validator,
    );
  }
}
