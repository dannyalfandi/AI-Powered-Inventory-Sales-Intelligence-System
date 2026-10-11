// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Every role, system role first (the backend's order). Roles are few, so
/// the list loads them all instead of paging.

@ProviderFor(RoleList)
final roleListProvider = RoleListProvider._();

/// Every role, system role first (the backend's order). Roles are few, so
/// the list loads them all instead of paging.
final class RoleListProvider
    extends $AsyncNotifierProvider<RoleList, List<Role>> {
  /// Every role, system role first (the backend's order). Roles are few, so
  /// the list loads them all instead of paging.
  RoleListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'roleListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$roleListHash();

  @$internal
  @override
  RoleList create() => RoleList();
}

String _$roleListHash() => r'b1899c7aa8a57fad876b201c07b349b97643c1df';

/// Every role, system role first (the backend's order). Roles are few, so
/// the list loads them all instead of paging.

abstract class _$RoleList extends $AsyncNotifier<List<Role>> {
  FutureOr<List<Role>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Role>>, List<Role>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Role>>, List<Role>>,
              AsyncValue<List<Role>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Every role, for the user form's role picker and for deciding which users
/// the caller may manage (see `grant_scope.dart`). Invalidated whenever roles
/// are created, renamed, re-permissioned or deleted. GET /roles answers for
/// `Permissions.roleList` (roles.view, users.create or users.update); callers
/// without one of those must not watch this.

@ProviderFor(roleOptions)
final roleOptionsProvider = RoleOptionsProvider._();

/// Every role, for the user form's role picker and for deciding which users
/// the caller may manage (see `grant_scope.dart`). Invalidated whenever roles
/// are created, renamed, re-permissioned or deleted. GET /roles answers for
/// `Permissions.roleList` (roles.view, users.create or users.update); callers
/// without one of those must not watch this.

final class RoleOptionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Role>>,
          List<Role>,
          FutureOr<List<Role>>
        >
    with $FutureModifier<List<Role>>, $FutureProvider<List<Role>> {
  /// Every role, for the user form's role picker and for deciding which users
  /// the caller may manage (see `grant_scope.dart`). Invalidated whenever roles
  /// are created, renamed, re-permissioned or deleted. GET /roles answers for
  /// `Permissions.roleList` (roles.view, users.create or users.update); callers
  /// without one of those must not watch this.
  RoleOptionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'roleOptionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$roleOptionsHash();

  @$internal
  @override
  $FutureProviderElement<List<Role>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Role>> create(Ref ref) {
    return roleOptions(ref);
  }
}

String _$roleOptionsHash() => r'e1e5f88cfe29b8ef6c7db3ff749b45f088b4ca0b';

/// The fixed permission catalog, descriptions in the app's language.

@ProviderFor(permissionCatalog)
final permissionCatalogProvider = PermissionCatalogProvider._();

/// The fixed permission catalog, descriptions in the app's language.

final class PermissionCatalogProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CatalogPermission>>,
          List<CatalogPermission>,
          FutureOr<List<CatalogPermission>>
        >
    with
        $FutureModifier<List<CatalogPermission>>,
        $FutureProvider<List<CatalogPermission>> {
  /// The fixed permission catalog, descriptions in the app's language.
  PermissionCatalogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'permissionCatalogProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$permissionCatalogHash();

  @$internal
  @override
  $FutureProviderElement<List<CatalogPermission>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CatalogPermission>> create(Ref ref) {
    return permissionCatalog(ref);
  }
}

String _$permissionCatalogHash() => r'56a896de896f0f4cb1f3547ddd4b0dfbf0b4f934';
