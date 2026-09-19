// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Inventory {

 int get productId; int get quantity; int get lowStockThreshold;/// `quantity <= lowStockThreshold`, computed by the backend.
 bool get isLowStock;
/// Create a copy of Inventory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryCopyWith<Inventory> get copyWith => _$InventoryCopyWithImpl<Inventory>(this as Inventory, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Inventory;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Inventory&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.lowStockThreshold, _this.lowStockThreshold) || other.lowStockThreshold == _this.lowStockThreshold)&&(identical(other.isLowStock, _this.isLowStock) || other.isLowStock == _this.isLowStock));
}


@override
int get hashCode {
  final _this = this as Inventory;
  return Object.hash(runtimeType,_this.productId,_this.quantity,_this.lowStockThreshold,_this.isLowStock);
}

@override
String toString() {
  final _this = this as Inventory;
  return 'Inventory(productId: ${_this.productId}, quantity: ${_this.quantity}, lowStockThreshold: ${_this.lowStockThreshold}, isLowStock: ${_this.isLowStock})';
}


}

/// @nodoc
abstract mixin class $InventoryCopyWith<$Res>  {
  factory $InventoryCopyWith(Inventory value, $Res Function(Inventory) _then) = _$InventoryCopyWithImpl;
@useResult
$Res call({
 int productId, int quantity, int lowStockThreshold, bool isLowStock
});




}
/// @nodoc
class _$InventoryCopyWithImpl<$Res>
    implements $InventoryCopyWith<$Res> {
  _$InventoryCopyWithImpl(this._self, this._then);

  final Inventory _self;
  final $Res Function(Inventory) _then;

/// Create a copy of Inventory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? quantity = null,Object? lowStockThreshold = null,Object? isLowStock = null,}) {
  return _then(Inventory(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,lowStockThreshold: null == lowStockThreshold ? _self.lowStockThreshold : lowStockThreshold // ignore: cast_nullable_to_non_nullable
as int,isLowStock: null == isLowStock ? _self.isLowStock : isLowStock // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Inventory].
extension InventoryPatterns on Inventory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Inventory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Inventory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Inventory value)  $default,){
final _that = this;
switch (_that) {
case _Inventory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Inventory value)?  $default,){
final _that = this;
switch (_that) {
case _Inventory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int productId,  int quantity,  int lowStockThreshold,  bool isLowStock)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Inventory() when $default != null:
return $default(_that.productId,_that.quantity,_that.lowStockThreshold,_that.isLowStock);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int productId,  int quantity,  int lowStockThreshold,  bool isLowStock)  $default,) {final _that = this;
switch (_that) {
case _Inventory():
return $default(_that.productId,_that.quantity,_that.lowStockThreshold,_that.isLowStock);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int productId,  int quantity,  int lowStockThreshold,  bool isLowStock)?  $default,) {final _that = this;
switch (_that) {
case _Inventory() when $default != null:
return $default(_that.productId,_that.quantity,_that.lowStockThreshold,_that.isLowStock);case _:
  return null;

}
}

}

/// @nodoc


class _Inventory implements Inventory {
  const _Inventory({required this.productId, required this.quantity, required this.lowStockThreshold, required this.isLowStock});
  

@override final  int productId;
@override final  int quantity;
@override final  int lowStockThreshold;
/// `quantity <= lowStockThreshold`, computed by the backend.
@override final  bool isLowStock;

/// Create a copy of Inventory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryCopyWith<_Inventory> get copyWith => __$InventoryCopyWithImpl<_Inventory>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Inventory&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.lowStockThreshold, lowStockThreshold) || other.lowStockThreshold == lowStockThreshold)&&(identical(other.isLowStock, isLowStock) || other.isLowStock == isLowStock));
}


@override
int get hashCode {
    return Object.hash(runtimeType,productId,quantity,lowStockThreshold,isLowStock);
}

@override
String toString() {
    return 'Inventory(productId: $productId, quantity: $quantity, lowStockThreshold: $lowStockThreshold, isLowStock: $isLowStock)';
}


}

/// @nodoc
abstract mixin class _$InventoryCopyWith<$Res> implements $InventoryCopyWith<$Res> {
  factory _$InventoryCopyWith(_Inventory value, $Res Function(_Inventory) _then) = __$InventoryCopyWithImpl;
@override @useResult
$Res call({
 int productId, int quantity, int lowStockThreshold, bool isLowStock
});




}
/// @nodoc
class __$InventoryCopyWithImpl<$Res>
    implements _$InventoryCopyWith<$Res> {
  __$InventoryCopyWithImpl(this._self, this._then);

  final _Inventory _self;
  final $Res Function(_Inventory) _then;

/// Create a copy of Inventory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? quantity = null,Object? lowStockThreshold = null,Object? isLowStock = null,}) {
  return _then(_Inventory(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,lowStockThreshold: null == lowStockThreshold ? _self.lowStockThreshold : lowStockThreshold // ignore: cast_nullable_to_non_nullable
as int,isLowStock: null == isLowStock ? _self.isLowStock : isLowStock // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$StockMovement {

 int get id; int get productId; MovementType get type;/// Amount moved (IN/OUT) or the new stock level (ADJUSTMENT).
 int get quantity; int get quantityBefore; int get quantityAfter; String get reason; DateTime get createdAt;
/// Create a copy of StockMovement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockMovementCopyWith<StockMovement> get copyWith => _$StockMovementCopyWithImpl<StockMovement>(this as StockMovement, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as StockMovement;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockMovement&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.quantityBefore, _this.quantityBefore) || other.quantityBefore == _this.quantityBefore)&&(identical(other.quantityAfter, _this.quantityAfter) || other.quantityAfter == _this.quantityAfter)&&(identical(other.reason, _this.reason) || other.reason == _this.reason)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}


@override
int get hashCode {
  final _this = this as StockMovement;
  return Object.hash(runtimeType,_this.id,_this.productId,_this.type,_this.quantity,_this.quantityBefore,_this.quantityAfter,_this.reason,_this.createdAt);
}

@override
String toString() {
  final _this = this as StockMovement;
  return 'StockMovement(id: ${_this.id}, productId: ${_this.productId}, type: ${_this.type}, quantity: ${_this.quantity}, quantityBefore: ${_this.quantityBefore}, quantityAfter: ${_this.quantityAfter}, reason: ${_this.reason}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $StockMovementCopyWith<$Res>  {
  factory $StockMovementCopyWith(StockMovement value, $Res Function(StockMovement) _then) = _$StockMovementCopyWithImpl;
@useResult
$Res call({
 int id, int productId, MovementType type, int quantity, int quantityBefore, int quantityAfter, String reason, DateTime createdAt
});




}
/// @nodoc
class _$StockMovementCopyWithImpl<$Res>
    implements $StockMovementCopyWith<$Res> {
  _$StockMovementCopyWithImpl(this._self, this._then);

  final StockMovement _self;
  final $Res Function(StockMovement) _then;

/// Create a copy of StockMovement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productId = null,Object? type = null,Object? quantity = null,Object? quantityBefore = null,Object? quantityAfter = null,Object? reason = null,Object? createdAt = null,}) {
  return _then(StockMovement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MovementType,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,quantityBefore: null == quantityBefore ? _self.quantityBefore : quantityBefore // ignore: cast_nullable_to_non_nullable
as int,quantityAfter: null == quantityAfter ? _self.quantityAfter : quantityAfter // ignore: cast_nullable_to_non_nullable
as int,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [StockMovement].
extension StockMovementPatterns on StockMovement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockMovement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockMovement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockMovement value)  $default,){
final _that = this;
switch (_that) {
case _StockMovement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockMovement value)?  $default,){
final _that = this;
switch (_that) {
case _StockMovement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int productId,  MovementType type,  int quantity,  int quantityBefore,  int quantityAfter,  String reason,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockMovement() when $default != null:
return $default(_that.id,_that.productId,_that.type,_that.quantity,_that.quantityBefore,_that.quantityAfter,_that.reason,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int productId,  MovementType type,  int quantity,  int quantityBefore,  int quantityAfter,  String reason,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _StockMovement():
return $default(_that.id,_that.productId,_that.type,_that.quantity,_that.quantityBefore,_that.quantityAfter,_that.reason,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int productId,  MovementType type,  int quantity,  int quantityBefore,  int quantityAfter,  String reason,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _StockMovement() when $default != null:
return $default(_that.id,_that.productId,_that.type,_that.quantity,_that.quantityBefore,_that.quantityAfter,_that.reason,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _StockMovement implements StockMovement {
  const _StockMovement({required this.id, required this.productId, required this.type, required this.quantity, required this.quantityBefore, required this.quantityAfter, required this.reason, required this.createdAt});
  

@override final  int id;
@override final  int productId;
@override final  MovementType type;
/// Amount moved (IN/OUT) or the new stock level (ADJUSTMENT).
@override final  int quantity;
@override final  int quantityBefore;
@override final  int quantityAfter;
@override final  String reason;
@override final  DateTime createdAt;

/// Create a copy of StockMovement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockMovementCopyWith<_StockMovement> get copyWith => __$StockMovementCopyWithImpl<_StockMovement>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockMovement&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.type, type) || other.type == type)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.quantityBefore, quantityBefore) || other.quantityBefore == quantityBefore)&&(identical(other.quantityAfter, quantityAfter) || other.quantityAfter == quantityAfter)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,productId,type,quantity,quantityBefore,quantityAfter,reason,createdAt);
}

@override
String toString() {
    return 'StockMovement(id: $id, productId: $productId, type: $type, quantity: $quantity, quantityBefore: $quantityBefore, quantityAfter: $quantityAfter, reason: $reason, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$StockMovementCopyWith<$Res> implements $StockMovementCopyWith<$Res> {
  factory _$StockMovementCopyWith(_StockMovement value, $Res Function(_StockMovement) _then) = __$StockMovementCopyWithImpl;
@override @useResult
$Res call({
 int id, int productId, MovementType type, int quantity, int quantityBefore, int quantityAfter, String reason, DateTime createdAt
});




}
/// @nodoc
class __$StockMovementCopyWithImpl<$Res>
    implements _$StockMovementCopyWith<$Res> {
  __$StockMovementCopyWithImpl(this._self, this._then);

  final _StockMovement _self;
  final $Res Function(_StockMovement) _then;

/// Create a copy of StockMovement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productId = null,Object? type = null,Object? quantity = null,Object? quantityBefore = null,Object? quantityAfter = null,Object? reason = null,Object? createdAt = null,}) {
  return _then(_StockMovement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MovementType,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,quantityBefore: null == quantityBefore ? _self.quantityBefore : quantityBefore // ignore: cast_nullable_to_non_nullable
as int,quantityAfter: null == quantityAfter ? _self.quantityAfter : quantityAfter // ignore: cast_nullable_to_non_nullable
as int,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$MovementResult {

 StockMovement get movement; Inventory get inventory;
/// Create a copy of MovementResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovementResultCopyWith<MovementResult> get copyWith => _$MovementResultCopyWithImpl<MovementResult>(this as MovementResult, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MovementResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MovementResult&&(identical(other.movement, _this.movement) || other.movement == _this.movement)&&(identical(other.inventory, _this.inventory) || other.inventory == _this.inventory));
}


@override
int get hashCode {
  final _this = this as MovementResult;
  return Object.hash(runtimeType,_this.movement,_this.inventory);
}

@override
String toString() {
  final _this = this as MovementResult;
  return 'MovementResult(movement: ${_this.movement}, inventory: ${_this.inventory})';
}


}

/// @nodoc
abstract mixin class $MovementResultCopyWith<$Res>  {
  factory $MovementResultCopyWith(MovementResult value, $Res Function(MovementResult) _then) = _$MovementResultCopyWithImpl;
@useResult
$Res call({
 StockMovement movement, Inventory inventory
});


$StockMovementCopyWith<$Res> get movement;$InventoryCopyWith<$Res> get inventory;

}
/// @nodoc
class _$MovementResultCopyWithImpl<$Res>
    implements $MovementResultCopyWith<$Res> {
  _$MovementResultCopyWithImpl(this._self, this._then);

  final MovementResult _self;
  final $Res Function(MovementResult) _then;

/// Create a copy of MovementResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? movement = null,Object? inventory = null,}) {
  return _then(MovementResult(
movement: null == movement ? _self.movement : movement // ignore: cast_nullable_to_non_nullable
as StockMovement,inventory: null == inventory ? _self.inventory : inventory // ignore: cast_nullable_to_non_nullable
as Inventory,
  ));
}
/// Create a copy of MovementResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StockMovementCopyWith<$Res> get movement {
  
  return $StockMovementCopyWith<$Res>(_self.movement, (value) {
    return _then(_self.copyWith(movement: value));
  });
}/// Create a copy of MovementResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InventoryCopyWith<$Res> get inventory {
  
  return $InventoryCopyWith<$Res>(_self.inventory, (value) {
    return _then(_self.copyWith(inventory: value));
  });
}
}


/// Adds pattern-matching-related methods to [MovementResult].
extension MovementResultPatterns on MovementResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MovementResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MovementResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MovementResult value)  $default,){
final _that = this;
switch (_that) {
case _MovementResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MovementResult value)?  $default,){
final _that = this;
switch (_that) {
case _MovementResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StockMovement movement,  Inventory inventory)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MovementResult() when $default != null:
return $default(_that.movement,_that.inventory);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StockMovement movement,  Inventory inventory)  $default,) {final _that = this;
switch (_that) {
case _MovementResult():
return $default(_that.movement,_that.inventory);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StockMovement movement,  Inventory inventory)?  $default,) {final _that = this;
switch (_that) {
case _MovementResult() when $default != null:
return $default(_that.movement,_that.inventory);case _:
  return null;

}
}

}

/// @nodoc


class _MovementResult implements MovementResult {
  const _MovementResult({required this.movement, required this.inventory});
  

@override final  StockMovement movement;
@override final  Inventory inventory;

/// Create a copy of MovementResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MovementResultCopyWith<_MovementResult> get copyWith => __$MovementResultCopyWithImpl<_MovementResult>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MovementResult&&(identical(other.movement, movement) || other.movement == movement)&&(identical(other.inventory, inventory) || other.inventory == inventory));
}


@override
int get hashCode {
    return Object.hash(runtimeType,movement,inventory);
}

@override
String toString() {
    return 'MovementResult(movement: $movement, inventory: $inventory)';
}


}

/// @nodoc
abstract mixin class _$MovementResultCopyWith<$Res> implements $MovementResultCopyWith<$Res> {
  factory _$MovementResultCopyWith(_MovementResult value, $Res Function(_MovementResult) _then) = __$MovementResultCopyWithImpl;
@override @useResult
$Res call({
 StockMovement movement, Inventory inventory
});


@override $StockMovementCopyWith<$Res> get movement;@override $InventoryCopyWith<$Res> get inventory;

}
/// @nodoc
class __$MovementResultCopyWithImpl<$Res>
    implements _$MovementResultCopyWith<$Res> {
  __$MovementResultCopyWithImpl(this._self, this._then);

  final _MovementResult _self;
  final $Res Function(_MovementResult) _then;

/// Create a copy of MovementResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? movement = null,Object? inventory = null,}) {
  return _then(_MovementResult(
movement: null == movement ? _self.movement : movement // ignore: cast_nullable_to_non_nullable
as StockMovement,inventory: null == inventory ? _self.inventory : inventory // ignore: cast_nullable_to_non_nullable
as Inventory,
  ));
}

/// Create a copy of MovementResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StockMovementCopyWith<$Res> get movement {
  
  return $StockMovementCopyWith<$Res>(_self.movement, (value) {
    return _then(_self.copyWith(movement: value));
  });
}/// Create a copy of MovementResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InventoryCopyWith<$Res> get inventory {
  
  return $InventoryCopyWith<$Res>(_self.inventory, (value) {
    return _then(_self.copyWith(inventory: value));
  });
}
}

/// @nodoc
mixin _$MovementInput {

 MovementType get type; int? get quantity; String get reason;
/// Create a copy of MovementInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovementInputCopyWith<MovementInput> get copyWith => _$MovementInputCopyWithImpl<MovementInput>(this as MovementInput, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MovementInput;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MovementInput&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.reason, _this.reason) || other.reason == _this.reason));
}


@override
int get hashCode {
  final _this = this as MovementInput;
  return Object.hash(runtimeType,_this.type,_this.quantity,_this.reason);
}

@override
String toString() {
  final _this = this as MovementInput;
  return 'MovementInput(type: ${_this.type}, quantity: ${_this.quantity}, reason: ${_this.reason})';
}


}

/// @nodoc
abstract mixin class $MovementInputCopyWith<$Res>  {
  factory $MovementInputCopyWith(MovementInput value, $Res Function(MovementInput) _then) = _$MovementInputCopyWithImpl;
@useResult
$Res call({
 MovementType type, int? quantity, String reason
});




}
/// @nodoc
class _$MovementInputCopyWithImpl<$Res>
    implements $MovementInputCopyWith<$Res> {
  _$MovementInputCopyWithImpl(this._self, this._then);

  final MovementInput _self;
  final $Res Function(MovementInput) _then;

/// Create a copy of MovementInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? quantity = freezed,Object? reason = null,}) {
  return _then(MovementInput(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MovementType,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int?,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MovementInput].
extension MovementInputPatterns on MovementInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MovementInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MovementInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MovementInput value)  $default,){
final _that = this;
switch (_that) {
case _MovementInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MovementInput value)?  $default,){
final _that = this;
switch (_that) {
case _MovementInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MovementType type,  int? quantity,  String reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MovementInput() when $default != null:
return $default(_that.type,_that.quantity,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MovementType type,  int? quantity,  String reason)  $default,) {final _that = this;
switch (_that) {
case _MovementInput():
return $default(_that.type,_that.quantity,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MovementType type,  int? quantity,  String reason)?  $default,) {final _that = this;
switch (_that) {
case _MovementInput() when $default != null:
return $default(_that.type,_that.quantity,_that.reason);case _:
  return null;

}
}

}

/// @nodoc


class _MovementInput extends MovementInput {
  const _MovementInput({required this.type, required this.quantity, this.reason = ''}): super._();
  

@override final  MovementType type;
@override final  int? quantity;
@override@JsonKey() final  String reason;

/// Create a copy of MovementInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MovementInputCopyWith<_MovementInput> get copyWith => __$MovementInputCopyWithImpl<_MovementInput>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MovementInput&&(identical(other.type, type) || other.type == type)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode {
    return Object.hash(runtimeType,type,quantity,reason);
}

@override
String toString() {
    return 'MovementInput(type: $type, quantity: $quantity, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$MovementInputCopyWith<$Res> implements $MovementInputCopyWith<$Res> {
  factory _$MovementInputCopyWith(_MovementInput value, $Res Function(_MovementInput) _then) = __$MovementInputCopyWithImpl;
@override @useResult
$Res call({
 MovementType type, int? quantity, String reason
});




}
/// @nodoc
class __$MovementInputCopyWithImpl<$Res>
    implements _$MovementInputCopyWith<$Res> {
  __$MovementInputCopyWithImpl(this._self, this._then);

  final _MovementInput _self;
  final $Res Function(_MovementInput) _then;

/// Create a copy of MovementInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? quantity = freezed,Object? reason = null,}) {
  return _then(_MovementInput(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MovementType,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int?,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$LowStockItem {

 int get productId; String get sku; String get name; int get quantity; int get lowStockThreshold;
/// Create a copy of LowStockItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LowStockItemCopyWith<LowStockItem> get copyWith => _$LowStockItemCopyWithImpl<LowStockItem>(this as LowStockItem, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LowStockItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LowStockItem&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.sku, _this.sku) || other.sku == _this.sku)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.lowStockThreshold, _this.lowStockThreshold) || other.lowStockThreshold == _this.lowStockThreshold));
}


@override
int get hashCode {
  final _this = this as LowStockItem;
  return Object.hash(runtimeType,_this.productId,_this.sku,_this.name,_this.quantity,_this.lowStockThreshold);
}

@override
String toString() {
  final _this = this as LowStockItem;
  return 'LowStockItem(productId: ${_this.productId}, sku: ${_this.sku}, name: ${_this.name}, quantity: ${_this.quantity}, lowStockThreshold: ${_this.lowStockThreshold})';
}


}

/// @nodoc
abstract mixin class $LowStockItemCopyWith<$Res>  {
  factory $LowStockItemCopyWith(LowStockItem value, $Res Function(LowStockItem) _then) = _$LowStockItemCopyWithImpl;
@useResult
$Res call({
 int productId, String sku, String name, int quantity, int lowStockThreshold
});




}
/// @nodoc
class _$LowStockItemCopyWithImpl<$Res>
    implements $LowStockItemCopyWith<$Res> {
  _$LowStockItemCopyWithImpl(this._self, this._then);

  final LowStockItem _self;
  final $Res Function(LowStockItem) _then;

/// Create a copy of LowStockItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? sku = null,Object? name = null,Object? quantity = null,Object? lowStockThreshold = null,}) {
  return _then(LowStockItem(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,lowStockThreshold: null == lowStockThreshold ? _self.lowStockThreshold : lowStockThreshold // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LowStockItem].
extension LowStockItemPatterns on LowStockItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LowStockItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LowStockItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LowStockItem value)  $default,){
final _that = this;
switch (_that) {
case _LowStockItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LowStockItem value)?  $default,){
final _that = this;
switch (_that) {
case _LowStockItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int productId,  String sku,  String name,  int quantity,  int lowStockThreshold)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LowStockItem() when $default != null:
return $default(_that.productId,_that.sku,_that.name,_that.quantity,_that.lowStockThreshold);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int productId,  String sku,  String name,  int quantity,  int lowStockThreshold)  $default,) {final _that = this;
switch (_that) {
case _LowStockItem():
return $default(_that.productId,_that.sku,_that.name,_that.quantity,_that.lowStockThreshold);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int productId,  String sku,  String name,  int quantity,  int lowStockThreshold)?  $default,) {final _that = this;
switch (_that) {
case _LowStockItem() when $default != null:
return $default(_that.productId,_that.sku,_that.name,_that.quantity,_that.lowStockThreshold);case _:
  return null;

}
}

}

/// @nodoc


class _LowStockItem implements LowStockItem {
  const _LowStockItem({required this.productId, required this.sku, required this.name, required this.quantity, required this.lowStockThreshold});
  

@override final  int productId;
@override final  String sku;
@override final  String name;
@override final  int quantity;
@override final  int lowStockThreshold;

/// Create a copy of LowStockItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LowStockItemCopyWith<_LowStockItem> get copyWith => __$LowStockItemCopyWithImpl<_LowStockItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LowStockItem&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.name, name) || other.name == name)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.lowStockThreshold, lowStockThreshold) || other.lowStockThreshold == lowStockThreshold));
}


@override
int get hashCode {
    return Object.hash(runtimeType,productId,sku,name,quantity,lowStockThreshold);
}

@override
String toString() {
    return 'LowStockItem(productId: $productId, sku: $sku, name: $name, quantity: $quantity, lowStockThreshold: $lowStockThreshold)';
}


}

/// @nodoc
abstract mixin class _$LowStockItemCopyWith<$Res> implements $LowStockItemCopyWith<$Res> {
  factory _$LowStockItemCopyWith(_LowStockItem value, $Res Function(_LowStockItem) _then) = __$LowStockItemCopyWithImpl;
@override @useResult
$Res call({
 int productId, String sku, String name, int quantity, int lowStockThreshold
});




}
/// @nodoc
class __$LowStockItemCopyWithImpl<$Res>
    implements _$LowStockItemCopyWith<$Res> {
  __$LowStockItemCopyWithImpl(this._self, this._then);

  final _LowStockItem _self;
  final $Res Function(_LowStockItem) _then;

/// Create a copy of LowStockItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? sku = null,Object? name = null,Object? quantity = null,Object? lowStockThreshold = null,}) {
  return _then(_LowStockItem(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,lowStockThreshold: null == lowStockThreshold ? _self.lowStockThreshold : lowStockThreshold // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
