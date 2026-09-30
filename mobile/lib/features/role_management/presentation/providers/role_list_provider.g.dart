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

/// Every role, for the user form's role picker. Invalidated whenever roles
/// are created, renamed or deleted.

@ProviderFor(roleOptions)
final roleOptionsProvider = RoleOptionsProvider._();

/// Every role, for the user form's role picker. Invalidated whenever roles
/// are created, renamed or deleted.

final class RoleOptionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Role>>,
          List<Role>,
          FutureOr<List<Role>>
        >
    with $FutureModifier<List<Role>>, $FutureProvider<List<Role>> {
  /// Every role, for the user form's role picker. Invalidated whenever roles
  /// are created, renamed or deleted.
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

/// How many users have the role (non-deleted; from GET /users). Only watched
/// by users who hold `users.view` — the call needs it.

@ProviderFor(roleUserCount)
final roleUserCountProvider = RoleUserCountFamily._();

/// How many users have the role (non-deleted; from GET /users). Only watched
/// by users who hold `users.view` — the call needs it.

final class RoleUserCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  /// How many users have the role (non-deleted; from GET /users). Only watched
  /// by users who hold `users.view` — the call needs it.
  RoleUserCountProvider._({
    required RoleUserCountFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'roleUserCountProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$roleUserCountHash();

  @override
  String toString() {
    return r'roleUserCountProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    final argument = this.argument as int;
    return roleUserCount(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RoleUserCountProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$roleUserCountHash() => r'1cd3d5bc7aaedff992f882849184fa774010cfe6';

/// How many users have the role (non-deleted; from GET /users). Only watched
/// by users who hold `users.view` — the call needs it.

final class RoleUserCountFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<int>, int> {
  RoleUserCountFamily._()
    : super(
        retry: null,
        name: r'roleUserCountProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// How many users have the role (non-deleted; from GET /users). Only watched
  /// by users who hold `users.view` — the call needs it.

  RoleUserCountProvider call(int roleId) =>
      RoleUserCountProvider._(argument: roleId, from: this);

  @override
  String toString() => r'roleUserCountProvider';
}

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
