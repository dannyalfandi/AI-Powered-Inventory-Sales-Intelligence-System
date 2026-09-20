// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AnalyticsRangeModel {

 DateTime get from; DateTime get to;
/// Create a copy of AnalyticsRangeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsRangeModelCopyWith<AnalyticsRangeModel> get copyWith => _$AnalyticsRangeModelCopyWithImpl<AnalyticsRangeModel>(this as AnalyticsRangeModel, _$identity);

  /// Serializes this AnalyticsRangeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AnalyticsRangeModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsRangeModel&&(identical(other.from, _this.from) || other.from == _this.from)&&(identical(other.to, _this.to) || other.to == _this.to));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AnalyticsRangeModel;
  return Object.hash(runtimeType,_this.from,_this.to);
}

@override
String toString() {
  final _this = this as AnalyticsRangeModel;
  return 'AnalyticsRangeModel(from: ${_this.from}, to: ${_this.to})';
}


}

/// @nodoc
abstract mixin class $AnalyticsRangeModelCopyWith<$Res>  {
  factory $AnalyticsRangeModelCopyWith(AnalyticsRangeModel value, $Res Function(AnalyticsRangeModel) _then) = _$AnalyticsRangeModelCopyWithImpl;
@useResult
$Res call({
 DateTime from, DateTime to
});




}
/// @nodoc
class _$AnalyticsRangeModelCopyWithImpl<$Res>
    implements $AnalyticsRangeModelCopyWith<$Res> {
  _$AnalyticsRangeModelCopyWithImpl(this._self, this._then);

  final AnalyticsRangeModel _self;
  final $Res Function(AnalyticsRangeModel) _then;

/// Create a copy of AnalyticsRangeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? from = null,Object? to = null,}) {
  return _then(AnalyticsRangeModel(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AnalyticsRangeModel].
extension AnalyticsRangeModelPatterns on AnalyticsRangeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalyticsRangeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalyticsRangeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalyticsRangeModel value)  $default,){
final _that = this;
switch (_that) {
case _AnalyticsRangeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalyticsRangeModel value)?  $default,){
final _that = this;
switch (_that) {
case _AnalyticsRangeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime from,  DateTime to)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalyticsRangeModel() when $default != null:
return $default(_that.from,_that.to);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime from,  DateTime to)  $default,) {final _that = this;
switch (_that) {
case _AnalyticsRangeModel():
return $default(_that.from,_that.to);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime from,  DateTime to)?  $default,) {final _that = this;
switch (_that) {
case _AnalyticsRangeModel() when $default != null:
return $default(_that.from,_that.to);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnalyticsRangeModel extends AnalyticsRangeModel {
  const _AnalyticsRangeModel({required this.from, required this.to}): super._();
  factory _AnalyticsRangeModel.fromJson(Map<String, dynamic> json) => _$AnalyticsRangeModelFromJson(json);

@override final  DateTime from;
@override final  DateTime to;

/// Create a copy of AnalyticsRangeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalyticsRangeModelCopyWith<_AnalyticsRangeModel> get copyWith => __$AnalyticsRangeModelCopyWithImpl<_AnalyticsRangeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnalyticsRangeModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsRangeModel&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,from,to);
}

@override
String toString() {
    return 'AnalyticsRangeModel(from: $from, to: $to)';
}


}

/// @nodoc
abstract mixin class _$AnalyticsRangeModelCopyWith<$Res> implements $AnalyticsRangeModelCopyWith<$Res> {
  factory _$AnalyticsRangeModelCopyWith(_AnalyticsRangeModel value, $Res Function(_AnalyticsRangeModel) _then) = __$AnalyticsRangeModelCopyWithImpl;
@override @useResult
$Res call({
 DateTime from, DateTime to
});




}
/// @nodoc
class __$AnalyticsRangeModelCopyWithImpl<$Res>
    implements _$AnalyticsRangeModelCopyWith<$Res> {
  __$AnalyticsRangeModelCopyWithImpl(this._self, this._then);

  final _AnalyticsRangeModel _self;
  final $Res Function(_AnalyticsRangeModel) _then;

/// Create a copy of AnalyticsRangeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? from = null,Object? to = null,}) {
  return _then(_AnalyticsRangeModel(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$DashboardSummaryModel {

 AnalyticsRangeModel get range; int get totalRevenue; int get totalOrders; int get totalItemsSold; int get averageOrderValue;
/// Create a copy of DashboardSummaryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardSummaryModelCopyWith<DashboardSummaryModel> get copyWith => _$DashboardSummaryModelCopyWithImpl<DashboardSummaryModel>(this as DashboardSummaryModel, _$identity);

  /// Serializes this DashboardSummaryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DashboardSummaryModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardSummaryModel&&(identical(other.range, _this.range) || other.range == _this.range)&&(identical(other.totalRevenue, _this.totalRevenue) || other.totalRevenue == _this.totalRevenue)&&(identical(other.totalOrders, _this.totalOrders) || other.totalOrders == _this.totalOrders)&&(identical(other.totalItemsSold, _this.totalItemsSold) || other.totalItemsSold == _this.totalItemsSold)&&(identical(other.averageOrderValue, _this.averageOrderValue) || other.averageOrderValue == _this.averageOrderValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DashboardSummaryModel;
  return Object.hash(runtimeType,_this.range,_this.totalRevenue,_this.totalOrders,_this.totalItemsSold,_this.averageOrderValue);
}

@override
String toString() {
  final _this = this as DashboardSummaryModel;
  return 'DashboardSummaryModel(range: ${_this.range}, totalRevenue: ${_this.totalRevenue}, totalOrders: ${_this.totalOrders}, totalItemsSold: ${_this.totalItemsSold}, averageOrderValue: ${_this.averageOrderValue})';
}


}

/// @nodoc
abstract mixin class $DashboardSummaryModelCopyWith<$Res>  {
  factory $DashboardSummaryModelCopyWith(DashboardSummaryModel value, $Res Function(DashboardSummaryModel) _then) = _$DashboardSummaryModelCopyWithImpl;
@useResult
$Res call({
 AnalyticsRangeModel range, int totalRevenue, int totalOrders, int totalItemsSold, int averageOrderValue
});


$AnalyticsRangeModelCopyWith<$Res> get range;

}
/// @nodoc
class _$DashboardSummaryModelCopyWithImpl<$Res>
    implements $DashboardSummaryModelCopyWith<$Res> {
  _$DashboardSummaryModelCopyWithImpl(this._self, this._then);

  final DashboardSummaryModel _self;
  final $Res Function(DashboardSummaryModel) _then;

/// Create a copy of DashboardSummaryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? range = null,Object? totalRevenue = null,Object? totalOrders = null,Object? totalItemsSold = null,Object? averageOrderValue = null,}) {
  return _then(DashboardSummaryModel(
range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as AnalyticsRangeModel,totalRevenue: null == totalRevenue ? _self.totalRevenue : totalRevenue // ignore: cast_nullable_to_non_nullable
as int,totalOrders: null == totalOrders ? _self.totalOrders : totalOrders // ignore: cast_nullable_to_non_nullable
as int,totalItemsSold: null == totalItemsSold ? _self.totalItemsSold : totalItemsSold // ignore: cast_nullable_to_non_nullable
as int,averageOrderValue: null == averageOrderValue ? _self.averageOrderValue : averageOrderValue // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of DashboardSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsRangeModelCopyWith<$Res> get range {
  
  return $AnalyticsRangeModelCopyWith<$Res>(_self.range, (value) {
    return _then(_self.copyWith(range: value));
  });
}
}


/// Adds pattern-matching-related methods to [DashboardSummaryModel].
extension DashboardSummaryModelPatterns on DashboardSummaryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardSummaryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardSummaryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardSummaryModel value)  $default,){
final _that = this;
switch (_that) {
case _DashboardSummaryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardSummaryModel value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardSummaryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AnalyticsRangeModel range,  int totalRevenue,  int totalOrders,  int totalItemsSold,  int averageOrderValue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardSummaryModel() when $default != null:
return $default(_that.range,_that.totalRevenue,_that.totalOrders,_that.totalItemsSold,_that.averageOrderValue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AnalyticsRangeModel range,  int totalRevenue,  int totalOrders,  int totalItemsSold,  int averageOrderValue)  $default,) {final _that = this;
switch (_that) {
case _DashboardSummaryModel():
return $default(_that.range,_that.totalRevenue,_that.totalOrders,_that.totalItemsSold,_that.averageOrderValue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AnalyticsRangeModel range,  int totalRevenue,  int totalOrders,  int totalItemsSold,  int averageOrderValue)?  $default,) {final _that = this;
switch (_that) {
case _DashboardSummaryModel() when $default != null:
return $default(_that.range,_that.totalRevenue,_that.totalOrders,_that.totalItemsSold,_that.averageOrderValue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardSummaryModel extends DashboardSummaryModel {
  const _DashboardSummaryModel({required this.range, required this.totalRevenue, required this.totalOrders, required this.totalItemsSold, required this.averageOrderValue}): super._();
  factory _DashboardSummaryModel.fromJson(Map<String, dynamic> json) => _$DashboardSummaryModelFromJson(json);

@override final  AnalyticsRangeModel range;
@override final  int totalRevenue;
@override final  int totalOrders;
@override final  int totalItemsSold;
@override final  int averageOrderValue;

/// Create a copy of DashboardSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardSummaryModelCopyWith<_DashboardSummaryModel> get copyWith => __$DashboardSummaryModelCopyWithImpl<_DashboardSummaryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardSummaryModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardSummaryModel&&(identical(other.range, range) || other.range == range)&&(identical(other.totalRevenue, totalRevenue) || other.totalRevenue == totalRevenue)&&(identical(other.totalOrders, totalOrders) || other.totalOrders == totalOrders)&&(identical(other.totalItemsSold, totalItemsSold) || other.totalItemsSold == totalItemsSold)&&(identical(other.averageOrderValue, averageOrderValue) || other.averageOrderValue == averageOrderValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,range,totalRevenue,totalOrders,totalItemsSold,averageOrderValue);
}

@override
String toString() {
    return 'DashboardSummaryModel(range: $range, totalRevenue: $totalRevenue, totalOrders: $totalOrders, totalItemsSold: $totalItemsSold, averageOrderValue: $averageOrderValue)';
}


}

/// @nodoc
abstract mixin class _$DashboardSummaryModelCopyWith<$Res> implements $DashboardSummaryModelCopyWith<$Res> {
  factory _$DashboardSummaryModelCopyWith(_DashboardSummaryModel value, $Res Function(_DashboardSummaryModel) _then) = __$DashboardSummaryModelCopyWithImpl;
@override @useResult
$Res call({
 AnalyticsRangeModel range, int totalRevenue, int totalOrders, int totalItemsSold, int averageOrderValue
});


@override $AnalyticsRangeModelCopyWith<$Res> get range;

}
/// @nodoc
class __$DashboardSummaryModelCopyWithImpl<$Res>
    implements _$DashboardSummaryModelCopyWith<$Res> {
  __$DashboardSummaryModelCopyWithImpl(this._self, this._then);

  final _DashboardSummaryModel _self;
  final $Res Function(_DashboardSummaryModel) _then;

/// Create a copy of DashboardSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? range = null,Object? totalRevenue = null,Object? totalOrders = null,Object? totalItemsSold = null,Object? averageOrderValue = null,}) {
  return _then(_DashboardSummaryModel(
range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as AnalyticsRangeModel,totalRevenue: null == totalRevenue ? _self.totalRevenue : totalRevenue // ignore: cast_nullable_to_non_nullable
as int,totalOrders: null == totalOrders ? _self.totalOrders : totalOrders // ignore: cast_nullable_to_non_nullable
as int,totalItemsSold: null == totalItemsSold ? _self.totalItemsSold : totalItemsSold // ignore: cast_nullable_to_non_nullable
as int,averageOrderValue: null == averageOrderValue ? _self.averageOrderValue : averageOrderValue // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of DashboardSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsRangeModelCopyWith<$Res> get range {
  
  return $AnalyticsRangeModelCopyWith<$Res>(_self.range, (value) {
    return _then(_self.copyWith(range: value));
  });
}
}


/// @nodoc
mixin _$SalesTrendPointModel {

 DateTime get periodStart; DateTime get periodEnd; int get revenue; int get orders;
/// Create a copy of SalesTrendPointModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalesTrendPointModelCopyWith<SalesTrendPointModel> get copyWith => _$SalesTrendPointModelCopyWithImpl<SalesTrendPointModel>(this as SalesTrendPointModel, _$identity);

  /// Serializes this SalesTrendPointModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SalesTrendPointModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalesTrendPointModel&&(identical(other.periodStart, _this.periodStart) || other.periodStart == _this.periodStart)&&(identical(other.periodEnd, _this.periodEnd) || other.periodEnd == _this.periodEnd)&&(identical(other.revenue, _this.revenue) || other.revenue == _this.revenue)&&(identical(other.orders, _this.orders) || other.orders == _this.orders));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SalesTrendPointModel;
  return Object.hash(runtimeType,_this.periodStart,_this.periodEnd,_this.revenue,_this.orders);
}

@override
String toString() {
  final _this = this as SalesTrendPointModel;
  return 'SalesTrendPointModel(periodStart: ${_this.periodStart}, periodEnd: ${_this.periodEnd}, revenue: ${_this.revenue}, orders: ${_this.orders})';
}


}

/// @nodoc
abstract mixin class $SalesTrendPointModelCopyWith<$Res>  {
  factory $SalesTrendPointModelCopyWith(SalesTrendPointModel value, $Res Function(SalesTrendPointModel) _then) = _$SalesTrendPointModelCopyWithImpl;
@useResult
$Res call({
 DateTime periodStart, DateTime periodEnd, int revenue, int orders
});




}
/// @nodoc
class _$SalesTrendPointModelCopyWithImpl<$Res>
    implements $SalesTrendPointModelCopyWith<$Res> {
  _$SalesTrendPointModelCopyWithImpl(this._self, this._then);

  final SalesTrendPointModel _self;
  final $Res Function(SalesTrendPointModel) _then;

/// Create a copy of SalesTrendPointModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? periodStart = null,Object? periodEnd = null,Object? revenue = null,Object? orders = null,}) {
  return _then(SalesTrendPointModel(
periodStart: null == periodStart ? _self.periodStart : periodStart // ignore: cast_nullable_to_non_nullable
as DateTime,periodEnd: null == periodEnd ? _self.periodEnd : periodEnd // ignore: cast_nullable_to_non_nullable
as DateTime,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as int,orders: null == orders ? _self.orders : orders // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SalesTrendPointModel].
extension SalesTrendPointModelPatterns on SalesTrendPointModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalesTrendPointModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalesTrendPointModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalesTrendPointModel value)  $default,){
final _that = this;
switch (_that) {
case _SalesTrendPointModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalesTrendPointModel value)?  $default,){
final _that = this;
switch (_that) {
case _SalesTrendPointModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime periodStart,  DateTime periodEnd,  int revenue,  int orders)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SalesTrendPointModel() when $default != null:
return $default(_that.periodStart,_that.periodEnd,_that.revenue,_that.orders);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime periodStart,  DateTime periodEnd,  int revenue,  int orders)  $default,) {final _that = this;
switch (_that) {
case _SalesTrendPointModel():
return $default(_that.periodStart,_that.periodEnd,_that.revenue,_that.orders);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime periodStart,  DateTime periodEnd,  int revenue,  int orders)?  $default,) {final _that = this;
switch (_that) {
case _SalesTrendPointModel() when $default != null:
return $default(_that.periodStart,_that.periodEnd,_that.revenue,_that.orders);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SalesTrendPointModel extends SalesTrendPointModel {
  const _SalesTrendPointModel({required this.periodStart, required this.periodEnd, required this.revenue, required this.orders}): super._();
  factory _SalesTrendPointModel.fromJson(Map<String, dynamic> json) => _$SalesTrendPointModelFromJson(json);

@override final  DateTime periodStart;
@override final  DateTime periodEnd;
@override final  int revenue;
@override final  int orders;

/// Create a copy of SalesTrendPointModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalesTrendPointModelCopyWith<_SalesTrendPointModel> get copyWith => __$SalesTrendPointModelCopyWithImpl<_SalesTrendPointModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SalesTrendPointModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalesTrendPointModel&&(identical(other.periodStart, periodStart) || other.periodStart == periodStart)&&(identical(other.periodEnd, periodEnd) || other.periodEnd == periodEnd)&&(identical(other.revenue, revenue) || other.revenue == revenue)&&(identical(other.orders, orders) || other.orders == orders));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,periodStart,periodEnd,revenue,orders);
}

@override
String toString() {
    return 'SalesTrendPointModel(periodStart: $periodStart, periodEnd: $periodEnd, revenue: $revenue, orders: $orders)';
}


}

/// @nodoc
abstract mixin class _$SalesTrendPointModelCopyWith<$Res> implements $SalesTrendPointModelCopyWith<$Res> {
  factory _$SalesTrendPointModelCopyWith(_SalesTrendPointModel value, $Res Function(_SalesTrendPointModel) _then) = __$SalesTrendPointModelCopyWithImpl;
@override @useResult
$Res call({
 DateTime periodStart, DateTime periodEnd, int revenue, int orders
});




}
/// @nodoc
class __$SalesTrendPointModelCopyWithImpl<$Res>
    implements _$SalesTrendPointModelCopyWith<$Res> {
  __$SalesTrendPointModelCopyWithImpl(this._self, this._then);

  final _SalesTrendPointModel _self;
  final $Res Function(_SalesTrendPointModel) _then;

/// Create a copy of SalesTrendPointModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? periodStart = null,Object? periodEnd = null,Object? revenue = null,Object? orders = null,}) {
  return _then(_SalesTrendPointModel(
periodStart: null == periodStart ? _self.periodStart : periodStart // ignore: cast_nullable_to_non_nullable
as DateTime,periodEnd: null == periodEnd ? _self.periodEnd : periodEnd // ignore: cast_nullable_to_non_nullable
as DateTime,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as int,orders: null == orders ? _self.orders : orders // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$SalesTrendModel {

 AnalyticsRangeModel get range; String get granularity; List<SalesTrendPointModel> get points;
/// Create a copy of SalesTrendModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalesTrendModelCopyWith<SalesTrendModel> get copyWith => _$SalesTrendModelCopyWithImpl<SalesTrendModel>(this as SalesTrendModel, _$identity);

  /// Serializes this SalesTrendModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SalesTrendModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalesTrendModel&&(identical(other.range, _this.range) || other.range == _this.range)&&(identical(other.granularity, _this.granularity) || other.granularity == _this.granularity)&&const DeepCollectionEquality().equals(other.points, _this.points));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SalesTrendModel;
  return Object.hash(runtimeType,_this.range,_this.granularity,const DeepCollectionEquality().hash(_this.points));
}

@override
String toString() {
  final _this = this as SalesTrendModel;
  return 'SalesTrendModel(range: ${_this.range}, granularity: ${_this.granularity}, points: ${_this.points})';
}


}

/// @nodoc
abstract mixin class $SalesTrendModelCopyWith<$Res>  {
  factory $SalesTrendModelCopyWith(SalesTrendModel value, $Res Function(SalesTrendModel) _then) = _$SalesTrendModelCopyWithImpl;
@useResult
$Res call({
 AnalyticsRangeModel range, String granularity, List<SalesTrendPointModel> points
});


$AnalyticsRangeModelCopyWith<$Res> get range;

}
/// @nodoc
class _$SalesTrendModelCopyWithImpl<$Res>
    implements $SalesTrendModelCopyWith<$Res> {
  _$SalesTrendModelCopyWithImpl(this._self, this._then);

  final SalesTrendModel _self;
  final $Res Function(SalesTrendModel) _then;

/// Create a copy of SalesTrendModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? range = null,Object? granularity = null,Object? points = null,}) {
  return _then(SalesTrendModel(
range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as AnalyticsRangeModel,granularity: null == granularity ? _self.granularity : granularity // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as List<SalesTrendPointModel>,
  ));
}
/// Create a copy of SalesTrendModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsRangeModelCopyWith<$Res> get range {
  
  return $AnalyticsRangeModelCopyWith<$Res>(_self.range, (value) {
    return _then(_self.copyWith(range: value));
  });
}
}


/// Adds pattern-matching-related methods to [SalesTrendModel].
extension SalesTrendModelPatterns on SalesTrendModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalesTrendModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalesTrendModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalesTrendModel value)  $default,){
final _that = this;
switch (_that) {
case _SalesTrendModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalesTrendModel value)?  $default,){
final _that = this;
switch (_that) {
case _SalesTrendModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AnalyticsRangeModel range,  String granularity,  List<SalesTrendPointModel> points)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SalesTrendModel() when $default != null:
return $default(_that.range,_that.granularity,_that.points);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AnalyticsRangeModel range,  String granularity,  List<SalesTrendPointModel> points)  $default,) {final _that = this;
switch (_that) {
case _SalesTrendModel():
return $default(_that.range,_that.granularity,_that.points);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AnalyticsRangeModel range,  String granularity,  List<SalesTrendPointModel> points)?  $default,) {final _that = this;
switch (_that) {
case _SalesTrendModel() when $default != null:
return $default(_that.range,_that.granularity,_that.points);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SalesTrendModel extends SalesTrendModel {
  const _SalesTrendModel({required this.range, required this.granularity,  List<SalesTrendPointModel> points = const <SalesTrendPointModel>[]}): _points = points,super._();
  factory _SalesTrendModel.fromJson(Map<String, dynamic> json) => _$SalesTrendModelFromJson(json);

@override final  AnalyticsRangeModel range;
@override final  String granularity;
 final  List<SalesTrendPointModel> _points;
@override@JsonKey() List<SalesTrendPointModel> get points {
  if (_points is EqualUnmodifiableListView) return _points;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_points);
}


/// Create a copy of SalesTrendModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalesTrendModelCopyWith<_SalesTrendModel> get copyWith => __$SalesTrendModelCopyWithImpl<_SalesTrendModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SalesTrendModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalesTrendModel&&(identical(other.range, range) || other.range == range)&&(identical(other.granularity, granularity) || other.granularity == granularity)&&const DeepCollectionEquality().equals(other.points, _points));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,range,granularity,const DeepCollectionEquality().hash(_points));
}

@override
String toString() {
    return 'SalesTrendModel(range: $range, granularity: $granularity, points: $points)';
}


}

/// @nodoc
abstract mixin class _$SalesTrendModelCopyWith<$Res> implements $SalesTrendModelCopyWith<$Res> {
  factory _$SalesTrendModelCopyWith(_SalesTrendModel value, $Res Function(_SalesTrendModel) _then) = __$SalesTrendModelCopyWithImpl;
@override @useResult
$Res call({
 AnalyticsRangeModel range, String granularity, List<SalesTrendPointModel> points
});


@override $AnalyticsRangeModelCopyWith<$Res> get range;

}
/// @nodoc
class __$SalesTrendModelCopyWithImpl<$Res>
    implements _$SalesTrendModelCopyWith<$Res> {
  __$SalesTrendModelCopyWithImpl(this._self, this._then);

  final _SalesTrendModel _self;
  final $Res Function(_SalesTrendModel) _then;

/// Create a copy of SalesTrendModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? range = null,Object? granularity = null,Object? points = null,}) {
  return _then(_SalesTrendModel(
range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as AnalyticsRangeModel,granularity: null == granularity ? _self.granularity : granularity // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self._points : points // ignore: cast_nullable_to_non_nullable
as List<SalesTrendPointModel>,
  ));
}

/// Create a copy of SalesTrendModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsRangeModelCopyWith<$Res> get range {
  
  return $AnalyticsRangeModelCopyWith<$Res>(_self.range, (value) {
    return _then(_self.copyWith(range: value));
  });
}
}


/// @nodoc
mixin _$TopProductModel {

 int get productId; String get sku; String get name; int get quantitySold; int get revenue;
/// Create a copy of TopProductModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TopProductModelCopyWith<TopProductModel> get copyWith => _$TopProductModelCopyWithImpl<TopProductModel>(this as TopProductModel, _$identity);

  /// Serializes this TopProductModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TopProductModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TopProductModel&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.sku, _this.sku) || other.sku == _this.sku)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.quantitySold, _this.quantitySold) || other.quantitySold == _this.quantitySold)&&(identical(other.revenue, _this.revenue) || other.revenue == _this.revenue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TopProductModel;
  return Object.hash(runtimeType,_this.productId,_this.sku,_this.name,_this.quantitySold,_this.revenue);
}

@override
String toString() {
  final _this = this as TopProductModel;
  return 'TopProductModel(productId: ${_this.productId}, sku: ${_this.sku}, name: ${_this.name}, quantitySold: ${_this.quantitySold}, revenue: ${_this.revenue})';
}


}

/// @nodoc
abstract mixin class $TopProductModelCopyWith<$Res>  {
  factory $TopProductModelCopyWith(TopProductModel value, $Res Function(TopProductModel) _then) = _$TopProductModelCopyWithImpl;
@useResult
$Res call({
 int productId, String sku, String name, int quantitySold, int revenue
});




}
/// @nodoc
class _$TopProductModelCopyWithImpl<$Res>
    implements $TopProductModelCopyWith<$Res> {
  _$TopProductModelCopyWithImpl(this._self, this._then);

  final TopProductModel _self;
  final $Res Function(TopProductModel) _then;

/// Create a copy of TopProductModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? sku = null,Object? name = null,Object? quantitySold = null,Object? revenue = null,}) {
  return _then(TopProductModel(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantitySold: null == quantitySold ? _self.quantitySold : quantitySold // ignore: cast_nullable_to_non_nullable
as int,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TopProductModel].
extension TopProductModelPatterns on TopProductModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TopProductModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TopProductModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TopProductModel value)  $default,){
final _that = this;
switch (_that) {
case _TopProductModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TopProductModel value)?  $default,){
final _that = this;
switch (_that) {
case _TopProductModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int productId,  String sku,  String name,  int quantitySold,  int revenue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TopProductModel() when $default != null:
return $default(_that.productId,_that.sku,_that.name,_that.quantitySold,_that.revenue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int productId,  String sku,  String name,  int quantitySold,  int revenue)  $default,) {final _that = this;
switch (_that) {
case _TopProductModel():
return $default(_that.productId,_that.sku,_that.name,_that.quantitySold,_that.revenue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int productId,  String sku,  String name,  int quantitySold,  int revenue)?  $default,) {final _that = this;
switch (_that) {
case _TopProductModel() when $default != null:
return $default(_that.productId,_that.sku,_that.name,_that.quantitySold,_that.revenue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TopProductModel extends TopProductModel {
  const _TopProductModel({required this.productId, required this.sku, required this.name, required this.quantitySold, required this.revenue}): super._();
  factory _TopProductModel.fromJson(Map<String, dynamic> json) => _$TopProductModelFromJson(json);

@override final  int productId;
@override final  String sku;
@override final  String name;
@override final  int quantitySold;
@override final  int revenue;

/// Create a copy of TopProductModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TopProductModelCopyWith<_TopProductModel> get copyWith => __$TopProductModelCopyWithImpl<_TopProductModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TopProductModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TopProductModel&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.name, name) || other.name == name)&&(identical(other.quantitySold, quantitySold) || other.quantitySold == quantitySold)&&(identical(other.revenue, revenue) || other.revenue == revenue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,productId,sku,name,quantitySold,revenue);
}

@override
String toString() {
    return 'TopProductModel(productId: $productId, sku: $sku, name: $name, quantitySold: $quantitySold, revenue: $revenue)';
}


}

/// @nodoc
abstract mixin class _$TopProductModelCopyWith<$Res> implements $TopProductModelCopyWith<$Res> {
  factory _$TopProductModelCopyWith(_TopProductModel value, $Res Function(_TopProductModel) _then) = __$TopProductModelCopyWithImpl;
@override @useResult
$Res call({
 int productId, String sku, String name, int quantitySold, int revenue
});




}
/// @nodoc
class __$TopProductModelCopyWithImpl<$Res>
    implements _$TopProductModelCopyWith<$Res> {
  __$TopProductModelCopyWithImpl(this._self, this._then);

  final _TopProductModel _self;
  final $Res Function(_TopProductModel) _then;

/// Create a copy of TopProductModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? sku = null,Object? name = null,Object? quantitySold = null,Object? revenue = null,}) {
  return _then(_TopProductModel(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantitySold: null == quantitySold ? _self.quantitySold : quantitySold // ignore: cast_nullable_to_non_nullable
as int,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$TopProductsResponse {

 AnalyticsRangeModel get range; List<TopProductModel> get products;
/// Create a copy of TopProductsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TopProductsResponseCopyWith<TopProductsResponse> get copyWith => _$TopProductsResponseCopyWithImpl<TopProductsResponse>(this as TopProductsResponse, _$identity);

  /// Serializes this TopProductsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TopProductsResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TopProductsResponse&&(identical(other.range, _this.range) || other.range == _this.range)&&const DeepCollectionEquality().equals(other.products, _this.products));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TopProductsResponse;
  return Object.hash(runtimeType,_this.range,const DeepCollectionEquality().hash(_this.products));
}

@override
String toString() {
  final _this = this as TopProductsResponse;
  return 'TopProductsResponse(range: ${_this.range}, products: ${_this.products})';
}


}

/// @nodoc
abstract mixin class $TopProductsResponseCopyWith<$Res>  {
  factory $TopProductsResponseCopyWith(TopProductsResponse value, $Res Function(TopProductsResponse) _then) = _$TopProductsResponseCopyWithImpl;
@useResult
$Res call({
 AnalyticsRangeModel range, List<TopProductModel> products
});


$AnalyticsRangeModelCopyWith<$Res> get range;

}
/// @nodoc
class _$TopProductsResponseCopyWithImpl<$Res>
    implements $TopProductsResponseCopyWith<$Res> {
  _$TopProductsResponseCopyWithImpl(this._self, this._then);

  final TopProductsResponse _self;
  final $Res Function(TopProductsResponse) _then;

/// Create a copy of TopProductsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? range = null,Object? products = null,}) {
  return _then(TopProductsResponse(
range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as AnalyticsRangeModel,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<TopProductModel>,
  ));
}
/// Create a copy of TopProductsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsRangeModelCopyWith<$Res> get range {
  
  return $AnalyticsRangeModelCopyWith<$Res>(_self.range, (value) {
    return _then(_self.copyWith(range: value));
  });
}
}


/// Adds pattern-matching-related methods to [TopProductsResponse].
extension TopProductsResponsePatterns on TopProductsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TopProductsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TopProductsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TopProductsResponse value)  $default,){
final _that = this;
switch (_that) {
case _TopProductsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TopProductsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TopProductsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AnalyticsRangeModel range,  List<TopProductModel> products)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TopProductsResponse() when $default != null:
return $default(_that.range,_that.products);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AnalyticsRangeModel range,  List<TopProductModel> products)  $default,) {final _that = this;
switch (_that) {
case _TopProductsResponse():
return $default(_that.range,_that.products);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AnalyticsRangeModel range,  List<TopProductModel> products)?  $default,) {final _that = this;
switch (_that) {
case _TopProductsResponse() when $default != null:
return $default(_that.range,_that.products);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TopProductsResponse extends TopProductsResponse {
  const _TopProductsResponse({required this.range,  List<TopProductModel> products = const <TopProductModel>[]}): _products = products,super._();
  factory _TopProductsResponse.fromJson(Map<String, dynamic> json) => _$TopProductsResponseFromJson(json);

@override final  AnalyticsRangeModel range;
 final  List<TopProductModel> _products;
@override@JsonKey() List<TopProductModel> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}


/// Create a copy of TopProductsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TopProductsResponseCopyWith<_TopProductsResponse> get copyWith => __$TopProductsResponseCopyWithImpl<_TopProductsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TopProductsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TopProductsResponse&&(identical(other.range, range) || other.range == range)&&const DeepCollectionEquality().equals(other.products, _products));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,range,const DeepCollectionEquality().hash(_products));
}

@override
String toString() {
    return 'TopProductsResponse(range: $range, products: $products)';
}


}

/// @nodoc
abstract mixin class _$TopProductsResponseCopyWith<$Res> implements $TopProductsResponseCopyWith<$Res> {
  factory _$TopProductsResponseCopyWith(_TopProductsResponse value, $Res Function(_TopProductsResponse) _then) = __$TopProductsResponseCopyWithImpl;
@override @useResult
$Res call({
 AnalyticsRangeModel range, List<TopProductModel> products
});


@override $AnalyticsRangeModelCopyWith<$Res> get range;

}
/// @nodoc
class __$TopProductsResponseCopyWithImpl<$Res>
    implements _$TopProductsResponseCopyWith<$Res> {
  __$TopProductsResponseCopyWithImpl(this._self, this._then);

  final _TopProductsResponse _self;
  final $Res Function(_TopProductsResponse) _then;

/// Create a copy of TopProductsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? range = null,Object? products = null,}) {
  return _then(_TopProductsResponse(
range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as AnalyticsRangeModel,products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<TopProductModel>,
  ));
}

/// Create a copy of TopProductsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsRangeModelCopyWith<$Res> get range {
  
  return $AnalyticsRangeModelCopyWith<$Res>(_self.range, (value) {
    return _then(_self.copyWith(range: value));
  });
}
}


/// @nodoc
mixin _$CategoryBreakdownModel {

 int? get categoryId; String get categoryName; int get quantitySold; int get revenue;
/// Create a copy of CategoryBreakdownModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryBreakdownModelCopyWith<CategoryBreakdownModel> get copyWith => _$CategoryBreakdownModelCopyWithImpl<CategoryBreakdownModel>(this as CategoryBreakdownModel, _$identity);

  /// Serializes this CategoryBreakdownModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CategoryBreakdownModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryBreakdownModel&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.categoryName, _this.categoryName) || other.categoryName == _this.categoryName)&&(identical(other.quantitySold, _this.quantitySold) || other.quantitySold == _this.quantitySold)&&(identical(other.revenue, _this.revenue) || other.revenue == _this.revenue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CategoryBreakdownModel;
  return Object.hash(runtimeType,_this.categoryId,_this.categoryName,_this.quantitySold,_this.revenue);
}

@override
String toString() {
  final _this = this as CategoryBreakdownModel;
  return 'CategoryBreakdownModel(categoryId: ${_this.categoryId}, categoryName: ${_this.categoryName}, quantitySold: ${_this.quantitySold}, revenue: ${_this.revenue})';
}


}

/// @nodoc
abstract mixin class $CategoryBreakdownModelCopyWith<$Res>  {
  factory $CategoryBreakdownModelCopyWith(CategoryBreakdownModel value, $Res Function(CategoryBreakdownModel) _then) = _$CategoryBreakdownModelCopyWithImpl;
@useResult
$Res call({
 int? categoryId, String categoryName, int quantitySold, int revenue
});




}
/// @nodoc
class _$CategoryBreakdownModelCopyWithImpl<$Res>
    implements $CategoryBreakdownModelCopyWith<$Res> {
  _$CategoryBreakdownModelCopyWithImpl(this._self, this._then);

  final CategoryBreakdownModel _self;
  final $Res Function(CategoryBreakdownModel) _then;

/// Create a copy of CategoryBreakdownModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = freezed,Object? categoryName = null,Object? quantitySold = null,Object? revenue = null,}) {
  return _then(CategoryBreakdownModel(
categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,quantitySold: null == quantitySold ? _self.quantitySold : quantitySold // ignore: cast_nullable_to_non_nullable
as int,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryBreakdownModel].
extension CategoryBreakdownModelPatterns on CategoryBreakdownModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryBreakdownModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryBreakdownModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryBreakdownModel value)  $default,){
final _that = this;
switch (_that) {
case _CategoryBreakdownModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryBreakdownModel value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryBreakdownModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? categoryId,  String categoryName,  int quantitySold,  int revenue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryBreakdownModel() when $default != null:
return $default(_that.categoryId,_that.categoryName,_that.quantitySold,_that.revenue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? categoryId,  String categoryName,  int quantitySold,  int revenue)  $default,) {final _that = this;
switch (_that) {
case _CategoryBreakdownModel():
return $default(_that.categoryId,_that.categoryName,_that.quantitySold,_that.revenue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? categoryId,  String categoryName,  int quantitySold,  int revenue)?  $default,) {final _that = this;
switch (_that) {
case _CategoryBreakdownModel() when $default != null:
return $default(_that.categoryId,_that.categoryName,_that.quantitySold,_that.revenue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategoryBreakdownModel extends CategoryBreakdownModel {
  const _CategoryBreakdownModel({this.categoryId, required this.categoryName, required this.quantitySold, required this.revenue}): super._();
  factory _CategoryBreakdownModel.fromJson(Map<String, dynamic> json) => _$CategoryBreakdownModelFromJson(json);

@override final  int? categoryId;
@override final  String categoryName;
@override final  int quantitySold;
@override final  int revenue;

/// Create a copy of CategoryBreakdownModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryBreakdownModelCopyWith<_CategoryBreakdownModel> get copyWith => __$CategoryBreakdownModelCopyWithImpl<_CategoryBreakdownModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryBreakdownModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryBreakdownModel&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.quantitySold, quantitySold) || other.quantitySold == quantitySold)&&(identical(other.revenue, revenue) || other.revenue == revenue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,categoryId,categoryName,quantitySold,revenue);
}

@override
String toString() {
    return 'CategoryBreakdownModel(categoryId: $categoryId, categoryName: $categoryName, quantitySold: $quantitySold, revenue: $revenue)';
}


}

/// @nodoc
abstract mixin class _$CategoryBreakdownModelCopyWith<$Res> implements $CategoryBreakdownModelCopyWith<$Res> {
  factory _$CategoryBreakdownModelCopyWith(_CategoryBreakdownModel value, $Res Function(_CategoryBreakdownModel) _then) = __$CategoryBreakdownModelCopyWithImpl;
@override @useResult
$Res call({
 int? categoryId, String categoryName, int quantitySold, int revenue
});




}
/// @nodoc
class __$CategoryBreakdownModelCopyWithImpl<$Res>
    implements _$CategoryBreakdownModelCopyWith<$Res> {
  __$CategoryBreakdownModelCopyWithImpl(this._self, this._then);

  final _CategoryBreakdownModel _self;
  final $Res Function(_CategoryBreakdownModel) _then;

/// Create a copy of CategoryBreakdownModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = freezed,Object? categoryName = null,Object? quantitySold = null,Object? revenue = null,}) {
  return _then(_CategoryBreakdownModel(
categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,quantitySold: null == quantitySold ? _self.quantitySold : quantitySold // ignore: cast_nullable_to_non_nullable
as int,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CategoryBreakdownResponse {

 AnalyticsRangeModel get range; List<CategoryBreakdownModel> get categories;
/// Create a copy of CategoryBreakdownResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryBreakdownResponseCopyWith<CategoryBreakdownResponse> get copyWith => _$CategoryBreakdownResponseCopyWithImpl<CategoryBreakdownResponse>(this as CategoryBreakdownResponse, _$identity);

  /// Serializes this CategoryBreakdownResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CategoryBreakdownResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryBreakdownResponse&&(identical(other.range, _this.range) || other.range == _this.range)&&const DeepCollectionEquality().equals(other.categories, _this.categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CategoryBreakdownResponse;
  return Object.hash(runtimeType,_this.range,const DeepCollectionEquality().hash(_this.categories));
}

@override
String toString() {
  final _this = this as CategoryBreakdownResponse;
  return 'CategoryBreakdownResponse(range: ${_this.range}, categories: ${_this.categories})';
}


}

/// @nodoc
abstract mixin class $CategoryBreakdownResponseCopyWith<$Res>  {
  factory $CategoryBreakdownResponseCopyWith(CategoryBreakdownResponse value, $Res Function(CategoryBreakdownResponse) _then) = _$CategoryBreakdownResponseCopyWithImpl;
@useResult
$Res call({
 AnalyticsRangeModel range, List<CategoryBreakdownModel> categories
});


$AnalyticsRangeModelCopyWith<$Res> get range;

}
/// @nodoc
class _$CategoryBreakdownResponseCopyWithImpl<$Res>
    implements $CategoryBreakdownResponseCopyWith<$Res> {
  _$CategoryBreakdownResponseCopyWithImpl(this._self, this._then);

  final CategoryBreakdownResponse _self;
  final $Res Function(CategoryBreakdownResponse) _then;

/// Create a copy of CategoryBreakdownResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? range = null,Object? categories = null,}) {
  return _then(CategoryBreakdownResponse(
range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as AnalyticsRangeModel,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryBreakdownModel>,
  ));
}
/// Create a copy of CategoryBreakdownResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsRangeModelCopyWith<$Res> get range {
  
  return $AnalyticsRangeModelCopyWith<$Res>(_self.range, (value) {
    return _then(_self.copyWith(range: value));
  });
}
}


/// Adds pattern-matching-related methods to [CategoryBreakdownResponse].
extension CategoryBreakdownResponsePatterns on CategoryBreakdownResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryBreakdownResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryBreakdownResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryBreakdownResponse value)  $default,){
final _that = this;
switch (_that) {
case _CategoryBreakdownResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryBreakdownResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryBreakdownResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AnalyticsRangeModel range,  List<CategoryBreakdownModel> categories)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryBreakdownResponse() when $default != null:
return $default(_that.range,_that.categories);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AnalyticsRangeModel range,  List<CategoryBreakdownModel> categories)  $default,) {final _that = this;
switch (_that) {
case _CategoryBreakdownResponse():
return $default(_that.range,_that.categories);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AnalyticsRangeModel range,  List<CategoryBreakdownModel> categories)?  $default,) {final _that = this;
switch (_that) {
case _CategoryBreakdownResponse() when $default != null:
return $default(_that.range,_that.categories);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategoryBreakdownResponse extends CategoryBreakdownResponse {
  const _CategoryBreakdownResponse({required this.range,  List<CategoryBreakdownModel> categories = const <CategoryBreakdownModel>[]}): _categories = categories,super._();
  factory _CategoryBreakdownResponse.fromJson(Map<String, dynamic> json) => _$CategoryBreakdownResponseFromJson(json);

@override final  AnalyticsRangeModel range;
 final  List<CategoryBreakdownModel> _categories;
@override@JsonKey() List<CategoryBreakdownModel> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}


/// Create a copy of CategoryBreakdownResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryBreakdownResponseCopyWith<_CategoryBreakdownResponse> get copyWith => __$CategoryBreakdownResponseCopyWithImpl<_CategoryBreakdownResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryBreakdownResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryBreakdownResponse&&(identical(other.range, range) || other.range == range)&&const DeepCollectionEquality().equals(other.categories, _categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,range,const DeepCollectionEquality().hash(_categories));
}

@override
String toString() {
    return 'CategoryBreakdownResponse(range: $range, categories: $categories)';
}


}

/// @nodoc
abstract mixin class _$CategoryBreakdownResponseCopyWith<$Res> implements $CategoryBreakdownResponseCopyWith<$Res> {
  factory _$CategoryBreakdownResponseCopyWith(_CategoryBreakdownResponse value, $Res Function(_CategoryBreakdownResponse) _then) = __$CategoryBreakdownResponseCopyWithImpl;
@override @useResult
$Res call({
 AnalyticsRangeModel range, List<CategoryBreakdownModel> categories
});


@override $AnalyticsRangeModelCopyWith<$Res> get range;

}
/// @nodoc
class __$CategoryBreakdownResponseCopyWithImpl<$Res>
    implements _$CategoryBreakdownResponseCopyWith<$Res> {
  __$CategoryBreakdownResponseCopyWithImpl(this._self, this._then);

  final _CategoryBreakdownResponse _self;
  final $Res Function(_CategoryBreakdownResponse) _then;

/// Create a copy of CategoryBreakdownResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? range = null,Object? categories = null,}) {
  return _then(_CategoryBreakdownResponse(
range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as AnalyticsRangeModel,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryBreakdownModel>,
  ));
}

/// Create a copy of CategoryBreakdownResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsRangeModelCopyWith<$Res> get range {
  
  return $AnalyticsRangeModelCopyWith<$Res>(_self.range, (value) {
    return _then(_self.copyWith(range: value));
  });
}
}


/// @nodoc
mixin _$LowStockAlertCountResponse {

 int get count;
/// Create a copy of LowStockAlertCountResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LowStockAlertCountResponseCopyWith<LowStockAlertCountResponse> get copyWith => _$LowStockAlertCountResponseCopyWithImpl<LowStockAlertCountResponse>(this as LowStockAlertCountResponse, _$identity);

  /// Serializes this LowStockAlertCountResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LowStockAlertCountResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LowStockAlertCountResponse&&(identical(other.count, _this.count) || other.count == _this.count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LowStockAlertCountResponse;
  return Object.hash(runtimeType,_this.count);
}

@override
String toString() {
  final _this = this as LowStockAlertCountResponse;
  return 'LowStockAlertCountResponse(count: ${_this.count})';
}


}

/// @nodoc
abstract mixin class $LowStockAlertCountResponseCopyWith<$Res>  {
  factory $LowStockAlertCountResponseCopyWith(LowStockAlertCountResponse value, $Res Function(LowStockAlertCountResponse) _then) = _$LowStockAlertCountResponseCopyWithImpl;
@useResult
$Res call({
 int count
});




}
/// @nodoc
class _$LowStockAlertCountResponseCopyWithImpl<$Res>
    implements $LowStockAlertCountResponseCopyWith<$Res> {
  _$LowStockAlertCountResponseCopyWithImpl(this._self, this._then);

  final LowStockAlertCountResponse _self;
  final $Res Function(LowStockAlertCountResponse) _then;

/// Create a copy of LowStockAlertCountResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = null,}) {
  return _then(LowStockAlertCountResponse(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LowStockAlertCountResponse].
extension LowStockAlertCountResponsePatterns on LowStockAlertCountResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LowStockAlertCountResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LowStockAlertCountResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LowStockAlertCountResponse value)  $default,){
final _that = this;
switch (_that) {
case _LowStockAlertCountResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LowStockAlertCountResponse value)?  $default,){
final _that = this;
switch (_that) {
case _LowStockAlertCountResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LowStockAlertCountResponse() when $default != null:
return $default(_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int count)  $default,) {final _that = this;
switch (_that) {
case _LowStockAlertCountResponse():
return $default(_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int count)?  $default,) {final _that = this;
switch (_that) {
case _LowStockAlertCountResponse() when $default != null:
return $default(_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LowStockAlertCountResponse implements LowStockAlertCountResponse {
  const _LowStockAlertCountResponse({required this.count});
  factory _LowStockAlertCountResponse.fromJson(Map<String, dynamic> json) => _$LowStockAlertCountResponseFromJson(json);

@override final  int count;

/// Create a copy of LowStockAlertCountResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LowStockAlertCountResponseCopyWith<_LowStockAlertCountResponse> get copyWith => __$LowStockAlertCountResponseCopyWithImpl<_LowStockAlertCountResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LowStockAlertCountResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LowStockAlertCountResponse&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,count);
}

@override
String toString() {
    return 'LowStockAlertCountResponse(count: $count)';
}


}

/// @nodoc
abstract mixin class _$LowStockAlertCountResponseCopyWith<$Res> implements $LowStockAlertCountResponseCopyWith<$Res> {
  factory _$LowStockAlertCountResponseCopyWith(_LowStockAlertCountResponse value, $Res Function(_LowStockAlertCountResponse) _then) = __$LowStockAlertCountResponseCopyWithImpl;
@override @useResult
$Res call({
 int count
});




}
/// @nodoc
class __$LowStockAlertCountResponseCopyWithImpl<$Res>
    implements _$LowStockAlertCountResponseCopyWith<$Res> {
  __$LowStockAlertCountResponseCopyWithImpl(this._self, this._then);

  final _LowStockAlertCountResponse _self;
  final $Res Function(_LowStockAlertCountResponse) _then;

/// Create a copy of LowStockAlertCountResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = null,}) {
  return _then(_LowStockAlertCountResponse(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
