// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InventoryModel {

 int get productId; int get quantity; int get lowStockThreshold; bool get isLowStock;
/// Create a copy of InventoryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryModelCopyWith<InventoryModel> get copyWith => _$InventoryModelCopyWithImpl<InventoryModel>(this as InventoryModel, _$identity);

  /// Serializes this InventoryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as InventoryModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryModel&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.lowStockThreshold, _this.lowStockThreshold) || other.lowStockThreshold == _this.lowStockThreshold)&&(identical(other.isLowStock, _this.isLowStock) || other.isLowStock == _this.isLowStock));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as InventoryModel;
  return Object.hash(runtimeType,_this.productId,_this.quantity,_this.lowStockThreshold,_this.isLowStock);
}

@override
String toString() {
  final _this = this as InventoryModel;
  return 'InventoryModel(productId: ${_this.productId}, quantity: ${_this.quantity}, lowStockThreshold: ${_this.lowStockThreshold}, isLowStock: ${_this.isLowStock})';
}


}

/// @nodoc
abstract mixin class $InventoryModelCopyWith<$Res>  {
  factory $InventoryModelCopyWith(InventoryModel value, $Res Function(InventoryModel) _then) = _$InventoryModelCopyWithImpl;
@useResult
$Res call({
 int productId, int quantity, int lowStockThreshold, bool isLowStock
});




}
/// @nodoc
class _$InventoryModelCopyWithImpl<$Res>
    implements $InventoryModelCopyWith<$Res> {
  _$InventoryModelCopyWithImpl(this._self, this._then);

  final InventoryModel _self;
  final $Res Function(InventoryModel) _then;

/// Create a copy of InventoryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? quantity = null,Object? lowStockThreshold = null,Object? isLowStock = null,}) {
  return _then(InventoryModel(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,lowStockThreshold: null == lowStockThreshold ? _self.lowStockThreshold : lowStockThreshold // ignore: cast_nullable_to_non_nullable
as int,isLowStock: null == isLowStock ? _self.isLowStock : isLowStock // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [InventoryModel].
extension InventoryModelPatterns on InventoryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventoryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventoryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventoryModel value)  $default,){
final _that = this;
switch (_that) {
case _InventoryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventoryModel value)?  $default,){
final _that = this;
switch (_that) {
case _InventoryModel() when $default != null:
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
case _InventoryModel() when $default != null:
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
case _InventoryModel():
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
case _InventoryModel() when $default != null:
return $default(_that.productId,_that.quantity,_that.lowStockThreshold,_that.isLowStock);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InventoryModel extends InventoryModel {
  const _InventoryModel({required this.productId, required this.quantity, required this.lowStockThreshold, required this.isLowStock}): super._();
  factory _InventoryModel.fromJson(Map<String, dynamic> json) => _$InventoryModelFromJson(json);

@override final  int productId;
@override final  int quantity;
@override final  int lowStockThreshold;
@override final  bool isLowStock;

/// Create a copy of InventoryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryModelCopyWith<_InventoryModel> get copyWith => __$InventoryModelCopyWithImpl<_InventoryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InventoryModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventoryModel&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.lowStockThreshold, lowStockThreshold) || other.lowStockThreshold == lowStockThreshold)&&(identical(other.isLowStock, isLowStock) || other.isLowStock == isLowStock));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,productId,quantity,lowStockThreshold,isLowStock);
}

@override
String toString() {
    return 'InventoryModel(productId: $productId, quantity: $quantity, lowStockThreshold: $lowStockThreshold, isLowStock: $isLowStock)';
}


}

/// @nodoc
abstract mixin class _$InventoryModelCopyWith<$Res> implements $InventoryModelCopyWith<$Res> {
  factory _$InventoryModelCopyWith(_InventoryModel value, $Res Function(_InventoryModel) _then) = __$InventoryModelCopyWithImpl;
@override @useResult
$Res call({
 int productId, int quantity, int lowStockThreshold, bool isLowStock
});




}
/// @nodoc
class __$InventoryModelCopyWithImpl<$Res>
    implements _$InventoryModelCopyWith<$Res> {
  __$InventoryModelCopyWithImpl(this._self, this._then);

  final _InventoryModel _self;
  final $Res Function(_InventoryModel) _then;

/// Create a copy of InventoryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? quantity = null,Object? lowStockThreshold = null,Object? isLowStock = null,}) {
  return _then(_InventoryModel(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,lowStockThreshold: null == lowStockThreshold ? _self.lowStockThreshold : lowStockThreshold // ignore: cast_nullable_to_non_nullable
as int,isLowStock: null == isLowStock ? _self.isLowStock : isLowStock // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$StockMovementModel {

 int get id; int get productId; String get type; int get quantity; int get quantityBefore; int get quantityAfter; String get reason; DateTime get createdAt;
/// Create a copy of StockMovementModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockMovementModelCopyWith<StockMovementModel> get copyWith => _$StockMovementModelCopyWithImpl<StockMovementModel>(this as StockMovementModel, _$identity);

  /// Serializes this StockMovementModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StockMovementModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockMovementModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.quantityBefore, _this.quantityBefore) || other.quantityBefore == _this.quantityBefore)&&(identical(other.quantityAfter, _this.quantityAfter) || other.quantityAfter == _this.quantityAfter)&&(identical(other.reason, _this.reason) || other.reason == _this.reason)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StockMovementModel;
  return Object.hash(runtimeType,_this.id,_this.productId,_this.type,_this.quantity,_this.quantityBefore,_this.quantityAfter,_this.reason,_this.createdAt);
}

@override
String toString() {
  final _this = this as StockMovementModel;
  return 'StockMovementModel(id: ${_this.id}, productId: ${_this.productId}, type: ${_this.type}, quantity: ${_this.quantity}, quantityBefore: ${_this.quantityBefore}, quantityAfter: ${_this.quantityAfter}, reason: ${_this.reason}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $StockMovementModelCopyWith<$Res>  {
  factory $StockMovementModelCopyWith(StockMovementModel value, $Res Function(StockMovementModel) _then) = _$StockMovementModelCopyWithImpl;
@useResult
$Res call({
 int id, int productId, String type, int quantity, int quantityBefore, int quantityAfter, String reason, DateTime createdAt
});




}
/// @nodoc
class _$StockMovementModelCopyWithImpl<$Res>
    implements $StockMovementModelCopyWith<$Res> {
  _$StockMovementModelCopyWithImpl(this._self, this._then);

  final StockMovementModel _self;
  final $Res Function(StockMovementModel) _then;

/// Create a copy of StockMovementModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productId = null,Object? type = null,Object? quantity = null,Object? quantityBefore = null,Object? quantityAfter = null,Object? reason = null,Object? createdAt = null,}) {
  return _then(StockMovementModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,quantityBefore: null == quantityBefore ? _self.quantityBefore : quantityBefore // ignore: cast_nullable_to_non_nullable
as int,quantityAfter: null == quantityAfter ? _self.quantityAfter : quantityAfter // ignore: cast_nullable_to_non_nullable
as int,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [StockMovementModel].
extension StockMovementModelPatterns on StockMovementModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockMovementModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockMovementModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockMovementModel value)  $default,){
final _that = this;
switch (_that) {
case _StockMovementModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockMovementModel value)?  $default,){
final _that = this;
switch (_that) {
case _StockMovementModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int productId,  String type,  int quantity,  int quantityBefore,  int quantityAfter,  String reason,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockMovementModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int productId,  String type,  int quantity,  int quantityBefore,  int quantityAfter,  String reason,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _StockMovementModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int productId,  String type,  int quantity,  int quantityBefore,  int quantityAfter,  String reason,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _StockMovementModel() when $default != null:
return $default(_that.id,_that.productId,_that.type,_that.quantity,_that.quantityBefore,_that.quantityAfter,_that.reason,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StockMovementModel extends StockMovementModel {
  const _StockMovementModel({required this.id, required this.productId, required this.type, required this.quantity, required this.quantityBefore, required this.quantityAfter, this.reason = '', required this.createdAt}): super._();
  factory _StockMovementModel.fromJson(Map<String, dynamic> json) => _$StockMovementModelFromJson(json);

@override final  int id;
@override final  int productId;
@override final  String type;
@override final  int quantity;
@override final  int quantityBefore;
@override final  int quantityAfter;
@override@JsonKey() final  String reason;
@override final  DateTime createdAt;

/// Create a copy of StockMovementModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockMovementModelCopyWith<_StockMovementModel> get copyWith => __$StockMovementModelCopyWithImpl<_StockMovementModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StockMovementModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockMovementModel&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.type, type) || other.type == type)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.quantityBefore, quantityBefore) || other.quantityBefore == quantityBefore)&&(identical(other.quantityAfter, quantityAfter) || other.quantityAfter == quantityAfter)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,productId,type,quantity,quantityBefore,quantityAfter,reason,createdAt);
}

@override
String toString() {
    return 'StockMovementModel(id: $id, productId: $productId, type: $type, quantity: $quantity, quantityBefore: $quantityBefore, quantityAfter: $quantityAfter, reason: $reason, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$StockMovementModelCopyWith<$Res> implements $StockMovementModelCopyWith<$Res> {
  factory _$StockMovementModelCopyWith(_StockMovementModel value, $Res Function(_StockMovementModel) _then) = __$StockMovementModelCopyWithImpl;
@override @useResult
$Res call({
 int id, int productId, String type, int quantity, int quantityBefore, int quantityAfter, String reason, DateTime createdAt
});




}
/// @nodoc
class __$StockMovementModelCopyWithImpl<$Res>
    implements _$StockMovementModelCopyWith<$Res> {
  __$StockMovementModelCopyWithImpl(this._self, this._then);

  final _StockMovementModel _self;
  final $Res Function(_StockMovementModel) _then;

/// Create a copy of StockMovementModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productId = null,Object? type = null,Object? quantity = null,Object? quantityBefore = null,Object? quantityAfter = null,Object? reason = null,Object? createdAt = null,}) {
  return _then(_StockMovementModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,quantityBefore: null == quantityBefore ? _self.quantityBefore : quantityBefore // ignore: cast_nullable_to_non_nullable
as int,quantityAfter: null == quantityAfter ? _self.quantityAfter : quantityAfter // ignore: cast_nullable_to_non_nullable
as int,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$MovementResultModel {

 StockMovementModel get movement; InventoryModel get inventory;
/// Create a copy of MovementResultModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovementResultModelCopyWith<MovementResultModel> get copyWith => _$MovementResultModelCopyWithImpl<MovementResultModel>(this as MovementResultModel, _$identity);

  /// Serializes this MovementResultModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MovementResultModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MovementResultModel&&(identical(other.movement, _this.movement) || other.movement == _this.movement)&&(identical(other.inventory, _this.inventory) || other.inventory == _this.inventory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MovementResultModel;
  return Object.hash(runtimeType,_this.movement,_this.inventory);
}

@override
String toString() {
  final _this = this as MovementResultModel;
  return 'MovementResultModel(movement: ${_this.movement}, inventory: ${_this.inventory})';
}


}

/// @nodoc
abstract mixin class $MovementResultModelCopyWith<$Res>  {
  factory $MovementResultModelCopyWith(MovementResultModel value, $Res Function(MovementResultModel) _then) = _$MovementResultModelCopyWithImpl;
@useResult
$Res call({
 StockMovementModel movement, InventoryModel inventory
});


$StockMovementModelCopyWith<$Res> get movement;$InventoryModelCopyWith<$Res> get inventory;

}
/// @nodoc
class _$MovementResultModelCopyWithImpl<$Res>
    implements $MovementResultModelCopyWith<$Res> {
  _$MovementResultModelCopyWithImpl(this._self, this._then);

  final MovementResultModel _self;
  final $Res Function(MovementResultModel) _then;

/// Create a copy of MovementResultModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? movement = null,Object? inventory = null,}) {
  return _then(MovementResultModel(
movement: null == movement ? _self.movement : movement // ignore: cast_nullable_to_non_nullable
as StockMovementModel,inventory: null == inventory ? _self.inventory : inventory // ignore: cast_nullable_to_non_nullable
as InventoryModel,
  ));
}
/// Create a copy of MovementResultModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StockMovementModelCopyWith<$Res> get movement {
  
  return $StockMovementModelCopyWith<$Res>(_self.movement, (value) {
    return _then(_self.copyWith(movement: value));
  });
}/// Create a copy of MovementResultModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InventoryModelCopyWith<$Res> get inventory {
  
  return $InventoryModelCopyWith<$Res>(_self.inventory, (value) {
    return _then(_self.copyWith(inventory: value));
  });
}
}


/// Adds pattern-matching-related methods to [MovementResultModel].
extension MovementResultModelPatterns on MovementResultModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MovementResultModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MovementResultModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MovementResultModel value)  $default,){
final _that = this;
switch (_that) {
case _MovementResultModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MovementResultModel value)?  $default,){
final _that = this;
switch (_that) {
case _MovementResultModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StockMovementModel movement,  InventoryModel inventory)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MovementResultModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StockMovementModel movement,  InventoryModel inventory)  $default,) {final _that = this;
switch (_that) {
case _MovementResultModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StockMovementModel movement,  InventoryModel inventory)?  $default,) {final _that = this;
switch (_that) {
case _MovementResultModel() when $default != null:
return $default(_that.movement,_that.inventory);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MovementResultModel extends MovementResultModel {
  const _MovementResultModel({required this.movement, required this.inventory}): super._();
  factory _MovementResultModel.fromJson(Map<String, dynamic> json) => _$MovementResultModelFromJson(json);

@override final  StockMovementModel movement;
@override final  InventoryModel inventory;

/// Create a copy of MovementResultModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MovementResultModelCopyWith<_MovementResultModel> get copyWith => __$MovementResultModelCopyWithImpl<_MovementResultModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MovementResultModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MovementResultModel&&(identical(other.movement, movement) || other.movement == movement)&&(identical(other.inventory, inventory) || other.inventory == inventory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,movement,inventory);
}

@override
String toString() {
    return 'MovementResultModel(movement: $movement, inventory: $inventory)';
}


}

/// @nodoc
abstract mixin class _$MovementResultModelCopyWith<$Res> implements $MovementResultModelCopyWith<$Res> {
  factory _$MovementResultModelCopyWith(_MovementResultModel value, $Res Function(_MovementResultModel) _then) = __$MovementResultModelCopyWithImpl;
@override @useResult
$Res call({
 StockMovementModel movement, InventoryModel inventory
});


@override $StockMovementModelCopyWith<$Res> get movement;@override $InventoryModelCopyWith<$Res> get inventory;

}
/// @nodoc
class __$MovementResultModelCopyWithImpl<$Res>
    implements _$MovementResultModelCopyWith<$Res> {
  __$MovementResultModelCopyWithImpl(this._self, this._then);

  final _MovementResultModel _self;
  final $Res Function(_MovementResultModel) _then;

/// Create a copy of MovementResultModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? movement = null,Object? inventory = null,}) {
  return _then(_MovementResultModel(
movement: null == movement ? _self.movement : movement // ignore: cast_nullable_to_non_nullable
as StockMovementModel,inventory: null == inventory ? _self.inventory : inventory // ignore: cast_nullable_to_non_nullable
as InventoryModel,
  ));
}

/// Create a copy of MovementResultModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StockMovementModelCopyWith<$Res> get movement {
  
  return $StockMovementModelCopyWith<$Res>(_self.movement, (value) {
    return _then(_self.copyWith(movement: value));
  });
}/// Create a copy of MovementResultModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InventoryModelCopyWith<$Res> get inventory {
  
  return $InventoryModelCopyWith<$Res>(_self.inventory, (value) {
    return _then(_self.copyWith(inventory: value));
  });
}
}


/// @nodoc
mixin _$LowStockItemModel {

 int get productId; String get sku; String get name; int get quantity; int get lowStockThreshold;
/// Create a copy of LowStockItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LowStockItemModelCopyWith<LowStockItemModel> get copyWith => _$LowStockItemModelCopyWithImpl<LowStockItemModel>(this as LowStockItemModel, _$identity);

  /// Serializes this LowStockItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LowStockItemModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LowStockItemModel&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.sku, _this.sku) || other.sku == _this.sku)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.lowStockThreshold, _this.lowStockThreshold) || other.lowStockThreshold == _this.lowStockThreshold));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LowStockItemModel;
  return Object.hash(runtimeType,_this.productId,_this.sku,_this.name,_this.quantity,_this.lowStockThreshold);
}

@override
String toString() {
  final _this = this as LowStockItemModel;
  return 'LowStockItemModel(productId: ${_this.productId}, sku: ${_this.sku}, name: ${_this.name}, quantity: ${_this.quantity}, lowStockThreshold: ${_this.lowStockThreshold})';
}


}

/// @nodoc
abstract mixin class $LowStockItemModelCopyWith<$Res>  {
  factory $LowStockItemModelCopyWith(LowStockItemModel value, $Res Function(LowStockItemModel) _then) = _$LowStockItemModelCopyWithImpl;
@useResult
$Res call({
 int productId, String sku, String name, int quantity, int lowStockThreshold
});




}
/// @nodoc
class _$LowStockItemModelCopyWithImpl<$Res>
    implements $LowStockItemModelCopyWith<$Res> {
  _$LowStockItemModelCopyWithImpl(this._self, this._then);

  final LowStockItemModel _self;
  final $Res Function(LowStockItemModel) _then;

/// Create a copy of LowStockItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? sku = null,Object? name = null,Object? quantity = null,Object? lowStockThreshold = null,}) {
  return _then(LowStockItemModel(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,lowStockThreshold: null == lowStockThreshold ? _self.lowStockThreshold : lowStockThreshold // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LowStockItemModel].
extension LowStockItemModelPatterns on LowStockItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LowStockItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LowStockItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LowStockItemModel value)  $default,){
final _that = this;
switch (_that) {
case _LowStockItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LowStockItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _LowStockItemModel() when $default != null:
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
case _LowStockItemModel() when $default != null:
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
case _LowStockItemModel():
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
case _LowStockItemModel() when $default != null:
return $default(_that.productId,_that.sku,_that.name,_that.quantity,_that.lowStockThreshold);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LowStockItemModel extends LowStockItemModel {
  const _LowStockItemModel({required this.productId, required this.sku, required this.name, required this.quantity, required this.lowStockThreshold}): super._();
  factory _LowStockItemModel.fromJson(Map<String, dynamic> json) => _$LowStockItemModelFromJson(json);

@override final  int productId;
@override final  String sku;
@override final  String name;
@override final  int quantity;
@override final  int lowStockThreshold;

/// Create a copy of LowStockItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LowStockItemModelCopyWith<_LowStockItemModel> get copyWith => __$LowStockItemModelCopyWithImpl<_LowStockItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LowStockItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LowStockItemModel&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.name, name) || other.name == name)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.lowStockThreshold, lowStockThreshold) || other.lowStockThreshold == lowStockThreshold));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,productId,sku,name,quantity,lowStockThreshold);
}

@override
String toString() {
    return 'LowStockItemModel(productId: $productId, sku: $sku, name: $name, quantity: $quantity, lowStockThreshold: $lowStockThreshold)';
}


}

/// @nodoc
abstract mixin class _$LowStockItemModelCopyWith<$Res> implements $LowStockItemModelCopyWith<$Res> {
  factory _$LowStockItemModelCopyWith(_LowStockItemModel value, $Res Function(_LowStockItemModel) _then) = __$LowStockItemModelCopyWithImpl;
@override @useResult
$Res call({
 int productId, String sku, String name, int quantity, int lowStockThreshold
});




}
/// @nodoc
class __$LowStockItemModelCopyWithImpl<$Res>
    implements _$LowStockItemModelCopyWith<$Res> {
  __$LowStockItemModelCopyWithImpl(this._self, this._then);

  final _LowStockItemModel _self;
  final $Res Function(_LowStockItemModel) _then;

/// Create a copy of LowStockItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? sku = null,Object? name = null,Object? quantity = null,Object? lowStockThreshold = null,}) {
  return _then(_LowStockItemModel(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,lowStockThreshold: null == lowStockThreshold ? _self.lowStockThreshold : lowStockThreshold // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CreateMovementRequest {

 String get type; int get quantity; String get reason;
/// Create a copy of CreateMovementRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateMovementRequestCopyWith<CreateMovementRequest> get copyWith => _$CreateMovementRequestCopyWithImpl<CreateMovementRequest>(this as CreateMovementRequest, _$identity);

  /// Serializes this CreateMovementRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CreateMovementRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateMovementRequest&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.reason, _this.reason) || other.reason == _this.reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CreateMovementRequest;
  return Object.hash(runtimeType,_this.type,_this.quantity,_this.reason);
}

@override
String toString() {
  final _this = this as CreateMovementRequest;
  return 'CreateMovementRequest(type: ${_this.type}, quantity: ${_this.quantity}, reason: ${_this.reason})';
}


}

/// @nodoc
abstract mixin class $CreateMovementRequestCopyWith<$Res>  {
  factory $CreateMovementRequestCopyWith(CreateMovementRequest value, $Res Function(CreateMovementRequest) _then) = _$CreateMovementRequestCopyWithImpl;
@useResult
$Res call({
 String type, int quantity, String reason
});




}
/// @nodoc
class _$CreateMovementRequestCopyWithImpl<$Res>
    implements $CreateMovementRequestCopyWith<$Res> {
  _$CreateMovementRequestCopyWithImpl(this._self, this._then);

  final CreateMovementRequest _self;
  final $Res Function(CreateMovementRequest) _then;

/// Create a copy of CreateMovementRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? quantity = null,Object? reason = null,}) {
  return _then(CreateMovementRequest(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateMovementRequest].
extension CreateMovementRequestPatterns on CreateMovementRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateMovementRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateMovementRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateMovementRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateMovementRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateMovementRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateMovementRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  int quantity,  String reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateMovementRequest() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  int quantity,  String reason)  $default,) {final _that = this;
switch (_that) {
case _CreateMovementRequest():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  int quantity,  String reason)?  $default,) {final _that = this;
switch (_that) {
case _CreateMovementRequest() when $default != null:
return $default(_that.type,_that.quantity,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateMovementRequest implements CreateMovementRequest {
  const _CreateMovementRequest({required this.type, required this.quantity, required this.reason});
  factory _CreateMovementRequest.fromJson(Map<String, dynamic> json) => _$CreateMovementRequestFromJson(json);

@override final  String type;
@override final  int quantity;
@override final  String reason;

/// Create a copy of CreateMovementRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateMovementRequestCopyWith<_CreateMovementRequest> get copyWith => __$CreateMovementRequestCopyWithImpl<_CreateMovementRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateMovementRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateMovementRequest&&(identical(other.type, type) || other.type == type)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,type,quantity,reason);
}

@override
String toString() {
    return 'CreateMovementRequest(type: $type, quantity: $quantity, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$CreateMovementRequestCopyWith<$Res> implements $CreateMovementRequestCopyWith<$Res> {
  factory _$CreateMovementRequestCopyWith(_CreateMovementRequest value, $Res Function(_CreateMovementRequest) _then) = __$CreateMovementRequestCopyWithImpl;
@override @useResult
$Res call({
 String type, int quantity, String reason
});




}
/// @nodoc
class __$CreateMovementRequestCopyWithImpl<$Res>
    implements _$CreateMovementRequestCopyWith<$Res> {
  __$CreateMovementRequestCopyWithImpl(this._self, this._then);

  final _CreateMovementRequest _self;
  final $Res Function(_CreateMovementRequest) _then;

/// Create a copy of CreateMovementRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? quantity = null,Object? reason = null,}) {
  return _then(_CreateMovementRequest(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
