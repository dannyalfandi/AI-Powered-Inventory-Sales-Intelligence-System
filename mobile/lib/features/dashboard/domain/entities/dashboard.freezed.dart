// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AnalyticsRange {

 DateTime get from; DateTime get to;
/// Create a copy of AnalyticsRange
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsRangeCopyWith<AnalyticsRange> get copyWith => _$AnalyticsRangeCopyWithImpl<AnalyticsRange>(this as AnalyticsRange, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AnalyticsRange;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsRange&&(identical(other.from, _this.from) || other.from == _this.from)&&(identical(other.to, _this.to) || other.to == _this.to));
}


@override
int get hashCode {
  final _this = this as AnalyticsRange;
  return Object.hash(runtimeType,_this.from,_this.to);
}

@override
String toString() {
  final _this = this as AnalyticsRange;
  return 'AnalyticsRange(from: ${_this.from}, to: ${_this.to})';
}


}

/// @nodoc
abstract mixin class $AnalyticsRangeCopyWith<$Res>  {
  factory $AnalyticsRangeCopyWith(AnalyticsRange value, $Res Function(AnalyticsRange) _then) = _$AnalyticsRangeCopyWithImpl;
@useResult
$Res call({
 DateTime from, DateTime to
});




}
/// @nodoc
class _$AnalyticsRangeCopyWithImpl<$Res>
    implements $AnalyticsRangeCopyWith<$Res> {
  _$AnalyticsRangeCopyWithImpl(this._self, this._then);

  final AnalyticsRange _self;
  final $Res Function(AnalyticsRange) _then;

/// Create a copy of AnalyticsRange
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? from = null,Object? to = null,}) {
  return _then(AnalyticsRange(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AnalyticsRange].
extension AnalyticsRangePatterns on AnalyticsRange {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalyticsRange value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalyticsRange() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalyticsRange value)  $default,){
final _that = this;
switch (_that) {
case _AnalyticsRange():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalyticsRange value)?  $default,){
final _that = this;
switch (_that) {
case _AnalyticsRange() when $default != null:
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
case _AnalyticsRange() when $default != null:
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
case _AnalyticsRange():
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
case _AnalyticsRange() when $default != null:
return $default(_that.from,_that.to);case _:
  return null;

}
}

}

/// @nodoc


class _AnalyticsRange extends AnalyticsRange {
  const _AnalyticsRange({required this.from, required this.to}): super._();
  

@override final  DateTime from;
@override final  DateTime to;

/// Create a copy of AnalyticsRange
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalyticsRangeCopyWith<_AnalyticsRange> get copyWith => __$AnalyticsRangeCopyWithImpl<_AnalyticsRange>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsRange&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to));
}


@override
int get hashCode {
    return Object.hash(runtimeType,from,to);
}

@override
String toString() {
    return 'AnalyticsRange(from: $from, to: $to)';
}


}

/// @nodoc
abstract mixin class _$AnalyticsRangeCopyWith<$Res> implements $AnalyticsRangeCopyWith<$Res> {
  factory _$AnalyticsRangeCopyWith(_AnalyticsRange value, $Res Function(_AnalyticsRange) _then) = __$AnalyticsRangeCopyWithImpl;
@override @useResult
$Res call({
 DateTime from, DateTime to
});




}
/// @nodoc
class __$AnalyticsRangeCopyWithImpl<$Res>
    implements _$AnalyticsRangeCopyWith<$Res> {
  __$AnalyticsRangeCopyWithImpl(this._self, this._then);

  final _AnalyticsRange _self;
  final $Res Function(_AnalyticsRange) _then;

/// Create a copy of AnalyticsRange
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? from = null,Object? to = null,}) {
  return _then(_AnalyticsRange(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$DashboardSummary {

 AnalyticsRange get range; int get totalRevenue; int get totalOrders; int get totalItemsSold;/// Revenue / orders, already rounded by the backend.
 int get averageOrderValue;
/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardSummaryCopyWith<DashboardSummary> get copyWith => _$DashboardSummaryCopyWithImpl<DashboardSummary>(this as DashboardSummary, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DashboardSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardSummary&&(identical(other.range, _this.range) || other.range == _this.range)&&(identical(other.totalRevenue, _this.totalRevenue) || other.totalRevenue == _this.totalRevenue)&&(identical(other.totalOrders, _this.totalOrders) || other.totalOrders == _this.totalOrders)&&(identical(other.totalItemsSold, _this.totalItemsSold) || other.totalItemsSold == _this.totalItemsSold)&&(identical(other.averageOrderValue, _this.averageOrderValue) || other.averageOrderValue == _this.averageOrderValue));
}


@override
int get hashCode {
  final _this = this as DashboardSummary;
  return Object.hash(runtimeType,_this.range,_this.totalRevenue,_this.totalOrders,_this.totalItemsSold,_this.averageOrderValue);
}

@override
String toString() {
  final _this = this as DashboardSummary;
  return 'DashboardSummary(range: ${_this.range}, totalRevenue: ${_this.totalRevenue}, totalOrders: ${_this.totalOrders}, totalItemsSold: ${_this.totalItemsSold}, averageOrderValue: ${_this.averageOrderValue})';
}


}

/// @nodoc
abstract mixin class $DashboardSummaryCopyWith<$Res>  {
  factory $DashboardSummaryCopyWith(DashboardSummary value, $Res Function(DashboardSummary) _then) = _$DashboardSummaryCopyWithImpl;
@useResult
$Res call({
 AnalyticsRange range, int totalRevenue, int totalOrders, int totalItemsSold, int averageOrderValue
});


$AnalyticsRangeCopyWith<$Res> get range;

}
/// @nodoc
class _$DashboardSummaryCopyWithImpl<$Res>
    implements $DashboardSummaryCopyWith<$Res> {
  _$DashboardSummaryCopyWithImpl(this._self, this._then);

  final DashboardSummary _self;
  final $Res Function(DashboardSummary) _then;

/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? range = null,Object? totalRevenue = null,Object? totalOrders = null,Object? totalItemsSold = null,Object? averageOrderValue = null,}) {
  return _then(DashboardSummary(
range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as AnalyticsRange,totalRevenue: null == totalRevenue ? _self.totalRevenue : totalRevenue // ignore: cast_nullable_to_non_nullable
as int,totalOrders: null == totalOrders ? _self.totalOrders : totalOrders // ignore: cast_nullable_to_non_nullable
as int,totalItemsSold: null == totalItemsSold ? _self.totalItemsSold : totalItemsSold // ignore: cast_nullable_to_non_nullable
as int,averageOrderValue: null == averageOrderValue ? _self.averageOrderValue : averageOrderValue // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsRangeCopyWith<$Res> get range {
  
  return $AnalyticsRangeCopyWith<$Res>(_self.range, (value) {
    return _then(_self.copyWith(range: value));
  });
}
}


/// Adds pattern-matching-related methods to [DashboardSummary].
extension DashboardSummaryPatterns on DashboardSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardSummary value)  $default,){
final _that = this;
switch (_that) {
case _DashboardSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardSummary value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AnalyticsRange range,  int totalRevenue,  int totalOrders,  int totalItemsSold,  int averageOrderValue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AnalyticsRange range,  int totalRevenue,  int totalOrders,  int totalItemsSold,  int averageOrderValue)  $default,) {final _that = this;
switch (_that) {
case _DashboardSummary():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AnalyticsRange range,  int totalRevenue,  int totalOrders,  int totalItemsSold,  int averageOrderValue)?  $default,) {final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
return $default(_that.range,_that.totalRevenue,_that.totalOrders,_that.totalItemsSold,_that.averageOrderValue);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardSummary implements DashboardSummary {
  const _DashboardSummary({required this.range, required this.totalRevenue, required this.totalOrders, required this.totalItemsSold, required this.averageOrderValue});
  

@override final  AnalyticsRange range;
@override final  int totalRevenue;
@override final  int totalOrders;
@override final  int totalItemsSold;
/// Revenue / orders, already rounded by the backend.
@override final  int averageOrderValue;

/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardSummaryCopyWith<_DashboardSummary> get copyWith => __$DashboardSummaryCopyWithImpl<_DashboardSummary>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardSummary&&(identical(other.range, range) || other.range == range)&&(identical(other.totalRevenue, totalRevenue) || other.totalRevenue == totalRevenue)&&(identical(other.totalOrders, totalOrders) || other.totalOrders == totalOrders)&&(identical(other.totalItemsSold, totalItemsSold) || other.totalItemsSold == totalItemsSold)&&(identical(other.averageOrderValue, averageOrderValue) || other.averageOrderValue == averageOrderValue));
}


@override
int get hashCode {
    return Object.hash(runtimeType,range,totalRevenue,totalOrders,totalItemsSold,averageOrderValue);
}

@override
String toString() {
    return 'DashboardSummary(range: $range, totalRevenue: $totalRevenue, totalOrders: $totalOrders, totalItemsSold: $totalItemsSold, averageOrderValue: $averageOrderValue)';
}


}

/// @nodoc
abstract mixin class _$DashboardSummaryCopyWith<$Res> implements $DashboardSummaryCopyWith<$Res> {
  factory _$DashboardSummaryCopyWith(_DashboardSummary value, $Res Function(_DashboardSummary) _then) = __$DashboardSummaryCopyWithImpl;
@override @useResult
$Res call({
 AnalyticsRange range, int totalRevenue, int totalOrders, int totalItemsSold, int averageOrderValue
});


@override $AnalyticsRangeCopyWith<$Res> get range;

}
/// @nodoc
class __$DashboardSummaryCopyWithImpl<$Res>
    implements _$DashboardSummaryCopyWith<$Res> {
  __$DashboardSummaryCopyWithImpl(this._self, this._then);

  final _DashboardSummary _self;
  final $Res Function(_DashboardSummary) _then;

/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? range = null,Object? totalRevenue = null,Object? totalOrders = null,Object? totalItemsSold = null,Object? averageOrderValue = null,}) {
  return _then(_DashboardSummary(
range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as AnalyticsRange,totalRevenue: null == totalRevenue ? _self.totalRevenue : totalRevenue // ignore: cast_nullable_to_non_nullable
as int,totalOrders: null == totalOrders ? _self.totalOrders : totalOrders // ignore: cast_nullable_to_non_nullable
as int,totalItemsSold: null == totalItemsSold ? _self.totalItemsSold : totalItemsSold // ignore: cast_nullable_to_non_nullable
as int,averageOrderValue: null == averageOrderValue ? _self.averageOrderValue : averageOrderValue // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsRangeCopyWith<$Res> get range {
  
  return $AnalyticsRangeCopyWith<$Res>(_self.range, (value) {
    return _then(_self.copyWith(range: value));
  });
}
}

/// @nodoc
mixin _$SalesTrendPoint {

 DateTime get periodStart; DateTime get periodEnd; int get revenue; int get orders;
/// Create a copy of SalesTrendPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalesTrendPointCopyWith<SalesTrendPoint> get copyWith => _$SalesTrendPointCopyWithImpl<SalesTrendPoint>(this as SalesTrendPoint, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SalesTrendPoint;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalesTrendPoint&&(identical(other.periodStart, _this.periodStart) || other.periodStart == _this.periodStart)&&(identical(other.periodEnd, _this.periodEnd) || other.periodEnd == _this.periodEnd)&&(identical(other.revenue, _this.revenue) || other.revenue == _this.revenue)&&(identical(other.orders, _this.orders) || other.orders == _this.orders));
}


@override
int get hashCode {
  final _this = this as SalesTrendPoint;
  return Object.hash(runtimeType,_this.periodStart,_this.periodEnd,_this.revenue,_this.orders);
}

@override
String toString() {
  final _this = this as SalesTrendPoint;
  return 'SalesTrendPoint(periodStart: ${_this.periodStart}, periodEnd: ${_this.periodEnd}, revenue: ${_this.revenue}, orders: ${_this.orders})';
}


}

/// @nodoc
abstract mixin class $SalesTrendPointCopyWith<$Res>  {
  factory $SalesTrendPointCopyWith(SalesTrendPoint value, $Res Function(SalesTrendPoint) _then) = _$SalesTrendPointCopyWithImpl;
@useResult
$Res call({
 DateTime periodStart, DateTime periodEnd, int revenue, int orders
});




}
/// @nodoc
class _$SalesTrendPointCopyWithImpl<$Res>
    implements $SalesTrendPointCopyWith<$Res> {
  _$SalesTrendPointCopyWithImpl(this._self, this._then);

  final SalesTrendPoint _self;
  final $Res Function(SalesTrendPoint) _then;

/// Create a copy of SalesTrendPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? periodStart = null,Object? periodEnd = null,Object? revenue = null,Object? orders = null,}) {
  return _then(SalesTrendPoint(
periodStart: null == periodStart ? _self.periodStart : periodStart // ignore: cast_nullable_to_non_nullable
as DateTime,periodEnd: null == periodEnd ? _self.periodEnd : periodEnd // ignore: cast_nullable_to_non_nullable
as DateTime,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as int,orders: null == orders ? _self.orders : orders // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SalesTrendPoint].
extension SalesTrendPointPatterns on SalesTrendPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalesTrendPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalesTrendPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalesTrendPoint value)  $default,){
final _that = this;
switch (_that) {
case _SalesTrendPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalesTrendPoint value)?  $default,){
final _that = this;
switch (_that) {
case _SalesTrendPoint() when $default != null:
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
case _SalesTrendPoint() when $default != null:
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
case _SalesTrendPoint():
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
case _SalesTrendPoint() when $default != null:
return $default(_that.periodStart,_that.periodEnd,_that.revenue,_that.orders);case _:
  return null;

}
}

}

/// @nodoc


class _SalesTrendPoint implements SalesTrendPoint {
  const _SalesTrendPoint({required this.periodStart, required this.periodEnd, required this.revenue, required this.orders});
  

@override final  DateTime periodStart;
@override final  DateTime periodEnd;
@override final  int revenue;
@override final  int orders;

/// Create a copy of SalesTrendPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalesTrendPointCopyWith<_SalesTrendPoint> get copyWith => __$SalesTrendPointCopyWithImpl<_SalesTrendPoint>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalesTrendPoint&&(identical(other.periodStart, periodStart) || other.periodStart == periodStart)&&(identical(other.periodEnd, periodEnd) || other.periodEnd == periodEnd)&&(identical(other.revenue, revenue) || other.revenue == revenue)&&(identical(other.orders, orders) || other.orders == orders));
}


@override
int get hashCode {
    return Object.hash(runtimeType,periodStart,periodEnd,revenue,orders);
}

@override
String toString() {
    return 'SalesTrendPoint(periodStart: $periodStart, periodEnd: $periodEnd, revenue: $revenue, orders: $orders)';
}


}

/// @nodoc
abstract mixin class _$SalesTrendPointCopyWith<$Res> implements $SalesTrendPointCopyWith<$Res> {
  factory _$SalesTrendPointCopyWith(_SalesTrendPoint value, $Res Function(_SalesTrendPoint) _then) = __$SalesTrendPointCopyWithImpl;
@override @useResult
$Res call({
 DateTime periodStart, DateTime periodEnd, int revenue, int orders
});




}
/// @nodoc
class __$SalesTrendPointCopyWithImpl<$Res>
    implements _$SalesTrendPointCopyWith<$Res> {
  __$SalesTrendPointCopyWithImpl(this._self, this._then);

  final _SalesTrendPoint _self;
  final $Res Function(_SalesTrendPoint) _then;

/// Create a copy of SalesTrendPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? periodStart = null,Object? periodEnd = null,Object? revenue = null,Object? orders = null,}) {
  return _then(_SalesTrendPoint(
periodStart: null == periodStart ? _self.periodStart : periodStart // ignore: cast_nullable_to_non_nullable
as DateTime,periodEnd: null == periodEnd ? _self.periodEnd : periodEnd // ignore: cast_nullable_to_non_nullable
as DateTime,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as int,orders: null == orders ? _self.orders : orders // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$SalesTrend {

 AnalyticsRange get range; TrendGranularity get granularity; List<SalesTrendPoint> get points;
/// Create a copy of SalesTrend
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalesTrendCopyWith<SalesTrend> get copyWith => _$SalesTrendCopyWithImpl<SalesTrend>(this as SalesTrend, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SalesTrend;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalesTrend&&(identical(other.range, _this.range) || other.range == _this.range)&&(identical(other.granularity, _this.granularity) || other.granularity == _this.granularity)&&const DeepCollectionEquality().equals(other.points, _this.points));
}


@override
int get hashCode {
  final _this = this as SalesTrend;
  return Object.hash(runtimeType,_this.range,_this.granularity,const DeepCollectionEquality().hash(_this.points));
}

@override
String toString() {
  final _this = this as SalesTrend;
  return 'SalesTrend(range: ${_this.range}, granularity: ${_this.granularity}, points: ${_this.points})';
}


}

/// @nodoc
abstract mixin class $SalesTrendCopyWith<$Res>  {
  factory $SalesTrendCopyWith(SalesTrend value, $Res Function(SalesTrend) _then) = _$SalesTrendCopyWithImpl;
@useResult
$Res call({
 AnalyticsRange range, TrendGranularity granularity, List<SalesTrendPoint> points
});


$AnalyticsRangeCopyWith<$Res> get range;

}
/// @nodoc
class _$SalesTrendCopyWithImpl<$Res>
    implements $SalesTrendCopyWith<$Res> {
  _$SalesTrendCopyWithImpl(this._self, this._then);

  final SalesTrend _self;
  final $Res Function(SalesTrend) _then;

/// Create a copy of SalesTrend
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? range = null,Object? granularity = null,Object? points = null,}) {
  return _then(SalesTrend(
range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as AnalyticsRange,granularity: null == granularity ? _self.granularity : granularity // ignore: cast_nullable_to_non_nullable
as TrendGranularity,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as List<SalesTrendPoint>,
  ));
}
/// Create a copy of SalesTrend
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsRangeCopyWith<$Res> get range {
  
  return $AnalyticsRangeCopyWith<$Res>(_self.range, (value) {
    return _then(_self.copyWith(range: value));
  });
}
}


/// Adds pattern-matching-related methods to [SalesTrend].
extension SalesTrendPatterns on SalesTrend {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalesTrend value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalesTrend() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalesTrend value)  $default,){
final _that = this;
switch (_that) {
case _SalesTrend():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalesTrend value)?  $default,){
final _that = this;
switch (_that) {
case _SalesTrend() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AnalyticsRange range,  TrendGranularity granularity,  List<SalesTrendPoint> points)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SalesTrend() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AnalyticsRange range,  TrendGranularity granularity,  List<SalesTrendPoint> points)  $default,) {final _that = this;
switch (_that) {
case _SalesTrend():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AnalyticsRange range,  TrendGranularity granularity,  List<SalesTrendPoint> points)?  $default,) {final _that = this;
switch (_that) {
case _SalesTrend() when $default != null:
return $default(_that.range,_that.granularity,_that.points);case _:
  return null;

}
}

}

/// @nodoc


class _SalesTrend extends SalesTrend {
  const _SalesTrend({required this.range, required this.granularity, required  List<SalesTrendPoint> points}): _points = points,super._();
  

@override final  AnalyticsRange range;
@override final  TrendGranularity granularity;
 final  List<SalesTrendPoint> _points;
@override List<SalesTrendPoint> get points {
  if (_points is EqualUnmodifiableListView) return _points;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_points);
}


/// Create a copy of SalesTrend
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalesTrendCopyWith<_SalesTrend> get copyWith => __$SalesTrendCopyWithImpl<_SalesTrend>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalesTrend&&(identical(other.range, range) || other.range == range)&&(identical(other.granularity, granularity) || other.granularity == granularity)&&const DeepCollectionEquality().equals(other.points, _points));
}


@override
int get hashCode {
    return Object.hash(runtimeType,range,granularity,const DeepCollectionEquality().hash(_points));
}

@override
String toString() {
    return 'SalesTrend(range: $range, granularity: $granularity, points: $points)';
}


}

/// @nodoc
abstract mixin class _$SalesTrendCopyWith<$Res> implements $SalesTrendCopyWith<$Res> {
  factory _$SalesTrendCopyWith(_SalesTrend value, $Res Function(_SalesTrend) _then) = __$SalesTrendCopyWithImpl;
@override @useResult
$Res call({
 AnalyticsRange range, TrendGranularity granularity, List<SalesTrendPoint> points
});


@override $AnalyticsRangeCopyWith<$Res> get range;

}
/// @nodoc
class __$SalesTrendCopyWithImpl<$Res>
    implements _$SalesTrendCopyWith<$Res> {
  __$SalesTrendCopyWithImpl(this._self, this._then);

  final _SalesTrend _self;
  final $Res Function(_SalesTrend) _then;

/// Create a copy of SalesTrend
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? range = null,Object? granularity = null,Object? points = null,}) {
  return _then(_SalesTrend(
range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as AnalyticsRange,granularity: null == granularity ? _self.granularity : granularity // ignore: cast_nullable_to_non_nullable
as TrendGranularity,points: null == points ? _self._points : points // ignore: cast_nullable_to_non_nullable
as List<SalesTrendPoint>,
  ));
}

/// Create a copy of SalesTrend
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsRangeCopyWith<$Res> get range {
  
  return $AnalyticsRangeCopyWith<$Res>(_self.range, (value) {
    return _then(_self.copyWith(range: value));
  });
}
}

/// @nodoc
mixin _$TopProduct {

 int get productId; String get sku; String get name; int get quantitySold; int get revenue;
/// Create a copy of TopProduct
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TopProductCopyWith<TopProduct> get copyWith => _$TopProductCopyWithImpl<TopProduct>(this as TopProduct, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TopProduct;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TopProduct&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.sku, _this.sku) || other.sku == _this.sku)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.quantitySold, _this.quantitySold) || other.quantitySold == _this.quantitySold)&&(identical(other.revenue, _this.revenue) || other.revenue == _this.revenue));
}


@override
int get hashCode {
  final _this = this as TopProduct;
  return Object.hash(runtimeType,_this.productId,_this.sku,_this.name,_this.quantitySold,_this.revenue);
}

@override
String toString() {
  final _this = this as TopProduct;
  return 'TopProduct(productId: ${_this.productId}, sku: ${_this.sku}, name: ${_this.name}, quantitySold: ${_this.quantitySold}, revenue: ${_this.revenue})';
}


}

/// @nodoc
abstract mixin class $TopProductCopyWith<$Res>  {
  factory $TopProductCopyWith(TopProduct value, $Res Function(TopProduct) _then) = _$TopProductCopyWithImpl;
@useResult
$Res call({
 int productId, String sku, String name, int quantitySold, int revenue
});




}
/// @nodoc
class _$TopProductCopyWithImpl<$Res>
    implements $TopProductCopyWith<$Res> {
  _$TopProductCopyWithImpl(this._self, this._then);

  final TopProduct _self;
  final $Res Function(TopProduct) _then;

/// Create a copy of TopProduct
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? sku = null,Object? name = null,Object? quantitySold = null,Object? revenue = null,}) {
  return _then(TopProduct(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantitySold: null == quantitySold ? _self.quantitySold : quantitySold // ignore: cast_nullable_to_non_nullable
as int,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TopProduct].
extension TopProductPatterns on TopProduct {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TopProduct value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TopProduct() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TopProduct value)  $default,){
final _that = this;
switch (_that) {
case _TopProduct():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TopProduct value)?  $default,){
final _that = this;
switch (_that) {
case _TopProduct() when $default != null:
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
case _TopProduct() when $default != null:
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
case _TopProduct():
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
case _TopProduct() when $default != null:
return $default(_that.productId,_that.sku,_that.name,_that.quantitySold,_that.revenue);case _:
  return null;

}
}

}

/// @nodoc


class _TopProduct implements TopProduct {
  const _TopProduct({required this.productId, required this.sku, required this.name, required this.quantitySold, required this.revenue});
  

@override final  int productId;
@override final  String sku;
@override final  String name;
@override final  int quantitySold;
@override final  int revenue;

/// Create a copy of TopProduct
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TopProductCopyWith<_TopProduct> get copyWith => __$TopProductCopyWithImpl<_TopProduct>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TopProduct&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.name, name) || other.name == name)&&(identical(other.quantitySold, quantitySold) || other.quantitySold == quantitySold)&&(identical(other.revenue, revenue) || other.revenue == revenue));
}


@override
int get hashCode {
    return Object.hash(runtimeType,productId,sku,name,quantitySold,revenue);
}

@override
String toString() {
    return 'TopProduct(productId: $productId, sku: $sku, name: $name, quantitySold: $quantitySold, revenue: $revenue)';
}


}

/// @nodoc
abstract mixin class _$TopProductCopyWith<$Res> implements $TopProductCopyWith<$Res> {
  factory _$TopProductCopyWith(_TopProduct value, $Res Function(_TopProduct) _then) = __$TopProductCopyWithImpl;
@override @useResult
$Res call({
 int productId, String sku, String name, int quantitySold, int revenue
});




}
/// @nodoc
class __$TopProductCopyWithImpl<$Res>
    implements _$TopProductCopyWith<$Res> {
  __$TopProductCopyWithImpl(this._self, this._then);

  final _TopProduct _self;
  final $Res Function(_TopProduct) _then;

/// Create a copy of TopProduct
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? sku = null,Object? name = null,Object? quantitySold = null,Object? revenue = null,}) {
  return _then(_TopProduct(
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
mixin _$CategoryBreakdown {

 int? get categoryId; String get categoryName; int get quantitySold; int get revenue;
/// Create a copy of CategoryBreakdown
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryBreakdownCopyWith<CategoryBreakdown> get copyWith => _$CategoryBreakdownCopyWithImpl<CategoryBreakdown>(this as CategoryBreakdown, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CategoryBreakdown;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryBreakdown&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.categoryName, _this.categoryName) || other.categoryName == _this.categoryName)&&(identical(other.quantitySold, _this.quantitySold) || other.quantitySold == _this.quantitySold)&&(identical(other.revenue, _this.revenue) || other.revenue == _this.revenue));
}


@override
int get hashCode {
  final _this = this as CategoryBreakdown;
  return Object.hash(runtimeType,_this.categoryId,_this.categoryName,_this.quantitySold,_this.revenue);
}

@override
String toString() {
  final _this = this as CategoryBreakdown;
  return 'CategoryBreakdown(categoryId: ${_this.categoryId}, categoryName: ${_this.categoryName}, quantitySold: ${_this.quantitySold}, revenue: ${_this.revenue})';
}


}

/// @nodoc
abstract mixin class $CategoryBreakdownCopyWith<$Res>  {
  factory $CategoryBreakdownCopyWith(CategoryBreakdown value, $Res Function(CategoryBreakdown) _then) = _$CategoryBreakdownCopyWithImpl;
@useResult
$Res call({
 int? categoryId, String categoryName, int quantitySold, int revenue
});




}
/// @nodoc
class _$CategoryBreakdownCopyWithImpl<$Res>
    implements $CategoryBreakdownCopyWith<$Res> {
  _$CategoryBreakdownCopyWithImpl(this._self, this._then);

  final CategoryBreakdown _self;
  final $Res Function(CategoryBreakdown) _then;

/// Create a copy of CategoryBreakdown
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = freezed,Object? categoryName = null,Object? quantitySold = null,Object? revenue = null,}) {
  return _then(CategoryBreakdown(
categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,quantitySold: null == quantitySold ? _self.quantitySold : quantitySold // ignore: cast_nullable_to_non_nullable
as int,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryBreakdown].
extension CategoryBreakdownPatterns on CategoryBreakdown {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryBreakdown value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryBreakdown() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryBreakdown value)  $default,){
final _that = this;
switch (_that) {
case _CategoryBreakdown():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryBreakdown value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryBreakdown() when $default != null:
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
case _CategoryBreakdown() when $default != null:
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
case _CategoryBreakdown():
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
case _CategoryBreakdown() when $default != null:
return $default(_that.categoryId,_that.categoryName,_that.quantitySold,_that.revenue);case _:
  return null;

}
}

}

/// @nodoc


class _CategoryBreakdown extends CategoryBreakdown {
  const _CategoryBreakdown({this.categoryId, required this.categoryName, required this.quantitySold, required this.revenue}): super._();
  

@override final  int? categoryId;
@override final  String categoryName;
@override final  int quantitySold;
@override final  int revenue;

/// Create a copy of CategoryBreakdown
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryBreakdownCopyWith<_CategoryBreakdown> get copyWith => __$CategoryBreakdownCopyWithImpl<_CategoryBreakdown>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryBreakdown&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.quantitySold, quantitySold) || other.quantitySold == quantitySold)&&(identical(other.revenue, revenue) || other.revenue == revenue));
}


@override
int get hashCode {
    return Object.hash(runtimeType,categoryId,categoryName,quantitySold,revenue);
}

@override
String toString() {
    return 'CategoryBreakdown(categoryId: $categoryId, categoryName: $categoryName, quantitySold: $quantitySold, revenue: $revenue)';
}


}

/// @nodoc
abstract mixin class _$CategoryBreakdownCopyWith<$Res> implements $CategoryBreakdownCopyWith<$Res> {
  factory _$CategoryBreakdownCopyWith(_CategoryBreakdown value, $Res Function(_CategoryBreakdown) _then) = __$CategoryBreakdownCopyWithImpl;
@override @useResult
$Res call({
 int? categoryId, String categoryName, int quantitySold, int revenue
});




}
/// @nodoc
class __$CategoryBreakdownCopyWithImpl<$Res>
    implements _$CategoryBreakdownCopyWith<$Res> {
  __$CategoryBreakdownCopyWithImpl(this._self, this._then);

  final _CategoryBreakdown _self;
  final $Res Function(_CategoryBreakdown) _then;

/// Create a copy of CategoryBreakdown
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = freezed,Object? categoryName = null,Object? quantitySold = null,Object? revenue = null,}) {
  return _then(_CategoryBreakdown(
categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,quantitySold: null == quantitySold ? _self.quantitySold : quantitySold // ignore: cast_nullable_to_non_nullable
as int,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
