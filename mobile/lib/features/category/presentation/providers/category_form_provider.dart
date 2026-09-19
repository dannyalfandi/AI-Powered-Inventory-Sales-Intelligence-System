import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/category.dart';
import 'category_list_provider.dart';
import 'category_providers.dart';

part 'category_form_provider.g.dart';

/// Backs the create/edit form. `categoryId == null` → create mode (state is
/// `null`); otherwise loads the category via GET /api/v1/categories/:id.
@riverpod
class CategoryForm extends _$CategoryForm {
  @override
  Future<Category?> build(int? categoryId) async {
    if (categoryId == null) return null;
    return ref.watch(getCategoryByIdUseCaseProvider)(categoryId);
  }

  /// Creates or updates (PATCH with only the changed fields). Throws `Failure`
  /// so the form can show field errors; refreshes lists on success.
  Future<Category> save(CategoryInput input) async {
    final id = categoryId;
    final Category saved;
    if (id == null) {
      saved = await ref.read(createCategoryUseCaseProvider)(input);
    } else {
      final existing = state.value;
      final data = input.trimmed();
      final patch = existing == null
          ? CategoryPatch(name: data.name, description: data.description)
          : CategoryPatch(
              name: data.name != existing.name ? data.name : null,
              description: data.description != existing.description ? data.description : null,
            );
      saved = patch.isEmpty ? existing! : await ref.read(updateCategoryUseCaseProvider)(id, patch);
    }

    ref.invalidate(categoryListProvider);
    ref.invalidate(categoryOptionsProvider);
    if (ref.mounted) state = AsyncData(saved);
    return saved;
  }
}
