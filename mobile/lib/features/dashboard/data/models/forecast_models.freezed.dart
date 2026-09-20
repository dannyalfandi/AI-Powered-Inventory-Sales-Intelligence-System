// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'forecast_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ForecastPointModel {

 DateTime get date; double get predictedQuantity;
/// Create a copy of ForecastPointModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForecastPointModelCopyWith<ForecastPointModel> get copyWith => _$ForecastPointModelCopyWithImpl<ForecastPointModel>(this as ForecastPointModel, _$identity);

  /// Serializes this ForecastPointModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ForecastPointModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForecastPointModel&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.predictedQuantity, _this.predictedQuantity) || other.predictedQuantity == _this.predictedQuantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ForecastPointModel;
  return Object.hash(runtimeType,_this.date,_this.predictedQuantity);
}

@override
String toString() {
  final _this = this as ForecastPointModel;
  return 'ForecastPointModel(date: ${_this.date}, predictedQuantity: ${_this.predictedQuantity})';
}


}

/// @nodoc
abstract mixin class $ForecastPointModelCopyWith<$Res>  {
  factory $ForecastPointModelCopyWith(ForecastPointModel value, $Res Function(ForecastPointModel) _then) = _$ForecastPointModelCopyWithImpl;
@useResult
$Res call({
 DateTime date, double predictedQuantity
});




}
/// @nodoc
class _$ForecastPointModelCopyWithImpl<$Res>
    implements $ForecastPointModelCopyWith<$Res> {
  _$ForecastPointModelCopyWithImpl(this._self, this._then);

  final ForecastPointModel _self;
  final $Res Function(ForecastPointModel) _then;

/// Create a copy of ForecastPointModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? predictedQuantity = null,}) {
  return _then(ForecastPointModel(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,predictedQuantity: null == predictedQuantity ? _self.predictedQuantity : predictedQuantity // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ForecastPointModel].
extension ForecastPointModelPatterns on ForecastPointModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ForecastPointModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ForecastPointModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ForecastPointModel value)  $default,){
final _that = this;
switch (_that) {
case _ForecastPointModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ForecastPointModel value)?  $default,){
final _that = this;
switch (_that) {
case _ForecastPointModel() when $default != null:
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
case _ForecastPointModel() when $default != null:
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
case _ForecastPointModel():
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
case _ForecastPointModel() when $default != null:
return $default(_that.date,_that.predictedQuantity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ForecastPointModel extends ForecastPointModel {
  const _ForecastPointModel({required this.date, required this.predictedQuantity}): super._();
  factory _ForecastPointModel.fromJson(Map<String, dynamic> json) => _$ForecastPointModelFromJson(json);

@override final  DateTime date;
@override final  double predictedQuantity;

/// Create a copy of ForecastPointModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForecastPointModelCopyWith<_ForecastPointModel> get copyWith => __$ForecastPointModelCopyWithImpl<_ForecastPointModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ForecastPointModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForecastPointModel&&(identical(other.date, date) || other.date == date)&&(identical(other.predictedQuantity, predictedQuantity) || other.predictedQuantity == predictedQuantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,date,predictedQuantity);
}

@override
String toString() {
    return 'ForecastPointModel(date: $date, predictedQuantity: $predictedQuantity)';
}


}

/// @nodoc
abstract mixin class _$ForecastPointModelCopyWith<$Res> implements $ForecastPointModelCopyWith<$Res> {
  factory _$ForecastPointModelCopyWith(_ForecastPointModel value, $Res Function(_ForecastPointModel) _then) = __$ForecastPointModelCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, double predictedQuantity
});




}
/// @nodoc
class __$ForecastPointModelCopyWithImpl<$Res>
    implements _$ForecastPointModelCopyWith<$Res> {
  __$ForecastPointModelCopyWithImpl(this._self, this._then);

  final _ForecastPointModel _self;
  final $Res Function(_ForecastPointModel) _then;

/// Create a copy of ForecastPointModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? predictedQuantity = null,}) {
  return _then(_ForecastPointModel(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,predictedQuantity: null == predictedQuantity ? _self.predictedQuantity : predictedQuantity // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$ProductForecastModel {

 int get productId; String get productName; String get sku; List<ForecastPointModel> get forecast; String? get method; String? get error;
/// Create a copy of ProductForecastModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductForecastModelCopyWith<ProductForecastModel> get copyWith => _$ProductForecastModelCopyWithImpl<ProductForecastModel>(this as ProductForecastModel, _$identity);

  /// Serializes this ProductForecastModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProductForecastModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductForecastModel&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.productName, _this.productName) || other.productName == _this.productName)&&(identical(other.sku, _this.sku) || other.sku == _this.sku)&&const DeepCollectionEquality().equals(other.forecast, _this.forecast)&&(identical(other.method, _this.method) || other.method == _this.method)&&(identical(other.error, _this.error) || other.error == _this.error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProductForecastModel;
  return Object.hash(runtimeType,_this.productId,_this.productName,_this.sku,const DeepCollectionEquality().hash(_this.forecast),_this.method,_this.error);
}

@override
String toString() {
  final _this = this as ProductForecastModel;
  return 'ProductForecastModel(productId: ${_this.productId}, productName: ${_this.productName}, sku: ${_this.sku}, forecast: ${_this.forecast}, method: ${_this.method}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $ProductForecastModelCopyWith<$Res>  {
  factory $ProductForecastModelCopyWith(ProductForecastModel value, $Res Function(ProductForecastModel) _then) = _$ProductForecastModelCopyWithImpl;
@useResult
$Res call({
 int productId, String productName, String sku, List<ForecastPointModel> forecast, String? method, String? error
});




}
/// @nodoc
class _$ProductForecastModelCopyWithImpl<$Res>
    implements $ProductForecastModelCopyWith<$Res> {
  _$ProductForecastModelCopyWithImpl(this._self, this._then);

  final ProductForecastModel _self;
  final $Res Function(ProductForecastModel) _then;

/// Create a copy of ProductForecastModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? productName = null,Object? sku = null,Object? forecast = null,Object? method = freezed,Object? error = freezed,}) {
  return _then(ProductForecastModel(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,forecast: null == forecast ? _self.forecast : forecast // ignore: cast_nullable_to_non_nullable
as List<ForecastPointModel>,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductForecastModel].
extension ProductForecastModelPatterns on ProductForecastModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductForecastModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductForecastModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductForecastModel value)  $default,){
final _that = this;
switch (_that) {
case _ProductForecastModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductForecastModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProductForecastModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int productId,  String productName,  String sku,  List<ForecastPointModel> forecast,  String? method,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductForecastModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int productId,  String productName,  String sku,  List<ForecastPointModel> forecast,  String? method,  String? error)  $default,) {final _that = this;
switch (_that) {
case _ProductForecastModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int productId,  String productName,  String sku,  List<ForecastPointModel> forecast,  String? method,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _ProductForecastModel() when $default != null:
return $default(_that.productId,_that.productName,_that.sku,_that.forecast,_that.method,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductForecastModel extends ProductForecastModel {
  const _ProductForecastModel({required this.productId, required this.productName, required this.sku,  List<ForecastPointModel> forecast = const <ForecastPointModel>[], this.method, this.error}): _forecast = forecast,super._();
  factory _ProductForecastModel.fromJson(Map<String, dynamic> json) => _$ProductForecastModelFromJson(json);

@override final  int productId;
@override final  String productName;
@override final  String sku;
 final  List<ForecastPointModel> _forecast;
@override@JsonKey() List<ForecastPointModel> get forecast {
  if (_forecast is EqualUnmodifiableListView) return _forecast;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_forecast);
}

@override final  String? method;
@override final  String? error;

/// Create a copy of ProductForecastModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductForecastModelCopyWith<_ProductForecastModel> get copyWith => __$ProductForecastModelCopyWithImpl<_ProductForecastModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductForecastModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductForecastModel&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.sku, sku) || other.sku == sku)&&const DeepCollectionEquality().equals(other.forecast, _forecast)&&(identical(other.method, method) || other.method == method)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,productId,productName,sku,const DeepCollectionEquality().hash(_forecast),method,error);
}

@override
String toString() {
    return 'ProductForecastModel(productId: $productId, productName: $productName, sku: $sku, forecast: $forecast, method: $method, error: $error)';
}


}

/// @nodoc
abstract mixin class _$ProductForecastModelCopyWith<$Res> implements $ProductForecastModelCopyWith<$Res> {
  factory _$ProductForecastModelCopyWith(_ProductForecastModel value, $Res Function(_ProductForecastModel) _then) = __$ProductForecastModelCopyWithImpl;
@override @useResult
$Res call({
 int productId, String productName, String sku, List<ForecastPointModel> forecast, String? method, String? error
});




}
/// @nodoc
class __$ProductForecastModelCopyWithImpl<$Res>
    implements _$ProductForecastModelCopyWith<$Res> {
  __$ProductForecastModelCopyWithImpl(this._self, this._then);

  final _ProductForecastModel _self;
  final $Res Function(_ProductForecastModel) _then;

/// Create a copy of ProductForecastModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? productName = null,Object? sku = null,Object? forecast = null,Object? method = freezed,Object? error = freezed,}) {
  return _then(_ProductForecastModel(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,forecast: null == forecast ? _self._forecast : forecast // ignore: cast_nullable_to_non_nullable
as List<ForecastPointModel>,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ForecastReportModel {

 AnalyticsRangeModel get range; int get horizonDays;@JsonKey(name: 'forecast_available') bool get available; List<ProductForecastModel> get products;
/// Create a copy of ForecastReportModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForecastReportModelCopyWith<ForecastReportModel> get copyWith => _$ForecastReportModelCopyWithImpl<ForecastReportModel>(this as ForecastReportModel, _$identity);

  /// Serializes this ForecastReportModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ForecastReportModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForecastReportModel&&(identical(other.range, _this.range) || other.range == _this.range)&&(identical(other.horizonDays, _this.horizonDays) || other.horizonDays == _this.horizonDays)&&(identical(other.available, _this.available) || other.available == _this.available)&&const DeepCollectionEquality().equals(other.products, _this.products));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ForecastReportModel;
  return Object.hash(runtimeType,_this.range,_this.horizonDays,_this.available,const DeepCollectionEquality().hash(_this.products));
}

@override
String toString() {
  final _this = this as ForecastReportModel;
  return 'ForecastReportModel(range: ${_this.range}, horizonDays: ${_this.horizonDays}, available: ${_this.available}, products: ${_this.products})';
}


}

/// @nodoc
abstract mixin class $ForecastReportModelCopyWith<$Res>  {
  factory $ForecastReportModelCopyWith(ForecastReportModel value, $Res Function(ForecastReportModel) _then) = _$ForecastReportModelCopyWithImpl;
@useResult
$Res call({
 AnalyticsRangeModel range, int horizonDays,@JsonKey(name: 'forecast_available') bool available, List<ProductForecastModel> products
});


$AnalyticsRangeModelCopyWith<$Res> get range;

}
/// @nodoc
class _$ForecastReportModelCopyWithImpl<$Res>
    implements $ForecastReportModelCopyWith<$Res> {
  _$ForecastReportModelCopyWithImpl(this._self, this._then);

  final ForecastReportModel _self;
  final $Res Function(ForecastReportModel) _then;

/// Create a copy of ForecastReportModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? range = null,Object? horizonDays = null,Object? available = null,Object? products = null,}) {
  return _then(ForecastReportModel(
range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as AnalyticsRangeModel,horizonDays: null == horizonDays ? _self.horizonDays : horizonDays // ignore: cast_nullable_to_non_nullable
as int,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<ProductForecastModel>,
  ));
}
/// Create a copy of ForecastReportModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsRangeModelCopyWith<$Res> get range {
  
  return $AnalyticsRangeModelCopyWith<$Res>(_self.range, (value) {
    return _then(_self.copyWith(range: value));
  });
}
}


/// Adds pattern-matching-related methods to [ForecastReportModel].
extension ForecastReportModelPatterns on ForecastReportModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ForecastReportModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ForecastReportModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ForecastReportModel value)  $default,){
final _that = this;
switch (_that) {
case _ForecastReportModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ForecastReportModel value)?  $default,){
final _that = this;
switch (_that) {
case _ForecastReportModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AnalyticsRangeModel range,  int horizonDays, @JsonKey(name: 'forecast_available')  bool available,  List<ProductForecastModel> products)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ForecastReportModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AnalyticsRangeModel range,  int horizonDays, @JsonKey(name: 'forecast_available')  bool available,  List<ProductForecastModel> products)  $default,) {final _that = this;
switch (_that) {
case _ForecastReportModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AnalyticsRangeModel range,  int horizonDays, @JsonKey(name: 'forecast_available')  bool available,  List<ProductForecastModel> products)?  $default,) {final _that = this;
switch (_that) {
case _ForecastReportModel() when $default != null:
return $default(_that.range,_that.horizonDays,_that.available,_that.products);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ForecastReportModel extends ForecastReportModel {
  const _ForecastReportModel({required this.range, required this.horizonDays, @JsonKey(name: 'forecast_available') required this.available,  List<ProductForecastModel> products = const <ProductForecastModel>[]}): _products = products,super._();
  factory _ForecastReportModel.fromJson(Map<String, dynamic> json) => _$ForecastReportModelFromJson(json);

@override final  AnalyticsRangeModel range;
@override final  int horizonDays;
@override@JsonKey(name: 'forecast_available') final  bool available;
 final  List<ProductForecastModel> _products;
@override@JsonKey() List<ProductForecastModel> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}


/// Create a copy of ForecastReportModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForecastReportModelCopyWith<_ForecastReportModel> get copyWith => __$ForecastReportModelCopyWithImpl<_ForecastReportModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ForecastReportModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForecastReportModel&&(identical(other.range, range) || other.range == range)&&(identical(other.horizonDays, horizonDays) || other.horizonDays == horizonDays)&&(identical(other.available, available) || other.available == available)&&const DeepCollectionEquality().equals(other.products, _products));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,range,horizonDays,available,const DeepCollectionEquality().hash(_products));
}

@override
String toString() {
    return 'ForecastReportModel(range: $range, horizonDays: $horizonDays, available: $available, products: $products)';
}


}

/// @nodoc
abstract mixin class _$ForecastReportModelCopyWith<$Res> implements $ForecastReportModelCopyWith<$Res> {
  factory _$ForecastReportModelCopyWith(_ForecastReportModel value, $Res Function(_ForecastReportModel) _then) = __$ForecastReportModelCopyWithImpl;
@override @useResult
$Res call({
 AnalyticsRangeModel range, int horizonDays,@JsonKey(name: 'forecast_available') bool available, List<ProductForecastModel> products
});


@override $AnalyticsRangeModelCopyWith<$Res> get range;

}
/// @nodoc
class __$ForecastReportModelCopyWithImpl<$Res>
    implements _$ForecastReportModelCopyWith<$Res> {
  __$ForecastReportModelCopyWithImpl(this._self, this._then);

  final _ForecastReportModel _self;
  final $Res Function(_ForecastReportModel) _then;

/// Create a copy of ForecastReportModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? range = null,Object? horizonDays = null,Object? available = null,Object? products = null,}) {
  return _then(_ForecastReportModel(
range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as AnalyticsRangeModel,horizonDays: null == horizonDays ? _self.horizonDays : horizonDays // ignore: cast_nullable_to_non_nullable
as int,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<ProductForecastModel>,
  ));
}

/// Create a copy of ForecastReportModel
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
mixin _$ProductInsightModel {

 int get productId; String get productName; String get sku; String? get trend; double? get changePercent; String? get summary; String? get error;
/// Create a copy of ProductInsightModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductInsightModelCopyWith<ProductInsightModel> get copyWith => _$ProductInsightModelCopyWithImpl<ProductInsightModel>(this as ProductInsightModel, _$identity);

  /// Serializes this ProductInsightModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProductInsightModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductInsightModel&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.productName, _this.productName) || other.productName == _this.productName)&&(identical(other.sku, _this.sku) || other.sku == _this.sku)&&(identical(other.trend, _this.trend) || other.trend == _this.trend)&&(identical(other.changePercent, _this.changePercent) || other.changePercent == _this.changePercent)&&(identical(other.summary, _this.summary) || other.summary == _this.summary)&&(identical(other.error, _this.error) || other.error == _this.error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProductInsightModel;
  return Object.hash(runtimeType,_this.productId,_this.productName,_this.sku,_this.trend,_this.changePercent,_this.summary,_this.error);
}

@override
String toString() {
  final _this = this as ProductInsightModel;
  return 'ProductInsightModel(productId: ${_this.productId}, productName: ${_this.productName}, sku: ${_this.sku}, trend: ${_this.trend}, changePercent: ${_this.changePercent}, summary: ${_this.summary}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $ProductInsightModelCopyWith<$Res>  {
  factory $ProductInsightModelCopyWith(ProductInsightModel value, $Res Function(ProductInsightModel) _then) = _$ProductInsightModelCopyWithImpl;
@useResult
$Res call({
 int productId, String productName, String sku, String? trend, double? changePercent, String? summary, String? error
});




}
/// @nodoc
class _$ProductInsightModelCopyWithImpl<$Res>
    implements $ProductInsightModelCopyWith<$Res> {
  _$ProductInsightModelCopyWithImpl(this._self, this._then);

  final ProductInsightModel _self;
  final $Res Function(ProductInsightModel) _then;

/// Create a copy of ProductInsightModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? productName = null,Object? sku = null,Object? trend = freezed,Object? changePercent = freezed,Object? summary = freezed,Object? error = freezed,}) {
  return _then(ProductInsightModel(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,trend: freezed == trend ? _self.trend : trend // ignore: cast_nullable_to_non_nullable
as String?,changePercent: freezed == changePercent ? _self.changePercent : changePercent // ignore: cast_nullable_to_non_nullable
as double?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductInsightModel].
extension ProductInsightModelPatterns on ProductInsightModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductInsightModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductInsightModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductInsightModel value)  $default,){
final _that = this;
switch (_that) {
case _ProductInsightModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductInsightModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProductInsightModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int productId,  String productName,  String sku,  String? trend,  double? changePercent,  String? summary,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductInsightModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int productId,  String productName,  String sku,  String? trend,  double? changePercent,  String? summary,  String? error)  $default,) {final _that = this;
switch (_that) {
case _ProductInsightModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int productId,  String productName,  String sku,  String? trend,  double? changePercent,  String? summary,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _ProductInsightModel() when $default != null:
return $default(_that.productId,_that.productName,_that.sku,_that.trend,_that.changePercent,_that.summary,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductInsightModel extends ProductInsightModel {
  const _ProductInsightModel({required this.productId, required this.productName, required this.sku, this.trend, this.changePercent, this.summary, this.error}): super._();
  factory _ProductInsightModel.fromJson(Map<String, dynamic> json) => _$ProductInsightModelFromJson(json);

@override final  int productId;
@override final  String productName;
@override final  String sku;
@override final  String? trend;
@override final  double? changePercent;
@override final  String? summary;
@override final  String? error;

/// Create a copy of ProductInsightModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductInsightModelCopyWith<_ProductInsightModel> get copyWith => __$ProductInsightModelCopyWithImpl<_ProductInsightModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductInsightModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductInsightModel&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.trend, trend) || other.trend == trend)&&(identical(other.changePercent, changePercent) || other.changePercent == changePercent)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,productId,productName,sku,trend,changePercent,summary,error);
}

@override
String toString() {
    return 'ProductInsightModel(productId: $productId, productName: $productName, sku: $sku, trend: $trend, changePercent: $changePercent, summary: $summary, error: $error)';
}


}

/// @nodoc
abstract mixin class _$ProductInsightModelCopyWith<$Res> implements $ProductInsightModelCopyWith<$Res> {
  factory _$ProductInsightModelCopyWith(_ProductInsightModel value, $Res Function(_ProductInsightModel) _then) = __$ProductInsightModelCopyWithImpl;
@override @useResult
$Res call({
 int productId, String productName, String sku, String? trend, double? changePercent, String? summary, String? error
});




}
/// @nodoc
class __$ProductInsightModelCopyWithImpl<$Res>
    implements _$ProductInsightModelCopyWith<$Res> {
  __$ProductInsightModelCopyWithImpl(this._self, this._then);

  final _ProductInsightModel _self;
  final $Res Function(_ProductInsightModel) _then;

/// Create a copy of ProductInsightModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? productName = null,Object? sku = null,Object? trend = freezed,Object? changePercent = freezed,Object? summary = freezed,Object? error = freezed,}) {
  return _then(_ProductInsightModel(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,trend: freezed == trend ? _self.trend : trend // ignore: cast_nullable_to_non_nullable
as String?,changePercent: freezed == changePercent ? _self.changePercent : changePercent // ignore: cast_nullable_to_non_nullable
as double?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$InsightReportModel {

 AnalyticsRangeModel get range;@JsonKey(name: 'insights_available') bool get available; List<ProductInsightModel> get products;
/// Create a copy of InsightReportModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InsightReportModelCopyWith<InsightReportModel> get copyWith => _$InsightReportModelCopyWithImpl<InsightReportModel>(this as InsightReportModel, _$identity);

  /// Serializes this InsightReportModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as InsightReportModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InsightReportModel&&(identical(other.range, _this.range) || other.range == _this.range)&&(identical(other.available, _this.available) || other.available == _this.available)&&const DeepCollectionEquality().equals(other.products, _this.products));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as InsightReportModel;
  return Object.hash(runtimeType,_this.range,_this.available,const DeepCollectionEquality().hash(_this.products));
}

@override
String toString() {
  final _this = this as InsightReportModel;
  return 'InsightReportModel(range: ${_this.range}, available: ${_this.available}, products: ${_this.products})';
}


}

/// @nodoc
abstract mixin class $InsightReportModelCopyWith<$Res>  {
  factory $InsightReportModelCopyWith(InsightReportModel value, $Res Function(InsightReportModel) _then) = _$InsightReportModelCopyWithImpl;
@useResult
$Res call({
 AnalyticsRangeModel range,@JsonKey(name: 'insights_available') bool available, List<ProductInsightModel> products
});


$AnalyticsRangeModelCopyWith<$Res> get range;

}
/// @nodoc
class _$InsightReportModelCopyWithImpl<$Res>
    implements $InsightReportModelCopyWith<$Res> {
  _$InsightReportModelCopyWithImpl(this._self, this._then);

  final InsightReportModel _self;
  final $Res Function(InsightReportModel) _then;

/// Create a copy of InsightReportModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? range = null,Object? available = null,Object? products = null,}) {
  return _then(InsightReportModel(
range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as AnalyticsRangeModel,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<ProductInsightModel>,
  ));
}
/// Create a copy of InsightReportModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsRangeModelCopyWith<$Res> get range {
  
  return $AnalyticsRangeModelCopyWith<$Res>(_self.range, (value) {
    return _then(_self.copyWith(range: value));
  });
}
}


/// Adds pattern-matching-related methods to [InsightReportModel].
extension InsightReportModelPatterns on InsightReportModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InsightReportModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InsightReportModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InsightReportModel value)  $default,){
final _that = this;
switch (_that) {
case _InsightReportModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InsightReportModel value)?  $default,){
final _that = this;
switch (_that) {
case _InsightReportModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AnalyticsRangeModel range, @JsonKey(name: 'insights_available')  bool available,  List<ProductInsightModel> products)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InsightReportModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AnalyticsRangeModel range, @JsonKey(name: 'insights_available')  bool available,  List<ProductInsightModel> products)  $default,) {final _that = this;
switch (_that) {
case _InsightReportModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AnalyticsRangeModel range, @JsonKey(name: 'insights_available')  bool available,  List<ProductInsightModel> products)?  $default,) {final _that = this;
switch (_that) {
case _InsightReportModel() when $default != null:
return $default(_that.range,_that.available,_that.products);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InsightReportModel extends InsightReportModel {
  const _InsightReportModel({required this.range, @JsonKey(name: 'insights_available') required this.available,  List<ProductInsightModel> products = const <ProductInsightModel>[]}): _products = products,super._();
  factory _InsightReportModel.fromJson(Map<String, dynamic> json) => _$InsightReportModelFromJson(json);

@override final  AnalyticsRangeModel range;
@override@JsonKey(name: 'insights_available') final  bool available;
 final  List<ProductInsightModel> _products;
@override@JsonKey() List<ProductInsightModel> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}


/// Create a copy of InsightReportModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InsightReportModelCopyWith<_InsightReportModel> get copyWith => __$InsightReportModelCopyWithImpl<_InsightReportModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InsightReportModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InsightReportModel&&(identical(other.range, range) || other.range == range)&&(identical(other.available, available) || other.available == available)&&const DeepCollectionEquality().equals(other.products, _products));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,range,available,const DeepCollectionEquality().hash(_products));
}

@override
String toString() {
    return 'InsightReportModel(range: $range, available: $available, products: $products)';
}


}

/// @nodoc
abstract mixin class _$InsightReportModelCopyWith<$Res> implements $InsightReportModelCopyWith<$Res> {
  factory _$InsightReportModelCopyWith(_InsightReportModel value, $Res Function(_InsightReportModel) _then) = __$InsightReportModelCopyWithImpl;
@override @useResult
$Res call({
 AnalyticsRangeModel range,@JsonKey(name: 'insights_available') bool available, List<ProductInsightModel> products
});


@override $AnalyticsRangeModelCopyWith<$Res> get range;

}
/// @nodoc
class __$InsightReportModelCopyWithImpl<$Res>
    implements _$InsightReportModelCopyWith<$Res> {
  __$InsightReportModelCopyWithImpl(this._self, this._then);

  final _InsightReportModel _self;
  final $Res Function(_InsightReportModel) _then;

/// Create a copy of InsightReportModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? range = null,Object? available = null,Object? products = null,}) {
  return _then(_InsightReportModel(
range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as AnalyticsRangeModel,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<ProductInsightModel>,
  ));
}

/// Create a copy of InsightReportModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsRangeModelCopyWith<$Res> get range {
  
  return $AnalyticsRangeModelCopyWith<$Res>(_self.range, (value) {
    return _then(_self.copyWith(range: value));
  });
}
}

// dart format on
