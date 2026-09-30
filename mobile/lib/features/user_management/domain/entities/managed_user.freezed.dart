// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'managed_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ManagedUser {

 int get id; String get email; String get name; int get roleId; String get roleName; bool get roleIsSystem; bool get isActive; DateTime get createdAt;
/// Create a copy of ManagedUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ManagedUserCopyWith<ManagedUser> get copyWith => _$ManagedUserCopyWithImpl<ManagedUser>(this as ManagedUser, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ManagedUser;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ManagedUser&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.roleId, _this.roleId) || other.roleId == _this.roleId)&&(identical(other.roleName, _this.roleName) || other.roleName == _this.roleName)&&(identical(other.roleIsSystem, _this.roleIsSystem) || other.roleIsSystem == _this.roleIsSystem)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}


@override
int get hashCode {
  final _this = this as ManagedUser;
  return Object.hash(runtimeType,_this.id,_this.email,_this.name,_this.roleId,_this.roleName,_this.roleIsSystem,_this.isActive,_this.createdAt);
}

@override
String toString() {
  final _this = this as ManagedUser;
  return 'ManagedUser(id: ${_this.id}, email: ${_this.email}, name: ${_this.name}, roleId: ${_this.roleId}, roleName: ${_this.roleName}, roleIsSystem: ${_this.roleIsSystem}, isActive: ${_this.isActive}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $ManagedUserCopyWith<$Res>  {
  factory $ManagedUserCopyWith(ManagedUser value, $Res Function(ManagedUser) _then) = _$ManagedUserCopyWithImpl;
@useResult
$Res call({
 int id, String email, String name, int roleId, String roleName, bool roleIsSystem, bool isActive, DateTime createdAt
});




}
/// @nodoc
class _$ManagedUserCopyWithImpl<$Res>
    implements $ManagedUserCopyWith<$Res> {
  _$ManagedUserCopyWithImpl(this._self, this._then);

  final ManagedUser _self;
  final $Res Function(ManagedUser) _then;

/// Create a copy of ManagedUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? name = null,Object? roleId = null,Object? roleName = null,Object? roleIsSystem = null,Object? isActive = null,Object? createdAt = null,}) {
  return _then(ManagedUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,roleId: null == roleId ? _self.roleId : roleId // ignore: cast_nullable_to_non_nullable
as int,roleName: null == roleName ? _self.roleName : roleName // ignore: cast_nullable_to_non_nullable
as String,roleIsSystem: null == roleIsSystem ? _self.roleIsSystem : roleIsSystem // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ManagedUser].
extension ManagedUserPatterns on ManagedUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ManagedUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ManagedUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ManagedUser value)  $default,){
final _that = this;
switch (_that) {
case _ManagedUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ManagedUser value)?  $default,){
final _that = this;
switch (_that) {
case _ManagedUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String email,  String name,  int roleId,  String roleName,  bool roleIsSystem,  bool isActive,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ManagedUser() when $default != null:
return $default(_that.id,_that.email,_that.name,_that.roleId,_that.roleName,_that.roleIsSystem,_that.isActive,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String email,  String name,  int roleId,  String roleName,  bool roleIsSystem,  bool isActive,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _ManagedUser():
return $default(_that.id,_that.email,_that.name,_that.roleId,_that.roleName,_that.roleIsSystem,_that.isActive,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String email,  String name,  int roleId,  String roleName,  bool roleIsSystem,  bool isActive,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ManagedUser() when $default != null:
return $default(_that.id,_that.email,_that.name,_that.roleId,_that.roleName,_that.roleIsSystem,_that.isActive,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _ManagedUser implements ManagedUser {
  const _ManagedUser({required this.id, required this.email, required this.name, required this.roleId, required this.roleName, required this.roleIsSystem, required this.isActive, required this.createdAt});
  

@override final  int id;
@override final  String email;
@override final  String name;
@override final  int roleId;
@override final  String roleName;
@override final  bool roleIsSystem;
@override final  bool isActive;
@override final  DateTime createdAt;

/// Create a copy of ManagedUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ManagedUserCopyWith<_ManagedUser> get copyWith => __$ManagedUserCopyWithImpl<_ManagedUser>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ManagedUser&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.name, name) || other.name == name)&&(identical(other.roleId, roleId) || other.roleId == roleId)&&(identical(other.roleName, roleName) || other.roleName == roleName)&&(identical(other.roleIsSystem, roleIsSystem) || other.roleIsSystem == roleIsSystem)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,email,name,roleId,roleName,roleIsSystem,isActive,createdAt);
}

@override
String toString() {
    return 'ManagedUser(id: $id, email: $email, name: $name, roleId: $roleId, roleName: $roleName, roleIsSystem: $roleIsSystem, isActive: $isActive, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ManagedUserCopyWith<$Res> implements $ManagedUserCopyWith<$Res> {
  factory _$ManagedUserCopyWith(_ManagedUser value, $Res Function(_ManagedUser) _then) = __$ManagedUserCopyWithImpl;
@override @useResult
$Res call({
 int id, String email, String name, int roleId, String roleName, bool roleIsSystem, bool isActive, DateTime createdAt
});




}
/// @nodoc
class __$ManagedUserCopyWithImpl<$Res>
    implements _$ManagedUserCopyWith<$Res> {
  __$ManagedUserCopyWithImpl(this._self, this._then);

  final _ManagedUser _self;
  final $Res Function(_ManagedUser) _then;

/// Create a copy of ManagedUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? name = null,Object? roleId = null,Object? roleName = null,Object? roleIsSystem = null,Object? isActive = null,Object? createdAt = null,}) {
  return _then(_ManagedUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,roleId: null == roleId ? _self.roleId : roleId // ignore: cast_nullable_to_non_nullable
as int,roleName: null == roleName ? _self.roleName : roleName // ignore: cast_nullable_to_non_nullable
as String,roleIsSystem: null == roleIsSystem ? _self.roleIsSystem : roleIsSystem // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$UserInput {

 String get email; String get password; String get name; int? get roleId; bool get isActive;
/// Create a copy of UserInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserInputCopyWith<UserInput> get copyWith => _$UserInputCopyWithImpl<UserInput>(this as UserInput, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as UserInput;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserInput&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.password, _this.password) || other.password == _this.password)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.roleId, _this.roleId) || other.roleId == _this.roleId)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive));
}


@override
int get hashCode {
  final _this = this as UserInput;
  return Object.hash(runtimeType,_this.email,_this.password,_this.name,_this.roleId,_this.isActive);
}

@override
String toString() {
  final _this = this as UserInput;
  return 'UserInput(email: ${_this.email}, password: ${_this.password}, name: ${_this.name}, roleId: ${_this.roleId}, isActive: ${_this.isActive})';
}


}

/// @nodoc
abstract mixin class $UserInputCopyWith<$Res>  {
  factory $UserInputCopyWith(UserInput value, $Res Function(UserInput) _then) = _$UserInputCopyWithImpl;
@useResult
$Res call({
 String email, String password, String name, int? roleId, bool isActive
});




}
/// @nodoc
class _$UserInputCopyWithImpl<$Res>
    implements $UserInputCopyWith<$Res> {
  _$UserInputCopyWithImpl(this._self, this._then);

  final UserInput _self;
  final $Res Function(UserInput) _then;

/// Create a copy of UserInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? password = null,Object? name = null,Object? roleId = freezed,Object? isActive = null,}) {
  return _then(UserInput(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,roleId: freezed == roleId ? _self.roleId : roleId // ignore: cast_nullable_to_non_nullable
as int?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UserInput].
extension UserInputPatterns on UserInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserInput value)  $default,){
final _that = this;
switch (_that) {
case _UserInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserInput value)?  $default,){
final _that = this;
switch (_that) {
case _UserInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String email,  String password,  String name,  int? roleId,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserInput() when $default != null:
return $default(_that.email,_that.password,_that.name,_that.roleId,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String email,  String password,  String name,  int? roleId,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _UserInput():
return $default(_that.email,_that.password,_that.name,_that.roleId,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String email,  String password,  String name,  int? roleId,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _UserInput() when $default != null:
return $default(_that.email,_that.password,_that.name,_that.roleId,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc


class _UserInput extends UserInput {
  const _UserInput({required this.email, required this.password, required this.name, required this.roleId, this.isActive = true}): super._();
  

@override final  String email;
@override final  String password;
@override final  String name;
@override final  int? roleId;
@override@JsonKey() final  bool isActive;

/// Create a copy of UserInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserInputCopyWith<_UserInput> get copyWith => __$UserInputCopyWithImpl<_UserInput>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserInput&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.name, name) || other.name == name)&&(identical(other.roleId, roleId) || other.roleId == roleId)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode {
    return Object.hash(runtimeType,email,password,name,roleId,isActive);
}

@override
String toString() {
    return 'UserInput(email: $email, password: $password, name: $name, roleId: $roleId, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$UserInputCopyWith<$Res> implements $UserInputCopyWith<$Res> {
  factory _$UserInputCopyWith(_UserInput value, $Res Function(_UserInput) _then) = __$UserInputCopyWithImpl;
@override @useResult
$Res call({
 String email, String password, String name, int? roleId, bool isActive
});




}
/// @nodoc
class __$UserInputCopyWithImpl<$Res>
    implements _$UserInputCopyWith<$Res> {
  __$UserInputCopyWithImpl(this._self, this._then);

  final _UserInput _self;
  final $Res Function(_UserInput) _then;

/// Create a copy of UserInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? password = null,Object? name = null,Object? roleId = freezed,Object? isActive = null,}) {
  return _then(_UserInput(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,roleId: freezed == roleId ? _self.roleId : roleId // ignore: cast_nullable_to_non_nullable
as int?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$UserPatch {

 String? get email; String? get password; String? get name; int? get roleId; bool? get isActive;
/// Create a copy of UserPatch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserPatchCopyWith<UserPatch> get copyWith => _$UserPatchCopyWithImpl<UserPatch>(this as UserPatch, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as UserPatch;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserPatch&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.password, _this.password) || other.password == _this.password)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.roleId, _this.roleId) || other.roleId == _this.roleId)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive));
}


@override
int get hashCode {
  final _this = this as UserPatch;
  return Object.hash(runtimeType,_this.email,_this.password,_this.name,_this.roleId,_this.isActive);
}

@override
String toString() {
  final _this = this as UserPatch;
  return 'UserPatch(email: ${_this.email}, password: ${_this.password}, name: ${_this.name}, roleId: ${_this.roleId}, isActive: ${_this.isActive})';
}


}

/// @nodoc
abstract mixin class $UserPatchCopyWith<$Res>  {
  factory $UserPatchCopyWith(UserPatch value, $Res Function(UserPatch) _then) = _$UserPatchCopyWithImpl;
@useResult
$Res call({
 String? email, String? password, String? name, int? roleId, bool? isActive
});




}
/// @nodoc
class _$UserPatchCopyWithImpl<$Res>
    implements $UserPatchCopyWith<$Res> {
  _$UserPatchCopyWithImpl(this._self, this._then);

  final UserPatch _self;
  final $Res Function(UserPatch) _then;

/// Create a copy of UserPatch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = freezed,Object? password = freezed,Object? name = freezed,Object? roleId = freezed,Object? isActive = freezed,}) {
  return _then(UserPatch(
email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,roleId: freezed == roleId ? _self.roleId : roleId // ignore: cast_nullable_to_non_nullable
as int?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserPatch].
extension UserPatchPatterns on UserPatch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserPatch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserPatch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserPatch value)  $default,){
final _that = this;
switch (_that) {
case _UserPatch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserPatch value)?  $default,){
final _that = this;
switch (_that) {
case _UserPatch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? email,  String? password,  String? name,  int? roleId,  bool? isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserPatch() when $default != null:
return $default(_that.email,_that.password,_that.name,_that.roleId,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? email,  String? password,  String? name,  int? roleId,  bool? isActive)  $default,) {final _that = this;
switch (_that) {
case _UserPatch():
return $default(_that.email,_that.password,_that.name,_that.roleId,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? email,  String? password,  String? name,  int? roleId,  bool? isActive)?  $default,) {final _that = this;
switch (_that) {
case _UserPatch() when $default != null:
return $default(_that.email,_that.password,_that.name,_that.roleId,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc


class _UserPatch extends UserPatch {
  const _UserPatch({this.email, this.password, this.name, this.roleId, this.isActive}): super._();
  

@override final  String? email;
@override final  String? password;
@override final  String? name;
@override final  int? roleId;
@override final  bool? isActive;

/// Create a copy of UserPatch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserPatchCopyWith<_UserPatch> get copyWith => __$UserPatchCopyWithImpl<_UserPatch>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserPatch&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.name, name) || other.name == name)&&(identical(other.roleId, roleId) || other.roleId == roleId)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode {
    return Object.hash(runtimeType,email,password,name,roleId,isActive);
}

@override
String toString() {
    return 'UserPatch(email: $email, password: $password, name: $name, roleId: $roleId, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$UserPatchCopyWith<$Res> implements $UserPatchCopyWith<$Res> {
  factory _$UserPatchCopyWith(_UserPatch value, $Res Function(_UserPatch) _then) = __$UserPatchCopyWithImpl;
@override @useResult
$Res call({
 String? email, String? password, String? name, int? roleId, bool? isActive
});




}
/// @nodoc
class __$UserPatchCopyWithImpl<$Res>
    implements _$UserPatchCopyWith<$Res> {
  __$UserPatchCopyWithImpl(this._self, this._then);

  final _UserPatch _self;
  final $Res Function(_UserPatch) _then;

/// Create a copy of UserPatch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = freezed,Object? password = freezed,Object? name = freezed,Object? roleId = freezed,Object? isActive = freezed,}) {
  return _then(_UserPatch(
email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,roleId: freezed == roleId ? _self.roleId : roleId // ignore: cast_nullable_to_non_nullable
as int?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
