// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sales_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SalesOrder {

 int get id; String get orderNumber; int get customerId;/// Always sent by the backend (also for customers deleted later).
 OrderCustomer? get customer; OrderStatus get status;/// Whole Rupiah.
 int get totalAmount; String get notes; DateTime? get confirmedAt; DateTime? get shippedAt; DateTime? get cancelledAt; DateTime get createdAt; DateTime get updatedAt;/// Empty in list responses; filled in the order detail.
 List<SalesOrderItem> get items;
/// Create a copy of SalesOrder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalesOrderCopyWith<SalesOrder> get copyWith => _$SalesOrderCopyWithImpl<SalesOrder>(this as SalesOrder, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SalesOrder;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalesOrder&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.orderNumber, _this.orderNumber) || other.orderNumber == _this.orderNumber)&&(identical(other.customerId, _this.customerId) || other.customerId == _this.customerId)&&(identical(other.customer, _this.customer) || other.customer == _this.customer)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.totalAmount, _this.totalAmount) || other.totalAmount == _this.totalAmount)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.confirmedAt, _this.confirmedAt) || other.confirmedAt == _this.confirmedAt)&&(identical(other.shippedAt, _this.shippedAt) || other.shippedAt == _this.shippedAt)&&(identical(other.cancelledAt, _this.cancelledAt) || other.cancelledAt == _this.cancelledAt)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&const DeepCollectionEquality().equals(other.items, _this.items));
}


@override
int get hashCode {
  final _this = this as SalesOrder;
  return Object.hash(runtimeType,_this.id,_this.orderNumber,_this.customerId,_this.customer,_this.status,_this.totalAmount,_this.notes,_this.confirmedAt,_this.shippedAt,_this.cancelledAt,_this.createdAt,_this.updatedAt,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as SalesOrder;
  return 'SalesOrder(id: ${_this.id}, orderNumber: ${_this.orderNumber}, customerId: ${_this.customerId}, customer: ${_this.customer}, status: ${_this.status}, totalAmount: ${_this.totalAmount}, notes: ${_this.notes}, confirmedAt: ${_this.confirmedAt}, shippedAt: ${_this.shippedAt}, cancelledAt: ${_this.cancelledAt}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $SalesOrderCopyWith<$Res>  {
  factory $SalesOrderCopyWith(SalesOrder value, $Res Function(SalesOrder) _then) = _$SalesOrderCopyWithImpl;
@useResult
$Res call({
 int id, String orderNumber, int customerId, OrderCustomer? customer, OrderStatus status, int totalAmount, String notes, DateTime? confirmedAt, DateTime? shippedAt, DateTime? cancelledAt, DateTime createdAt, DateTime updatedAt, List<SalesOrderItem> items
});


$OrderCustomerCopyWith<$Res>? get customer;

}
/// @nodoc
class _$SalesOrderCopyWithImpl<$Res>
    implements $SalesOrderCopyWith<$Res> {
  _$SalesOrderCopyWithImpl(this._self, this._then);

  final SalesOrder _self;
  final $Res Function(SalesOrder) _then;

/// Create a copy of SalesOrder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderNumber = null,Object? customerId = null,Object? customer = freezed,Object? status = null,Object? totalAmount = null,Object? notes = null,Object? confirmedAt = freezed,Object? shippedAt = freezed,Object? cancelledAt = freezed,Object? createdAt = null,Object? updatedAt = null,Object? items = null,}) {
  return _then(SalesOrder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as int,customer: freezed == customer ? _self.customer : customer // ignore: cast_nullable_to_non_nullable
as OrderCustomer?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as int,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,confirmedAt: freezed == confirmedAt ? _self.confirmedAt : confirmedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,shippedAt: freezed == shippedAt ? _self.shippedAt : shippedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<SalesOrderItem>,
  ));
}
/// Create a copy of SalesOrder
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderCustomerCopyWith<$Res>? get customer {
    if (_self.customer == null) {
    return null;
  }

  return $OrderCustomerCopyWith<$Res>(_self.customer!, (value) {
    return _then(_self.copyWith(customer: value));
  });
}
}


/// Adds pattern-matching-related methods to [SalesOrder].
extension SalesOrderPatterns on SalesOrder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalesOrder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalesOrder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalesOrder value)  $default,){
final _that = this;
switch (_that) {
case _SalesOrder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalesOrder value)?  $default,){
final _that = this;
switch (_that) {
case _SalesOrder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String orderNumber,  int customerId,  OrderCustomer? customer,  OrderStatus status,  int totalAmount,  String notes,  DateTime? confirmedAt,  DateTime? shippedAt,  DateTime? cancelledAt,  DateTime createdAt,  DateTime updatedAt,  List<SalesOrderItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SalesOrder() when $default != null:
return $default(_that.id,_that.orderNumber,_that.customerId,_that.customer,_that.status,_that.totalAmount,_that.notes,_that.confirmedAt,_that.shippedAt,_that.cancelledAt,_that.createdAt,_that.updatedAt,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String orderNumber,  int customerId,  OrderCustomer? customer,  OrderStatus status,  int totalAmount,  String notes,  DateTime? confirmedAt,  DateTime? shippedAt,  DateTime? cancelledAt,  DateTime createdAt,  DateTime updatedAt,  List<SalesOrderItem> items)  $default,) {final _that = this;
switch (_that) {
case _SalesOrder():
return $default(_that.id,_that.orderNumber,_that.customerId,_that.customer,_that.status,_that.totalAmount,_that.notes,_that.confirmedAt,_that.shippedAt,_that.cancelledAt,_that.createdAt,_that.updatedAt,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String orderNumber,  int customerId,  OrderCustomer? customer,  OrderStatus status,  int totalAmount,  String notes,  DateTime? confirmedAt,  DateTime? shippedAt,  DateTime? cancelledAt,  DateTime createdAt,  DateTime updatedAt,  List<SalesOrderItem> items)?  $default,) {final _that = this;
switch (_that) {
case _SalesOrder() when $default != null:
return $default(_that.id,_that.orderNumber,_that.customerId,_that.customer,_that.status,_that.totalAmount,_that.notes,_that.confirmedAt,_that.shippedAt,_that.cancelledAt,_that.createdAt,_that.updatedAt,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _SalesOrder implements SalesOrder {
  const _SalesOrder({required this.id, required this.orderNumber, required this.customerId, this.customer, required this.status, required this.totalAmount, required this.notes, this.confirmedAt, this.shippedAt, this.cancelledAt, required this.createdAt, required this.updatedAt,  List<SalesOrderItem> items = const []}): _items = items;
  

@override final  int id;
@override final  String orderNumber;
@override final  int customerId;
/// Always sent by the backend (also for customers deleted later).
@override final  OrderCustomer? customer;
@override final  OrderStatus status;
/// Whole Rupiah.
@override final  int totalAmount;
@override final  String notes;
@override final  DateTime? confirmedAt;
@override final  DateTime? shippedAt;
@override final  DateTime? cancelledAt;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
/// Empty in list responses; filled in the order detail.
 final  List<SalesOrderItem> _items;
/// Empty in list responses; filled in the order detail.
@override@JsonKey() List<SalesOrderItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of SalesOrder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalesOrderCopyWith<_SalesOrder> get copyWith => __$SalesOrderCopyWithImpl<_SalesOrder>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalesOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.customer, customer) || other.customer == customer)&&(identical(other.status, status) || other.status == status)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.confirmedAt, confirmedAt) || other.confirmedAt == confirmedAt)&&(identical(other.shippedAt, shippedAt) || other.shippedAt == shippedAt)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.items, _items));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,orderNumber,customerId,customer,status,totalAmount,notes,confirmedAt,shippedAt,cancelledAt,createdAt,updatedAt,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'SalesOrder(id: $id, orderNumber: $orderNumber, customerId: $customerId, customer: $customer, status: $status, totalAmount: $totalAmount, notes: $notes, confirmedAt: $confirmedAt, shippedAt: $shippedAt, cancelledAt: $cancelledAt, createdAt: $createdAt, updatedAt: $updatedAt, items: $items)';
}


}

/// @nodoc
abstract mixin class _$SalesOrderCopyWith<$Res> implements $SalesOrderCopyWith<$Res> {
  factory _$SalesOrderCopyWith(_SalesOrder value, $Res Function(_SalesOrder) _then) = __$SalesOrderCopyWithImpl;
@override @useResult
$Res call({
 int id, String orderNumber, int customerId, OrderCustomer? customer, OrderStatus status, int totalAmount, String notes, DateTime? confirmedAt, DateTime? shippedAt, DateTime? cancelledAt, DateTime createdAt, DateTime updatedAt, List<SalesOrderItem> items
});


@override $OrderCustomerCopyWith<$Res>? get customer;

}
/// @nodoc
class __$SalesOrderCopyWithImpl<$Res>
    implements _$SalesOrderCopyWith<$Res> {
  __$SalesOrderCopyWithImpl(this._self, this._then);

  final _SalesOrder _self;
  final $Res Function(_SalesOrder) _then;

/// Create a copy of SalesOrder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderNumber = null,Object? customerId = null,Object? customer = freezed,Object? status = null,Object? totalAmount = null,Object? notes = null,Object? confirmedAt = freezed,Object? shippedAt = freezed,Object? cancelledAt = freezed,Object? createdAt = null,Object? updatedAt = null,Object? items = null,}) {
  return _then(_SalesOrder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as int,customer: freezed == customer ? _self.customer : customer // ignore: cast_nullable_to_non_nullable
as OrderCustomer?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as int,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,confirmedAt: freezed == confirmedAt ? _self.confirmedAt : confirmedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,shippedAt: freezed == shippedAt ? _self.shippedAt : shippedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<SalesOrderItem>,
  ));
}

/// Create a copy of SalesOrder
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderCustomerCopyWith<$Res>? get customer {
    if (_self.customer == null) {
    return null;
  }

  return $OrderCustomerCopyWith<$Res>(_self.customer!, (value) {
    return _then(_self.copyWith(customer: value));
  });
}
}

/// @nodoc
mixin _$OrderCustomer {

 int get id; String get name; String? get email; String get phone; String get address;
/// Create a copy of OrderCustomer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderCustomerCopyWith<OrderCustomer> get copyWith => _$OrderCustomerCopyWithImpl<OrderCustomer>(this as OrderCustomer, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OrderCustomer;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderCustomer&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.address, _this.address) || other.address == _this.address));
}


@override
int get hashCode {
  final _this = this as OrderCustomer;
  return Object.hash(runtimeType,_this.id,_this.name,_this.email,_this.phone,_this.address);
}

@override
String toString() {
  final _this = this as OrderCustomer;
  return 'OrderCustomer(id: ${_this.id}, name: ${_this.name}, email: ${_this.email}, phone: ${_this.phone}, address: ${_this.address})';
}


}

/// @nodoc
abstract mixin class $OrderCustomerCopyWith<$Res>  {
  factory $OrderCustomerCopyWith(OrderCustomer value, $Res Function(OrderCustomer) _then) = _$OrderCustomerCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? email, String phone, String address
});




}
/// @nodoc
class _$OrderCustomerCopyWithImpl<$Res>
    implements $OrderCustomerCopyWith<$Res> {
  _$OrderCustomerCopyWithImpl(this._self, this._then);

  final OrderCustomer _self;
  final $Res Function(OrderCustomer) _then;

/// Create a copy of OrderCustomer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? email = freezed,Object? phone = null,Object? address = null,}) {
  return _then(OrderCustomer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderCustomer].
extension OrderCustomerPatterns on OrderCustomer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderCustomer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderCustomer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderCustomer value)  $default,){
final _that = this;
switch (_that) {
case _OrderCustomer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderCustomer value)?  $default,){
final _that = this;
switch (_that) {
case _OrderCustomer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? email,  String phone,  String address)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderCustomer() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.phone,_that.address);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? email,  String phone,  String address)  $default,) {final _that = this;
switch (_that) {
case _OrderCustomer():
return $default(_that.id,_that.name,_that.email,_that.phone,_that.address);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? email,  String phone,  String address)?  $default,) {final _that = this;
switch (_that) {
case _OrderCustomer() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.phone,_that.address);case _:
  return null;

}
}

}

/// @nodoc


class _OrderCustomer implements OrderCustomer {
  const _OrderCustomer({required this.id, required this.name, this.email, required this.phone, required this.address});
  

@override final  int id;
@override final  String name;
@override final  String? email;
@override final  String phone;
@override final  String address;

/// Create a copy of OrderCustomer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderCustomerCopyWith<_OrderCustomer> get copyWith => __$OrderCustomerCopyWithImpl<_OrderCustomer>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderCustomer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.address, address) || other.address == address));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,email,phone,address);
}

@override
String toString() {
    return 'OrderCustomer(id: $id, name: $name, email: $email, phone: $phone, address: $address)';
}


}

/// @nodoc
abstract mixin class _$OrderCustomerCopyWith<$Res> implements $OrderCustomerCopyWith<$Res> {
  factory _$OrderCustomerCopyWith(_OrderCustomer value, $Res Function(_OrderCustomer) _then) = __$OrderCustomerCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? email, String phone, String address
});




}
/// @nodoc
class __$OrderCustomerCopyWithImpl<$Res>
    implements _$OrderCustomerCopyWith<$Res> {
  __$OrderCustomerCopyWithImpl(this._self, this._then);

  final _OrderCustomer _self;
  final $Res Function(_OrderCustomer) _then;

/// Create a copy of OrderCustomer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? email = freezed,Object? phone = null,Object? address = null,}) {
  return _then(_OrderCustomer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$SalesOrderItem {

 int get id; int get productId; String get productSku; String get productName; int get quantity; int get unitPrice; int get subtotal;
/// Create a copy of SalesOrderItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalesOrderItemCopyWith<SalesOrderItem> get copyWith => _$SalesOrderItemCopyWithImpl<SalesOrderItem>(this as SalesOrderItem, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SalesOrderItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalesOrderItem&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.productSku, _this.productSku) || other.productSku == _this.productSku)&&(identical(other.productName, _this.productName) || other.productName == _this.productName)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.unitPrice, _this.unitPrice) || other.unitPrice == _this.unitPrice)&&(identical(other.subtotal, _this.subtotal) || other.subtotal == _this.subtotal));
}


@override
int get hashCode {
  final _this = this as SalesOrderItem;
  return Object.hash(runtimeType,_this.id,_this.productId,_this.productSku,_this.productName,_this.quantity,_this.unitPrice,_this.subtotal);
}

@override
String toString() {
  final _this = this as SalesOrderItem;
  return 'SalesOrderItem(id: ${_this.id}, productId: ${_this.productId}, productSku: ${_this.productSku}, productName: ${_this.productName}, quantity: ${_this.quantity}, unitPrice: ${_this.unitPrice}, subtotal: ${_this.subtotal})';
}


}

/// @nodoc
abstract mixin class $SalesOrderItemCopyWith<$Res>  {
  factory $SalesOrderItemCopyWith(SalesOrderItem value, $Res Function(SalesOrderItem) _then) = _$SalesOrderItemCopyWithImpl;
@useResult
$Res call({
 int id, int productId, String productSku, String productName, int quantity, int unitPrice, int subtotal
});




}
/// @nodoc
class _$SalesOrderItemCopyWithImpl<$Res>
    implements $SalesOrderItemCopyWith<$Res> {
  _$SalesOrderItemCopyWithImpl(this._self, this._then);

  final SalesOrderItem _self;
  final $Res Function(SalesOrderItem) _then;

/// Create a copy of SalesOrderItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productId = null,Object? productSku = null,Object? productName = null,Object? quantity = null,Object? unitPrice = null,Object? subtotal = null,}) {
  return _then(SalesOrderItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,productSku: null == productSku ? _self.productSku : productSku // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as int,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SalesOrderItem].
extension SalesOrderItemPatterns on SalesOrderItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalesOrderItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalesOrderItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalesOrderItem value)  $default,){
final _that = this;
switch (_that) {
case _SalesOrderItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalesOrderItem value)?  $default,){
final _that = this;
switch (_that) {
case _SalesOrderItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int productId,  String productSku,  String productName,  int quantity,  int unitPrice,  int subtotal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SalesOrderItem() when $default != null:
return $default(_that.id,_that.productId,_that.productSku,_that.productName,_that.quantity,_that.unitPrice,_that.subtotal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int productId,  String productSku,  String productName,  int quantity,  int unitPrice,  int subtotal)  $default,) {final _that = this;
switch (_that) {
case _SalesOrderItem():
return $default(_that.id,_that.productId,_that.productSku,_that.productName,_that.quantity,_that.unitPrice,_that.subtotal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int productId,  String productSku,  String productName,  int quantity,  int unitPrice,  int subtotal)?  $default,) {final _that = this;
switch (_that) {
case _SalesOrderItem() when $default != null:
return $default(_that.id,_that.productId,_that.productSku,_that.productName,_that.quantity,_that.unitPrice,_that.subtotal);case _:
  return null;

}
}

}

/// @nodoc


class _SalesOrderItem implements SalesOrderItem {
  const _SalesOrderItem({required this.id, required this.productId, required this.productSku, required this.productName, required this.quantity, required this.unitPrice, required this.subtotal});
  

@override final  int id;
@override final  int productId;
@override final  String productSku;
@override final  String productName;
@override final  int quantity;
@override final  int unitPrice;
@override final  int subtotal;

/// Create a copy of SalesOrderItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalesOrderItemCopyWith<_SalesOrderItem> get copyWith => __$SalesOrderItemCopyWithImpl<_SalesOrderItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalesOrderItem&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productSku, productSku) || other.productSku == productSku)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,productId,productSku,productName,quantity,unitPrice,subtotal);
}

@override
String toString() {
    return 'SalesOrderItem(id: $id, productId: $productId, productSku: $productSku, productName: $productName, quantity: $quantity, unitPrice: $unitPrice, subtotal: $subtotal)';
}


}

/// @nodoc
abstract mixin class _$SalesOrderItemCopyWith<$Res> implements $SalesOrderItemCopyWith<$Res> {
  factory _$SalesOrderItemCopyWith(_SalesOrderItem value, $Res Function(_SalesOrderItem) _then) = __$SalesOrderItemCopyWithImpl;
@override @useResult
$Res call({
 int id, int productId, String productSku, String productName, int quantity, int unitPrice, int subtotal
});




}
/// @nodoc
class __$SalesOrderItemCopyWithImpl<$Res>
    implements _$SalesOrderItemCopyWith<$Res> {
  __$SalesOrderItemCopyWithImpl(this._self, this._then);

  final _SalesOrderItem _self;
  final $Res Function(_SalesOrderItem) _then;

/// Create a copy of SalesOrderItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productId = null,Object? productSku = null,Object? productName = null,Object? quantity = null,Object? unitPrice = null,Object? subtotal = null,}) {
  return _then(_SalesOrderItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,productSku: null == productSku ? _self.productSku : productSku // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as int,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$SalesOrderInput {

 int? get customerId; List<OrderLineInput> get items; String get notes;
/// Create a copy of SalesOrderInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalesOrderInputCopyWith<SalesOrderInput> get copyWith => _$SalesOrderInputCopyWithImpl<SalesOrderInput>(this as SalesOrderInput, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SalesOrderInput;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalesOrderInput&&(identical(other.customerId, _this.customerId) || other.customerId == _this.customerId)&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.notes, _this.notes) || other.notes == _this.notes));
}


@override
int get hashCode {
  final _this = this as SalesOrderInput;
  return Object.hash(runtimeType,_this.customerId,const DeepCollectionEquality().hash(_this.items),_this.notes);
}

@override
String toString() {
  final _this = this as SalesOrderInput;
  return 'SalesOrderInput(customerId: ${_this.customerId}, items: ${_this.items}, notes: ${_this.notes})';
}


}

/// @nodoc
abstract mixin class $SalesOrderInputCopyWith<$Res>  {
  factory $SalesOrderInputCopyWith(SalesOrderInput value, $Res Function(SalesOrderInput) _then) = _$SalesOrderInputCopyWithImpl;
@useResult
$Res call({
 int? customerId, List<OrderLineInput> items, String notes
});




}
/// @nodoc
class _$SalesOrderInputCopyWithImpl<$Res>
    implements $SalesOrderInputCopyWith<$Res> {
  _$SalesOrderInputCopyWithImpl(this._self, this._then);

  final SalesOrderInput _self;
  final $Res Function(SalesOrderInput) _then;

/// Create a copy of SalesOrderInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? customerId = freezed,Object? items = null,Object? notes = null,}) {
  return _then(SalesOrderInput(
customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as int?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OrderLineInput>,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SalesOrderInput].
extension SalesOrderInputPatterns on SalesOrderInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalesOrderInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalesOrderInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalesOrderInput value)  $default,){
final _that = this;
switch (_that) {
case _SalesOrderInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalesOrderInput value)?  $default,){
final _that = this;
switch (_that) {
case _SalesOrderInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? customerId,  List<OrderLineInput> items,  String notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SalesOrderInput() when $default != null:
return $default(_that.customerId,_that.items,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? customerId,  List<OrderLineInput> items,  String notes)  $default,) {final _that = this;
switch (_that) {
case _SalesOrderInput():
return $default(_that.customerId,_that.items,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? customerId,  List<OrderLineInput> items,  String notes)?  $default,) {final _that = this;
switch (_that) {
case _SalesOrderInput() when $default != null:
return $default(_that.customerId,_that.items,_that.notes);case _:
  return null;

}
}

}

/// @nodoc


class _SalesOrderInput implements SalesOrderInput {
  const _SalesOrderInput({required this.customerId, required  List<OrderLineInput> items, this.notes = ''}): _items = items;
  

@override final  int? customerId;
 final  List<OrderLineInput> _items;
@override List<OrderLineInput> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  String notes;

/// Create a copy of SalesOrderInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalesOrderInputCopyWith<_SalesOrderInput> get copyWith => __$SalesOrderInputCopyWithImpl<_SalesOrderInput>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalesOrderInput&&(identical(other.customerId, customerId) || other.customerId == customerId)&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.notes, notes) || other.notes == notes));
}


@override
int get hashCode {
    return Object.hash(runtimeType,customerId,const DeepCollectionEquality().hash(_items),notes);
}

@override
String toString() {
    return 'SalesOrderInput(customerId: $customerId, items: $items, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$SalesOrderInputCopyWith<$Res> implements $SalesOrderInputCopyWith<$Res> {
  factory _$SalesOrderInputCopyWith(_SalesOrderInput value, $Res Function(_SalesOrderInput) _then) = __$SalesOrderInputCopyWithImpl;
@override @useResult
$Res call({
 int? customerId, List<OrderLineInput> items, String notes
});




}
/// @nodoc
class __$SalesOrderInputCopyWithImpl<$Res>
    implements _$SalesOrderInputCopyWith<$Res> {
  __$SalesOrderInputCopyWithImpl(this._self, this._then);

  final _SalesOrderInput _self;
  final $Res Function(_SalesOrderInput) _then;

/// Create a copy of SalesOrderInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? customerId = freezed,Object? items = null,Object? notes = null,}) {
  return _then(_SalesOrderInput(
customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as int?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<OrderLineInput>,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$OrderLineInput {

 int get productId;/// Null while the quantity field is empty.
 int? get quantity;
/// Create a copy of OrderLineInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderLineInputCopyWith<OrderLineInput> get copyWith => _$OrderLineInputCopyWithImpl<OrderLineInput>(this as OrderLineInput, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OrderLineInput;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderLineInput&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity));
}


@override
int get hashCode {
  final _this = this as OrderLineInput;
  return Object.hash(runtimeType,_this.productId,_this.quantity);
}

@override
String toString() {
  final _this = this as OrderLineInput;
  return 'OrderLineInput(productId: ${_this.productId}, quantity: ${_this.quantity})';
}


}

/// @nodoc
abstract mixin class $OrderLineInputCopyWith<$Res>  {
  factory $OrderLineInputCopyWith(OrderLineInput value, $Res Function(OrderLineInput) _then) = _$OrderLineInputCopyWithImpl;
@useResult
$Res call({
 int productId, int? quantity
});




}
/// @nodoc
class _$OrderLineInputCopyWithImpl<$Res>
    implements $OrderLineInputCopyWith<$Res> {
  _$OrderLineInputCopyWithImpl(this._self, this._then);

  final OrderLineInput _self;
  final $Res Function(OrderLineInput) _then;

/// Create a copy of OrderLineInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? quantity = freezed,}) {
  return _then(OrderLineInput(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderLineInput].
extension OrderLineInputPatterns on OrderLineInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderLineInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderLineInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderLineInput value)  $default,){
final _that = this;
switch (_that) {
case _OrderLineInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderLineInput value)?  $default,){
final _that = this;
switch (_that) {
case _OrderLineInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int productId,  int? quantity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderLineInput() when $default != null:
return $default(_that.productId,_that.quantity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int productId,  int? quantity)  $default,) {final _that = this;
switch (_that) {
case _OrderLineInput():
return $default(_that.productId,_that.quantity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int productId,  int? quantity)?  $default,) {final _that = this;
switch (_that) {
case _OrderLineInput() when $default != null:
return $default(_that.productId,_that.quantity);case _:
  return null;

}
}

}

/// @nodoc


class _OrderLineInput implements OrderLineInput {
  const _OrderLineInput({required this.productId, required this.quantity});
  

@override final  int productId;
/// Null while the quantity field is empty.
@override final  int? quantity;

/// Create a copy of OrderLineInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderLineInputCopyWith<_OrderLineInput> get copyWith => __$OrderLineInputCopyWithImpl<_OrderLineInput>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderLineInput&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}


@override
int get hashCode {
    return Object.hash(runtimeType,productId,quantity);
}

@override
String toString() {
    return 'OrderLineInput(productId: $productId, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class _$OrderLineInputCopyWith<$Res> implements $OrderLineInputCopyWith<$Res> {
  factory _$OrderLineInputCopyWith(_OrderLineInput value, $Res Function(_OrderLineInput) _then) = __$OrderLineInputCopyWithImpl;
@override @useResult
$Res call({
 int productId, int? quantity
});




}
/// @nodoc
class __$OrderLineInputCopyWithImpl<$Res>
    implements _$OrderLineInputCopyWith<$Res> {
  __$OrderLineInputCopyWithImpl(this._self, this._then);

  final _OrderLineInput _self;
  final $Res Function(_OrderLineInput) _then;

/// Create a copy of OrderLineInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? quantity = freezed,}) {
  return _then(_OrderLineInput(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
