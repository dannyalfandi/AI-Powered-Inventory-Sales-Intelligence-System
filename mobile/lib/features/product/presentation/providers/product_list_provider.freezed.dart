// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_list_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductListState {

 List<Product> get items; int get page; int get pageSize; int get total; String get search; bool get isLoadingMore; Failure? get loadMoreError;
/// Create a copy of ProductListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductListStateCopyWith<ProductListState> get copyWith => _$ProductListStateCopyWithImpl<ProductListState>(this as ProductListState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProductListState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductListState&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.page, _this.page) || other.page == _this.page)&&(identical(other.pageSize, _this.pageSize) || other.pageSize == _this.pageSize)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.search, _this.search) || other.search == _this.search)&&(identical(other.isLoadingMore, _this.isLoadingMore) || other.isLoadingMore == _this.isLoadingMore)&&(identical(other.loadMoreError, _this.loadMoreError) || other.loadMoreError == _this.loadMoreError));
}


@override
int get hashCode {
  final _this = this as ProductListState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.page,_this.pageSize,_this.total,_this.search,_this.isLoadingMore,_this.loadMoreError);
}

@override
String toString() {
  final _this = this as ProductListState;
  return 'ProductListState(items: ${_this.items}, page: ${_this.page}, pageSize: ${_this.pageSize}, total: ${_this.total}, search: ${_this.search}, isLoadingMore: ${_this.isLoadingMore}, loadMoreError: ${_this.loadMoreError})';
}


}

/// @nodoc
abstract mixin class $ProductListStateCopyWith<$Res>  {
  factory $ProductListStateCopyWith(ProductListState value, $Res Function(ProductListState) _then) = _$ProductListStateCopyWithImpl;
@useResult
$Res call({
 List<Product> items, int page, int pageSize, int total, String search, bool isLoadingMore, Failure? loadMoreError
});




}
/// @nodoc
class _$ProductListStateCopyWithImpl<$Res>
    implements $ProductListStateCopyWith<$Res> {
  _$ProductListStateCopyWithImpl(this._self, this._then);

  final ProductListState _self;
  final $Res Function(ProductListState) _then;

/// Create a copy of ProductListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? page = null,Object? pageSize = null,Object? total = null,Object? search = null,Object? isLoadingMore = null,Object? loadMoreError = freezed,}) {
  return _then(ProductListState(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Product>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,loadMoreError: freezed == loadMoreError ? _self.loadMoreError : loadMoreError // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductListState].
extension ProductListStatePatterns on ProductListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductListState value)  $default,){
final _that = this;
switch (_that) {
case _ProductListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductListState value)?  $default,){
final _that = this;
switch (_that) {
case _ProductListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Product> items,  int page,  int pageSize,  int total,  String search,  bool isLoadingMore,  Failure? loadMoreError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductListState() when $default != null:
return $default(_that.items,_that.page,_that.pageSize,_that.total,_that.search,_that.isLoadingMore,_that.loadMoreError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Product> items,  int page,  int pageSize,  int total,  String search,  bool isLoadingMore,  Failure? loadMoreError)  $default,) {final _that = this;
switch (_that) {
case _ProductListState():
return $default(_that.items,_that.page,_that.pageSize,_that.total,_that.search,_that.isLoadingMore,_that.loadMoreError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Product> items,  int page,  int pageSize,  int total,  String search,  bool isLoadingMore,  Failure? loadMoreError)?  $default,) {final _that = this;
switch (_that) {
case _ProductListState() when $default != null:
return $default(_that.items,_that.page,_that.pageSize,_that.total,_that.search,_that.isLoadingMore,_that.loadMoreError);case _:
  return null;

}
}

}

/// @nodoc


class _ProductListState extends ProductListState {
  const _ProductListState({required  List<Product> items, required this.page, required this.pageSize, required this.total, this.search = '', this.isLoadingMore = false, this.loadMoreError}): _items = items,super._();
  

 final  List<Product> _items;
@override List<Product> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int page;
@override final  int pageSize;
@override final  int total;
@override@JsonKey() final  String search;
@override@JsonKey() final  bool isLoadingMore;
@override final  Failure? loadMoreError;

/// Create a copy of ProductListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductListStateCopyWith<_ProductListState> get copyWith => __$ProductListStateCopyWithImpl<_ProductListState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductListState&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.total, total) || other.total == total)&&(identical(other.search, search) || other.search == search)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.loadMoreError, loadMoreError) || other.loadMoreError == loadMoreError));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),page,pageSize,total,search,isLoadingMore,loadMoreError);
}

@override
String toString() {
    return 'ProductListState(items: $items, page: $page, pageSize: $pageSize, total: $total, search: $search, isLoadingMore: $isLoadingMore, loadMoreError: $loadMoreError)';
}


}

/// @nodoc
abstract mixin class _$ProductListStateCopyWith<$Res> implements $ProductListStateCopyWith<$Res> {
  factory _$ProductListStateCopyWith(_ProductListState value, $Res Function(_ProductListState) _then) = __$ProductListStateCopyWithImpl;
@override @useResult
$Res call({
 List<Product> items, int page, int pageSize, int total, String search, bool isLoadingMore, Failure? loadMoreError
});




}
/// @nodoc
class __$ProductListStateCopyWithImpl<$Res>
    implements _$ProductListStateCopyWith<$Res> {
  __$ProductListStateCopyWithImpl(this._self, this._then);

  final _ProductListState _self;
  final $Res Function(_ProductListState) _then;

/// Create a copy of ProductListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? page = null,Object? pageSize = null,Object? total = null,Object? search = null,Object? isLoadingMore = null,Object? loadMoreError = freezed,}) {
  return _then(_ProductListState(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Product>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,loadMoreError: freezed == loadMoreError ? _self.loadMoreError : loadMoreError // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
