import '../entities/role.dart';
import '../repositories/role_repository.dart';

class GetPermissionCatalog {
  const GetPermissionCatalog(this._repository);

  final RoleRepository _repository;

  Future<List<CatalogPermission>> call() => _repository.getPermissionCatalog();
}
