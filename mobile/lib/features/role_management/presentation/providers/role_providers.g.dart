// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(roleRemoteDataSource)
final roleRemoteDataSourceProvider = RoleRemoteDataSourceProvider._();

final class RoleRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          RoleRemoteDataSource,
          RoleRemoteDataSource,
          RoleRemoteDataSource
        >
    with $Provider<RoleRemoteDataSource> {
  RoleRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'roleRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$roleRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<RoleRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RoleRemoteDataSource create(Ref ref) {
    return roleRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RoleRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RoleRemoteDataSource>(value),
    );
  }
}

String _$roleRemoteDataSourceHash() =>
    r'1582db446c4dbbca40f3a138bf264245e147bec4';

@ProviderFor(roleRepository)
final roleRepositoryProvider = RoleRepositoryProvider._();

final class RoleRepositoryProvider
    extends $FunctionalProvider<RoleRepository, RoleRepository, RoleRepository>
    with $Provider<RoleRepository> {
  RoleRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'roleRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$roleRepositoryHash();

  @$internal
  @override
  $ProviderElement<RoleRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RoleRepository create(Ref ref) {
    return roleRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RoleRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RoleRepository>(value),
    );
  }
}

String _$roleRepositoryHash() => r'8fcf4371506693b1495b1014a985371dc2ca7270';

@ProviderFor(getRolesUseCase)
final getRolesUseCaseProvider = GetRolesUseCaseProvider._();

final class GetRolesUseCaseProvider
    extends $FunctionalProvider<GetRoles, GetRoles, GetRoles>
    with $Provider<GetRoles> {
  GetRolesUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getRolesUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getRolesUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetRoles> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetRoles create(Ref ref) {
    return getRolesUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetRoles value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetRoles>(value),
    );
  }
}

String _$getRolesUseCaseHash() => r'd76d69abf9618baa508e0a21e766d1968ff0d027';

@ProviderFor(getRoleUseCase)
final getRoleUseCaseProvider = GetRoleUseCaseProvider._();

final class GetRoleUseCaseProvider
    extends $FunctionalProvider<GetRole, GetRole, GetRole>
    with $Provider<GetRole> {
  GetRoleUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getRoleUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getRoleUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetRole> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetRole create(Ref ref) {
    return getRoleUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetRole value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetRole>(value),
    );
  }
}

String _$getRoleUseCaseHash() => r'900ad9915383da734026517ac146f4016c5f21f7';

@ProviderFor(createRoleUseCase)
final createRoleUseCaseProvider = CreateRoleUseCaseProvider._();

final class CreateRoleUseCaseProvider
    extends $FunctionalProvider<CreateRole, CreateRole, CreateRole>
    with $Provider<CreateRole> {
  CreateRoleUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createRoleUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createRoleUseCaseHash();

  @$internal
  @override
  $ProviderElement<CreateRole> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CreateRole create(Ref ref) {
    return createRoleUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateRole value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateRole>(value),
    );
  }
}

String _$createRoleUseCaseHash() => r'403b3ec33b33851252c38acd8c6808f4063a1eed';

@ProviderFor(updateRoleUseCase)
final updateRoleUseCaseProvider = UpdateRoleUseCaseProvider._();

final class UpdateRoleUseCaseProvider
    extends $FunctionalProvider<UpdateRole, UpdateRole, UpdateRole>
    with $Provider<UpdateRole> {
  UpdateRoleUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateRoleUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateRoleUseCaseHash();

  @$internal
  @override
  $ProviderElement<UpdateRole> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UpdateRole create(Ref ref) {
    return updateRoleUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateRole value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateRole>(value),
    );
  }
}

String _$updateRoleUseCaseHash() => r'189ae45d81d690f3f1ce3e8a9ef5aaa87c151fa0';

@ProviderFor(deleteRoleUseCase)
final deleteRoleUseCaseProvider = DeleteRoleUseCaseProvider._();

final class DeleteRoleUseCaseProvider
    extends $FunctionalProvider<DeleteRole, DeleteRole, DeleteRole>
    with $Provider<DeleteRole> {
  DeleteRoleUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteRoleUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteRoleUseCaseHash();

  @$internal
  @override
  $ProviderElement<DeleteRole> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DeleteRole create(Ref ref) {
    return deleteRoleUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeleteRole value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeleteRole>(value),
    );
  }
}

String _$deleteRoleUseCaseHash() => r'313a73a86e2a8f84fbf5ab481a7e393344093086';

@ProviderFor(setRolePermissionsUseCase)
final setRolePermissionsUseCaseProvider = SetRolePermissionsUseCaseProvider._();

final class SetRolePermissionsUseCaseProvider
    extends
        $FunctionalProvider<
          SetRolePermissions,
          SetRolePermissions,
          SetRolePermissions
        >
    with $Provider<SetRolePermissions> {
  SetRolePermissionsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'setRolePermissionsUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$setRolePermissionsUseCaseHash();

  @$internal
  @override
  $ProviderElement<SetRolePermissions> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SetRolePermissions create(Ref ref) {
    return setRolePermissionsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SetRolePermissions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SetRolePermissions>(value),
    );
  }
}

String _$setRolePermissionsUseCaseHash() =>
    r'1c56a6eaa49b5607bc0a6d73685502175505022e';

@ProviderFor(getPermissionCatalogUseCase)
final getPermissionCatalogUseCaseProvider =
    GetPermissionCatalogUseCaseProvider._();

final class GetPermissionCatalogUseCaseProvider
    extends
        $FunctionalProvider<
          GetPermissionCatalog,
          GetPermissionCatalog,
          GetPermissionCatalog
        >
    with $Provider<GetPermissionCatalog> {
  GetPermissionCatalogUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getPermissionCatalogUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getPermissionCatalogUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetPermissionCatalog> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetPermissionCatalog create(Ref ref) {
    return getPermissionCatalogUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetPermissionCatalog value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetPermissionCatalog>(value),
    );
  }
}

String _$getPermissionCatalogUseCaseHash() =>
    r'a9cfc893920b6a27349e82a711f45bdb4c19aa91';
