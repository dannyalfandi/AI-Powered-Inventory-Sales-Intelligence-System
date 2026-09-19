import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/product.dart';
import '../../domain/entities/product_input.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

/// JSON shape of a product from the Go backend (backend/internal/model/product.go).
/// Keys are snake_case via build.yaml `field_rename: snake`.
///
/// `category_id` is `null` without a category; `category` is then omitted
/// entirely (Go `omitempty`), otherwise it is the full category object.
@freezed
abstract class ProductModel with _$ProductModel {
  const ProductModel._();

  const factory ProductModel({
    required int id,
    required String sku,
    required String name,
    @Default('') String description,
    required int price,
    required DateTime createdAt,
    required DateTime updatedAt,
    int? categoryId,
    ProductCategoryModel? category,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);

  Product toEntity() => Product(
        id: id,
        sku: sku,
        name: name,
        description: description,
        price: price,
        createdAt: createdAt,
        updatedAt: updatedAt,
        categoryId: categoryId,
        category: category?.toEntity(),
      );
}

/// Embedded category (backend model.Category). Only `id` and `name` are used;
/// the other keys (`description`, timestamps) are ignored.
@freezed
abstract class ProductCategoryModel with _$ProductCategoryModel {
  const ProductCategoryModel._();

  const factory ProductCategoryModel({
    required int id,
    required String name,
  }) = _ProductCategoryModel;

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$ProductCategoryModelFromJson(json);

  ProductCategory toEntity() => ProductCategory(id: id, name: name);
}

/// Request body for POST /api/v1/products (backend model.CreateProductInput).
/// `category_id: null` creates the product without a category.
@freezed
abstract class CreateProductRequest with _$CreateProductRequest {
  const factory CreateProductRequest({
    required String sku,
    required String name,
    required String description,
    required int price,
    int? categoryId,
  }) = _CreateProductRequest;

  factory CreateProductRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateProductRequestFromJson(json);

  factory CreateProductRequest.fromEntity(ProductInput input) => CreateProductRequest(
        sku: input.sku,
        name: input.name,
        description: input.description,
        price: input.price,
        categoryId: input.categoryId,
      );
}

/// Request body for PATCH /api/v1/products/:id (backend model.UpdateProductInput).
/// Null fields are omitted from JSON so the backend leaves them unchanged;
/// `category_id: 0` removes the category.
@freezed
abstract class UpdateProductRequest with _$UpdateProductRequest {
  @JsonSerializable(includeIfNull: false)
  const factory UpdateProductRequest({
    String? sku,
    String? name,
    String? description,
    int? price,
    int? categoryId,
  }) = _UpdateProductRequest;

  factory UpdateProductRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProductRequestFromJson(json);

  factory UpdateProductRequest.fromEntity(ProductPatch patch) => UpdateProductRequest(
        sku: patch.sku,
        name: patch.name,
        description: patch.description,
        price: patch.price,
        categoryId: patch.categoryId,
      );
}
