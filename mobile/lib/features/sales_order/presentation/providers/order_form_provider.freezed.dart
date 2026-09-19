// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_form_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrderFormLine {

 Product get product;/// Null while the quantity field is empty.
 int? get quantity;
/// Create a copy of OrderFormLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderFormLineCopyWith<OrderFormLine> get copyWith => _$OrderFormLineCopyWithImpl<OrderFormLine>(this as OrderFormLine, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OrderFormLine;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderFormLine&&(identical(other.product, _this.product) || other.product == _this.product)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity));
}


@override
int get hashCode {
  final _this = this as OrderFormLine;
  return Object.hash(runtimeType,_this.product,_this.quantity);
}

@override
String toString() {
  final _this = this as OrderFormLine;
  return 'OrderFormLine(product: ${_this.product}, quantity: ${_this.quantity})';
}


}

/// @nodoc
abstract mixin class $OrderFormLineCopyWith<$Res>  {
  factory $OrderFormLineCopyWith(OrderFormLine value, $Res Function(OrderFormLine) _then) = _$OrderFormLineCopyWithImpl;
@useResult
$Res call({
 Product product, int? quantity
});


$ProductCopyWith<$Res> get product;

}
/// @nodoc
class _$OrderFormLineCopyWithImpl<$Res>
    implements $OrderFormLineCopyWith<$Res> {
  _$OrderFormLineCopyWithImpl(this._self, this._then);

  final OrderFormLine _self;
  final $Res Function(OrderFormLine) _then;

/// Create a copy of OrderFormLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? product = null,Object? quantity = freezed,}) {
  return _then(OrderFormLine(
product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as Product,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of OrderFormLine
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductCopyWith<$Res> get product {
  
  return $ProductCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}


/// Adds pattern-matching-related methods to [OrderFormLine].
extension OrderFormLinePatterns on OrderFormLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderFormLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderFormLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderFormLine value)  $default,){
final _that = this;
switch (_that) {
case _OrderFormLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderFormLine value)?  $default,){
final _that = this;
switch (_that) {
case _OrderFormLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Product product,  int? quantity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderFormLine() when $default != null:
return $default(_that.product,_that.quantity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Product product,  int? quantity)  $default,) {final _that = this;
switch (_that) {
case _OrderFormLine():
return $default(_that.product,_that.quantity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Product product,  int? quantity)?  $default,) {final _that = this;
switch (_that) {
case _OrderFormLine() when $default != null:
return $default(_that.product,_that.quantity);case _:
  return null;

}
}

}

/// @nodoc


class _OrderFormLine extends OrderFormLine {
  const _OrderFormLine({required this.product, this.quantity}): super._();
  

@override final  Product product;
/// Null while the quantity field is empty.
@override final  int? quantity;

/// Create a copy of OrderFormLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderFormLineCopyWith<_OrderFormLine> get copyWith => __$OrderFormLineCopyWithImpl<_OrderFormLine>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderFormLine&&(identical(other.product, product) || other.product == product)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}


@override
int get hashCode {
    return Object.hash(runtimeType,product,quantity);
}

@override
String toString() {
    return 'OrderFormLine(product: $product, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class _$OrderFormLineCopyWith<$Res> implements $OrderFormLineCopyWith<$Res> {
  factory _$OrderFormLineCopyWith(_OrderFormLine value, $Res Function(_OrderFormLine) _then) = __$OrderFormLineCopyWithImpl;
@override @useResult
$Res call({
 Product product, int? quantity
});


@override $ProductCopyWith<$Res> get product;

}
/// @nodoc
class __$OrderFormLineCopyWithImpl<$Res>
    implements _$OrderFormLineCopyWith<$Res> {
  __$OrderFormLineCopyWithImpl(this._self, this._then);

  final _OrderFormLine _self;
  final $Res Function(_OrderFormLine) _then;

/// Create a copy of OrderFormLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? product = null,Object? quantity = freezed,}) {
  return _then(_OrderFormLine(
product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as Product,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of OrderFormLine
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductCopyWith<$Res> get product {
  
  return $ProductCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}

/// @nodoc
mixin _$OrderFormState {

 Customer? get customer; List<OrderFormLine> get lines; String get notes;
/// Create a copy of OrderFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderFormStateCopyWith<OrderFormState> get copyWith => _$OrderFormStateCopyWithImpl<OrderFormState>(this as OrderFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OrderFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderFormState&&(identical(other.customer, _this.customer) || other.customer == _this.customer)&&const DeepCollectionEquality().equals(other.lines, _this.lines)&&(identical(other.notes, _this.notes) || other.notes == _this.notes));
}


@override
int get hashCode {
  final _this = this as OrderFormState;
  return Object.hash(runtimeType,_this.customer,const DeepCollectionEquality().hash(_this.lines),_this.notes);
}

@override
String toString() {
  final _this = this as OrderFormState;
  return 'OrderFormState(customer: ${_this.customer}, lines: ${_this.lines}, notes: ${_this.notes})';
}


}

/// @nodoc
abstract mixin class $OrderFormStateCopyWith<$Res>  {
  factory $OrderFormStateCopyWith(OrderFormState value, $Res Function(OrderFormState) _then) = _$OrderFormStateCopyWithImpl;
@useResult
$Res call({
 Customer? customer, List<OrderFormLine> lines, String notes
});


$CustomerCopyWith<$Res>? get customer;

}
/// @nodoc
class _$OrderFormStateCopyWithImpl<$Res>
    implements $OrderFormStateCopyWith<$Res> {
  _$OrderFormStateCopyWithImpl(this._self, this._then);

  final OrderFormState _self;
  final $Res Function(OrderFormState) _then;

/// Create a copy of OrderFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? customer = freezed,Object? lines = null,Object? notes = null,}) {
  return _then(OrderFormState(
customer: freezed == customer ? _self.customer : customer // ignore: cast_nullable_to_non_nullable
as Customer?,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<OrderFormLine>,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of OrderFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomerCopyWith<$Res>? get customer {
    if (_self.customer == null) {
    return null;
  }

  return $CustomerCopyWith<$Res>(_self.customer!, (value) {
    return _then(_self.copyWith(customer: value));
  });
}
}


/// Adds pattern-matching-related methods to [OrderFormState].
extension OrderFormStatePatterns on OrderFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderFormState value)  $default,){
final _that = this;
switch (_that) {
case _OrderFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderFormState value)?  $default,){
final _that = this;
switch (_that) {
case _OrderFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Customer? customer,  List<OrderFormLine> lines,  String notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderFormState() when $default != null:
return $default(_that.customer,_that.lines,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Customer? customer,  List<OrderFormLine> lines,  String notes)  $default,) {final _that = this;
switch (_that) {
case _OrderFormState():
return $default(_that.customer,_that.lines,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Customer? customer,  List<OrderFormLine> lines,  String notes)?  $default,) {final _that = this;
switch (_that) {
case _OrderFormState() when $default != null:
return $default(_that.customer,_that.lines,_that.notes);case _:
  return null;

}
}

}

/// @nodoc


class _OrderFormState extends OrderFormState {
  const _OrderFormState({this.customer,  List<OrderFormLine> lines = const [], this.notes = ''}): _lines = lines,super._();
  

@override final  Customer? customer;
 final  List<OrderFormLine> _lines;
@override@JsonKey() List<OrderFormLine> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

@override@JsonKey() final  String notes;

/// Create a copy of OrderFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderFormStateCopyWith<_OrderFormState> get copyWith => __$OrderFormStateCopyWithImpl<_OrderFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderFormState&&(identical(other.customer, customer) || other.customer == customer)&&const DeepCollectionEquality().equals(other.lines, _lines)&&(identical(other.notes, notes) || other.notes == notes));
}


@override
int get hashCode {
    return Object.hash(runtimeType,customer,const DeepCollectionEquality().hash(_lines),notes);
}

@override
String toString() {
    return 'OrderFormState(customer: $customer, lines: $lines, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$OrderFormStateCopyWith<$Res> implements $OrderFormStateCopyWith<$Res> {
  factory _$OrderFormStateCopyWith(_OrderFormState value, $Res Function(_OrderFormState) _then) = __$OrderFormStateCopyWithImpl;
@override @useResult
$Res call({
 Customer? customer, List<OrderFormLine> lines, String notes
});


@override $CustomerCopyWith<$Res>? get customer;

}
/// @nodoc
class __$OrderFormStateCopyWithImpl<$Res>
    implements _$OrderFormStateCopyWith<$Res> {
  __$OrderFormStateCopyWithImpl(this._self, this._then);

  final _OrderFormState _self;
  final $Res Function(_OrderFormState) _then;

/// Create a copy of OrderFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? customer = freezed,Object? lines = null,Object? notes = null,}) {
  return _then(_OrderFormState(
customer: freezed == customer ? _self.customer : customer // ignore: cast_nullable_to_non_nullable
as Customer?,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<OrderFormLine>,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of OrderFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomerCopyWith<$Res>? get customer {
    if (_self.customer == null) {
    return null;
  }

  return $CustomerCopyWith<$Res>(_self.customer!, (value) {
    return _then(_self.copyWith(customer: value));
  });
}
}

// dart format on
