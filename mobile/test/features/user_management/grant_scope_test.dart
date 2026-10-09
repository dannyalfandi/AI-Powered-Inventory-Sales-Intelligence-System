import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/auth/permissions.dart';
import 'package:inventory_intel/features/auth/domain/entities/auth_user.dart';
import 'package:inventory_intel/features/role_management/domain/entities/role.dart';
import 'package:inventory_intel/features/user_management/domain/grant_scope.dart';

import '../../helpers/admin_fixtures.dart';
import '../../helpers/auth_fixtures.dart';

// The app's copy of backend grant_scope.go, as a matrix: who (Super Admin,
// a user manager whose permissions cover Staff and Gudang, one with only
// users.*) against which role / which user.

/// Holds more than any manager here.
final powerRole = role(5, name: 'Power', permissions: const [
  Permissions.productsView,
  Permissions.productsDelete,
  Permissions.usersDelete,
]);

/// Grants nothing: within everyone's scope.
final guestRole = role(6, name: 'Tamu');

AuthUser _manager(int id, Set<String> permissions) => AuthUser(
  id: id,
  email: 'manager$id@example.com',
  name: 'Manager $id',
  role: AuthRole(id: 40 + id, name: 'Manager $id', isSystem: false),
  permissions: permissions,
);

/// users.* plus Staff's and Gudang's permissions.
final managerEnough = _manager(20, {
  Permissions.usersView,
  Permissions.usersCreate,
  Permissions.usersUpdate,
  Permissions.productsView,
  Permissions.salesOrdersCreate,
  Permissions.inventoryView,
});

/// users.* only: not even Staff.
final managerShort = _manager(21, {
  Permissions.usersView,
  Permissions.usersCreate,
  Permissions.usersUpdate,
  Permissions.usersDelete,
});

void main() {
  final actors = <String, AuthUser>{
    'Super Admin': superAdmin,
    'manager (enough)': managerEnough,
    'manager (short)': managerShort,
  };

  group('canGrantRole', () {
    final roles = <String, Role>{
      'Staff': staffRole,
      'custom subset (Gudang)': gudangRole,
      'custom beyond (Power)': powerRole,
      'empty role': guestRole,
      'Super Admin': superAdminRole,
    };
    const expected = <String, Map<String, bool>>{
      'Super Admin': {
        'Staff': true,
        'custom subset (Gudang)': true,
        'custom beyond (Power)': true,
        'empty role': true,
        'Super Admin': true,
      },
      'manager (enough)': {
        'Staff': true,
        'custom subset (Gudang)': true,
        'custom beyond (Power)': false,
        'empty role': true,
        'Super Admin': false,
      },
      'manager (short)': {
        'Staff': false,
        'custom subset (Gudang)': false,
        'custom beyond (Power)': false,
        'empty role': true,
        'Super Admin': false,
      },
    };

    for (final MapEntry(key: who, value: me) in actors.entries) {
      for (final MapEntry(key: what, value: r) in roles.entries) {
        test('$who → $what', () => expect(canGrantRole(me, r), expected[who]![what]));
      }
    }

    test('the system role is never grantable by a non-Super-Admin, even holding every listed key', () {
      final holdsAll = _manager(30, superAdminRole.permissions.toSet());
      expect(canGrantRole(holdsAll, superAdminRole), isFalse);
    });
  });

  group('canManageUser', () {
    final rolesById = {for (final r in [superAdminRole, staffRole, gudangRole, powerRole]) r.id: r};
    final unknownRole = role(99, name: 'Unknown');

    // The target users. "own account" is built per actor.
    final targets = <String, dynamic>{
      'Staff': managedUser(101, role: staffRole),
      'custom subset (Gudang)': managedUser(102, role: gudangRole),
      'custom beyond (Power)': managedUser(103, role: powerRole),
      'Super Admin': managedUser(104, role: superAdminRole),
      'own account': null,
      'role not in the list': managedUser(105, role: unknownRole),
    };
    const a = ManageAccess.allowed, d = ManageAccess.denied, u = ManageAccess.unknown;
    const expected = <String, Map<String, ManageAccess>>{
      'Super Admin': {
        'Staff': a,
        'custom subset (Gudang)': a,
        'custom beyond (Power)': a,
        'Super Admin': a,
        'own account': a,
        'role not in the list': a,
      },
      'manager (enough)': {
        'Staff': a,
        'custom subset (Gudang)': a,
        'custom beyond (Power)': d,
        'Super Admin': d,
        'own account': a,
        'role not in the list': u,
      },
      'manager (short)': {
        'Staff': d,
        'custom subset (Gudang)': d,
        'custom beyond (Power)': d,
        'Super Admin': d,
        'own account': a,
        'role not in the list': u,
      },
    };

    for (final MapEntry(key: who, value: me) in actors.entries) {
      for (final what in targets.keys) {
        test('$who → $what', () {
          // Your own account carries a role you hold by definition; give it
          // one that isn't in the list, to show "self" wins over "unknown".
          final target = what == 'own account' ? managedUser(me.id, role: role(me.role.id)) : targets[what];
          expect(canManageUser(me, target, rolesById), expected[who]![what]);
        });
      }
    }

    test('role list unknown (not loaded, or not readable): unknown — nothing is hidden', () {
      expect(canManageUser(managerEnough, managedUser(101, role: staffRole), null), ManageAccess.unknown);
      expect(canManageUser(managerShort, managedUser(103, role: powerRole), null), ManageAccess.unknown);
    });

    test('…except a Super Admin target, known from the embedded is_system alone', () {
      expect(canManageUser(managerEnough, managedUser(104, role: superAdminRole), null), ManageAccess.denied);
      expect(canManageUser(superAdmin, managedUser(104, role: superAdminRole), null), ManageAccess.allowed);
    });
  });
}
