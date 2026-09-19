import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';

/// A sellable item. [price] is in whole Rupiah (matches the backend int64).
@freezed
abstract class Product with _$Product {
  const factory Product({
    required int id,
    required String sku,
    required String name,
    required String description,
    required int price,
    required DateTime createdAt,
    required DateTime updatedAt,

    /// Null when the product has no category.
    int? categoryId,
    ProductCategory? category,
  }) = _Product;
}

/// The part of a category a product needs to show (the backend embeds the
/// full category object in product responses).
@freezed
abstract class ProductCategory with _$ProductCategory {
  const factory ProductCategory({
    required int id,
    required String name,
  }) = _ProductCategory;
}

/// One page of products plus pagination info from the backend `meta`.
@freezed
abstract class ProductPage with _$ProductPage {
  const ProductPage._();

  const factory ProductPage({
    required List<Product> items,
    required int page,
    required int pageSize,
    required int total,
  }) = _ProductPage;

  bool get hasMore => page * pageSize < total;
}
