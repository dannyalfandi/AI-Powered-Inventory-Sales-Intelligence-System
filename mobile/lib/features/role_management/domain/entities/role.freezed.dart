// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'role.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Role {

 int get id; String get name; String get description; bool get isSystem; List<String> get permissions; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Role
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoleCopyWith<Role> get copyWith => _$RoleCopyWithImpl<Role>(this as Role, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Role;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Role&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.isSystem, _this.isSystem) || other.isSystem == _this.isSystem)&&const DeepCollectionEquality().equals(other.permissions, _this.permissions)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}


@override
int get hashCode {
  final _this = this as Role;
  return Object.hash(runtimeType,_this.id,_this.name,_this.description,_this.isSystem,const DeepCollectionEquality().hash(_this.permissions),_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as Role;
  return 'Role(id: ${_this.id}, name: ${_this.name}, description: ${_this.description}, isSystem: ${_this.isSystem}, permissions: ${_this.permissions}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $RoleCopyWith<$Res>  {
  factory $RoleCopyWith(Role value, $Res Function(Role) _then) = _$RoleCopyWithImpl;
@useResult
$Res call({
 int id, String name, String description, bool isSystem, List<String> permissions, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$RoleCopyWithImpl<$Res>
    implements $RoleCopyWith<$Res> {
  _$RoleCopyWithImpl(this._self, this._then);

  final Role _self;
  final $Res Function(Role) _then;

/// Create a copy of Role
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? isSystem = null,Object? permissions = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(Role(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,permissions: null == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Role].
extension RolePatterns on Role {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Role value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Role() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Role value)  $default,){
final _that = this;
switch (_that) {
case _Role():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Role value)?  $default,){
final _that = this;
switch (_that) {
case _Role() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String description,  bool isSystem,  List<String> permissions,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Role() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String description,  bool isSystem,  List<String> permissions,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Role():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String description,  bool isSystem,  List<String> permissions,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Role() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.isSystem,_that.permissions,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Role implements Role {
  const _Role({required this.id, required this.name, required this.description, required this.isSystem, required  List<String> permissions, required this.createdAt, required this.updatedAt}): _permissions = permissions;
  

@override final  int id;
@override final  String name;
@override final  String description;
@override final  bool isSystem;
 final  List<String> _permissions;
@override List<String> get permissions {
  if (_permissions is EqualUnmodifiableListView) return _permissions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_permissions);
}

@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Role
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoleCopyWith<_Role> get copyWith => __$RoleCopyWithImpl<_Role>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Role&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.isSystem, isSystem) || other.isSystem == isSystem)&&const DeepCollectionEquality().equals(other.permissions, _permissions)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,description,isSystem,const DeepCollectionEquality().hash(_permissions),createdAt,updatedAt);
}

@override
String toString() {
    return 'Role(id: $id, name: $name, description: $description, isSystem: $isSystem, permissions: $permissions, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$RoleCopyWith<$Res> implements $RoleCopyWith<$Res> {
  factory _$RoleCopyWith(_Role value, $Res Function(_Role) _then) = __$RoleCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String description, bool isSystem, List<String> permissions, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$RoleCopyWithImpl<$Res>
    implements _$RoleCopyWith<$Res> {
  __$RoleCopyWithImpl(this._self, this._then);

  final _Role _self;
  final $Res Function(_Role) _then;

/// Create a copy of Role
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? isSystem = null,Object? permissions = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Role(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,permissions: null == permissions ? _self._permissions : permissions // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$CatalogPermission {

 int get id; String get key; String get description; String get group;
/// Create a copy of CatalogPermission
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatalogPermissionCopyWith<CatalogPermission> get copyWith => _$CatalogPermissionCopyWithImpl<CatalogPermission>(this as CatalogPermission, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CatalogPermission;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatalogPermission&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.group, _this.group) || other.group == _this.group));
}


@override
int get hashCode {
  final _this = this as CatalogPermission;
  return Object.hash(runtimeType,_this.id,_this.key,_this.description,_this.group);
}

@override
String toString() {
  final _this = this as CatalogPermission;
  return 'CatalogPermission(id: ${_this.id}, key: ${_this.key}, description: ${_this.description}, group: ${_this.group})';
}


}

/// @nodoc
abstract mixin class $CatalogPermissionCopyWith<$Res>  {
  factory $CatalogPermissionCopyWith(CatalogPermission value, $Res Function(CatalogPermission) _then) = _$CatalogPermissionCopyWithImpl;
@useResult
$Res call({
 int id, String key, String description, String group
});




}
/// @nodoc
class _$CatalogPermissionCopyWithImpl<$Res>
    implements $CatalogPermissionCopyWith<$Res> {
  _$CatalogPermissionCopyWithImpl(this._self, this._then);

  final CatalogPermission _self;
  final $Res Function(CatalogPermission) _then;

/// Create a copy of CatalogPermission
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? key = null,Object? description = null,Object? group = null,}) {
  return _then(CatalogPermission(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CatalogPermission].
extension CatalogPermissionPatterns on CatalogPermission {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CatalogPermission value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CatalogPermission() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CatalogPermission value)  $default,){
final _that = this;
switch (_that) {
case _CatalogPermission():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CatalogPermission value)?  $default,){
final _that = this;
switch (_that) {
case _CatalogPermission() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String key,  String description,  String group)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CatalogPermission() when $default != null:
return $default(_that.id,_that.key,_that.description,_that.group);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String key,  String description,  String group)  $default,) {final _that = this;
switch (_that) {
case _CatalogPermission():
return $default(_that.id,_that.key,_that.description,_that.group);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String key,  String description,  String group)?  $default,) {final _that = this;
switch (_that) {
case _CatalogPermission() when $default != null:
return $default(_that.id,_that.key,_that.description,_that.group);case _:
  return null;

}
}

}

/// @nodoc


class _CatalogPermission implements CatalogPermission {
  const _CatalogPermission({required this.id, required this.key, required this.description, required this.group});
  

@override final  int id;
@override final  String key;
@override final  String description;
@override final  String group;

/// Create a copy of CatalogPermission
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatalogPermissionCopyWith<_CatalogPermission> get copyWith => __$CatalogPermissionCopyWithImpl<_CatalogPermission>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CatalogPermission&&(identical(other.id, id) || other.id == id)&&(identical(other.key, key) || other.key == key)&&(identical(other.description, description) || other.description == description)&&(identical(other.group, group) || other.group == group));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,key,description,group);
}

@override
String toString() {
    return 'CatalogPermission(id: $id, key: $key, description: $description, group: $group)';
}


}

/// @nodoc
abstract mixin class _$CatalogPermissionCopyWith<$Res> implements $CatalogPermissionCopyWith<$Res> {
  factory _$CatalogPermissionCopyWith(_CatalogPermission value, $Res Function(_CatalogPermission) _then) = __$CatalogPermissionCopyWithImpl;
@override @useResult
$Res call({
 int id, String key, String description, String group
});




}
/// @nodoc
class __$CatalogPermissionCopyWithImpl<$Res>
    implements _$CatalogPermissionCopyWith<$Res> {
  __$CatalogPermissionCopyWithImpl(this._self, this._then);

  final _CatalogPermission _self;
  final $Res Function(_CatalogPermission) _then;

/// Create a copy of CatalogPermission
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? key = null,Object? description = null,Object? group = null,}) {
  return _then(_CatalogPermission(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$PermissionGroup {

 String get code; List<CatalogPermission> get permissions;
/// Create a copy of PermissionGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PermissionGroupCopyWith<PermissionGroup> get copyWith => _$PermissionGroupCopyWithImpl<PermissionGroup>(this as PermissionGroup, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PermissionGroup;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PermissionGroup&&(identical(other.code, _this.code) || other.code == _this.code)&&const DeepCollectionEquality().equals(other.permissions, _this.permissions));
}


@override
int get hashCode {
  final _this = this as PermissionGroup;
  return Object.hash(runtimeType,_this.code,const DeepCollectionEquality().hash(_this.permissions));
}

@override
String toString() {
  final _this = this as PermissionGroup;
  return 'PermissionGroup(code: ${_this.code}, permissions: ${_this.permissions})';
}


}

/// @nodoc
abstract mixin class $PermissionGroupCopyWith<$Res>  {
  factory $PermissionGroupCopyWith(PermissionGroup value, $Res Function(PermissionGroup) _then) = _$PermissionGroupCopyWithImpl;
@useResult
$Res call({
 String code, List<CatalogPermission> permissions
});




}
/// @nodoc
class _$PermissionGroupCopyWithImpl<$Res>
    implements $PermissionGroupCopyWith<$Res> {
  _$PermissionGroupCopyWithImpl(this._self, this._then);

  final PermissionGroup _self;
  final $Res Function(PermissionGroup) _then;

/// Create a copy of PermissionGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? permissions = null,}) {
  return _then(PermissionGroup(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,permissions: null == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as List<CatalogPermission>,
  ));
}

}


/// Adds pattern-matching-related methods to [PermissionGroup].
extension PermissionGroupPatterns on PermissionGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PermissionGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PermissionGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PermissionGroup value)  $default,){
final _that = this;
switch (_that) {
case _PermissionGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PermissionGroup value)?  $default,){
final _that = this;
switch (_that) {
case _PermissionGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  List<CatalogPermission> permissions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PermissionGroup() when $default != null:
return $default(_that.code,_that.permissions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  List<CatalogPermission> permissions)  $default,) {final _that = this;
switch (_that) {
case _PermissionGroup():
return $default(_that.code,_that.permissions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  List<CatalogPermission> permissions)?  $default,) {final _that = this;
switch (_that) {
case _PermissionGroup() when $default != null:
return $default(_that.code,_that.permissions);case _:
  return null;

}
}

}

/// @nodoc


class _PermissionGroup implements PermissionGroup {
  const _PermissionGroup({required this.code, required  List<CatalogPermission> permissions}): _permissions = permissions;
  

@override final  String code;
 final  List<CatalogPermission> _permissions;
@override List<CatalogPermission> get permissions {
  if (_permissions is EqualUnmodifiableListView) return _permissions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_permissions);
}


/// Create a copy of PermissionGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PermissionGroupCopyWith<_PermissionGroup> get copyWith => __$PermissionGroupCopyWithImpl<_PermissionGroup>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PermissionGroup&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other.permissions, _permissions));
}


@override
int get hashCode {
    return Object.hash(runtimeType,code,const DeepCollectionEquality().hash(_permissions));
}

@override
String toString() {
    return 'PermissionGroup(code: $code, permissions: $permissions)';
}


}

/// @nodoc
abstract mixin class _$PermissionGroupCopyWith<$Res> implements $PermissionGroupCopyWith<$Res> {
  factory _$PermissionGroupCopyWith(_PermissionGroup value, $Res Function(_PermissionGroup) _then) = __$PermissionGroupCopyWithImpl;
@override @useResult
$Res call({
 String code, List<CatalogPermission> permissions
});




}
/// @nodoc
class __$PermissionGroupCopyWithImpl<$Res>
    implements _$PermissionGroupCopyWith<$Res> {
  __$PermissionGroupCopyWithImpl(this._self, this._then);

  final _PermissionGroup _self;
  final $Res Function(_PermissionGroup) _then;

/// Create a copy of PermissionGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? permissions = null,}) {
  return _then(_PermissionGroup(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,permissions: null == permissions ? _self._permissions : permissions // ignore: cast_nullable_to_non_nullable
as List<CatalogPermission>,
  ));
}


}

/// @nodoc
mixin _$RoleInput {

 String get name; String get description;
/// Create a copy of RoleInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoleInputCopyWith<RoleInput> get copyWith => _$RoleInputCopyWithImpl<RoleInput>(this as RoleInput, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RoleInput;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoleInput&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description));
}


@override
int get hashCode {
  final _this = this as RoleInput;
  return Object.hash(runtimeType,_this.name,_this.description);
}

@override
String toString() {
  final _this = this as RoleInput;
  return 'RoleInput(name: ${_this.name}, description: ${_this.description})';
}


}

/// @nodoc
abstract mixin class $RoleInputCopyWith<$Res>  {
  factory $RoleInputCopyWith(RoleInput value, $Res Function(RoleInput) _then) = _$RoleInputCopyWithImpl;
@useResult
$Res call({
 String name, String description
});




}
/// @nodoc
class _$RoleInputCopyWithImpl<$Res>
    implements $RoleInputCopyWith<$Res> {
  _$RoleInputCopyWithImpl(this._self, this._then);

  final RoleInput _self;
  final $Res Function(RoleInput) _then;

/// Create a copy of RoleInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = null,}) {
  return _then(RoleInput(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RoleInput].
extension RoleInputPatterns on RoleInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoleInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoleInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoleInput value)  $default,){
final _that = this;
switch (_that) {
case _RoleInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoleInput value)?  $default,){
final _that = this;
switch (_that) {
case _RoleInput() when $default != null:
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
case _RoleInput() when $default != null:
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
case _RoleInput():
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
case _RoleInput() when $default != null:
return $default(_that.name,_that.description);case _:
  return null;

}
}

}

/// @nodoc


class _RoleInput extends RoleInput {
  const _RoleInput({required this.name, this.description = ''}): super._();
  

@override final  String name;
@override@JsonKey() final  String description;

/// Create a copy of RoleInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoleInputCopyWith<_RoleInput> get copyWith => __$RoleInputCopyWithImpl<_RoleInput>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoleInput&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,description);
}

@override
String toString() {
    return 'RoleInput(name: $name, description: $description)';
}


}

/// @nodoc
abstract mixin class _$RoleInputCopyWith<$Res> implements $RoleInputCopyWith<$Res> {
  factory _$RoleInputCopyWith(_RoleInput value, $Res Function(_RoleInput) _then) = __$RoleInputCopyWithImpl;
@override @useResult
$Res call({
 String name, String description
});




}
/// @nodoc
class __$RoleInputCopyWithImpl<$Res>
    implements _$RoleInputCopyWith<$Res> {
  __$RoleInputCopyWithImpl(this._self, this._then);

  final _RoleInput _self;
  final $Res Function(_RoleInput) _then;

/// Create a copy of RoleInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = null,}) {
  return _then(_RoleInput(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$RolePatch {

 String? get name; String? get description;
/// Create a copy of RolePatch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RolePatchCopyWith<RolePatch> get copyWith => _$RolePatchCopyWithImpl<RolePatch>(this as RolePatch, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RolePatch;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RolePatch&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description));
}


@override
int get hashCode {
  final _this = this as RolePatch;
  return Object.hash(runtimeType,_this.name,_this.description);
}

@override
String toString() {
  final _this = this as RolePatch;
  return 'RolePatch(name: ${_this.name}, description: ${_this.description})';
}


}

/// @nodoc
abstract mixin class $RolePatchCopyWith<$Res>  {
  factory $RolePatchCopyWith(RolePatch value, $Res Function(RolePatch) _then) = _$RolePatchCopyWithImpl;
@useResult
$Res call({
 String? name, String? description
});




}
/// @nodoc
class _$RolePatchCopyWithImpl<$Res>
    implements $RolePatchCopyWith<$Res> {
  _$RolePatchCopyWithImpl(this._self, this._then);

  final RolePatch _self;
  final $Res Function(RolePatch) _then;

/// Create a copy of RolePatch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? description = freezed,}) {
  return _then(RolePatch(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RolePatch].
extension RolePatchPatterns on RolePatch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RolePatch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RolePatch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RolePatch value)  $default,){
final _that = this;
switch (_that) {
case _RolePatch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RolePatch value)?  $default,){
final _that = this;
switch (_that) {
case _RolePatch() when $default != null:
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
case _RolePatch() when $default != null:
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
case _RolePatch():
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
case _RolePatch() when $default != null:
return $default(_that.name,_that.description);case _:
  return null;

}
}

}

/// @nodoc


class _RolePatch extends RolePatch {
  const _RolePatch({this.name, this.description}): super._();
  

@override final  String? name;
@override final  String? description;

/// Create a copy of RolePatch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RolePatchCopyWith<_RolePatch> get copyWith => __$RolePatchCopyWithImpl<_RolePatch>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RolePatch&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,description);
}

@override
String toString() {
    return 'RolePatch(name: $name, description: $description)';
}


}

/// @nodoc
abstract mixin class _$RolePatchCopyWith<$Res> implements $RolePatchCopyWith<$Res> {
  factory _$RolePatchCopyWith(_RolePatch value, $Res Function(_RolePatch) _then) = __$RolePatchCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? description
});




}
/// @nodoc
class __$RolePatchCopyWithImpl<$Res>
    implements _$RolePatchCopyWith<$Res> {
  __$RolePatchCopyWithImpl(this._self, this._then);

  final _RolePatch _self;
  final $Res Function(_RolePatch) _then;

/// Create a copy of RolePatch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? description = freezed,}) {
  return _then(_RolePatch(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
