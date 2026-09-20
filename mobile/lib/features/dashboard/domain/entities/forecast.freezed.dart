// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'forecast.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ForecastPoint {

 DateTime get date; double get predictedQuantity;
/// Create a copy of ForecastPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForecastPointCopyWith<ForecastPoint> get copyWith => _$ForecastPointCopyWithImpl<ForecastPoint>(this as ForecastPoint, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ForecastPoint;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForecastPoint&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.predictedQuantity, _this.predictedQuantity) || other.predictedQuantity == _this.predictedQuantity));
}


@override
int get hashCode {
  final _this = this as ForecastPoint;
  return Object.hash(runtimeType,_this.date,_this.predictedQuantity);
}

@override
String toString() {
  final _this = this as ForecastPoint;
  return 'ForecastPoint(date: ${_this.date}, predictedQuantity: ${_this.predictedQuantity})';
}


}

/// @nodoc
abstract mixin class $ForecastPointCopyWith<$Res>  {
  factory $ForecastPointCopyWith(ForecastPoint value, $Res Function(ForecastPoint) _then) = _$ForecastPointCopyWithImpl;
@useResult
$Res call({
 DateTime date, double predictedQuantity
});




}
/// @nodoc
class _$ForecastPointCopyWithImpl<$Res>
    implements $ForecastPointCopyWith<$Res> {
  _$ForecastPointCopyWithImpl(this._self, this._then);

  final ForecastPoint _self;
  final $Res Function(ForecastPoint) _then;

/// Create a copy of ForecastPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? predictedQuantity = null,}) {
  return _then(ForecastPoint(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,predictedQuantity: null == predictedQuantity ? _self.predictedQuantity : predictedQuantity // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ForecastPoint].
extension ForecastPointPatterns on ForecastPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ForecastPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ForecastPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ForecastPoint value)  $default,){
final _that = this;
switch (_that) {
case _ForecastPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ForecastPoint value)?  $default,){
final _that = this;
switch (_that) {
case _ForecastPoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  double predictedQuantity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ForecastPoint() when $default != null:
return $default(_that.date,_that.predictedQuantity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  double predictedQuantity)  $default,) {final _that = this;
switch (_that) {
case _ForecastPoint():
return $default(_that.date,_that.predictedQuantity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  double predictedQuantity)?  $default,) {final _that = this;
switch (_that) {
case _ForecastPoint() when $default != null:
return $default(_that.date,_that.predictedQuantity);case _:
  return null;

}
}

}

/// @nodoc


class _ForecastPoint implements ForecastPoint {
  const _ForecastPoint({required this.date, required this.predictedQuantity});
  

@override final  DateTime date;
@override final  double predictedQuantity;

/// Create a copy of ForecastPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForecastPointCopyWith<_ForecastPoint> get copyWith => __$ForecastPointCopyWithImpl<_ForecastPoint>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForecastPoint&&(identical(other.date, date) || other.date == date)&&(identical(other.predictedQuantity, predictedQuantity) || other.predictedQuantity == predictedQuantity));
}


@override
int get hashCode {
    return Object.hash(runtimeType,date,predictedQuantity);
}

@override
String toString() {
    return 'ForecastPoint(date: $date, predictedQuantity: $predictedQuantity)';
}


}

/// @nodoc
abstract mixin class _$ForecastPointCopyWith<$Res> implements $ForecastPointCopyWith<$Res> {
  factory _$ForecastPointCopyWith(_ForecastPoint value, $Res Function(_ForecastPoint) _then) = __$ForecastPointCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, double predictedQuantity
});




}
/// @nodoc
class __$ForecastPointCopyWithImpl<$Res>
    implements _$ForecastPointCopyWith<$Res> {
  __$ForecastPointCopyWithImpl(this._self, this._then);

  final _ForecastPoint _self;
  final $Res Function(_ForecastPoint) _then;

/// Create a copy of ForecastPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? predictedQuantity = null,}) {
  return _then(_ForecastPoint(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,predictedQuantity: null == predictedQuantity ? _self.predictedQuantity : predictedQuantity // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$ProductForecast {

 int get productId; String get productName; String get sku; List<ForecastPoint> get forecast;/// Which model produced it, e.g. "moving_average"; null when it failed.
 String? get method;/// Why this product has no forecast. Null when it worked.
 String? get error;
/// Create a copy of ProductForecast
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductForecastCopyWith<ProductForecast> get copyWith => _$ProductForecastCopyWithImpl<ProductForecast>(this as ProductForecast, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProductForecast;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductForecast&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.productName, _this.productName) || other.productName == _this.productName)&&(identical(other.sku, _this.sku) || other.sku == _this.sku)&&const DeepCollectionEquality().equals(other.forecast, _this.forecast)&&(identical(other.method, _this.method) || other.method == _this.method)&&(identical(other.error, _this.error) || other.error == _this.error));
}


@override
int get hashCode {
  final _this = this as ProductForecast;
  return Object.hash(runtimeType,_this.productId,_this.productName,_this.sku,const DeepCollectionEquality().hash(_this.forecast),_this.method,_this.error);
}

@override
String toString() {
  final _this = this as ProductForecast;
  return 'ProductForecast(productId: ${_this.productId}, productName: ${_this.productName}, sku: ${_this.sku}, forecast: ${_this.forecast}, method: ${_this.method}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $ProductForecastCopyWith<$Res>  {
  factory $ProductForecastCopyWith(ProductForecast value, $Res Function(ProductForecast) _then) = _$ProductForecastCopyWithImpl;
@useResult
$Res call({
 int productId, String productName, String sku, List<ForecastPoint> forecast, String? method, String? error
});




}
/// @nodoc
class _$ProductForecastCopyWithImpl<$Res>
    implements $ProductForecastCopyWith<$Res> {
  _$ProductForecastCopyWithImpl(this._self, this._then);

  final ProductForecast _self;
  final $Res Function(ProductForecast) _then;

/// Create a copy of ProductForecast
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? productName = null,Object? sku = null,Object? forecast = null,Object? method = freezed,Object? error = freezed,}) {
  return _then(ProductForecast(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,forecast: null == forecast ? _self.forecast : forecast // ignore: cast_nullable_to_non_nullable
as List<ForecastPoint>,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductForecast].
extension ProductForecastPatterns on ProductForecast {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductForecast value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductForecast() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductForecast value)  $default,){
final _that = this;
switch (_that) {
case _ProductForecast():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductForecast value)?  $default,){
final _that = this;
switch (_that) {
case _ProductForecast() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int productId,  String productName,  String sku,  List<ForecastPoint> forecast,  String? method,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductForecast() when $default != null:
return $default(_that.productId,_that.productName,_that.sku,_that.forecast,_that.method,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int productId,  String productName,  String sku,  List<ForecastPoint> forecast,  String? method,  String? error)  $default,) {final _that = this;
switch (_that) {
case _ProductForecast():
return $default(_that.productId,_that.productName,_that.sku,_that.forecast,_that.method,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int productId,  String productName,  String sku,  List<ForecastPoint> forecast,  String? method,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _ProductForecast() when $default != null:
return $default(_that.productId,_that.productName,_that.sku,_that.forecast,_that.method,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _ProductForecast extends ProductForecast {
  const _ProductForecast({required this.productId, required this.productName, required this.sku,  List<ForecastPoint> forecast = const <ForecastPoint>[], this.method, this.error}): _forecast = forecast,super._();
  

@override final  int productId;
@override final  String productName;
@override final  String sku;
 final  List<ForecastPoint> _forecast;
@override@JsonKey() List<ForecastPoint> get forecast {
  if (_forecast is EqualUnmodifiableListView) return _forecast;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_forecast);
}

/// Which model produced it, e.g. "moving_average"; null when it failed.
@override final  String? method;
/// Why this product has no forecast. Null when it worked.
@override final  String? error;

/// Create a copy of ProductForecast
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductForecastCopyWith<_ProductForecast> get copyWith => __$ProductForecastCopyWithImpl<_ProductForecast>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductForecast&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.sku, sku) || other.sku == sku)&&const DeepCollectionEquality().equals(other.forecast, _forecast)&&(identical(other.method, method) || other.method == method)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,productId,productName,sku,const DeepCollectionEquality().hash(_forecast),method,error);
}

@override
String toString() {
    return 'ProductForecast(productId: $productId, productName: $productName, sku: $sku, forecast: $forecast, method: $method, error: $error)';
}


}

/// @nodoc
abstract mixin class _$ProductForecastCopyWith<$Res> implements $ProductForecastCopyWith<$Res> {
  factory _$ProductForecastCopyWith(_ProductForecast value, $Res Function(_ProductForecast) _then) = __$ProductForecastCopyWithImpl;
@override @useResult
$Res call({
 int productId, String productName, String sku, List<ForecastPoint> forecast, String? method, String? error
});




}
/// @nodoc
class __$ProductForecastCopyWithImpl<$Res>
    implements _$ProductForecastCopyWith<$Res> {
  __$ProductForecastCopyWithImpl(this._self, this._then);

  final _ProductForecast _self;
  final $Res Function(_ProductForecast) _then;

/// Create a copy of ProductForecast
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? productName = null,Object? sku = null,Object? forecast = null,Object? method = freezed,Object? error = freezed,}) {
  return _then(_ProductForecast(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,forecast: null == forecast ? _self._forecast : forecast // ignore: cast_nullable_to_non_nullable
as List<ForecastPoint>,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$ForecastReport {

 AnalyticsRange get range; int get horizonDays;/// False when every product failed: the ML service is unreachable.
 bool get available; List<ProductForecast> get products;
/// Create a copy of ForecastReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForecastReportCopyWith<ForecastReport> get copyWith => _$ForecastReportCopyWithImpl<ForecastReport>(this as ForecastReport, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ForecastReport;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForecastReport&&(identical(other.range, _this.range) || other.range == _this.range)&&(identical(other.horizonDays, _this.horizonDays) || other.horizonDays == _this.horizonDays)&&(identical(other.available, _this.available) || other.available == _this.available)&&const DeepCollectionEquality().equals(other.products, _this.products));
}


@override
int get hashCode {
  final _this = this as ForecastReport;
  return Object.hash(runtimeType,_this.range,_this.horizonDays,_this.available,const DeepCollectionEquality().hash(_this.products));
}

@override
String toString() {
  final _this = this as ForecastReport;
  return 'ForecastReport(range: ${_this.range}, horizonDays: ${_this.horizonDays}, available: ${_this.available}, products: ${_this.products})';
}


}

/// @nodoc
abstract mixin class $ForecastReportCopyWith<$Res>  {
  factory $ForecastReportCopyWith(ForecastReport value, $Res Function(ForecastReport) _then) = _$ForecastReportCopyWithImpl;
@useResult
$Res call({
 AnalyticsRange range, int horizonDays, bool available, List<ProductForecast> products
});


$AnalyticsRangeCopyWith<$Res> get range;

}
/// @nodoc
class _$ForecastReportCopyWithImpl<$Res>
    implements $ForecastReportCopyWith<$Res> {
  _$ForecastReportCopyWithImpl(this._self, this._then);

  final ForecastReport _self;
  final $Res Function(ForecastReport) _then;

/// Create a copy of ForecastReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? range = null,Object? horizonDays = null,Object? available = null,Object? products = null,}) {
  return _then(ForecastReport(
range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as AnalyticsRange,horizonDays: null == horizonDays ? _self.horizonDays : horizonDays // ignore: cast_nullable_to_non_nullable
as int,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<ProductForecast>,
  ));
}
/// Create a copy of ForecastReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsRangeCopyWith<$Res> get range {
  
  return $AnalyticsRangeCopyWith<$Res>(_self.range, (value) {
    return _then(_self.copyWith(range: value));
  });
}
}


/// Adds pattern-matching-related methods to [ForecastReport].
extension ForecastReportPatterns on ForecastReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ForecastReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ForecastReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ForecastReport value)  $default,){
final _that = this;
switch (_that) {
case _ForecastReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ForecastReport value)?  $default,){
final _that = this;
switch (_that) {
case _ForecastReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AnalyticsRange range,  int horizonDays,  bool available,  List<ProductForecast> products)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ForecastReport() when $default != null:
return $default(_that.range,_that.horizonDays,_that.available,_that.products);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AnalyticsRange range,  int horizonDays,  bool available,  List<ProductForecast> products)  $default,) {final _that = this;
switch (_that) {
case _ForecastReport():
return $default(_that.range,_that.horizonDays,_that.available,_that.products);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AnalyticsRange range,  int horizonDays,  bool available,  List<ProductForecast> products)?  $default,) {final _that = this;
switch (_that) {
case _ForecastReport() when $default != null:
return $default(_that.range,_that.horizonDays,_that.available,_that.products);case _:
  return null;

}
}

}

/// @nodoc


class _ForecastReport extends ForecastReport {
  const _ForecastReport({required this.range, required this.horizonDays, required this.available,  List<ProductForecast> products = const <ProductForecast>[]}): _products = products,super._();
  

@override final  AnalyticsRange range;
@override final  int horizonDays;
/// False when every product failed: the ML service is unreachable.
@override final  bool available;
 final  List<ProductForecast> _products;
@override@JsonKey() List<ProductForecast> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}


/// Create a copy of ForecastReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForecastReportCopyWith<_ForecastReport> get copyWith => __$ForecastReportCopyWithImpl<_ForecastReport>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForecastReport&&(identical(other.range, range) || other.range == range)&&(identical(other.horizonDays, horizonDays) || other.horizonDays == horizonDays)&&(identical(other.available, available) || other.available == available)&&const DeepCollectionEquality().equals(other.products, _products));
}


@override
int get hashCode {
    return Object.hash(runtimeType,range,horizonDays,available,const DeepCollectionEquality().hash(_products));
}

@override
String toString() {
    return 'ForecastReport(range: $range, horizonDays: $horizonDays, available: $available, products: $products)';
}


}

/// @nodoc
abstract mixin class _$ForecastReportCopyWith<$Res> implements $ForecastReportCopyWith<$Res> {
  factory _$ForecastReportCopyWith(_ForecastReport value, $Res Function(_ForecastReport) _then) = __$ForecastReportCopyWithImpl;
@override @useResult
$Res call({
 AnalyticsRange range, int horizonDays, bool available, List<ProductForecast> products
});


@override $AnalyticsRangeCopyWith<$Res> get range;

}
/// @nodoc
class __$ForecastReportCopyWithImpl<$Res>
    implements _$ForecastReportCopyWith<$Res> {
  __$ForecastReportCopyWithImpl(this._self, this._then);

  final _ForecastReport _self;
  final $Res Function(_ForecastReport) _then;

/// Create a copy of ForecastReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? range = null,Object? horizonDays = null,Object? available = null,Object? products = null,}) {
  return _then(_ForecastReport(
range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as AnalyticsRange,horizonDays: null == horizonDays ? _self.horizonDays : horizonDays // ignore: cast_nullable_to_non_nullable
as int,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<ProductForecast>,
  ));
}

/// Create a copy of ForecastReport
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
mixin _$ProductInsight {

 int get productId; String get productName; String get sku; TrendDirection? get trend;/// Percentage change between the two compared periods; 0 is a real value,
/// null means there is no result for this product.
 double? get changePercent;/// Ready-to-display Indonesian sentence from the ML service.
 String? get summary; String? get error;
/// Create a copy of ProductInsight
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductInsightCopyWith<ProductInsight> get copyWith => _$ProductInsightCopyWithImpl<ProductInsight>(this as ProductInsight, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProductInsight;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductInsight&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.productName, _this.productName) || other.productName == _this.productName)&&(identical(other.sku, _this.sku) || other.sku == _this.sku)&&(identical(other.trend, _this.trend) || other.trend == _this.trend)&&(identical(other.changePercent, _this.changePercent) || other.changePercent == _this.changePercent)&&(identical(other.summary, _this.summary) || other.summary == _this.summary)&&(identical(other.error, _this.error) || other.error == _this.error));
}


@override
int get hashCode {
  final _this = this as ProductInsight;
  return Object.hash(runtimeType,_this.productId,_this.productName,_this.sku,_this.trend,_this.changePercent,_this.summary,_this.error);
}

@override
String toString() {
  final _this = this as ProductInsight;
  return 'ProductInsight(productId: ${_this.productId}, productName: ${_this.productName}, sku: ${_this.sku}, trend: ${_this.trend}, changePercent: ${_this.changePercent}, summary: ${_this.summary}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $ProductInsightCopyWith<$Res>  {
  factory $ProductInsightCopyWith(ProductInsight value, $Res Function(ProductInsight) _then) = _$ProductInsightCopyWithImpl;
@useResult
$Res call({
 int productId, String productName, String sku, TrendDirection? trend, double? changePercent, String? summary, String? error
});




}
/// @nodoc
class _$ProductInsightCopyWithImpl<$Res>
    implements $ProductInsightCopyWith<$Res> {
  _$ProductInsightCopyWithImpl(this._self, this._then);

  final ProductInsight _self;
  final $Res Function(ProductInsight) _then;

/// Create a copy of ProductInsight
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? productName = null,Object? sku = null,Object? trend = freezed,Object? changePercent = freezed,Object? summary = freezed,Object? error = freezed,}) {
  return _then(ProductInsight(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,trend: freezed == trend ? _self.trend : trend // ignore: cast_nullable_to_non_nullable
as TrendDirection?,changePercent: freezed == changePercent ? _self.changePercent : changePercent // ignore: cast_nullable_to_non_nullable
as double?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductInsight].
extension ProductInsightPatterns on ProductInsight {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductInsight value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductInsight() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductInsight value)  $default,){
final _that = this;
switch (_that) {
case _ProductInsight():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductInsight value)?  $default,){
final _that = this;
switch (_that) {
case _ProductInsight() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int productId,  String productName,  String sku,  TrendDirection? trend,  double? changePercent,  String? summary,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductInsight() when $default != null:
return $default(_that.productId,_that.productName,_that.sku,_that.trend,_that.changePercent,_that.summary,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int productId,  String productName,  String sku,  TrendDirection? trend,  double? changePercent,  String? summary,  String? error)  $default,) {final _that = this;
switch (_that) {
case _ProductInsight():
return $default(_that.productId,_that.productName,_that.sku,_that.trend,_that.changePercent,_that.summary,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int productId,  String productName,  String sku,  TrendDirection? trend,  double? changePercent,  String? summary,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _ProductInsight() when $default != null:
return $default(_that.productId,_that.productName,_that.sku,_that.trend,_that.changePercent,_that.summary,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _ProductInsight extends ProductInsight {
  const _ProductInsight({required this.productId, required this.productName, required this.sku, this.trend, this.changePercent, this.summary, this.error}): super._();
  

@override final  int productId;
@override final  String productName;
@override final  String sku;
@override final  TrendDirection? trend;
/// Percentage change between the two compared periods; 0 is a real value,
/// null means there is no result for this product.
@override final  double? changePercent;
/// Ready-to-display Indonesian sentence from the ML service.
@override final  String? summary;
@override final  String? error;

/// Create a copy of ProductInsight
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductInsightCopyWith<_ProductInsight> get copyWith => __$ProductInsightCopyWithImpl<_ProductInsight>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductInsight&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.trend, trend) || other.trend == trend)&&(identical(other.changePercent, changePercent) || other.changePercent == changePercent)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,productId,productName,sku,trend,changePercent,summary,error);
}

@override
String toString() {
    return 'ProductInsight(productId: $productId, productName: $productName, sku: $sku, trend: $trend, changePercent: $changePercent, summary: $summary, error: $error)';
}


}

/// @nodoc
abstract mixin class _$ProductInsightCopyWith<$Res> implements $ProductInsightCopyWith<$Res> {
  factory _$ProductInsightCopyWith(_ProductInsight value, $Res Function(_ProductInsight) _then) = __$ProductInsightCopyWithImpl;
@override @useResult
$Res call({
 int productId, String productName, String sku, TrendDirection? trend, double? changePercent, String? summary, String? error
});




}
/// @nodoc
class __$ProductInsightCopyWithImpl<$Res>
    implements _$ProductInsightCopyWith<$Res> {
  __$ProductInsightCopyWithImpl(this._self, this._then);

  final _ProductInsight _self;
  final $Res Function(_ProductInsight) _then;

/// Create a copy of ProductInsight
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? productName = null,Object? sku = null,Object? trend = freezed,Object? changePercent = freezed,Object? summary = freezed,Object? error = freezed,}) {
  return _then(_ProductInsight(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,trend: freezed == trend ? _self.trend : trend // ignore: cast_nullable_to_non_nullable
as TrendDirection?,changePercent: freezed == changePercent ? _self.changePercent : changePercent // ignore: cast_nullable_to_non_nullable
as double?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$InsightReport {

 AnalyticsRange get range; bool get available; List<ProductInsight> get products;
/// Create a copy of InsightReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InsightReportCopyWith<InsightReport> get copyWith => _$InsightReportCopyWithImpl<InsightReport>(this as InsightReport, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as InsightReport;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InsightReport&&(identical(other.range, _this.range) || other.range == _this.range)&&(identical(other.available, _this.available) || other.available == _this.available)&&const DeepCollectionEquality().equals(other.products, _this.products));
}


@override
int get hashCode {
  final _this = this as InsightReport;
  return Object.hash(runtimeType,_this.range,_this.available,const DeepCollectionEquality().hash(_this.products));
}

@override
String toString() {
  final _this = this as InsightReport;
  return 'InsightReport(range: ${_this.range}, available: ${_this.available}, products: ${_this.products})';
}


}

/// @nodoc
abstract mixin class $InsightReportCopyWith<$Res>  {
  factory $InsightReportCopyWith(InsightReport value, $Res Function(InsightReport) _then) = _$InsightReportCopyWithImpl;
@useResult
$Res call({
 AnalyticsRange range, bool available, List<ProductInsight> products
});


$AnalyticsRangeCopyWith<$Res> get range;

}
/// @nodoc
class _$InsightReportCopyWithImpl<$Res>
    implements $InsightReportCopyWith<$Res> {
  _$InsightReportCopyWithImpl(this._self, this._then);

  final InsightReport _self;
  final $Res Function(InsightReport) _then;

/// Create a copy of InsightReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? range = null,Object? available = null,Object? products = null,}) {
  return _then(InsightReport(
range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as AnalyticsRange,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<ProductInsight>,
  ));
}
/// Create a copy of InsightReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsRangeCopyWith<$Res> get range {
  
  return $AnalyticsRangeCopyWith<$Res>(_self.range, (value) {
    return _then(_self.copyWith(range: value));
  });
}
}


/// Adds pattern-matching-related methods to [InsightReport].
extension InsightReportPatterns on InsightReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InsightReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InsightReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InsightReport value)  $default,){
final _that = this;
switch (_that) {
case _InsightReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InsightReport value)?  $default,){
final _that = this;
switch (_that) {
case _InsightReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AnalyticsRange range,  bool available,  List<ProductInsight> products)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InsightReport() when $default != null:
return $default(_that.range,_that.available,_that.products);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AnalyticsRange range,  bool available,  List<ProductInsight> products)  $default,) {final _that = this;
switch (_that) {
case _InsightReport():
return $default(_that.range,_that.available,_that.products);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AnalyticsRange range,  bool available,  List<ProductInsight> products)?  $default,) {final _that = this;
switch (_that) {
case _InsightReport() when $default != null:
return $default(_that.range,_that.available,_that.products);case _:
  return null;

}
}

}

/// @nodoc


class _InsightReport extends InsightReport {
  const _InsightReport({required this.range, required this.available,  List<ProductInsight> products = const <ProductInsight>[]}): _products = products,super._();
  

@override final  AnalyticsRange range;
@override final  bool available;
 final  List<ProductInsight> _products;
@override@JsonKey() List<ProductInsight> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}


/// Create a copy of InsightReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InsightReportCopyWith<_InsightReport> get copyWith => __$InsightReportCopyWithImpl<_InsightReport>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InsightReport&&(identical(other.range, range) || other.range == range)&&(identical(other.available, available) || other.available == available)&&const DeepCollectionEquality().equals(other.products, _products));
}


@override
int get hashCode {
    return Object.hash(runtimeType,range,available,const DeepCollectionEquality().hash(_products));
}

@override
String toString() {
    return 'InsightReport(range: $range, available: $available, products: $products)';
}


}

/// @nodoc
abstract mixin class _$InsightReportCopyWith<$Res> implements $InsightReportCopyWith<$Res> {
  factory _$InsightReportCopyWith(_InsightReport value, $Res Function(_InsightReport) _then) = __$InsightReportCopyWithImpl;
@override @useResult
$Res call({
 AnalyticsRange range, bool available, List<ProductInsight> products
});


@override $AnalyticsRangeCopyWith<$Res> get range;

}
/// @nodoc
class __$InsightReportCopyWithImpl<$Res>
    implements _$InsightReportCopyWith<$Res> {
  __$InsightReportCopyWithImpl(this._self, this._then);

  final _InsightReport _self;
  final $Res Function(_InsightReport) _then;

/// Create a copy of InsightReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? range = null,Object? available = null,Object? products = null,}) {
  return _then(_InsightReport(
range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as AnalyticsRange,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<ProductInsight>,
  ));
}

/// Create a copy of InsightReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsRangeCopyWith<$Res> get range {
  
  return $AnalyticsRangeCopyWith<$Res>(_self.range, (value) {
    return _then(_self.copyWith(range: value));
  });
}
}

// dart format on
