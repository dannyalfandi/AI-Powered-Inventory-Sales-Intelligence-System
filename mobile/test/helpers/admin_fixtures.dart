import 'package:inventory_intel/core/pagination/paged.dart';
import 'package:inventory_intel/features/role_management/domain/entities/role.dart';
import 'package:inventory_intel/features/role_management/domain/repositories/role_repository.dart';
import 'package:inventory_intel/features/user_management/domain/entities/managed_user.dart';
import 'package:inventory_intel/features/user_management/domain/repositories/user_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockRoleRepository extends Mock implements RoleRepository {}

class MockUserRepository extends Mock implements UserRepository {}

final _ts = DateTime.utc(2026, 9, 26);

Role role(
  int id, {
  String? name,
  bool isSystem = false,
  List<String> permissions = const [],
  String description = '',
  int userCount = 0,
}) => Role(
  id: id,
  name: name ?? 'Role $id',
  description: description,
  isSystem: isSystem,
  permissions: permissions,
  userCount: userCount,
  createdAt: _ts,
  updatedAt: _ts,
);

final superAdminRole =
    role(1, name: 'Super Admin', isSystem: true, permissions: const ['products.view', 'users.delete'], userCount: 1);
final staffRole = role(2, name: 'Staff', permissions: const ['products.view', 'sales_orders.create'], userCount: 1);

/// No user yet: the one role here that may be offered for deletion.
final gudangRole = role(3, name: 'Gudang', permissions: const ['inventory.view']);

PageResult<Role> rolePage(List<Role> items) =>
    PageResult(items: items, page: 1, pageSize: 100, total: items.length);

/// A slice of the real catalog (three groups), in the API's order.
const catalog = [
  CatalogPermission(id: 1, key: 'products.view', description: 'View products', group: 'products'),
  CatalogPermission(id: 2, key: 'products.create', description: 'Create products', group: 'products'),
  CatalogPermission(id: 9, key: 'inventory.view', description: 'View stock', group: 'inventory'),
  CatalogPermission(id: 11, key: 'inventory.record_movement', description: 'Record movements', group: 'inventory'),
  CatalogPermission(id: 24, key: 'users.view', description: 'View users', group: 'users'),
];

ManagedUser managedUser(int id, {String? name, String? email, Role? role, bool isActive = true}) {
  final r = role ?? staffRole;
  return ManagedUser(
    id: id,
    email: email ?? 'user$id@example.com',
    name: name ?? 'User $id',
    roleId: r.id,
    roleName: r.name,
    roleIsSystem: r.isSystem,
    isActive: isActive,
    createdAt: _ts,
  );
}

PageResult<ManagedUser> userPage(List<ManagedUser> items, {int page = 1, int pageSize = 20, int? total}) =>
    PageResult(items: items, page: page, pageSize: pageSize, total: total ?? items.length);

void registerAdminFallbacks() {
  registerFallbackValue(const RoleInput(name: ''));
  registerFallbackValue(const RolePatch());
  registerFallbackValue(const UserInput(email: '', password: '', name: '', roleId: null));
  registerFallbackValue(const UserPatch());
  registerFallbackValue(<String>[]);
}
