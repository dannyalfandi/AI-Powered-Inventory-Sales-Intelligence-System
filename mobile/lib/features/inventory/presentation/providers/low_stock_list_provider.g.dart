// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'low_stock_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Products at or below their low-stock threshold, lowest stock first.

@ProviderFor(LowStockList)
final lowStockListProvider = LowStockListProvider._();

/// Products at or below their low-stock threshold, lowest stock first.
final class LowStockListProvider
    extends $AsyncNotifierProvider<LowStockList, PagedState<LowStockItem>> {
  /// Products at or below their low-stock threshold, lowest stock first.
  LowStockListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lowStockListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lowStockListHash();

  @$internal
  @override
  LowStockList create() => LowStockList();
}

String _$lowStockListHash() => r'a78b641eac5aa9724820e05e14b0dd606dd0014c';

/// Products at or below their low-stock threshold, lowest stock first.

abstract class _$LowStockList extends $AsyncNotifier<PagedState<LowStockItem>> {
  FutureOr<PagedState<LowStockItem>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<PagedState<LowStockItem>>,
              PagedState<LowStockItem>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PagedState<LowStockItem>>,
                PagedState<LowStockItem>
              >,
              AsyncValue<PagedState<LowStockItem>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
