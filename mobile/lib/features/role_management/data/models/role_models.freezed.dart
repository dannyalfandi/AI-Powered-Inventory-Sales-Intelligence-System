// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'role_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RoleModel {

 int get id; String get name; String get description; bool get isSystem; List<String>? get permissions; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of RoleModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoleModelCopyWith<RoleModel> get copyWith => _$RoleModelCopyWithImpl<RoleModel>(this as RoleModel, _$identity);

  /// Serializes this RoleModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RoleModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoleModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.isSystem, _this.isSystem) || other.isSystem == _this.isSystem)&&const DeepCollectionEquality().equals(other.permissions, _this.permissions)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RoleModel;
  return Object.hash(runtimeType,_this.id,_this.name,_this.description,_this.isSystem,const DeepCollectionEquality().hash(_this.permissions),_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as RoleModel;
  return 'RoleModel(id: ${_this.id}, name: ${_this.name}, description: ${_this.description}, isSystem: ${_this.isSystem}, permissions: ${_this.permissions}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $RoleModelCopyWith<$Res>  {
  factory $RoleModelCopyWith(RoleModel value, $Res Function(RoleModel) _then) = _$RoleModelCopyWithImpl;
@useResult
$Res call({
 int id, String name, String description, bool isSystem, List<String>? permissions, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$RoleModelCopyWithImpl<$Res>
    implements $RoleModelCopyWith<$Res> {
  _$RoleModelCopyWithImpl(this._self, this._then);

  final RoleModel _self;
  final $Res Function(RoleModel) _then;

/// Create a copy of RoleModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? isSystem = null,Object? permissions = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(RoleModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,permissions: freezed == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as List<String>?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [RoleModel].
extension RoleModelPatterns on RoleModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoleModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoleModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoleModel value)  $default,){
final _that = this;
switch (_that) {
case _RoleModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoleModel value)?  $default,){
final _that = this;
switch (_that) {
case _RoleModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String description,  bool isSystem,  List<String>? permissions,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoleModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.isSystem,_that.permissions,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String description,  bool isSystem,  List<String>? permissions,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _RoleModel():
return $default(_that.id,_that.name,_that.description,_that.isSystem,_that.permissions,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String description,  bool isSystem,  List<String>? permissions,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _RoleModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.isSystem,_that.permissions,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RoleModel extends RoleModel {
  const _RoleModel({required this.id, required this.name, this.description = '', required this.isSystem,  List<String>? permissions, required this.createdAt, required this.updatedAt}): _permissions = permissions,super._();
  factory _RoleModel.fromJson(Map<String, dynamic> json) => _$RoleModelFromJson(json);

@override final  int id;
@override final  String name;
@override@JsonKey() final  String description;
@override final  bool isSystem;
 final  List<String>? _permissions;
@override List<String>? get permissions {
  final value = _permissions;
  if (value == null) return null;
  if (_permissions is EqualUnmodifiableListView) return _permissions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of RoleModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoleModelCopyWith<_RoleModel> get copyWith => __$RoleModelCopyWithImpl<_RoleModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoleModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoleModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.isSystem, isSystem) || other.isSystem == isSystem)&&const DeepCollectionEquality().equals(other.permissions, _permissions)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,description,isSystem,const DeepCollectionEquality().hash(_permissions),createdAt,updatedAt);
}

@override
String toString() {
    return 'RoleModel(id: $id, name: $name, description: $description, isSystem: $isSystem, permissions: $permissions, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$RoleModelCopyWith<$Res> implements $RoleModelCopyWith<$Res> {
  factory _$RoleModelCopyWith(_RoleModel value, $Res Function(_RoleModel) _then) = __$RoleModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String description, bool isSystem, List<String>? permissions, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$RoleModelCopyWithImpl<$Res>
    implements _$RoleModelCopyWith<$Res> {
  __$RoleModelCopyWithImpl(this._self, this._then);

  final _RoleModel _self;
  final $Res Function(_RoleModel) _then;

/// Create a copy of RoleModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? isSystem = null,Object? permissions = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_RoleModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,permissions: freezed == permissions ? _self._permissions : permissions // ignore: cast_nullable_to_non_nullable
as List<String>?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$CatalogPermissionModel {

 int get id; String get key; String get description; String get resourceGroup;
/// Create a copy of CatalogPermissionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatalogPermissionModelCopyWith<CatalogPermissionModel> get copyWith => _$CatalogPermissionModelCopyWithImpl<CatalogPermissionModel>(this as CatalogPermissionModel, _$identity);

  /// Serializes this CatalogPermissionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CatalogPermissionModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatalogPermissionModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.resourceGroup, _this.resourceGroup) || other.resourceGroup == _this.resourceGroup));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CatalogPermissionModel;
  return Object.hash(runtimeType,_this.id,_this.key,_this.description,_this.resourceGroup);
}

@override
String toString() {
  final _this = this as CatalogPermissionModel;
  return 'CatalogPermissionModel(id: ${_this.id}, key: ${_this.key}, description: ${_this.description}, resourceGroup: ${_this.resourceGroup})';
}


}

/// @nodoc
abstract mixin class $CatalogPermissionModelCopyWith<$Res>  {
  factory $CatalogPermissionModelCopyWith(CatalogPermissionModel value, $Res Function(CatalogPermissionModel) _then) = _$CatalogPermissionModelCopyWithImpl;
@useResult
$Res call({
 int id, String key, String description, String resourceGroup
});




}
/// @nodoc
class _$CatalogPermissionModelCopyWithImpl<$Res>
    implements $CatalogPermissionModelCopyWith<$Res> {
  _$CatalogPermissionModelCopyWithImpl(this._self, this._then);

  final CatalogPermissionModel _self;
  final $Res Function(CatalogPermissionModel) _then;

/// Create a copy of CatalogPermissionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? key = null,Object? description = null,Object? resourceGroup = null,}) {
  return _then(CatalogPermissionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,resourceGroup: null == resourceGroup ? _self.resourceGroup : resourceGroup // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CatalogPermissionModel].
extension CatalogPermissionModelPatterns on CatalogPermissionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CatalogPermissionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CatalogPermissionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CatalogPermissionModel value)  $default,){
final _that = this;
switch (_that) {
case _CatalogPermissionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CatalogPermissionModel value)?  $default,){
final _that = this;
switch (_that) {
case _CatalogPermissionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String key,  String description,  String resourceGroup)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CatalogPermissionModel() when $default != null:
return $default(_that.id,_that.key,_that.description,_that.resourceGroup);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String key,  String description,  String resourceGroup)  $default,) {final _that = this;
switch (_that) {
case _CatalogPermissionModel():
return $default(_that.id,_that.key,_that.description,_that.resourceGroup);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String key,  String description,  String resourceGroup)?  $default,) {final _that = this;
switch (_that) {
case _CatalogPermissionModel() when $default != null:
return $default(_that.id,_that.key,_that.description,_that.resourceGroup);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CatalogPermissionModel extends CatalogPermissionModel {
  const _CatalogPermissionModel({required this.id, required this.key, this.description = '', required this.resourceGroup}): super._();
  factory _CatalogPermissionModel.fromJson(Map<String, dynamic> json) => _$CatalogPermissionModelFromJson(json);

@override final  int id;
@override final  String key;
@override@JsonKey() final  String description;
@override final  String resourceGroup;

/// Create a copy of CatalogPermissionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatalogPermissionModelCopyWith<_CatalogPermissionModel> get copyWith => __$CatalogPermissionModelCopyWithImpl<_CatalogPermissionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CatalogPermissionModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CatalogPermissionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.key, key) || other.key == key)&&(identical(other.description, description) || other.description == description)&&(identical(other.resourceGroup, resourceGroup) || other.resourceGroup == resourceGroup));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,key,description,resourceGroup);
}

@override
String toString() {
    return 'CatalogPermissionModel(id: $id, key: $key, description: $description, resourceGroup: $resourceGroup)';
}


}

/// @nodoc
abstract mixin class _$CatalogPermissionModelCopyWith<$Res> implements $CatalogPermissionModelCopyWith<$Res> {
  factory _$CatalogPermissionModelCopyWith(_CatalogPermissionModel value, $Res Function(_CatalogPermissionModel) _then) = __$CatalogPermissionModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String key, String description, String resourceGroup
});




}
/// @nodoc
class __$CatalogPermissionModelCopyWithImpl<$Res>
    implements _$CatalogPermissionModelCopyWith<$Res> {
  __$CatalogPermissionModelCopyWithImpl(this._self, this._then);

  final _CatalogPermissionModel _self;
  final $Res Function(_CatalogPermissionModel) _then;

/// Create a copy of CatalogPermissionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? key = null,Object? description = null,Object? resourceGroup = null,}) {
  return _then(_CatalogPermissionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,resourceGroup: null == resourceGroup ? _self.resourceGroup : resourceGroup // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CreateRoleRequest {

 String get name; String get description;
/// Create a copy of CreateRoleRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateRoleRequestCopyWith<CreateRoleRequest> get copyWith => _$CreateRoleRequestCopyWithImpl<CreateRoleRequest>(this as CreateRoleRequest, _$identity);

  /// Serializes this CreateRoleRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CreateRoleRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateRoleRequest&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CreateRoleRequest;
  return Object.hash(runtimeType,_this.name,_this.description);
}

@override
String toString() {
  final _this = this as CreateRoleRequest;
  return 'CreateRoleRequest(name: ${_this.name}, description: ${_this.description})';
}


}

/// @nodoc
abstract mixin class $CreateRoleRequestCopyWith<$Res>  {
  factory $CreateRoleRequestCopyWith(CreateRoleRequest value, $Res Function(CreateRoleRequest) _then) = _$CreateRoleRequestCopyWithImpl;
@useResult
$Res call({
 String name, String description
});




}
/// @nodoc
class _$CreateRoleRequestCopyWithImpl<$Res>
    implements $CreateRoleRequestCopyWith<$Res> {
  _$CreateRoleRequestCopyWithImpl(this._self, this._then);

  final CreateRoleRequest _self;
  final $Res Function(CreateRoleRequest) _then;

/// Create a copy of CreateRoleRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = null,}) {
  return _then(CreateRoleRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateRoleRequest].
extension CreateRoleRequestPatterns on CreateRoleRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateRoleRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateRoleRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateRoleRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateRoleRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateRoleRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateRoleRequest() when $default != null:
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
case _CreateRoleRequest() when $default != null:
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
case _CreateRoleRequest():
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
case _CreateRoleRequest() when $default != null:
return $default(_that.name,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateRoleRequest implements CreateRoleRequest {
  const _CreateRoleRequest({required this.name, required this.description});
  factory _CreateRoleRequest.fromJson(Map<String, dynamic> json) => _$CreateRoleRequestFromJson(json);

@override final  String name;
@override final  String description;

/// Create a copy of CreateRoleRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateRoleRequestCopyWith<_CreateRoleRequest> get copyWith => __$CreateRoleRequestCopyWithImpl<_CreateRoleRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateRoleRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateRoleRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,description);
}

@override
String toString() {
    return 'CreateRoleRequest(name: $name, description: $description)';
}


}

/// @nodoc
abstract mixin class _$CreateRoleRequestCopyWith<$Res> implements $CreateRoleRequestCopyWith<$Res> {
  factory _$CreateRoleRequestCopyWith(_CreateRoleRequest value, $Res Function(_CreateRoleRequest) _then) = __$CreateRoleRequestCopyWithImpl;
@override @useResult
$Res call({
 String name, String description
});




}
/// @nodoc
class __$CreateRoleRequestCopyWithImpl<$Res>
    implements _$CreateRoleRequestCopyWith<$Res> {
  __$CreateRoleRequestCopyWithImpl(this._self, this._then);

  final _CreateRoleRequest _self;
  final $Res Function(_CreateRoleRequest) _then;

/// Create a copy of CreateRoleRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = null,}) {
  return _then(_CreateRoleRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$UpdateRoleRequest {

 String? get name; String? get description;
/// Create a copy of UpdateRoleRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateRoleRequestCopyWith<UpdateRoleRequest> get copyWith => _$UpdateRoleRequestCopyWithImpl<UpdateRoleRequest>(this as UpdateRoleRequest, _$identity);

  /// Serializes this UpdateRoleRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UpdateRoleRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateRoleRequest&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UpdateRoleRequest;
  return Object.hash(runtimeType,_this.name,_this.description);
}

@override
String toString() {
  final _this = this as UpdateRoleRequest;
  return 'UpdateRoleRequest(name: ${_this.name}, description: ${_this.description})';
}


}

/// @nodoc
abstract mixin class $UpdateRoleRequestCopyWith<$Res>  {
  factory $UpdateRoleRequestCopyWith(UpdateRoleRequest value, $Res Function(UpdateRoleRequest) _then) = _$UpdateRoleRequestCopyWithImpl;
@useResult
$Res call({
 String? name, String? description
});




}
/// @nodoc
class _$UpdateRoleRequestCopyWithImpl<$Res>
    implements $UpdateRoleRequestCopyWith<$Res> {
  _$UpdateRoleRequestCopyWithImpl(this._self, this._then);

  final UpdateRoleRequest _self;
  final $Res Function(UpdateRoleRequest) _then;

/// Create a copy of UpdateRoleRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? description = freezed,}) {
  return _then(UpdateRoleRequest(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateRoleRequest].
extension UpdateRoleRequestPatterns on UpdateRoleRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateRoleRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateRoleRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateRoleRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateRoleRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateRoleRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateRoleRequest() when $default != null:
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
case _UpdateRoleRequest() when $default != null:
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
case _UpdateRoleRequest():
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
case _UpdateRoleRequest() when $default != null:
return $default(_that.name,_that.description);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(includeIfNull: false)
class _UpdateRoleRequest implements UpdateRoleRequest {
  const _UpdateRoleRequest({this.name, this.description});
  factory _UpdateRoleRequest.fromJson(Map<String, dynamic> json) => _$UpdateRoleRequestFromJson(json);

@override final  String? name;
@override final  String? description;

/// Create a copy of UpdateRoleRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateRoleRequestCopyWith<_UpdateRoleRequest> get copyWith => __$UpdateRoleRequestCopyWithImpl<_UpdateRoleRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateRoleRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateRoleRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,description);
}

@override
String toString() {
    return 'UpdateRoleRequest(name: $name, description: $description)';
}


}

/// @nodoc
abstract mixin class _$UpdateRoleRequestCopyWith<$Res> implements $UpdateRoleRequestCopyWith<$Res> {
  factory _$UpdateRoleRequestCopyWith(_UpdateRoleRequest value, $Res Function(_UpdateRoleRequest) _then) = __$UpdateRoleRequestCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? description
});




}
/// @nodoc
class __$UpdateRoleRequestCopyWithImpl<$Res>
    implements _$UpdateRoleRequestCopyWith<$Res> {
  __$UpdateRoleRequestCopyWithImpl(this._self, this._then);

  final _UpdateRoleRequest _self;
  final $Res Function(_UpdateRoleRequest) _then;

/// Create a copy of UpdateRoleRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? description = freezed,}) {
  return _then(_UpdateRoleRequest(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$SetRolePermissionsRequest {

 List<String> get permissionKeys;
/// Create a copy of SetRolePermissionsRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetRolePermissionsRequestCopyWith<SetRolePermissionsRequest> get copyWith => _$SetRolePermissionsRequestCopyWithImpl<SetRolePermissionsRequest>(this as SetRolePermissionsRequest, _$identity);

  /// Serializes this SetRolePermissionsRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SetRolePermissionsRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetRolePermissionsRequest&&const DeepCollectionEquality().equals(other.permissionKeys, _this.permissionKeys));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SetRolePermissionsRequest;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.permissionKeys));
}

@override
String toString() {
  final _this = this as SetRolePermissionsRequest;
  return 'SetRolePermissionsRequest(permissionKeys: ${_this.permissionKeys})';
}


}

/// @nodoc
abstract mixin class $SetRolePermissionsRequestCopyWith<$Res>  {
  factory $SetRolePermissionsRequestCopyWith(SetRolePermissionsRequest value, $Res Function(SetRolePermissionsRequest) _then) = _$SetRolePermissionsRequestCopyWithImpl;
@useResult
$Res call({
 List<String> permissionKeys
});




}
/// @nodoc
class _$SetRolePermissionsRequestCopyWithImpl<$Res>
    implements $SetRolePermissionsRequestCopyWith<$Res> {
  _$SetRolePermissionsRequestCopyWithImpl(this._self, this._then);

  final SetRolePermissionsRequest _self;
  final $Res Function(SetRolePermissionsRequest) _then;

/// Create a copy of SetRolePermissionsRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? permissionKeys = null,}) {
  return _then(SetRolePermissionsRequest(
permissionKeys: null == permissionKeys ? _self.permissionKeys : permissionKeys // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SetRolePermissionsRequest].
extension SetRolePermissionsRequestPatterns on SetRolePermissionsRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SetRolePermissionsRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SetRolePermissionsRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SetRolePermissionsRequest value)  $default,){
final _that = this;
switch (_that) {
case _SetRolePermissionsRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SetRolePermissionsRequest value)?  $default,){
final _that = this;
switch (_that) {
case _SetRolePermissionsRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> permissionKeys)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SetRolePermissionsRequest() when $default != null:
return $default(_that.permissionKeys);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> permissionKeys)  $default,) {final _that = this;
switch (_that) {
case _SetRolePermissionsRequest():
return $default(_that.permissionKeys);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> permissionKeys)?  $default,) {final _that = this;
switch (_that) {
case _SetRolePermissionsRequest() when $default != null:
return $default(_that.permissionKeys);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SetRolePermissionsRequest implements SetRolePermissionsRequest {
  const _SetRolePermissionsRequest({required  List<String> permissionKeys}): _permissionKeys = permissionKeys;
  factory _SetRolePermissionsRequest.fromJson(Map<String, dynamic> json) => _$SetRolePermissionsRequestFromJson(json);

 final  List<String> _permissionKeys;
@override List<String> get permissionKeys {
  if (_permissionKeys is EqualUnmodifiableListView) return _permissionKeys;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_permissionKeys);
}


/// Create a copy of SetRolePermissionsRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetRolePermissionsRequestCopyWith<_SetRolePermissionsRequest> get copyWith => __$SetRolePermissionsRequestCopyWithImpl<_SetRolePermissionsRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SetRolePermissionsRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetRolePermissionsRequest&&const DeepCollectionEquality().equals(other.permissionKeys, _permissionKeys));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_permissionKeys));
}

@override
String toString() {
    return 'SetRolePermissionsRequest(permissionKeys: $permissionKeys)';
}


}

/// @nodoc
abstract mixin class _$SetRolePermissionsRequestCopyWith<$Res> implements $SetRolePermissionsRequestCopyWith<$Res> {
  factory _$SetRolePermissionsRequestCopyWith(_SetRolePermissionsRequest value, $Res Function(_SetRolePermissionsRequest) _then) = __$SetRolePermissionsRequestCopyWithImpl;
@override @useResult
$Res call({
 List<String> permissionKeys
});




}
/// @nodoc
class __$SetRolePermissionsRequestCopyWithImpl<$Res>
    implements _$SetRolePermissionsRequestCopyWith<$Res> {
  __$SetRolePermissionsRequestCopyWithImpl(this._self, this._then);

  final _SetRolePermissionsRequest _self;
  final $Res Function(_SetRolePermissionsRequest) _then;

/// Create a copy of SetRolePermissionsRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? permissionKeys = null,}) {
  return _then(_SetRolePermissionsRequest(
permissionKeys: null == permissionKeys ? _self._permissionKeys : permissionKeys // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
