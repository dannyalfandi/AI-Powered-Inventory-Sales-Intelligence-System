// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_refresher.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The app's [PermissionRefresher]: refreshes through
/// [AuthController.refreshPermissions], and hears every 403 the network layer
/// reports ([permissionDeniedProvider]). `InventoryApp` creates it at start
/// and calls [PermissionRefresher.onResumed] on every resume.

@ProviderFor(permissionRefresher)
final permissionRefresherProvider = PermissionRefresherProvider._();

/// The app's [PermissionRefresher]: refreshes through
/// [AuthController.refreshPermissions], and hears every 403 the network layer
/// reports ([permissionDeniedProvider]). `InventoryApp` creates it at start
/// and calls [PermissionRefresher.onResumed] on every resume.

final class PermissionRefresherProvider
    extends
        $FunctionalProvider<
          PermissionRefresher,
          PermissionRefresher,
          PermissionRefresher
        >
    with $Provider<PermissionRefresher> {
  /// The app's [PermissionRefresher]: refreshes through
  /// [AuthController.refreshPermissions], and hears every 403 the network layer
  /// reports ([permissionDeniedProvider]). `InventoryApp` creates it at start
  /// and calls [PermissionRefresher.onResumed] on every resume.
  PermissionRefresherProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'permissionRefresherProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$permissionRefresherHash();

  @$internal
  @override
  $ProviderElement<PermissionRefresher> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PermissionRefresher create(Ref ref) {
    return permissionRefresher(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PermissionRefresher value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PermissionRefresher>(value),
    );
  }
}

String _$permissionRefresherHash() =>
    r'86fc2faf2e9a7603cabe77cb719d5d17a7804ccd';
