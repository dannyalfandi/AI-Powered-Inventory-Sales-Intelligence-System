// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'page_meta_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PageMetaModel {

 int get page; int get pageSize; int get total;
/// Create a copy of PageMetaModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PageMetaModelCopyWith<PageMetaModel> get copyWith => _$PageMetaModelCopyWithImpl<PageMetaModel>(this as PageMetaModel, _$identity);

  /// Serializes this PageMetaModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PageMetaModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PageMetaModel&&(identical(other.page, _this.page) || other.page == _this.page)&&(identical(other.pageSize, _this.pageSize) || other.pageSize == _this.pageSize)&&(identical(other.total, _this.total) || other.total == _this.total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PageMetaModel;
  return Object.hash(runtimeType,_this.page,_this.pageSize,_this.total);
}

@override
String toString() {
  final _this = this as PageMetaModel;
  return 'PageMetaModel(page: ${_this.page}, pageSize: ${_this.pageSize}, total: ${_this.total})';
}


}

/// @nodoc
abstract mixin class $PageMetaModelCopyWith<$Res>  {
  factory $PageMetaModelCopyWith(PageMetaModel value, $Res Function(PageMetaModel) _then) = _$PageMetaModelCopyWithImpl;
@useResult
$Res call({
 int page, int pageSize, int total
});




}
/// @nodoc
class _$PageMetaModelCopyWithImpl<$Res>
    implements $PageMetaModelCopyWith<$Res> {
  _$PageMetaModelCopyWithImpl(this._self, this._then);

  final PageMetaModel _self;
  final $Res Function(PageMetaModel) _then;

/// Create a copy of PageMetaModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? page = null,Object? pageSize = null,Object? total = null,}) {
  return _then(PageMetaModel(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PageMetaModel].
extension PageMetaModelPatterns on PageMetaModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PageMetaModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PageMetaModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PageMetaModel value)  $default,){
final _that = this;
switch (_that) {
case _PageMetaModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PageMetaModel value)?  $default,){
final _that = this;
switch (_that) {
case _PageMetaModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int page,  int pageSize,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PageMetaModel() when $default != null:
return $default(_that.page,_that.pageSize,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int page,  int pageSize,  int total)  $default,) {final _that = this;
switch (_that) {
case _PageMetaModel():
return $default(_that.page,_that.pageSize,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int page,  int pageSize,  int total)?  $default,) {final _that = this;
switch (_that) {
case _PageMetaModel() when $default != null:
return $default(_that.page,_that.pageSize,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PageMetaModel implements PageMetaModel {
  const _PageMetaModel({required this.page, required this.pageSize, required this.total});
  factory _PageMetaModel.fromJson(Map<String, dynamic> json) => _$PageMetaModelFromJson(json);

@override final  int page;
@override final  int pageSize;
@override final  int total;

/// Create a copy of PageMetaModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PageMetaModelCopyWith<_PageMetaModel> get copyWith => __$PageMetaModelCopyWithImpl<_PageMetaModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PageMetaModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PageMetaModel&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,page,pageSize,total);
}

@override
String toString() {
    return 'PageMetaModel(page: $page, pageSize: $pageSize, total: $total)';
}


}

/// @nodoc
abstract mixin class _$PageMetaModelCopyWith<$Res> implements $PageMetaModelCopyWith<$Res> {
  factory _$PageMetaModelCopyWith(_PageMetaModel value, $Res Function(_PageMetaModel) _then) = __$PageMetaModelCopyWithImpl;
@override @useResult
$Res call({
 int page, int pageSize, int total
});




}
/// @nodoc
class __$PageMetaModelCopyWithImpl<$Res>
    implements _$PageMetaModelCopyWith<$Res> {
  __$PageMetaModelCopyWithImpl(this._self, this._then);

  final _PageMetaModel _self;
  final $Res Function(_PageMetaModel) _then;

/// Create a copy of PageMetaModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? page = null,Object? pageSize = null,Object? total = null,}) {
  return _then(_PageMetaModel(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
