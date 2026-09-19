// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sales_order_list_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SalesOrderFilter {

 OrderStatus? get status; int? get customerId; String? get customerName;
/// Create a copy of SalesOrderFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalesOrderFilterCopyWith<SalesOrderFilter> get copyWith => _$SalesOrderFilterCopyWithImpl<SalesOrderFilter>(this as SalesOrderFilter, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SalesOrderFilter;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalesOrderFilter&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.customerId, _this.customerId) || other.customerId == _this.customerId)&&(identical(other.customerName, _this.customerName) || other.customerName == _this.customerName));
}


@override
int get hashCode {
  final _this = this as SalesOrderFilter;
  return Object.hash(runtimeType,_this.status,_this.customerId,_this.customerName);
}

@override
String toString() {
  final _this = this as SalesOrderFilter;
  return 'SalesOrderFilter(status: ${_this.status}, customerId: ${_this.customerId}, customerName: ${_this.customerName})';
}


}

/// @nodoc
abstract mixin class $SalesOrderFilterCopyWith<$Res>  {
  factory $SalesOrderFilterCopyWith(SalesOrderFilter value, $Res Function(SalesOrderFilter) _then) = _$SalesOrderFilterCopyWithImpl;
@useResult
$Res call({
 OrderStatus? status, int? customerId, String? customerName
});




}
/// @nodoc
class _$SalesOrderFilterCopyWithImpl<$Res>
    implements $SalesOrderFilterCopyWith<$Res> {
  _$SalesOrderFilterCopyWithImpl(this._self, this._then);

  final SalesOrderFilter _self;
  final $Res Function(SalesOrderFilter) _then;

/// Create a copy of SalesOrderFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = freezed,Object? customerId = freezed,Object? customerName = freezed,}) {
  return _then(SalesOrderFilter(
status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as int?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SalesOrderFilter].
extension SalesOrderFilterPatterns on SalesOrderFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalesOrderFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalesOrderFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalesOrderFilter value)  $default,){
final _that = this;
switch (_that) {
case _SalesOrderFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalesOrderFilter value)?  $default,){
final _that = this;
switch (_that) {
case _SalesOrderFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( OrderStatus? status,  int? customerId,  String? customerName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SalesOrderFilter() when $default != null:
return $default(_that.status,_that.customerId,_that.customerName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( OrderStatus? status,  int? customerId,  String? customerName)  $default,) {final _that = this;
switch (_that) {
case _SalesOrderFilter():
return $default(_that.status,_that.customerId,_that.customerName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( OrderStatus? status,  int? customerId,  String? customerName)?  $default,) {final _that = this;
switch (_that) {
case _SalesOrderFilter() when $default != null:
return $default(_that.status,_that.customerId,_that.customerName);case _:
  return null;

}
}

}

/// @nodoc


class _SalesOrderFilter implements SalesOrderFilter {
  const _SalesOrderFilter({this.status, this.customerId, this.customerName});
  

@override final  OrderStatus? status;
@override final  int? customerId;
@override final  String? customerName;

/// Create a copy of SalesOrderFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalesOrderFilterCopyWith<_SalesOrderFilter> get copyWith => __$SalesOrderFilterCopyWithImpl<_SalesOrderFilter>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalesOrderFilter&&(identical(other.status, status) || other.status == status)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.customerName, customerName) || other.customerName == customerName));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,customerId,customerName);
}

@override
String toString() {
    return 'SalesOrderFilter(status: $status, customerId: $customerId, customerName: $customerName)';
}


}

/// @nodoc
abstract mixin class _$SalesOrderFilterCopyWith<$Res> implements $SalesOrderFilterCopyWith<$Res> {
  factory _$SalesOrderFilterCopyWith(_SalesOrderFilter value, $Res Function(_SalesOrderFilter) _then) = __$SalesOrderFilterCopyWithImpl;
@override @useResult
$Res call({
 OrderStatus? status, int? customerId, String? customerName
});




}
/// @nodoc
class __$SalesOrderFilterCopyWithImpl<$Res>
    implements _$SalesOrderFilterCopyWith<$Res> {
  __$SalesOrderFilterCopyWithImpl(this._self, this._then);

  final _SalesOrderFilter _self;
  final $Res Function(_SalesOrderFilter) _then;

/// Create a copy of SalesOrderFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = freezed,Object? customerId = freezed,Object? customerName = freezed,}) {
  return _then(_SalesOrderFilter(
status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as int?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
