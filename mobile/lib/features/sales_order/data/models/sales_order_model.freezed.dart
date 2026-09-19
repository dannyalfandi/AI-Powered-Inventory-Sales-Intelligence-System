// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sales_order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SalesOrderModel {

 int get id; String get orderNumber; int get customerId; String get status; int get totalAmount; String get notes; DateTime? get confirmedAt; DateTime? get shippedAt; DateTime? get cancelledAt; DateTime get createdAt; DateTime get updatedAt; OrderCustomerModel? get customer; List<SalesOrderItemModel> get items;
/// Create a copy of SalesOrderModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalesOrderModelCopyWith<SalesOrderModel> get copyWith => _$SalesOrderModelCopyWithImpl<SalesOrderModel>(this as SalesOrderModel, _$identity);

  /// Serializes this SalesOrderModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SalesOrderModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalesOrderModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.orderNumber, _this.orderNumber) || other.orderNumber == _this.orderNumber)&&(identical(other.customerId, _this.customerId) || other.customerId == _this.customerId)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.totalAmount, _this.totalAmount) || other.totalAmount == _this.totalAmount)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.confirmedAt, _this.confirmedAt) || other.confirmedAt == _this.confirmedAt)&&(identical(other.shippedAt, _this.shippedAt) || other.shippedAt == _this.shippedAt)&&(identical(other.cancelledAt, _this.cancelledAt) || other.cancelledAt == _this.cancelledAt)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.customer, _this.customer) || other.customer == _this.customer)&&const DeepCollectionEquality().equals(other.items, _this.items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SalesOrderModel;
  return Object.hash(runtimeType,_this.id,_this.orderNumber,_this.customerId,_this.status,_this.totalAmount,_this.notes,_this.confirmedAt,_this.shippedAt,_this.cancelledAt,_this.createdAt,_this.updatedAt,_this.customer,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as SalesOrderModel;
  return 'SalesOrderModel(id: ${_this.id}, orderNumber: ${_this.orderNumber}, customerId: ${_this.customerId}, status: ${_this.status}, totalAmount: ${_this.totalAmount}, notes: ${_this.notes}, confirmedAt: ${_this.confirmedAt}, shippedAt: ${_this.shippedAt}, cancelledAt: ${_this.cancelledAt}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, customer: ${_this.customer}, items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $SalesOrderModelCopyWith<$Res>  {
  factory $SalesOrderModelCopyWith(SalesOrderModel value, $Res Function(SalesOrderModel) _then) = _$SalesOrderModelCopyWithImpl;
@useResult
$Res call({
 int id, String orderNumber, int customerId, String status, int totalAmount, String notes, DateTime? confirmedAt, DateTime? shippedAt, DateTime? cancelledAt, DateTime createdAt, DateTime updatedAt, OrderCustomerModel? customer, List<SalesOrderItemModel> items
});


$OrderCustomerModelCopyWith<$Res>? get customer;

}
/// @nodoc
class _$SalesOrderModelCopyWithImpl<$Res>
    implements $SalesOrderModelCopyWith<$Res> {
  _$SalesOrderModelCopyWithImpl(this._self, this._then);

  final SalesOrderModel _self;
  final $Res Function(SalesOrderModel) _then;

/// Create a copy of SalesOrderModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderNumber = null,Object? customerId = null,Object? status = null,Object? totalAmount = null,Object? notes = null,Object? confirmedAt = freezed,Object? shippedAt = freezed,Object? cancelledAt = freezed,Object? createdAt = null,Object? updatedAt = null,Object? customer = freezed,Object? items = null,}) {
  return _then(SalesOrderModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as int,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,confirmedAt: freezed == confirmedAt ? _self.confirmedAt : confirmedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,shippedAt: freezed == shippedAt ? _self.shippedAt : shippedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,customer: freezed == customer ? _self.customer : customer // ignore: cast_nullable_to_non_nullable
as OrderCustomerModel?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<SalesOrderItemModel>,
  ));
}
/// Create a copy of SalesOrderModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderCustomerModelCopyWith<$Res>? get customer {
    if (_self.customer == null) {
    return null;
  }

  return $OrderCustomerModelCopyWith<$Res>(_self.customer!, (value) {
    return _then(_self.copyWith(customer: value));
  });
}
}


/// Adds pattern-matching-related methods to [SalesOrderModel].
extension SalesOrderModelPatterns on SalesOrderModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalesOrderModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalesOrderModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalesOrderModel value)  $default,){
final _that = this;
switch (_that) {
case _SalesOrderModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalesOrderModel value)?  $default,){
final _that = this;
switch (_that) {
case _SalesOrderModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String orderNumber,  int customerId,  String status,  int totalAmount,  String notes,  DateTime? confirmedAt,  DateTime? shippedAt,  DateTime? cancelledAt,  DateTime createdAt,  DateTime updatedAt,  OrderCustomerModel? customer,  List<SalesOrderItemModel> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SalesOrderModel() when $default != null:
return $default(_that.id,_that.orderNumber,_that.customerId,_that.status,_that.totalAmount,_that.notes,_that.confirmedAt,_that.shippedAt,_that.cancelledAt,_that.createdAt,_that.updatedAt,_that.customer,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String orderNumber,  int customerId,  String status,  int totalAmount,  String notes,  DateTime? confirmedAt,  DateTime? shippedAt,  DateTime? cancelledAt,  DateTime createdAt,  DateTime updatedAt,  OrderCustomerModel? customer,  List<SalesOrderItemModel> items)  $default,) {final _that = this;
switch (_that) {
case _SalesOrderModel():
return $default(_that.id,_that.orderNumber,_that.customerId,_that.status,_that.totalAmount,_that.notes,_that.confirmedAt,_that.shippedAt,_that.cancelledAt,_that.createdAt,_that.updatedAt,_that.customer,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String orderNumber,  int customerId,  String status,  int totalAmount,  String notes,  DateTime? confirmedAt,  DateTime? shippedAt,  DateTime? cancelledAt,  DateTime createdAt,  DateTime updatedAt,  OrderCustomerModel? customer,  List<SalesOrderItemModel> items)?  $default,) {final _that = this;
switch (_that) {
case _SalesOrderModel() when $default != null:
return $default(_that.id,_that.orderNumber,_that.customerId,_that.status,_that.totalAmount,_that.notes,_that.confirmedAt,_that.shippedAt,_that.cancelledAt,_that.createdAt,_that.updatedAt,_that.customer,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SalesOrderModel extends SalesOrderModel {
  const _SalesOrderModel({required this.id, required this.orderNumber, required this.customerId, required this.status, required this.totalAmount, this.notes = '', this.confirmedAt, this.shippedAt, this.cancelledAt, required this.createdAt, required this.updatedAt, this.customer,  List<SalesOrderItemModel> items = const []}): _items = items,super._();
  factory _SalesOrderModel.fromJson(Map<String, dynamic> json) => _$SalesOrderModelFromJson(json);

@override final  int id;
@override final  String orderNumber;
@override final  int customerId;
@override final  String status;
@override final  int totalAmount;
@override@JsonKey() final  String notes;
@override final  DateTime? confirmedAt;
@override final  DateTime? shippedAt;
@override final  DateTime? cancelledAt;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  OrderCustomerModel? customer;
 final  List<SalesOrderItemModel> _items;
@override@JsonKey() List<SalesOrderItemModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of SalesOrderModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalesOrderModelCopyWith<_SalesOrderModel> get copyWith => __$SalesOrderModelCopyWithImpl<_SalesOrderModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SalesOrderModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalesOrderModel&&(identical(other.id, id) || other.id == id)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.status, status) || other.status == status)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.confirmedAt, confirmedAt) || other.confirmedAt == confirmedAt)&&(identical(other.shippedAt, shippedAt) || other.shippedAt == shippedAt)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.customer, customer) || other.customer == customer)&&const DeepCollectionEquality().equals(other.items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,orderNumber,customerId,status,totalAmount,notes,confirmedAt,shippedAt,cancelledAt,createdAt,updatedAt,customer,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'SalesOrderModel(id: $id, orderNumber: $orderNumber, customerId: $customerId, status: $status, totalAmount: $totalAmount, notes: $notes, confirmedAt: $confirmedAt, shippedAt: $shippedAt, cancelledAt: $cancelledAt, createdAt: $createdAt, updatedAt: $updatedAt, customer: $customer, items: $items)';
}


}

/// @nodoc
abstract mixin class _$SalesOrderModelCopyWith<$Res> implements $SalesOrderModelCopyWith<$Res> {
  factory _$SalesOrderModelCopyWith(_SalesOrderModel value, $Res Function(_SalesOrderModel) _then) = __$SalesOrderModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String orderNumber, int customerId, String status, int totalAmount, String notes, DateTime? confirmedAt, DateTime? shippedAt, DateTime? cancelledAt, DateTime createdAt, DateTime updatedAt, OrderCustomerModel? customer, List<SalesOrderItemModel> items
});


@override $OrderCustomerModelCopyWith<$Res>? get customer;

}
/// @nodoc
class __$SalesOrderModelCopyWithImpl<$Res>
    implements _$SalesOrderModelCopyWith<$Res> {
  __$SalesOrderModelCopyWithImpl(this._self, this._then);

  final _SalesOrderModel _self;
  final $Res Function(_SalesOrderModel) _then;

/// Create a copy of SalesOrderModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderNumber = null,Object? customerId = null,Object? status = null,Object? totalAmount = null,Object? notes = null,Object? confirmedAt = freezed,Object? shippedAt = freezed,Object? cancelledAt = freezed,Object? createdAt = null,Object? updatedAt = null,Object? customer = freezed,Object? items = null,}) {
  return _then(_SalesOrderModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as int,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,confirmedAt: freezed == confirmedAt ? _self.confirmedAt : confirmedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,shippedAt: freezed == shippedAt ? _self.shippedAt : shippedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,customer: freezed == customer ? _self.customer : customer // ignore: cast_nullable_to_non_nullable
as OrderCustomerModel?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<SalesOrderItemModel>,
  ));
}

/// Create a copy of SalesOrderModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderCustomerModelCopyWith<$Res>? get customer {
    if (_self.customer == null) {
    return null;
  }

  return $OrderCustomerModelCopyWith<$Res>(_self.customer!, (value) {
    return _then(_self.copyWith(customer: value));
  });
}
}


/// @nodoc
mixin _$OrderCustomerModel {

 int get id; String get name; String? get email; String get phone; String get address;
/// Create a copy of OrderCustomerModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderCustomerModelCopyWith<OrderCustomerModel> get copyWith => _$OrderCustomerModelCopyWithImpl<OrderCustomerModel>(this as OrderCustomerModel, _$identity);

  /// Serializes this OrderCustomerModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OrderCustomerModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderCustomerModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.address, _this.address) || other.address == _this.address));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OrderCustomerModel;
  return Object.hash(runtimeType,_this.id,_this.name,_this.email,_this.phone,_this.address);
}

@override
String toString() {
  final _this = this as OrderCustomerModel;
  return 'OrderCustomerModel(id: ${_this.id}, name: ${_this.name}, email: ${_this.email}, phone: ${_this.phone}, address: ${_this.address})';
}


}

/// @nodoc
abstract mixin class $OrderCustomerModelCopyWith<$Res>  {
  factory $OrderCustomerModelCopyWith(OrderCustomerModel value, $Res Function(OrderCustomerModel) _then) = _$OrderCustomerModelCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? email, String phone, String address
});




}
/// @nodoc
class _$OrderCustomerModelCopyWithImpl<$Res>
    implements $OrderCustomerModelCopyWith<$Res> {
  _$OrderCustomerModelCopyWithImpl(this._self, this._then);

  final OrderCustomerModel _self;
  final $Res Function(OrderCustomerModel) _then;

/// Create a copy of OrderCustomerModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? email = freezed,Object? phone = null,Object? address = null,}) {
  return _then(OrderCustomerModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderCustomerModel].
extension OrderCustomerModelPatterns on OrderCustomerModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderCustomerModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderCustomerModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderCustomerModel value)  $default,){
final _that = this;
switch (_that) {
case _OrderCustomerModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderCustomerModel value)?  $default,){
final _that = this;
switch (_that) {
case _OrderCustomerModel() when $default != null:
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
case _OrderCustomerModel() when $default != null:
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
case _OrderCustomerModel():
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
case _OrderCustomerModel() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.phone,_that.address);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderCustomerModel extends OrderCustomerModel {
  const _OrderCustomerModel({required this.id, required this.name, this.email, this.phone = '', this.address = ''}): super._();
  factory _OrderCustomerModel.fromJson(Map<String, dynamic> json) => _$OrderCustomerModelFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? email;
@override@JsonKey() final  String phone;
@override@JsonKey() final  String address;

/// Create a copy of OrderCustomerModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderCustomerModelCopyWith<_OrderCustomerModel> get copyWith => __$OrderCustomerModelCopyWithImpl<_OrderCustomerModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderCustomerModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderCustomerModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.address, address) || other.address == address));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,email,phone,address);
}

@override
String toString() {
    return 'OrderCustomerModel(id: $id, name: $name, email: $email, phone: $phone, address: $address)';
}


}

/// @nodoc
abstract mixin class _$OrderCustomerModelCopyWith<$Res> implements $OrderCustomerModelCopyWith<$Res> {
  factory _$OrderCustomerModelCopyWith(_OrderCustomerModel value, $Res Function(_OrderCustomerModel) _then) = __$OrderCustomerModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? email, String phone, String address
});




}
/// @nodoc
class __$OrderCustomerModelCopyWithImpl<$Res>
    implements _$OrderCustomerModelCopyWith<$Res> {
  __$OrderCustomerModelCopyWithImpl(this._self, this._then);

  final _OrderCustomerModel _self;
  final $Res Function(_OrderCustomerModel) _then;

/// Create a copy of OrderCustomerModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? email = freezed,Object? phone = null,Object? address = null,}) {
  return _then(_OrderCustomerModel(
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
mixin _$SalesOrderItemModel {

 int get id; int get productId; String get productSku; String get productName; int get quantity; int get unitPrice; int get subtotal;
/// Create a copy of SalesOrderItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalesOrderItemModelCopyWith<SalesOrderItemModel> get copyWith => _$SalesOrderItemModelCopyWithImpl<SalesOrderItemModel>(this as SalesOrderItemModel, _$identity);

  /// Serializes this SalesOrderItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SalesOrderItemModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalesOrderItemModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.productSku, _this.productSku) || other.productSku == _this.productSku)&&(identical(other.productName, _this.productName) || other.productName == _this.productName)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.unitPrice, _this.unitPrice) || other.unitPrice == _this.unitPrice)&&(identical(other.subtotal, _this.subtotal) || other.subtotal == _this.subtotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SalesOrderItemModel;
  return Object.hash(runtimeType,_this.id,_this.productId,_this.productSku,_this.productName,_this.quantity,_this.unitPrice,_this.subtotal);
}

@override
String toString() {
  final _this = this as SalesOrderItemModel;
  return 'SalesOrderItemModel(id: ${_this.id}, productId: ${_this.productId}, productSku: ${_this.productSku}, productName: ${_this.productName}, quantity: ${_this.quantity}, unitPrice: ${_this.unitPrice}, subtotal: ${_this.subtotal})';
}


}

/// @nodoc
abstract mixin class $SalesOrderItemModelCopyWith<$Res>  {
  factory $SalesOrderItemModelCopyWith(SalesOrderItemModel value, $Res Function(SalesOrderItemModel) _then) = _$SalesOrderItemModelCopyWithImpl;
@useResult
$Res call({
 int id, int productId, String productSku, String productName, int quantity, int unitPrice, int subtotal
});




}
/// @nodoc
class _$SalesOrderItemModelCopyWithImpl<$Res>
    implements $SalesOrderItemModelCopyWith<$Res> {
  _$SalesOrderItemModelCopyWithImpl(this._self, this._then);

  final SalesOrderItemModel _self;
  final $Res Function(SalesOrderItemModel) _then;

/// Create a copy of SalesOrderItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productId = null,Object? productSku = null,Object? productName = null,Object? quantity = null,Object? unitPrice = null,Object? subtotal = null,}) {
  return _then(SalesOrderItemModel(
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


/// Adds pattern-matching-related methods to [SalesOrderItemModel].
extension SalesOrderItemModelPatterns on SalesOrderItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalesOrderItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalesOrderItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalesOrderItemModel value)  $default,){
final _that = this;
switch (_that) {
case _SalesOrderItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalesOrderItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _SalesOrderItemModel() when $default != null:
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
case _SalesOrderItemModel() when $default != null:
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
case _SalesOrderItemModel():
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
case _SalesOrderItemModel() when $default != null:
return $default(_that.id,_that.productId,_that.productSku,_that.productName,_that.quantity,_that.unitPrice,_that.subtotal);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SalesOrderItemModel extends SalesOrderItemModel {
  const _SalesOrderItemModel({required this.id, required this.productId, required this.productSku, required this.productName, required this.quantity, required this.unitPrice, required this.subtotal}): super._();
  factory _SalesOrderItemModel.fromJson(Map<String, dynamic> json) => _$SalesOrderItemModelFromJson(json);

@override final  int id;
@override final  int productId;
@override final  String productSku;
@override final  String productName;
@override final  int quantity;
@override final  int unitPrice;
@override final  int subtotal;

/// Create a copy of SalesOrderItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalesOrderItemModelCopyWith<_SalesOrderItemModel> get copyWith => __$SalesOrderItemModelCopyWithImpl<_SalesOrderItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SalesOrderItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalesOrderItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productSku, productSku) || other.productSku == productSku)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,productId,productSku,productName,quantity,unitPrice,subtotal);
}

@override
String toString() {
    return 'SalesOrderItemModel(id: $id, productId: $productId, productSku: $productSku, productName: $productName, quantity: $quantity, unitPrice: $unitPrice, subtotal: $subtotal)';
}


}

/// @nodoc
abstract mixin class _$SalesOrderItemModelCopyWith<$Res> implements $SalesOrderItemModelCopyWith<$Res> {
  factory _$SalesOrderItemModelCopyWith(_SalesOrderItemModel value, $Res Function(_SalesOrderItemModel) _then) = __$SalesOrderItemModelCopyWithImpl;
@override @useResult
$Res call({
 int id, int productId, String productSku, String productName, int quantity, int unitPrice, int subtotal
});




}
/// @nodoc
class __$SalesOrderItemModelCopyWithImpl<$Res>
    implements _$SalesOrderItemModelCopyWith<$Res> {
  __$SalesOrderItemModelCopyWithImpl(this._self, this._then);

  final _SalesOrderItemModel _self;
  final $Res Function(_SalesOrderItemModel) _then;

/// Create a copy of SalesOrderItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productId = null,Object? productSku = null,Object? productName = null,Object? quantity = null,Object? unitPrice = null,Object? subtotal = null,}) {
  return _then(_SalesOrderItemModel(
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
mixin _$CreateSalesOrderRequest {

 int get customerId; List<CreateOrderItemRequest> get items; String get notes;
/// Create a copy of CreateSalesOrderRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateSalesOrderRequestCopyWith<CreateSalesOrderRequest> get copyWith => _$CreateSalesOrderRequestCopyWithImpl<CreateSalesOrderRequest>(this as CreateSalesOrderRequest, _$identity);

  /// Serializes this CreateSalesOrderRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CreateSalesOrderRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateSalesOrderRequest&&(identical(other.customerId, _this.customerId) || other.customerId == _this.customerId)&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.notes, _this.notes) || other.notes == _this.notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CreateSalesOrderRequest;
  return Object.hash(runtimeType,_this.customerId,const DeepCollectionEquality().hash(_this.items),_this.notes);
}

@override
String toString() {
  final _this = this as CreateSalesOrderRequest;
  return 'CreateSalesOrderRequest(customerId: ${_this.customerId}, items: ${_this.items}, notes: ${_this.notes})';
}


}

/// @nodoc
abstract mixin class $CreateSalesOrderRequestCopyWith<$Res>  {
  factory $CreateSalesOrderRequestCopyWith(CreateSalesOrderRequest value, $Res Function(CreateSalesOrderRequest) _then) = _$CreateSalesOrderRequestCopyWithImpl;
@useResult
$Res call({
 int customerId, List<CreateOrderItemRequest> items, String notes
});




}
/// @nodoc
class _$CreateSalesOrderRequestCopyWithImpl<$Res>
    implements $CreateSalesOrderRequestCopyWith<$Res> {
  _$CreateSalesOrderRequestCopyWithImpl(this._self, this._then);

  final CreateSalesOrderRequest _self;
  final $Res Function(CreateSalesOrderRequest) _then;

/// Create a copy of CreateSalesOrderRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? customerId = null,Object? items = null,Object? notes = null,}) {
  return _then(CreateSalesOrderRequest(
customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<CreateOrderItemRequest>,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateSalesOrderRequest].
extension CreateSalesOrderRequestPatterns on CreateSalesOrderRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateSalesOrderRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateSalesOrderRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateSalesOrderRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateSalesOrderRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateSalesOrderRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateSalesOrderRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int customerId,  List<CreateOrderItemRequest> items,  String notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateSalesOrderRequest() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int customerId,  List<CreateOrderItemRequest> items,  String notes)  $default,) {final _that = this;
switch (_that) {
case _CreateSalesOrderRequest():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int customerId,  List<CreateOrderItemRequest> items,  String notes)?  $default,) {final _that = this;
switch (_that) {
case _CreateSalesOrderRequest() when $default != null:
return $default(_that.customerId,_that.items,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateSalesOrderRequest implements CreateSalesOrderRequest {
  const _CreateSalesOrderRequest({required this.customerId, required  List<CreateOrderItemRequest> items, required this.notes}): _items = items;
  factory _CreateSalesOrderRequest.fromJson(Map<String, dynamic> json) => _$CreateSalesOrderRequestFromJson(json);

@override final  int customerId;
 final  List<CreateOrderItemRequest> _items;
@override List<CreateOrderItemRequest> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  String notes;

/// Create a copy of CreateSalesOrderRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateSalesOrderRequestCopyWith<_CreateSalesOrderRequest> get copyWith => __$CreateSalesOrderRequestCopyWithImpl<_CreateSalesOrderRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateSalesOrderRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateSalesOrderRequest&&(identical(other.customerId, customerId) || other.customerId == customerId)&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,customerId,const DeepCollectionEquality().hash(_items),notes);
}

@override
String toString() {
    return 'CreateSalesOrderRequest(customerId: $customerId, items: $items, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$CreateSalesOrderRequestCopyWith<$Res> implements $CreateSalesOrderRequestCopyWith<$Res> {
  factory _$CreateSalesOrderRequestCopyWith(_CreateSalesOrderRequest value, $Res Function(_CreateSalesOrderRequest) _then) = __$CreateSalesOrderRequestCopyWithImpl;
@override @useResult
$Res call({
 int customerId, List<CreateOrderItemRequest> items, String notes
});




}
/// @nodoc
class __$CreateSalesOrderRequestCopyWithImpl<$Res>
    implements _$CreateSalesOrderRequestCopyWith<$Res> {
  __$CreateSalesOrderRequestCopyWithImpl(this._self, this._then);

  final _CreateSalesOrderRequest _self;
  final $Res Function(_CreateSalesOrderRequest) _then;

/// Create a copy of CreateSalesOrderRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? customerId = null,Object? items = null,Object? notes = null,}) {
  return _then(_CreateSalesOrderRequest(
customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<CreateOrderItemRequest>,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CreateOrderItemRequest {

 int get productId; int get quantity;
/// Create a copy of CreateOrderItemRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateOrderItemRequestCopyWith<CreateOrderItemRequest> get copyWith => _$CreateOrderItemRequestCopyWithImpl<CreateOrderItemRequest>(this as CreateOrderItemRequest, _$identity);

  /// Serializes this CreateOrderItemRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CreateOrderItemRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateOrderItemRequest&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CreateOrderItemRequest;
  return Object.hash(runtimeType,_this.productId,_this.quantity);
}

@override
String toString() {
  final _this = this as CreateOrderItemRequest;
  return 'CreateOrderItemRequest(productId: ${_this.productId}, quantity: ${_this.quantity})';
}


}

/// @nodoc
abstract mixin class $CreateOrderItemRequestCopyWith<$Res>  {
  factory $CreateOrderItemRequestCopyWith(CreateOrderItemRequest value, $Res Function(CreateOrderItemRequest) _then) = _$CreateOrderItemRequestCopyWithImpl;
@useResult
$Res call({
 int productId, int quantity
});




}
/// @nodoc
class _$CreateOrderItemRequestCopyWithImpl<$Res>
    implements $CreateOrderItemRequestCopyWith<$Res> {
  _$CreateOrderItemRequestCopyWithImpl(this._self, this._then);

  final CreateOrderItemRequest _self;
  final $Res Function(CreateOrderItemRequest) _then;

/// Create a copy of CreateOrderItemRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? quantity = null,}) {
  return _then(CreateOrderItemRequest(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateOrderItemRequest].
extension CreateOrderItemRequestPatterns on CreateOrderItemRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateOrderItemRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateOrderItemRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateOrderItemRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateOrderItemRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateOrderItemRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateOrderItemRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int productId,  int quantity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateOrderItemRequest() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int productId,  int quantity)  $default,) {final _that = this;
switch (_that) {
case _CreateOrderItemRequest():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int productId,  int quantity)?  $default,) {final _that = this;
switch (_that) {
case _CreateOrderItemRequest() when $default != null:
return $default(_that.productId,_that.quantity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateOrderItemRequest implements CreateOrderItemRequest {
  const _CreateOrderItemRequest({required this.productId, required this.quantity});
  factory _CreateOrderItemRequest.fromJson(Map<String, dynamic> json) => _$CreateOrderItemRequestFromJson(json);

@override final  int productId;
@override final  int quantity;

/// Create a copy of CreateOrderItemRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateOrderItemRequestCopyWith<_CreateOrderItemRequest> get copyWith => __$CreateOrderItemRequestCopyWithImpl<_CreateOrderItemRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateOrderItemRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateOrderItemRequest&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,productId,quantity);
}

@override
String toString() {
    return 'CreateOrderItemRequest(productId: $productId, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class _$CreateOrderItemRequestCopyWith<$Res> implements $CreateOrderItemRequestCopyWith<$Res> {
  factory _$CreateOrderItemRequestCopyWith(_CreateOrderItemRequest value, $Res Function(_CreateOrderItemRequest) _then) = __$CreateOrderItemRequestCopyWithImpl;
@override @useResult
$Res call({
 int productId, int quantity
});




}
/// @nodoc
class __$CreateOrderItemRequestCopyWithImpl<$Res>
    implements _$CreateOrderItemRequestCopyWith<$Res> {
  __$CreateOrderItemRequestCopyWithImpl(this._self, this._then);

  final _CreateOrderItemRequest _self;
  final $Res Function(_CreateOrderItemRequest) _then;

/// Create a copy of CreateOrderItemRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? quantity = null,}) {
  return _then(_CreateOrderItemRequest(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$UpdateOrderStatusRequest {

 String get status;
/// Create a copy of UpdateOrderStatusRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateOrderStatusRequestCopyWith<UpdateOrderStatusRequest> get copyWith => _$UpdateOrderStatusRequestCopyWithImpl<UpdateOrderStatusRequest>(this as UpdateOrderStatusRequest, _$identity);

  /// Serializes this UpdateOrderStatusRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UpdateOrderStatusRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateOrderStatusRequest&&(identical(other.status, _this.status) || other.status == _this.status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UpdateOrderStatusRequest;
  return Object.hash(runtimeType,_this.status);
}

@override
String toString() {
  final _this = this as UpdateOrderStatusRequest;
  return 'UpdateOrderStatusRequest(status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $UpdateOrderStatusRequestCopyWith<$Res>  {
  factory $UpdateOrderStatusRequestCopyWith(UpdateOrderStatusRequest value, $Res Function(UpdateOrderStatusRequest) _then) = _$UpdateOrderStatusRequestCopyWithImpl;
@useResult
$Res call({
 String status
});




}
/// @nodoc
class _$UpdateOrderStatusRequestCopyWithImpl<$Res>
    implements $UpdateOrderStatusRequestCopyWith<$Res> {
  _$UpdateOrderStatusRequestCopyWithImpl(this._self, this._then);

  final UpdateOrderStatusRequest _self;
  final $Res Function(UpdateOrderStatusRequest) _then;

/// Create a copy of UpdateOrderStatusRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,}) {
  return _then(UpdateOrderStatusRequest(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateOrderStatusRequest].
extension UpdateOrderStatusRequestPatterns on UpdateOrderStatusRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateOrderStatusRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateOrderStatusRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateOrderStatusRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateOrderStatusRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateOrderStatusRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateOrderStatusRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateOrderStatusRequest() when $default != null:
return $default(_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String status)  $default,) {final _that = this;
switch (_that) {
case _UpdateOrderStatusRequest():
return $default(_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String status)?  $default,) {final _that = this;
switch (_that) {
case _UpdateOrderStatusRequest() when $default != null:
return $default(_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateOrderStatusRequest implements UpdateOrderStatusRequest {
  const _UpdateOrderStatusRequest({required this.status});
  factory _UpdateOrderStatusRequest.fromJson(Map<String, dynamic> json) => _$UpdateOrderStatusRequestFromJson(json);

@override final  String status;

/// Create a copy of UpdateOrderStatusRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateOrderStatusRequestCopyWith<_UpdateOrderStatusRequest> get copyWith => __$UpdateOrderStatusRequestCopyWithImpl<_UpdateOrderStatusRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateOrderStatusRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateOrderStatusRequest&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,status);
}

@override
String toString() {
    return 'UpdateOrderStatusRequest(status: $status)';
}


}

/// @nodoc
abstract mixin class _$UpdateOrderStatusRequestCopyWith<$Res> implements $UpdateOrderStatusRequestCopyWith<$Res> {
  factory _$UpdateOrderStatusRequestCopyWith(_UpdateOrderStatusRequest value, $Res Function(_UpdateOrderStatusRequest) _then) = __$UpdateOrderStatusRequestCopyWithImpl;
@override @useResult
$Res call({
 String status
});




}
/// @nodoc
class __$UpdateOrderStatusRequestCopyWithImpl<$Res>
    implements _$UpdateOrderStatusRequestCopyWith<$Res> {
  __$UpdateOrderStatusRequestCopyWithImpl(this._self, this._then);

  final _UpdateOrderStatusRequest _self;
  final $Res Function(_UpdateOrderStatusRequest) _then;

/// Create a copy of UpdateOrderStatusRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,}) {
  return _then(_UpdateOrderStatusRequest(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
