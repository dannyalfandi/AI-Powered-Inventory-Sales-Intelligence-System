// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductModel _$ProductModelFromJson(Map<String, dynamic> json) =>
    _ProductModel(
      id: (json['id'] as num).toInt(),
      sku: json['sku'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      price: (json['price'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      categoryId: (json['category_id'] as num?)?.toInt(),
      category: json['category'] == null
          ? null
          : ProductCategoryModel.fromJson(
              json['category'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$ProductModelToJson(_ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sku': instance.sku,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'category_id': instance.categoryId,
      'category': instance.category?.toJson(),
    };

_ProductCategoryModel _$ProductCategoryModelFromJson(
  Map<String, dynamic> json,
) => _ProductCategoryModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
);

Map<String, dynamic> _$ProductCategoryModelToJson(
  _ProductCategoryModel instance,
) => <String, dynamic>{'id': instance.id, 'name': instance.name};

_CreateProductRequest _$CreateProductRequestFromJson(
  Map<String, dynamic> json,
) => _CreateProductRequest(
  sku: json['sku'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  price: (json['price'] as num).toInt(),
  categoryId: (json['category_id'] as num?)?.toInt(),
);

Map<String, dynamic> _$CreateProductRequestToJson(
  _CreateProductRequest instance,
) => <String, dynamic>{
  'sku': instance.sku,
  'name': instance.name,
  'description': instance.description,
  'price': instance.price,
  'category_id': instance.categoryId,
};

_UpdateProductRequest _$UpdateProductRequestFromJson(
  Map<String, dynamic> json,
) => _UpdateProductRequest(
  sku: json['sku'] as String?,
  name: json['name'] as String?,
  description: json['description'] as String?,
  price: (json['price'] as num?)?.toInt(),
  categoryId: (json['category_id'] as num?)?.toInt(),
);

Map<String, dynamic> _$UpdateProductRequestToJson(
  _UpdateProductRequest instance,
) => <String, dynamic>{
  'sku': ?instance.sku,
  'name': ?instance.name,
  'description': ?instance.description,
  'price': ?instance.price,
  'category_id': ?instance.categoryId,
};
