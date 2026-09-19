import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/product.dart';
import '../../domain/entities/product_input.dart';
import 'product_list_provider.dart';
import 'product_providers.dart';

part 'product_form_provider.g.dart';

/// Backs the create/edit form. `productId == null` → create mode (state is
/// `null`); otherwise loads the product via GET /api/v1/products/:id.
@riverpod
class ProductForm extends _$ProductForm {
  @override
  Future<Product?> build(int? productId) async {
    if (productId == null) return null;
    return ref.watch(getProductByIdUseCaseProvider)(productId);
  }

  /// Creates or updates (PATCH with only the changed fields). Throws `Failure`
  /// so the form can show field errors; refreshes the product list on success.
  Future<Product> save(ProductInput input) async {
    final id = productId;
    final Product saved;
    if (id == null) {
      saved = await ref.read(createProductUseCaseProvider)(input);
    } else {
      final existing = state.value;
      final patch = existing == null ? _fullPatch(input) : _diff(existing, input.trimmed());
      saved = patch.isEmpty ? existing! : await ref.read(updateProductUseCaseProvider)(id, patch);
    }

    ref.invalidate(productListProvider);
    if (id != null) ref.invalidate(productDetailProvider(id));
    if (ref.mounted) state = AsyncData(saved);
    return saved;
  }

  static ProductPatch _fullPatch(ProductInput i) => ProductPatch(
        sku: i.sku,
        name: i.name,
        description: i.description,
        price: i.price,
        categoryId: i.categoryId ?? ProductPatch.noCategory,
      );

  static ProductPatch _diff(Product old, ProductInput i) => ProductPatch(
        sku: i.sku != old.sku ? i.sku : null,
        name: i.name != old.name ? i.name : null,
        description: i.description != old.description ? i.description : null,
        price: i.price != old.price ? i.price : null,
        categoryId: i.categoryId != old.categoryId ? (i.categoryId ?? ProductPatch.noCategory) : null,
      );
}

/// A single product for the product detail (stock) screen. Invalidated by
/// [ProductForm.save] after an edit.
@riverpod
Future<Product> productDetail(Ref ref, int productId) =>
    ref.watch(getProductByIdUseCaseProvider)(productId);
