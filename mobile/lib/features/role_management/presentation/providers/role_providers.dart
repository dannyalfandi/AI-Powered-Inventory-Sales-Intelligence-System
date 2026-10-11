import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/datasources/role_remote_data_source.dart';
import '../../data/repositories/role_repository_impl.dart';
import '../../domain/repositories/role_repository.dart';
import '../../domain/usecases/create_role.dart';
import '../../domain/usecases/delete_role.dart';
import '../../domain/usecases/get_permission_catalog.dart';
import '../../domain/usecases/get_role.dart';
import '../../domain/usecases/get_roles.dart';
import '../../domain/usecases/set_role_permissions.dart';
import '../../domain/usecases/update_role.dart';

part 'role_providers.g.dart';

// Dependency graph for role management. Tests override roleRepositoryProvider.

@Riverpod(keepAlive: true)
RoleRemoteDataSource roleRemoteDataSource(Ref ref) => RoleRemoteDataSourceImpl(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
RoleRepository roleRepository(Ref ref) => RoleRepositoryImpl(ref.watch(roleRemoteDataSourceProvider));

@Riverpod(keepAlive: true)
GetRoles getRolesUseCase(Ref ref) => GetRoles(ref.watch(roleRepositoryProvider));

@Riverpod(keepAlive: true)
GetRole getRoleUseCase(Ref ref) => GetRole(ref.watch(roleRepositoryProvider));

@Riverpod(keepAlive: true)
CreateRole createRoleUseCase(Ref ref) => CreateRole(ref.watch(roleRepositoryProvider));

@Riverpod(keepAlive: true)
UpdateRole updateRoleUseCase(Ref ref) => UpdateRole(ref.watch(roleRepositoryProvider));

@Riverpod(keepAlive: true)
DeleteRole deleteRoleUseCase(Ref ref) => DeleteRole(ref.watch(roleRepositoryProvider));

@Riverpod(keepAlive: true)
SetRolePermissions setRolePermissionsUseCase(Ref ref) => SetRolePermissions(ref.watch(roleRepositoryProvider));

@Riverpod(keepAlive: true)
GetPermissionCatalog getPermissionCatalogUseCase(Ref ref) => GetPermissionCatalog(ref.watch(roleRepositoryProvider));
