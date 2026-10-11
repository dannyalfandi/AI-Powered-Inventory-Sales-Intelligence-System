import '../../../../core/error/guard.dart';
import '../../../../core/pagination/paged.dart';
import '../../domain/entities/role.dart';
import '../../domain/repositories/role_repository.dart';
import '../datasources/role_remote_data_source.dart';
import '../models/role_models.dart';

class RoleRepositoryImpl implements RoleRepository {
  const RoleRepositoryImpl(this._remote);

  final RoleRemoteDataSource _remote;

  @override
  Future<PageResult<Role>> getRoles({required int page, required int pageSize}) => guardApiCall(() async {
    final (items, meta) = await _remote.fetchRoles(page: page, pageSize: pageSize);
    return PageResult(
      items: items.map((m) => m.toEntity()).toList(),
      page: meta.page,
      pageSize: meta.pageSize,
      total: meta.total,
    );
  });

  @override
  Future<Role> getRole(int id) => guardApiCall(() async => (await _remote.fetchRole(id)).toEntity());

  @override
  Future<Role> createRole(RoleInput input) => guardApiCall(
    () async => (await _remote.createRole(CreateRoleRequest(name: input.name, description: input.description)))
        .toEntity(),
  );

  @override
  Future<Role> updateRole(int id, RolePatch patch) => guardApiCall(
    () async =>
        (await _remote.updateRole(id, UpdateRoleRequest(name: patch.name, description: patch.description)))
            .toEntity(),
  );

  @override
  Future<void> deleteRole(int id) => guardApiCall(() => _remote.deleteRole(id));

  @override
  Future<Role> setPermissions(int id, List<String> keys) => guardApiCall(
    () async => (await _remote.setPermissions(id, SetRolePermissionsRequest(permissionKeys: keys))).toEntity(),
  );

  @override
  Future<List<CatalogPermission>> getPermissionCatalog() =>
      guardApiCall(() async => (await _remote.fetchPermissions()).map((m) => m.toEntity()).toList());
}
