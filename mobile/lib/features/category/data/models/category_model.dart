import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/category.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

/// JSON shape of a category from the Go backend (backend/internal/model/category.go):
/// `{"id","name","description","created_at","updated_at"}`.
@freezed
abstract class CategoryModel with _$CategoryModel {
  const CategoryModel._();

  const factory CategoryModel({
    required int id,
    required String name,
    @Default('') String description,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => _$CategoryModelFromJson(json);

  Category toEntity() => Category(
        id: id,
        name: name,
        description: description,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

/// Request body for POST /api/v1/categories (backend model.CreateCategoryInput).
@freezed
abstract class CreateCategoryRequest with _$CreateCategoryRequest {
  const factory CreateCategoryRequest({
    required String name,
    required String description,
  }) = _CreateCategoryRequest;

  factory CreateCategoryRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateCategoryRequestFromJson(json);

  factory CreateCategoryRequest.fromEntity(CategoryInput input) =>
      CreateCategoryRequest(name: input.name, description: input.description);
}

/// Request body for PATCH /api/v1/categories/:id. Null fields are omitted so
/// the backend leaves them unchanged.
@freezed
abstract class UpdateCategoryRequest with _$UpdateCategoryRequest {
  @JsonSerializable(includeIfNull: false)
  const factory UpdateCategoryRequest({
    String? name,
    String? description,
  }) = _UpdateCategoryRequest;

  factory UpdateCategoryRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateCategoryRequestFromJson(json);

  factory UpdateCategoryRequest.fromEntity(CategoryPatch patch) =>
      UpdateCategoryRequest(name: patch.name, description: patch.description);
}
