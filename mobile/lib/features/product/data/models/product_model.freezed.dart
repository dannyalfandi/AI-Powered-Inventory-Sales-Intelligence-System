// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductModel {

 int get id; String get sku; String get name; String get description; int get price; DateTime get createdAt; DateTime get updatedAt; int? get categoryId; ProductCategoryModel? get category;
/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductModelCopyWith<ProductModel> get copyWith => _$ProductModelCopyWithImpl<ProductModel>(this as ProductModel, _$identity);

  /// Serializes this ProductModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProductModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.sku, _this.sku) || other.sku == _this.sku)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.category, _this.category) || other.category == _this.category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProductModel;
  return Object.hash(runtimeType,_this.id,_this.sku,_this.name,_this.description,_this.price,_this.createdAt,_this.updatedAt,_this.categoryId,_this.category);
}

@override
String toString() {
  final _this = this as ProductModel;
  return 'ProductModel(id: ${_this.id}, sku: ${_this.sku}, name: ${_this.name}, description: ${_this.description}, price: ${_this.price}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, categoryId: ${_this.categoryId}, category: ${_this.category})';
}


}

/// @nodoc
abstract mixin class $ProductModelCopyWith<$Res>  {
  factory $ProductModelCopyWith(ProductModel value, $Res Function(ProductModel) _then) = _$ProductModelCopyWithImpl;
@useResult
$Res call({
 int id, String sku, String name, String description, int price, DateTime createdAt, DateTime updatedAt, int? categoryId, ProductCategoryModel? category
});


$ProductCategoryModelCopyWith<$Res>? get category;

}
/// @nodoc
class _$ProductModelCopyWithImpl<$Res>
    implements $ProductModelCopyWith<$Res> {
  _$ProductModelCopyWithImpl(this._self, this._then);

  final ProductModel _self;
  final $Res Function(ProductModel) _then;

/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sku = null,Object? name = null,Object? description = null,Object? price = null,Object? createdAt = null,Object? updatedAt = null,Object? categoryId = freezed,Object? category = freezed,}) {
  return _then(ProductModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ProductCategoryModel?,
  ));
}
/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductCategoryModelCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $ProductCategoryModelCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProductModel].
extension ProductModelPatterns on ProductModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductModel value)  $default,){
final _that = this;
switch (_that) {
case _ProductModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String sku,  String name,  String description,  int price,  DateTime createdAt,  DateTime updatedAt,  int? categoryId,  ProductCategoryModel? category)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
return $default(_that.id,_that.sku,_that.name,_that.description,_that.price,_that.createdAt,_that.updatedAt,_that.categoryId,_that.category);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String sku,  String name,  String description,  int price,  DateTime createdAt,  DateTime updatedAt,  int? categoryId,  ProductCategoryModel? category)  $default,) {final _that = this;
switch (_that) {
case _ProductModel():
return $default(_that.id,_that.sku,_that.name,_that.description,_that.price,_that.createdAt,_that.updatedAt,_that.categoryId,_that.category);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String sku,  String name,  String description,  int price,  DateTime createdAt,  DateTime updatedAt,  int? categoryId,  ProductCategoryModel? category)?  $default,) {final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
return $default(_that.id,_that.sku,_that.name,_that.description,_that.price,_that.createdAt,_that.updatedAt,_that.categoryId,_that.category);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductModel extends ProductModel {
  const _ProductModel({required this.id, required this.sku, required this.name, this.description = '', required this.price, required this.createdAt, required this.updatedAt, this.categoryId, this.category}): super._();
  factory _ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);

@override final  int id;
@override final  String sku;
@override final  String name;
@override@JsonKey() final  String description;
@override final  int price;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  int? categoryId;
@override final  ProductCategoryModel? category;

/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductModelCopyWith<_ProductModel> get copyWith => __$ProductModelCopyWithImpl<_ProductModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductModel&&(identical(other.id, id) || other.id == id)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,sku,name,description,price,createdAt,updatedAt,categoryId,category);
}

@override
String toString() {
    return 'ProductModel(id: $id, sku: $sku, name: $name, description: $description, price: $price, createdAt: $createdAt, updatedAt: $updatedAt, categoryId: $categoryId, category: $category)';
}


}

/// @nodoc
abstract mixin class _$ProductModelCopyWith<$Res> implements $ProductModelCopyWith<$Res> {
  factory _$ProductModelCopyWith(_ProductModel value, $Res Function(_ProductModel) _then) = __$ProductModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String sku, String name, String description, int price, DateTime createdAt, DateTime updatedAt, int? categoryId, ProductCategoryModel? category
});


@override $ProductCategoryModelCopyWith<$Res>? get category;

}
/// @nodoc
class __$ProductModelCopyWithImpl<$Res>
    implements _$ProductModelCopyWith<$Res> {
  __$ProductModelCopyWithImpl(this._self, this._then);

  final _ProductModel _self;
  final $Res Function(_ProductModel) _then;

/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sku = null,Object? name = null,Object? description = null,Object? price = null,Object? createdAt = null,Object? updatedAt = null,Object? categoryId = freezed,Object? category = freezed,}) {
  return _then(_ProductModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ProductCategoryModel?,
  ));
}

/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductCategoryModelCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $ProductCategoryModelCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}


/// @nodoc
mixin _$ProductCategoryModel {

 int get id; String get name;
/// Create a copy of ProductCategoryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCategoryModelCopyWith<ProductCategoryModel> get copyWith => _$ProductCategoryModelCopyWithImpl<ProductCategoryModel>(this as ProductCategoryModel, _$identity);

  /// Serializes this ProductCategoryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProductCategoryModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductCategoryModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProductCategoryModel;
  return Object.hash(runtimeType,_this.id,_this.name);
}

@override
String toString() {
  final _this = this as ProductCategoryModel;
  return 'ProductCategoryModel(id: ${_this.id}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $ProductCategoryModelCopyWith<$Res>  {
  factory $ProductCategoryModelCopyWith(ProductCategoryModel value, $Res Function(ProductCategoryModel) _then) = _$ProductCategoryModelCopyWithImpl;
@useResult
$Res call({
 int id, String name
});




}
/// @nodoc
class _$ProductCategoryModelCopyWithImpl<$Res>
    implements $ProductCategoryModelCopyWith<$Res> {
  _$ProductCategoryModelCopyWithImpl(this._self, this._then);

  final ProductCategoryModel _self;
  final $Res Function(ProductCategoryModel) _then;

/// Create a copy of ProductCategoryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(ProductCategoryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductCategoryModel].
extension ProductCategoryModelPatterns on ProductCategoryModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductCategoryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductCategoryModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductCategoryModel value)  $default,){
final _that = this;
switch (_that) {
case _ProductCategoryModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductCategoryModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProductCategoryModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductCategoryModel() when $default != null:
return $default(_that.id,_that.name);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name)  $default,) {final _that = this;
switch (_that) {
case _ProductCategoryModel():
return $default(_that.id,_that.name);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _ProductCategoryModel() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductCategoryModel extends ProductCategoryModel {
  const _ProductCategoryModel({required this.id, required this.name}): super._();
  factory _ProductCategoryModel.fromJson(Map<String, dynamic> json) => _$ProductCategoryModelFromJson(json);

@override final  int id;
@override final  String name;

/// Create a copy of ProductCategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCategoryModelCopyWith<_ProductCategoryModel> get copyWith => __$ProductCategoryModelCopyWithImpl<_ProductCategoryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductCategoryModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductCategoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name);
}

@override
String toString() {
    return 'ProductCategoryModel(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$ProductCategoryModelCopyWith<$Res> implements $ProductCategoryModelCopyWith<$Res> {
  factory _$ProductCategoryModelCopyWith(_ProductCategoryModel value, $Res Function(_ProductCategoryModel) _then) = __$ProductCategoryModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name
});




}
/// @nodoc
class __$ProductCategoryModelCopyWithImpl<$Res>
    implements _$ProductCategoryModelCopyWith<$Res> {
  __$ProductCategoryModelCopyWithImpl(this._self, this._then);

  final _ProductCategoryModel _self;
  final $Res Function(_ProductCategoryModel) _then;

/// Create a copy of ProductCategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_ProductCategoryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CreateProductRequest {

 String get sku; String get name; String get description; int get price; int? get categoryId;
/// Create a copy of CreateProductRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateProductRequestCopyWith<CreateProductRequest> get copyWith => _$CreateProductRequestCopyWithImpl<CreateProductRequest>(this as CreateProductRequest, _$identity);

  /// Serializes this CreateProductRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CreateProductRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateProductRequest&&(identical(other.sku, _this.sku) || other.sku == _this.sku)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CreateProductRequest;
  return Object.hash(runtimeType,_this.sku,_this.name,_this.description,_this.price,_this.categoryId);
}

@override
String toString() {
  final _this = this as CreateProductRequest;
  return 'CreateProductRequest(sku: ${_this.sku}, name: ${_this.name}, description: ${_this.description}, price: ${_this.price}, categoryId: ${_this.categoryId})';
}


}

/// @nodoc
abstract mixin class $CreateProductRequestCopyWith<$Res>  {
  factory $CreateProductRequestCopyWith(CreateProductRequest value, $Res Function(CreateProductRequest) _then) = _$CreateProductRequestCopyWithImpl;
@useResult
$Res call({
 String sku, String name, String description, int price, int? categoryId
});




}
/// @nodoc
class _$CreateProductRequestCopyWithImpl<$Res>
    implements $CreateProductRequestCopyWith<$Res> {
  _$CreateProductRequestCopyWithImpl(this._self, this._then);

  final CreateProductRequest _self;
  final $Res Function(CreateProductRequest) _then;

/// Create a copy of CreateProductRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sku = null,Object? name = null,Object? description = null,Object? price = null,Object? categoryId = freezed,}) {
  return _then(CreateProductRequest(
sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateProductRequest].
extension CreateProductRequestPatterns on CreateProductRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateProductRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateProductRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateProductRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateProductRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateProductRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateProductRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sku,  String name,  String description,  int price,  int? categoryId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateProductRequest() when $default != null:
return $default(_that.sku,_that.name,_that.description,_that.price,_that.categoryId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sku,  String name,  String description,  int price,  int? categoryId)  $default,) {final _that = this;
switch (_that) {
case _CreateProductRequest():
return $default(_that.sku,_that.name,_that.description,_that.price,_that.categoryId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sku,  String name,  String description,  int price,  int? categoryId)?  $default,) {final _that = this;
switch (_that) {
case _CreateProductRequest() when $default != null:
return $default(_that.sku,_that.name,_that.description,_that.price,_that.categoryId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateProductRequest implements CreateProductRequest {
  const _CreateProductRequest({required this.sku, required this.name, required this.description, required this.price, this.categoryId});
  factory _CreateProductRequest.fromJson(Map<String, dynamic> json) => _$CreateProductRequestFromJson(json);

@override final  String sku;
@override final  String name;
@override final  String description;
@override final  int price;
@override final  int? categoryId;

/// Create a copy of CreateProductRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateProductRequestCopyWith<_CreateProductRequest> get copyWith => __$CreateProductRequestCopyWithImpl<_CreateProductRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateProductRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateProductRequest&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,sku,name,description,price,categoryId);
}

@override
String toString() {
    return 'CreateProductRequest(sku: $sku, name: $name, description: $description, price: $price, categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class _$CreateProductRequestCopyWith<$Res> implements $CreateProductRequestCopyWith<$Res> {
  factory _$CreateProductRequestCopyWith(_CreateProductRequest value, $Res Function(_CreateProductRequest) _then) = __$CreateProductRequestCopyWithImpl;
@override @useResult
$Res call({
 String sku, String name, String description, int price, int? categoryId
});




}
/// @nodoc
class __$CreateProductRequestCopyWithImpl<$Res>
    implements _$CreateProductRequestCopyWith<$Res> {
  __$CreateProductRequestCopyWithImpl(this._self, this._then);

  final _CreateProductRequest _self;
  final $Res Function(_CreateProductRequest) _then;

/// Create a copy of CreateProductRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sku = null,Object? name = null,Object? description = null,Object? price = null,Object? categoryId = freezed,}) {
  return _then(_CreateProductRequest(
sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$UpdateProductRequest {

 String? get sku; String? get name; String? get description; int? get price; int? get categoryId;
/// Create a copy of UpdateProductRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateProductRequestCopyWith<UpdateProductRequest> get copyWith => _$UpdateProductRequestCopyWithImpl<UpdateProductRequest>(this as UpdateProductRequest, _$identity);

  /// Serializes this UpdateProductRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UpdateProductRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateProductRequest&&(identical(other.sku, _this.sku) || other.sku == _this.sku)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UpdateProductRequest;
  return Object.hash(runtimeType,_this.sku,_this.name,_this.description,_this.price,_this.categoryId);
}

@override
String toString() {
  final _this = this as UpdateProductRequest;
  return 'UpdateProductRequest(sku: ${_this.sku}, name: ${_this.name}, description: ${_this.description}, price: ${_this.price}, categoryId: ${_this.categoryId})';
}


}

/// @nodoc
abstract mixin class $UpdateProductRequestCopyWith<$Res>  {
  factory $UpdateProductRequestCopyWith(UpdateProductRequest value, $Res Function(UpdateProductRequest) _then) = _$UpdateProductRequestCopyWithImpl;
@useResult
$Res call({
 String? sku, String? name, String? description, int? price, int? categoryId
});




}
/// @nodoc
class _$UpdateProductRequestCopyWithImpl<$Res>
    implements $UpdateProductRequestCopyWith<$Res> {
  _$UpdateProductRequestCopyWithImpl(this._self, this._then);

  final UpdateProductRequest _self;
  final $Res Function(UpdateProductRequest) _then;

/// Create a copy of UpdateProductRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sku = freezed,Object? name = freezed,Object? description = freezed,Object? price = freezed,Object? categoryId = freezed,}) {
  return _then(UpdateProductRequest(
sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateProductRequest].
extension UpdateProductRequestPatterns on UpdateProductRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateProductRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateProductRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateProductRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateProductRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateProductRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateProductRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? sku,  String? name,  String? description,  int? price,  int? categoryId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateProductRequest() when $default != null:
return $default(_that.sku,_that.name,_that.description,_that.price,_that.categoryId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? sku,  String? name,  String? description,  int? price,  int? categoryId)  $default,) {final _that = this;
switch (_that) {
case _UpdateProductRequest():
return $default(_that.sku,_that.name,_that.description,_that.price,_that.categoryId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? sku,  String? name,  String? description,  int? price,  int? categoryId)?  $default,) {final _that = this;
switch (_that) {
case _UpdateProductRequest() when $default != null:
return $default(_that.sku,_that.name,_that.description,_that.price,_that.categoryId);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(includeIfNull: false)
class _UpdateProductRequest implements UpdateProductRequest {
  const _UpdateProductRequest({this.sku, this.name, this.description, this.price, this.categoryId});
  factory _UpdateProductRequest.fromJson(Map<String, dynamic> json) => _$UpdateProductRequestFromJson(json);

@override final  String? sku;
@override final  String? name;
@override final  String? description;
@override final  int? price;
@override final  int? categoryId;

/// Create a copy of UpdateProductRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateProductRequestCopyWith<_UpdateProductRequest> get copyWith => __$UpdateProductRequestCopyWithImpl<_UpdateProductRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateProductRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateProductRequest&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,sku,name,description,price,categoryId);
}

@override
String toString() {
    return 'UpdateProductRequest(sku: $sku, name: $name, description: $description, price: $price, categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class _$UpdateProductRequestCopyWith<$Res> implements $UpdateProductRequestCopyWith<$Res> {
  factory _$UpdateProductRequestCopyWith(_UpdateProductRequest value, $Res Function(_UpdateProductRequest) _then) = __$UpdateProductRequestCopyWithImpl;
@override @useResult
$Res call({
 String? sku, String? name, String? description, int? price, int? categoryId
});




}
/// @nodoc
class __$UpdateProductRequestCopyWithImpl<$Res>
    implements _$UpdateProductRequestCopyWith<$Res> {
  __$UpdateProductRequestCopyWithImpl(this._self, this._then);

  final _UpdateProductRequest _self;
  final $Res Function(_UpdateProductRequest) _then;

/// Create a copy of UpdateProductRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sku = freezed,Object? name = freezed,Object? description = freezed,Object? price = freezed,Object? categoryId = freezed,}) {
  return _then(_UpdateProductRequest(
sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
