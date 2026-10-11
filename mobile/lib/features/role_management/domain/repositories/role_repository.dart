import '../../../../core/pagination/paged.dart';
import '../entities/role.dart';

/// Roles and the permission catalog. Every method throws `Failure`.
///
/// Each role carries its `userCount` (backend `user_count`), so nothing
/// here asks GET /users how many users a role has.
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
}
