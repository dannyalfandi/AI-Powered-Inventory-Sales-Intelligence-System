// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CategoryModel {

 int get id; String get name; String get description; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of CategoryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryModelCopyWith<CategoryModel> get copyWith => _$CategoryModelCopyWithImpl<CategoryModel>(this as CategoryModel, _$identity);

  /// Serializes this CategoryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CategoryModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CategoryModel;
  return Object.hash(runtimeType,_this.id,_this.name,_this.description,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as CategoryModel;
  return 'CategoryModel(id: ${_this.id}, name: ${_this.name}, description: ${_this.description}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $CategoryModelCopyWith<$Res>  {
  factory $CategoryModelCopyWith(CategoryModel value, $Res Function(CategoryModel) _then) = _$CategoryModelCopyWithImpl;
@useResult
$Res call({
 int id, String name, String description, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$CategoryModelCopyWithImpl<$Res>
    implements $CategoryModelCopyWith<$Res> {
  _$CategoryModelCopyWithImpl(this._self, this._then);

  final CategoryModel _self;
  final $Res Function(CategoryModel) _then;

/// Create a copy of CategoryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(CategoryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryModel].
extension CategoryModelPatterns on CategoryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryModel value)  $default,){
final _that = this;
switch (_that) {
case _CategoryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryModel value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String description,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String description,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _CategoryModel():
return $default(_that.id,_that.name,_that.description,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String description,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _CategoryModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategoryModel extends CategoryModel {
  const _CategoryModel({required this.id, required this.name, this.description = '', required this.createdAt, required this.updatedAt}): super._();
  factory _CategoryModel.fromJson(Map<String, dynamic> json) => _$CategoryModelFromJson(json);

@override final  int id;
@override final  String name;
@override@JsonKey() final  String description;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of CategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryModelCopyWith<_CategoryModel> get copyWith => __$CategoryModelCopyWithImpl<_CategoryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,description,createdAt,updatedAt);
}

@override
String toString() {
    return 'CategoryModel(id: $id, name: $name, description: $description, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CategoryModelCopyWith<$Res> implements $CategoryModelCopyWith<$Res> {
  factory _$CategoryModelCopyWith(_CategoryModel value, $Res Function(_CategoryModel) _then) = __$CategoryModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String description, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$CategoryModelCopyWithImpl<$Res>
    implements _$CategoryModelCopyWith<$Res> {
  __$CategoryModelCopyWithImpl(this._self, this._then);

  final _CategoryModel _self;
  final $Res Function(_CategoryModel) _then;

/// Create a copy of CategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_CategoryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$CreateCategoryRequest {

 String get name; String get description;
/// Create a copy of CreateCategoryRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateCategoryRequestCopyWith<CreateCategoryRequest> get copyWith => _$CreateCategoryRequestCopyWithImpl<CreateCategoryRequest>(this as CreateCategoryRequest, _$identity);

  /// Serializes this CreateCategoryRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CreateCategoryRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateCategoryRequest&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CreateCategoryRequest;
  return Object.hash(runtimeType,_this.name,_this.description);
}

@override
String toString() {
  final _this = this as CreateCategoryRequest;
  return 'CreateCategoryRequest(name: ${_this.name}, description: ${_this.description})';
}


}

/// @nodoc
abstract mixin class $CreateCategoryRequestCopyWith<$Res>  {
  factory $CreateCategoryRequestCopyWith(CreateCategoryRequest value, $Res Function(CreateCategoryRequest) _then) = _$CreateCategoryRequestCopyWithImpl;
@useResult
$Res call({
 String name, String description
});




}
/// @nodoc
class _$CreateCategoryRequestCopyWithImpl<$Res>
    implements $CreateCategoryRequestCopyWith<$Res> {
  _$CreateCategoryRequestCopyWithImpl(this._self, this._then);

  final CreateCategoryRequest _self;
  final $Res Function(CreateCategoryRequest) _then;

/// Create a copy of CreateCategoryRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = null,}) {
  return _then(CreateCategoryRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateCategoryRequest].
extension CreateCategoryRequestPatterns on CreateCategoryRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateCategoryRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateCategoryRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateCategoryRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateCategoryRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateCategoryRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateCategoryRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateCategoryRequest() when $default != null:
return $default(_that.name,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String description)  $default,) {final _that = this;
switch (_that) {
case _CreateCategoryRequest():
return $default(_that.name,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String description)?  $default,) {final _that = this;
switch (_that) {
case _CreateCategoryRequest() when $default != null:
return $default(_that.name,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateCategoryRequest implements CreateCategoryRequest {
  const _CreateCategoryRequest({required this.name, required this.description});
  factory _CreateCategoryRequest.fromJson(Map<String, dynamic> json) => _$CreateCategoryRequestFromJson(json);

@override final  String name;
@override final  String description;

/// Create a copy of CreateCategoryRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateCategoryRequestCopyWith<_CreateCategoryRequest> get copyWith => __$CreateCategoryRequestCopyWithImpl<_CreateCategoryRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateCategoryRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateCategoryRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,description);
}

@override
String toString() {
    return 'CreateCategoryRequest(name: $name, description: $description)';
}


}

/// @nodoc
abstract mixin class _$CreateCategoryRequestCopyWith<$Res> implements $CreateCategoryRequestCopyWith<$Res> {
  factory _$CreateCategoryRequestCopyWith(_CreateCategoryRequest value, $Res Function(_CreateCategoryRequest) _then) = __$CreateCategoryRequestCopyWithImpl;
@override @useResult
$Res call({
 String name, String description
});




}
/// @nodoc
class __$CreateCategoryRequestCopyWithImpl<$Res>
    implements _$CreateCategoryRequestCopyWith<$Res> {
  __$CreateCategoryRequestCopyWithImpl(this._self, this._then);

  final _CreateCategoryRequest _self;
  final $Res Function(_CreateCategoryRequest) _then;

/// Create a copy of CreateCategoryRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = null,}) {
  return _then(_CreateCategoryRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$UpdateCategoryRequest {

 String? get name; String? get description;
/// Create a copy of UpdateCategoryRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateCategoryRequestCopyWith<UpdateCategoryRequest> get copyWith => _$UpdateCategoryRequestCopyWithImpl<UpdateCategoryRequest>(this as UpdateCategoryRequest, _$identity);

  /// Serializes this UpdateCategoryRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UpdateCategoryRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateCategoryRequest&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UpdateCategoryRequest;
  return Object.hash(runtimeType,_this.name,_this.description);
}

@override
String toString() {
  final _this = this as UpdateCategoryRequest;
  return 'UpdateCategoryRequest(name: ${_this.name}, description: ${_this.description})';
}


}

/// @nodoc
abstract mixin class $UpdateCategoryRequestCopyWith<$Res>  {
  factory $UpdateCategoryRequestCopyWith(UpdateCategoryRequest value, $Res Function(UpdateCategoryRequest) _then) = _$UpdateCategoryRequestCopyWithImpl;
@useResult
$Res call({
 String? name, String? description
});




}
/// @nodoc
class _$UpdateCategoryRequestCopyWithImpl<$Res>
    implements $UpdateCategoryRequestCopyWith<$Res> {
  _$UpdateCategoryRequestCopyWithImpl(this._self, this._then);

  final UpdateCategoryRequest _self;
  final $Res Function(UpdateCategoryRequest) _then;

/// Create a copy of UpdateCategoryRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? description = freezed,}) {
  return _then(UpdateCategoryRequest(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateCategoryRequest].
extension UpdateCategoryRequestPatterns on UpdateCategoryRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateCategoryRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateCategoryRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateCategoryRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateCategoryRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateCategoryRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateCategoryRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateCategoryRequest() when $default != null:
return $default(_that.name,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  String? description)  $default,) {final _that = this;
switch (_that) {
case _UpdateCategoryRequest():
return $default(_that.name,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _UpdateCategoryRequest() when $default != null:
return $default(_that.name,_that.description);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(includeIfNull: false)
class _UpdateCategoryRequest implements UpdateCategoryRequest {
  const _UpdateCategoryRequest({this.name, this.description});
  factory _UpdateCategoryRequest.fromJson(Map<String, dynamic> json) => _$UpdateCategoryRequestFromJson(json);

@override final  String? name;
@override final  String? description;

/// Create a copy of UpdateCategoryRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateCategoryRequestCopyWith<_UpdateCategoryRequest> get copyWith => __$UpdateCategoryRequestCopyWithImpl<_UpdateCategoryRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateCategoryRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateCategoryRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,description);
}

@override
String toString() {
    return 'UpdateCategoryRequest(name: $name, description: $description)';
}


}

/// @nodoc
abstract mixin class _$UpdateCategoryRequestCopyWith<$Res> implements $UpdateCategoryRequestCopyWith<$Res> {
  factory _$UpdateCategoryRequestCopyWith(_UpdateCategoryRequest value, $Res Function(_UpdateCategoryRequest) _then) = __$UpdateCategoryRequestCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? description
});




}
/// @nodoc
class __$UpdateCategoryRequestCopyWithImpl<$Res>
    implements _$UpdateCategoryRequestCopyWith<$Res> {
  __$UpdateCategoryRequestCopyWithImpl(this._self, this._then);

  final _UpdateCategoryRequest _self;
  final $Res Function(_UpdateCategoryRequest) _then;

/// Create a copy of UpdateCategoryRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? description = freezed,}) {
  return _then(_UpdateCategoryRequest(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
