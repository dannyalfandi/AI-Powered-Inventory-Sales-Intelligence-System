import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/l10n/field_issue_text.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../shared/widgets/state_views.dart';
import '../../domain/entities/category.dart';
import '../providers/category_form_provider.dart';

/// Create (`categoryId == null`) or edit a category.
class CategoryFormScreen extends ConsumerWidget {
  const CategoryFormScreen({super.key, this.categoryId});

  final int? categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(categoryFormProvider(categoryId));

    return Scaffold(
      appBar: AppBar(title: Text(categoryId != null ? context.l10n.categoryEdit : context.l10n.categoryNew)),
      body: category.when(
        // Only the initial load; after a save the form keeps showing.
        skipLoadingOnRefresh: true,
        skipLoadingOnReload: true,
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          message: errorMessage(context, e),
          onRetry: () => ref.invalidate(categoryFormProvider(categoryId)),
        ),
        data: (c) => _CategoryForm(categoryId: categoryId, initial: c),
      ),
    );
  }
}

class _CategoryForm extends ConsumerStatefulWidget {
  const _CategoryForm({required this.categoryId, required this.initial});

  final int? categoryId;
  final Category? initial;

  @override
  ConsumerState<_CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends ConsumerState<_CategoryForm> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.initial?.name);
  late final _description = TextEditingController(text: widget.initial?.description);

  /// Field errors returned by the backend (422 details, 409 duplicate name).
  Map<String, String> _serverErrors = const {};
  bool _submitting = false;

  bool get _isEdit => widget.categoryId != null;

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
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
      await ref
          .read(categoryFormProvider(widget.categoryId).notifier)
          .save(CategoryInput(name: _name.text, description: _description.text));
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(_isEdit ? l10n.categoryUpdated : l10n.categoryCreated)),
      );
      context.pop(true);
    } on ValidationFailure catch (f) {
      _showServerErrors(f.messages);
      if (f.messages.isEmpty) {
        messenger.showSnackBar(SnackBar(content: Text(l10n.categorySaveFailed(f.message))));
      }
    } on Failure catch (f) {
      if (f is ServerFailure && f.isConflict) {
        _showServerErrors({'name': l10n.categoryNameTaken});
        return;
      }
      messenger.showSnackBar(SnackBar(content: Text(l10n.categorySaveFailed(f.message))));
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
            key: const Key('category_form_name'),
            controller: _name,
            decoration: InputDecoration(labelText: l10n.categoryFieldName, hintText: l10n.categoryNameHint),
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
            inputFormatters: [LengthLimitingTextInputFormatter(CategoryRules.nameMaxLength)],
            onChanged: (_) => _clearServerError('name'),
            validator: (v) => context.messageFor(CategoryRules.validateName(v ?? '')) ?? _serverErrors['name'],
          ),
          const SizedBox(height: 16),
          TextFormField(
            key: const Key('category_form_description'),
            controller: _description,
            decoration: InputDecoration(labelText: l10n.categoryFieldDescriptionOptional),
            minLines: 2,
            maxLines: 4,
            onChanged: (_) => _clearServerError('description'),
            validator: (_) => _serverErrors['description'],
          ),
          const SizedBox(height: 24),
          FilledButton(
            key: const Key('category_form_submit'),
            onPressed: _submitting ? null : _submit,
            child: _submitting
                ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : Text(_isEdit ? l10n.commonSaveChanges : l10n.categoriesAdd),
          ),
        ],
      ),
    );
  }
}
