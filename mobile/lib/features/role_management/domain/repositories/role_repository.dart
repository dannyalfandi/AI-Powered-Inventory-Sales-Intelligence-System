import '../../../../core/pagination/paged.dart';
import '../entities/role.dart';

/// Roles and the permission catalog. Every method throws `Failure`.
abstract interface class RoleRepository {
  Future<PageResult<Role>> getRoles({required int page, required int pageSize});

  Future<Role> getRole(int id);

  Future<Role> createRole(RoleInput input);

  Future<Role> updateRole(int id, RolePatch patch);

  /// 409 while any user (deleted ones included) still has the role, and
  /// always for the system role.
  Future<void> deleteRole(int id);

  /// Replaces the role's permissions with exactly [keys] (the full desired
  /// list, never a diff). Returns the role as saved.
  Future<Role> setPermissions(int id, List<String> keys);

  /// The fixed catalog, descriptions in the app's language.
  Future<List<CatalogPermission>> getPermissionCatalog();

  /// How many (non-deleted) users have the role. The roles endpoint doesn't
  /// report it, so it comes from GET /users?role_id=… — which needs
  /// `users.view`.
  Future<int> countUsers(int roleId);
}
