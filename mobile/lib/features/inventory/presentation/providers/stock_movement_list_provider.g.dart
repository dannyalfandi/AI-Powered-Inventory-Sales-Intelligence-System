// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_movement_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Movement history of one product, newest first, loaded page by page.

@ProviderFor(StockMovementList)
final stockMovementListProvider = StockMovementListFamily._();

/// Movement history of one product, newest first, loaded page by page.
final class StockMovementListProvider
    extends
        $AsyncNotifierProvider<StockMovementList, PagedState<StockMovement>> {
  /// Movement history of one product, newest first, loaded page by page.
  StockMovementListProvider._({
    required StockMovementListFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'stockMovementListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$stockMovementListHash();

  @override
  String toString() {
    return r'stockMovementListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  StockMovementList create() => StockMovementList();

  @override
  bool operator ==(Object other) {
    return other is StockMovementListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$stockMovementListHash() => r'2214f88078245cde7ad437172e1ebe1d9461ef2f';

/// Movement history of one product, newest first, loaded page by page.

final class StockMovementListFamily extends $Family
    with
        $ClassFamilyOverride<
          StockMovementList,
          AsyncValue<PagedState<StockMovement>>,
          PagedState<StockMovement>,
          FutureOr<PagedState<StockMovement>>,
          int
        > {
  StockMovementListFamily._()
    : super(
        retry: null,
        name: r'stockMovementListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Movement history of one product, newest first, loaded page by page.

  StockMovementListProvider call(int productId) =>
      StockMovementListProvider._(argument: productId, from: this);

  @override
  String toString() => r'stockMovementListProvider';
}

/// Movement history of one product, newest first, loaded page by page.

abstract class _$StockMovementList
    extends $AsyncNotifier<PagedState<StockMovement>> {
  late final _$args = ref.$arg as int;
  int get productId => _$args;

  FutureOr<PagedState<StockMovement>> build(int productId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<PagedState<StockMovement>>,
              PagedState<StockMovement>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PagedState<StockMovement>>,
                PagedState<StockMovement>
              >,
              AsyncValue<PagedState<StockMovement>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
