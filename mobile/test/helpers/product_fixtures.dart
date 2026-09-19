import 'package:inventory_intel/features/product/domain/entities/product.dart';
import 'package:inventory_intel/features/product/domain/entities/product_input.dart';
import 'package:inventory_intel/features/product/domain/repositories/product_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockProductRepository extends Mock implements ProductRepository {}

final _ts = DateTime.utc(2026, 9, 1);

/// Pass [category] to put the product in a category (sets categoryId too).
Product product(
  int id, {
  String? sku,
  String? name,
  int price = 10000,
  String description = '',
  ProductCategory? category,
}) =>
    Product(
      id: id,
      sku: sku ?? 'SKU-$id',
      name: name ?? 'Produk $id',
      description: description,
      price: price,
      createdAt: _ts,
      updatedAt: _ts,
      categoryId: category?.id,
      category: category,
    );

ProductPage productPage(List<Product> items, {int page = 1, int pageSize = 20, int? total}) =>
    ProductPage(items: items, page: page, pageSize: pageSize, total: total ?? items.length);

/// Call once in `setUpAll` so `any()` works for these argument types.
void registerProductFallbacks() {
  registerFallbackValue(const ProductInput(sku: 'x', name: 'x', price: 0));
  registerFallbackValue(const ProductPatch());
}
