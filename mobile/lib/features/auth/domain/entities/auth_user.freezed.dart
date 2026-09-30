// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthUser {

 int get id; String get email; String get name; AuthRole get role; Set<String> get permissions;
/// Create a copy of AuthUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthUserCopyWith<AuthUser> get copyWith => _$AuthUserCopyWithImpl<AuthUser>(this as AuthUser, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AuthUser;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthUser&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.role, _this.role) || other.role == _this.role)&&const DeepCollectionEquality().equals(other.permissions, _this.permissions));
}


@override
int get hashCode {
  final _this = this as AuthUser;
  return Object.hash(runtimeType,_this.id,_this.email,_this.name,_this.role,const DeepCollectionEquality().hash(_this.permissions));
}

@override
String toString() {
  final _this = this as AuthUser;
  return 'AuthUser(id: ${_this.id}, email: ${_this.email}, name: ${_this.name}, role: ${_this.role}, permissions: ${_this.permissions})';
}


}

/// @nodoc
abstract mixin class $AuthUserCopyWith<$Res>  {
  factory $AuthUserCopyWith(AuthUser value, $Res Function(AuthUser) _then) = _$AuthUserCopyWithImpl;
@useResult
$Res call({
 int id, String email, String name, AuthRole role, Set<String> permissions
});


$AuthRoleCopyWith<$Res> get role;

}
/// @nodoc
class _$AuthUserCopyWithImpl<$Res>
    implements $AuthUserCopyWith<$Res> {
  _$AuthUserCopyWithImpl(this._self, this._then);

  final AuthUser _self;
  final $Res Function(AuthUser) _then;

/// Create a copy of AuthUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? name = null,Object? role = null,Object? permissions = null,}) {
  return _then(AuthUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as AuthRole,permissions: null == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}
/// Create a copy of AuthUser
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthRoleCopyWith<$Res> get role {
  
  return $AuthRoleCopyWith<$Res>(_self.role, (value) {
    return _then(_self.copyWith(role: value));
  });
}
}


/// Adds pattern-matching-related methods to [AuthUser].
extension AuthUserPatterns on AuthUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthUser value)  $default,){
final _that = this;
switch (_that) {
case _AuthUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthUser value)?  $default,){
final _that = this;
switch (_that) {
case _AuthUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String email,  String name,  AuthRole role,  Set<String> permissions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthUser() when $default != null:
return $default(_that.id,_that.email,_that.name,_that.role,_that.permissions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String email,  String name,  AuthRole role,  Set<String> permissions)  $default,) {final _that = this;
switch (_that) {
case _AuthUser():
return $default(_that.id,_that.email,_that.name,_that.role,_that.permissions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String email,  String name,  AuthRole role,  Set<String> permissions)?  $default,) {final _that = this;
switch (_that) {
case _AuthUser() when $default != null:
return $default(_that.id,_that.email,_that.name,_that.role,_that.permissions);case _:
  return null;

}
}

}

/// @nodoc


class _AuthUser extends AuthUser {
  const _AuthUser({required this.id, required this.email, required this.name, required this.role, required  Set<String> permissions}): _permissions = permissions,super._();
  

@override final  int id;
@override final  String email;
@override final  String name;
@override final  AuthRole role;
 final  Set<String> _permissions;
@override Set<String> get permissions {
  if (_permissions is EqualUnmodifiableSetView) return _permissions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_permissions);
}


/// Create a copy of AuthUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthUserCopyWith<_AuthUser> get copyWith => __$AuthUserCopyWithImpl<_AuthUser>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthUser&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&const DeepCollectionEquality().equals(other.permissions, _permissions));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,email,name,role,const DeepCollectionEquality().hash(_permissions));
}

@override
String toString() {
    return 'AuthUser(id: $id, email: $email, name: $name, role: $role, permissions: $permissions)';
}


}

/// @nodoc
abstract mixin class _$AuthUserCopyWith<$Res> implements $AuthUserCopyWith<$Res> {
  factory _$AuthUserCopyWith(_AuthUser value, $Res Function(_AuthUser) _then) = __$AuthUserCopyWithImpl;
@override @useResult
$Res call({
 int id, String email, String name, AuthRole role, Set<String> permissions
});


@override $AuthRoleCopyWith<$Res> get role;

}
/// @nodoc
class __$AuthUserCopyWithImpl<$Res>
    implements _$AuthUserCopyWith<$Res> {
  __$AuthUserCopyWithImpl(this._self, this._then);

  final _AuthUser _self;
  final $Res Function(_AuthUser) _then;

/// Create a copy of AuthUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? name = null,Object? role = null,Object? permissions = null,}) {
  return _then(_AuthUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as AuthRole,permissions: null == permissions ? _self._permissions : permissions // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}

/// Create a copy of AuthUser
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthRoleCopyWith<$Res> get role {
  
  return $AuthRoleCopyWith<$Res>(_self.role, (value) {
    return _then(_self.copyWith(role: value));
  });
}
}

/// @nodoc
mixin _$AuthRole {

 int get id; String get name; bool get isSystem;
/// Create a copy of AuthRole
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthRoleCopyWith<AuthRole> get copyWith => _$AuthRoleCopyWithImpl<AuthRole>(this as AuthRole, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AuthRole;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthRole&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.isSystem, _this.isSystem) || other.isSystem == _this.isSystem));
}


@override
int get hashCode {
  final _this = this as AuthRole;
  return Object.hash(runtimeType,_this.id,_this.name,_this.isSystem);
}

@override
String toString() {
  final _this = this as AuthRole;
  return 'AuthRole(id: ${_this.id}, name: ${_this.name}, isSystem: ${_this.isSystem})';
}


}

/// @nodoc
abstract mixin class $AuthRoleCopyWith<$Res>  {
  factory $AuthRoleCopyWith(AuthRole value, $Res Function(AuthRole) _then) = _$AuthRoleCopyWithImpl;
@useResult
$Res call({
 int id, String name, bool isSystem
});




}
/// @nodoc
class _$AuthRoleCopyWithImpl<$Res>
    implements $AuthRoleCopyWith<$Res> {
  _$AuthRoleCopyWithImpl(this._self, this._then);

  final AuthRole _self;
  final $Res Function(AuthRole) _then;

/// Create a copy of AuthRole
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? isSystem = null,}) {
  return _then(AuthRole(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthRole].
extension AuthRolePatterns on AuthRole {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthRole value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthRole() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthRole value)  $default,){
final _that = this;
switch (_that) {
case _AuthRole():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthRole value)?  $default,){
final _that = this;
switch (_that) {
case _AuthRole() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  bool isSystem)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthRole() when $default != null:
return $default(_that.id,_that.name,_that.isSystem);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  bool isSystem)  $default,) {final _that = this;
switch (_that) {
case _AuthRole():
return $default(_that.id,_that.name,_that.isSystem);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  bool isSystem)?  $default,) {final _that = this;
switch (_that) {
case _AuthRole() when $default != null:
return $default(_that.id,_that.name,_that.isSystem);case _:
  return null;

}
}

}

/// @nodoc


class _AuthRole implements AuthRole {
  const _AuthRole({required this.id, required this.name, required this.isSystem});
  

@override final  int id;
@override final  String name;
@override final  bool isSystem;

/// Create a copy of AuthRole
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthRoleCopyWith<_AuthRole> get copyWith => __$AuthRoleCopyWithImpl<_AuthRole>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthRole&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.isSystem, isSystem) || other.isSystem == isSystem));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,isSystem);
}

@override
String toString() {
    return 'AuthRole(id: $id, name: $name, isSystem: $isSystem)';
}


}

/// @nodoc
abstract mixin class _$AuthRoleCopyWith<$Res> implements $AuthRoleCopyWith<$Res> {
  factory _$AuthRoleCopyWith(_AuthRole value, $Res Function(_AuthRole) _then) = __$AuthRoleCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, bool isSystem
});




}
/// @nodoc
class __$AuthRoleCopyWithImpl<$Res>
    implements _$AuthRoleCopyWith<$Res> {
  __$AuthRoleCopyWithImpl(this._self, this._then);

  final _AuthRole _self;
  final $Res Function(_AuthRole) _then;

/// Create a copy of AuthRole
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? isSystem = null,}) {
  return _then(_AuthRole(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
