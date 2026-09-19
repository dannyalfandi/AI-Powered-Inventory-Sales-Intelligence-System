// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Customer {

 int get id; String get name;/// Null when the customer has no email.
 String? get email; String get phone; String get address; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Customer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerCopyWith<Customer> get copyWith => _$CustomerCopyWithImpl<Customer>(this as Customer, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Customer;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Customer&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}


@override
int get hashCode {
  final _this = this as Customer;
  return Object.hash(runtimeType,_this.id,_this.name,_this.email,_this.phone,_this.address,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as Customer;
  return 'Customer(id: ${_this.id}, name: ${_this.name}, email: ${_this.email}, phone: ${_this.phone}, address: ${_this.address}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $CustomerCopyWith<$Res>  {
  factory $CustomerCopyWith(Customer value, $Res Function(Customer) _then) = _$CustomerCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? email, String phone, String address, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$CustomerCopyWithImpl<$Res>
    implements $CustomerCopyWith<$Res> {
  _$CustomerCopyWithImpl(this._self, this._then);

  final Customer _self;
  final $Res Function(Customer) _then;

/// Create a copy of Customer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? email = freezed,Object? phone = null,Object? address = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(Customer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Customer].
extension CustomerPatterns on Customer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Customer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Customer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Customer value)  $default,){
final _that = this;
switch (_that) {
case _Customer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Customer value)?  $default,){
final _that = this;
switch (_that) {
case _Customer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? email,  String phone,  String address,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Customer() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.phone,_that.address,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? email,  String phone,  String address,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Customer():
return $default(_that.id,_that.name,_that.email,_that.phone,_that.address,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? email,  String phone,  String address,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Customer() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.phone,_that.address,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Customer implements Customer {
  const _Customer({required this.id, required this.name, this.email, required this.phone, required this.address, required this.createdAt, required this.updatedAt});
  

@override final  int id;
@override final  String name;
/// Null when the customer has no email.
@override final  String? email;
@override final  String phone;
@override final  String address;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Customer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerCopyWith<_Customer> get copyWith => __$CustomerCopyWithImpl<_Customer>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Customer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.address, address) || other.address == address)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,email,phone,address,createdAt,updatedAt);
}

@override
String toString() {
    return 'Customer(id: $id, name: $name, email: $email, phone: $phone, address: $address, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CustomerCopyWith<$Res> implements $CustomerCopyWith<$Res> {
  factory _$CustomerCopyWith(_Customer value, $Res Function(_Customer) _then) = __$CustomerCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? email, String phone, String address, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$CustomerCopyWithImpl<$Res>
    implements _$CustomerCopyWith<$Res> {
  __$CustomerCopyWithImpl(this._self, this._then);

  final _Customer _self;
  final $Res Function(_Customer) _then;

/// Create a copy of Customer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? email = freezed,Object? phone = null,Object? address = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Customer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$CustomerInput {

 String get name; String get email; String get phone; String get address;
/// Create a copy of CustomerInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerInputCopyWith<CustomerInput> get copyWith => _$CustomerInputCopyWithImpl<CustomerInput>(this as CustomerInput, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CustomerInput;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerInput&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.address, _this.address) || other.address == _this.address));
}


@override
int get hashCode {
  final _this = this as CustomerInput;
  return Object.hash(runtimeType,_this.name,_this.email,_this.phone,_this.address);
}

@override
String toString() {
  final _this = this as CustomerInput;
  return 'CustomerInput(name: ${_this.name}, email: ${_this.email}, phone: ${_this.phone}, address: ${_this.address})';
}


}

/// @nodoc
abstract mixin class $CustomerInputCopyWith<$Res>  {
  factory $CustomerInputCopyWith(CustomerInput value, $Res Function(CustomerInput) _then) = _$CustomerInputCopyWithImpl;
@useResult
$Res call({
 String name, String email, String phone, String address
});




}
/// @nodoc
class _$CustomerInputCopyWithImpl<$Res>
    implements $CustomerInputCopyWith<$Res> {
  _$CustomerInputCopyWithImpl(this._self, this._then);

  final CustomerInput _self;
  final $Res Function(CustomerInput) _then;

/// Create a copy of CustomerInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? email = null,Object? phone = null,Object? address = null,}) {
  return _then(CustomerInput(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerInput].
extension CustomerInputPatterns on CustomerInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerInput value)  $default,){
final _that = this;
switch (_that) {
case _CustomerInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerInput value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String email,  String phone,  String address)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerInput() when $default != null:
return $default(_that.name,_that.email,_that.phone,_that.address);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String email,  String phone,  String address)  $default,) {final _that = this;
switch (_that) {
case _CustomerInput():
return $default(_that.name,_that.email,_that.phone,_that.address);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String email,  String phone,  String address)?  $default,) {final _that = this;
switch (_that) {
case _CustomerInput() when $default != null:
return $default(_that.name,_that.email,_that.phone,_that.address);case _:
  return null;

}
}

}

/// @nodoc


class _CustomerInput extends CustomerInput {
  const _CustomerInput({required this.name, this.email = '', this.phone = '', this.address = ''}): super._();
  

@override final  String name;
@override@JsonKey() final  String email;
@override@JsonKey() final  String phone;
@override@JsonKey() final  String address;

/// Create a copy of CustomerInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerInputCopyWith<_CustomerInput> get copyWith => __$CustomerInputCopyWithImpl<_CustomerInput>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerInput&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.address, address) || other.address == address));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,email,phone,address);
}

@override
String toString() {
    return 'CustomerInput(name: $name, email: $email, phone: $phone, address: $address)';
}


}

/// @nodoc
abstract mixin class _$CustomerInputCopyWith<$Res> implements $CustomerInputCopyWith<$Res> {
  factory _$CustomerInputCopyWith(_CustomerInput value, $Res Function(_CustomerInput) _then) = __$CustomerInputCopyWithImpl;
@override @useResult
$Res call({
 String name, String email, String phone, String address
});




}
/// @nodoc
class __$CustomerInputCopyWithImpl<$Res>
    implements _$CustomerInputCopyWith<$Res> {
  __$CustomerInputCopyWithImpl(this._self, this._then);

  final _CustomerInput _self;
  final $Res Function(_CustomerInput) _then;

/// Create a copy of CustomerInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? email = null,Object? phone = null,Object? address = null,}) {
  return _then(_CustomerInput(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$CustomerPatch {

 String? get name; String? get email; String? get phone; String? get address;
/// Create a copy of CustomerPatch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerPatchCopyWith<CustomerPatch> get copyWith => _$CustomerPatchCopyWithImpl<CustomerPatch>(this as CustomerPatch, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CustomerPatch;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerPatch&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.address, _this.address) || other.address == _this.address));
}


@override
int get hashCode {
  final _this = this as CustomerPatch;
  return Object.hash(runtimeType,_this.name,_this.email,_this.phone,_this.address);
}

@override
String toString() {
  final _this = this as CustomerPatch;
  return 'CustomerPatch(name: ${_this.name}, email: ${_this.email}, phone: ${_this.phone}, address: ${_this.address})';
}


}

/// @nodoc
abstract mixin class $CustomerPatchCopyWith<$Res>  {
  factory $CustomerPatchCopyWith(CustomerPatch value, $Res Function(CustomerPatch) _then) = _$CustomerPatchCopyWithImpl;
@useResult
$Res call({
 String? name, String? email, String? phone, String? address
});




}
/// @nodoc
class _$CustomerPatchCopyWithImpl<$Res>
    implements $CustomerPatchCopyWith<$Res> {
  _$CustomerPatchCopyWithImpl(this._self, this._then);

  final CustomerPatch _self;
  final $Res Function(CustomerPatch) _then;

/// Create a copy of CustomerPatch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? email = freezed,Object? phone = freezed,Object? address = freezed,}) {
  return _then(CustomerPatch(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerPatch].
extension CustomerPatchPatterns on CustomerPatch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerPatch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerPatch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerPatch value)  $default,){
final _that = this;
switch (_that) {
case _CustomerPatch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerPatch value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerPatch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  String? email,  String? phone,  String? address)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerPatch() when $default != null:
return $default(_that.name,_that.email,_that.phone,_that.address);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  String? email,  String? phone,  String? address)  $default,) {final _that = this;
switch (_that) {
case _CustomerPatch():
return $default(_that.name,_that.email,_that.phone,_that.address);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  String? email,  String? phone,  String? address)?  $default,) {final _that = this;
switch (_that) {
case _CustomerPatch() when $default != null:
return $default(_that.name,_that.email,_that.phone,_that.address);case _:
  return null;

}
}

}

/// @nodoc


class _CustomerPatch extends CustomerPatch {
  const _CustomerPatch({this.name, this.email, this.phone, this.address}): super._();
  

@override final  String? name;
@override final  String? email;
@override final  String? phone;
@override final  String? address;

/// Create a copy of CustomerPatch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerPatchCopyWith<_CustomerPatch> get copyWith => __$CustomerPatchCopyWithImpl<_CustomerPatch>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerPatch&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.address, address) || other.address == address));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,email,phone,address);
}

@override
String toString() {
    return 'CustomerPatch(name: $name, email: $email, phone: $phone, address: $address)';
}


}

/// @nodoc
abstract mixin class _$CustomerPatchCopyWith<$Res> implements $CustomerPatchCopyWith<$Res> {
  factory _$CustomerPatchCopyWith(_CustomerPatch value, $Res Function(_CustomerPatch) _then) = __$CustomerPatchCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? email, String? phone, String? address
});




}
/// @nodoc
class __$CustomerPatchCopyWithImpl<$Res>
    implements _$CustomerPatchCopyWith<$Res> {
  __$CustomerPatchCopyWithImpl(this._self, this._then);

  final _CustomerPatch _self;
  final $Res Function(_CustomerPatch) _then;

/// Create a copy of CustomerPatch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? email = freezed,Object? phone = freezed,Object? address = freezed,}) {
  return _then(_CustomerPatch(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
