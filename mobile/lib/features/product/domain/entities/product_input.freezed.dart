// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_input.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductInput {

 String get sku; String get name; String get description; int get price;/// Null: no category.
 int? get categoryId;
/// Create a copy of ProductInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductInputCopyWith<ProductInput> get copyWith => _$ProductInputCopyWithImpl<ProductInput>(this as ProductInput, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProductInput;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductInput&&(identical(other.sku, _this.sku) || other.sku == _this.sku)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId));
}


@override
int get hashCode {
  final _this = this as ProductInput;
  return Object.hash(runtimeType,_this.sku,_this.name,_this.description,_this.price,_this.categoryId);
}

@override
String toString() {
  final _this = this as ProductInput;
  return 'ProductInput(sku: ${_this.sku}, name: ${_this.name}, description: ${_this.description}, price: ${_this.price}, categoryId: ${_this.categoryId})';
}


}

/// @nodoc
abstract mixin class $ProductInputCopyWith<$Res>  {
  factory $ProductInputCopyWith(ProductInput value, $Res Function(ProductInput) _then) = _$ProductInputCopyWithImpl;
@useResult
$Res call({
 String sku, String name, String description, int price, int? categoryId
});




}
/// @nodoc
class _$ProductInputCopyWithImpl<$Res>
    implements $ProductInputCopyWith<$Res> {
  _$ProductInputCopyWithImpl(this._self, this._then);

  final ProductInput _self;
  final $Res Function(ProductInput) _then;

/// Create a copy of ProductInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sku = null,Object? name = null,Object? description = null,Object? price = null,Object? categoryId = freezed,}) {
  return _then(ProductInput(
sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductInput].
extension ProductInputPatterns on ProductInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductInput value)  $default,){
final _that = this;
switch (_that) {
case _ProductInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductInput value)?  $default,){
final _that = this;
switch (_that) {
case _ProductInput() when $default != null:
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
case _ProductInput() when $default != null:
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
case _ProductInput():
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
case _ProductInput() when $default != null:
return $default(_that.sku,_that.name,_that.description,_that.price,_that.categoryId);case _:
  return null;

}
}

}

/// @nodoc


class _ProductInput extends ProductInput {
  const _ProductInput({required this.sku, required this.name, this.description = '', required this.price, this.categoryId}): super._();
  

@override final  String sku;
@override final  String name;
@override@JsonKey() final  String description;
@override final  int price;
/// Null: no category.
@override final  int? categoryId;

/// Create a copy of ProductInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductInputCopyWith<_ProductInput> get copyWith => __$ProductInputCopyWithImpl<_ProductInput>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductInput&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,sku,name,description,price,categoryId);
}

@override
String toString() {
    return 'ProductInput(sku: $sku, name: $name, description: $description, price: $price, categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class _$ProductInputCopyWith<$Res> implements $ProductInputCopyWith<$Res> {
  factory _$ProductInputCopyWith(_ProductInput value, $Res Function(_ProductInput) _then) = __$ProductInputCopyWithImpl;
@override @useResult
$Res call({
 String sku, String name, String description, int price, int? categoryId
});




}
/// @nodoc
class __$ProductInputCopyWithImpl<$Res>
    implements _$ProductInputCopyWith<$Res> {
  __$ProductInputCopyWithImpl(this._self, this._then);

  final _ProductInput _self;
  final $Res Function(_ProductInput) _then;

/// Create a copy of ProductInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sku = null,Object? name = null,Object? description = null,Object? price = null,Object? categoryId = freezed,}) {
  return _then(_ProductInput(
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
mixin _$ProductPatch {

 String? get sku; String? get name; String? get description; int? get price;/// Null keeps the current category; [noCategory] removes it.
 int? get categoryId;
/// Create a copy of ProductPatch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductPatchCopyWith<ProductPatch> get copyWith => _$ProductPatchCopyWithImpl<ProductPatch>(this as ProductPatch, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProductPatch;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductPatch&&(identical(other.sku, _this.sku) || other.sku == _this.sku)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId));
}


@override
int get hashCode {
  final _this = this as ProductPatch;
  return Object.hash(runtimeType,_this.sku,_this.name,_this.description,_this.price,_this.categoryId);
}

@override
String toString() {
  final _this = this as ProductPatch;
  return 'ProductPatch(sku: ${_this.sku}, name: ${_this.name}, description: ${_this.description}, price: ${_this.price}, categoryId: ${_this.categoryId})';
}


}

/// @nodoc
abstract mixin class $ProductPatchCopyWith<$Res>  {
  factory $ProductPatchCopyWith(ProductPatch value, $Res Function(ProductPatch) _then) = _$ProductPatchCopyWithImpl;
@useResult
$Res call({
 String? sku, String? name, String? description, int? price, int? categoryId
});




}
/// @nodoc
class _$ProductPatchCopyWithImpl<$Res>
    implements $ProductPatchCopyWith<$Res> {
  _$ProductPatchCopyWithImpl(this._self, this._then);

  final ProductPatch _self;
  final $Res Function(ProductPatch) _then;

/// Create a copy of ProductPatch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sku = freezed,Object? name = freezed,Object? description = freezed,Object? price = freezed,Object? categoryId = freezed,}) {
  return _then(ProductPatch(
sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductPatch].
extension ProductPatchPatterns on ProductPatch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductPatch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductPatch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductPatch value)  $default,){
final _that = this;
switch (_that) {
case _ProductPatch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductPatch value)?  $default,){
final _that = this;
switch (_that) {
case _ProductPatch() when $default != null:
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
case _ProductPatch() when $default != null:
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
case _ProductPatch():
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
case _ProductPatch() when $default != null:
return $default(_that.sku,_that.name,_that.description,_that.price,_that.categoryId);case _:
  return null;

}
}

}

/// @nodoc


class _ProductPatch extends ProductPatch {
  const _ProductPatch({this.sku, this.name, this.description, this.price, this.categoryId}): super._();
  

@override final  String? sku;
@override final  String? name;
@override final  String? description;
@override final  int? price;
/// Null keeps the current category; [noCategory] removes it.
@override final  int? categoryId;

/// Create a copy of ProductPatch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductPatchCopyWith<_ProductPatch> get copyWith => __$ProductPatchCopyWithImpl<_ProductPatch>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductPatch&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,sku,name,description,price,categoryId);
}

@override
String toString() {
    return 'ProductPatch(sku: $sku, name: $name, description: $description, price: $price, categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class _$ProductPatchCopyWith<$Res> implements $ProductPatchCopyWith<$Res> {
  factory _$ProductPatchCopyWith(_ProductPatch value, $Res Function(_ProductPatch) _then) = __$ProductPatchCopyWithImpl;
@override @useResult
$Res call({
 String? sku, String? name, String? description, int? price, int? categoryId
});




}
/// @nodoc
class __$ProductPatchCopyWithImpl<$Res>
    implements _$ProductPatchCopyWith<$Res> {
  __$ProductPatchCopyWithImpl(this._self, this._then);

  final _ProductPatch _self;
  final $Res Function(_ProductPatch) _then;

/// Create a copy of ProductPatch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sku = freezed,Object? name = freezed,Object? description = freezed,Object? price = freezed,Object? categoryId = freezed,}) {
  return _then(_ProductPatch(
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
