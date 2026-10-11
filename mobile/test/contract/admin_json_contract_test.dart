import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/core/error/failure_mapper.dart';
import 'package:inventory_intel/core/network/page_meta_model.dart';
import 'package:inventory_intel/features/role_management/data/models/role_models.dart';
import 'package:inventory_intel/features/role_management/domain/entities/role.dart';
import 'package:inventory_intel/features/user_management/data/models/user_models.dart';

import '../helpers/admin_json.dart';

// JSON below was captured from the running Go API (admin@example.com, seeded
// data) on 2026-09-29 — not written from memory. See the endpoint list in
// backend/README.md; differences from what the client first assumed are
// noted next to the test that pins them.

Failure _map(int status, Map<String, dynamic> body, {String path = '/api/v1/roles'}) {
  final req = RequestOptions(path: path);
  return mapDioException(
    DioException.badResponse(
      statusCode: status,
      requestOptions: req,
      response: Response(requestOptions: req, statusCode: status, data: body),
    ),
  );
}

void main() {
  group('GET /api/v1/permissions', () {
    test('catalog entries: id, key, localized description, resource_group', () {
      final body = {
        'data': [
          {'id': 1, 'key': 'products.view', 'description': 'View the product list and details', 'resource_group': 'products'},
          {'id': 2, 'key': 'products.create', 'description': 'Create products', 'resource_group': 'products'},
          {'id': 9, 'key': 'inventory.view', 'description': 'View stock, movement history and low stock', 'resource_group': 'inventory'},
        ],
      };
      final perms = (body['data']!).map((e) => CatalogPermissionModel.fromJson(e).toEntity()).toList();

      expect(perms.first, const CatalogPermission(
        id: 1, key: 'products.view', description: 'View the product list and details', group: 'products',
      ));
      // The API provides the grouping; the app groups by it, in API order.
      final groups = groupPermissions(perms);
      expect(groups.map((g) => g.code), ['products', 'inventory']);
      expect(groups.first.permissions.map((p) => p.key), ['products.view', 'products.create']);
    });
  });

  group('roles', () {
    List<Role> rolesOf(String json) => ((jsonDecode(json) as Map<String, dynamic>)['data'] as List)
        .map((e) => RoleModel.fromJson(e as Map<String, dynamic>).toEntity())
        .toList();
    Role roleOf(String json) =>
        RoleModel.fromJson((jsonDecode(json) as Map<String, dynamic>)['data'] as Map<String, dynamic>).toEntity();

    test('GET /roles: every role carries user_count (0 included), with its permission keys and meta', () {
      final roles = rolesOf(adminGetRoles);
      final meta = PageMetaModel.fromJson((jsonDecode(adminGetRoles) as Map<String, dynamic>)['meta'] as Map<String, dynamic>);

      expect(meta.total, 5);
      expect([for (final r in roles) (r.name.split(' ').take(2).join(' '), r.userCount)], [
        ('Super Admin', 1),
        ('E2E Baru', 0),
        ('E2E Gudang', 2),
        ('E2E UserMgr', 1),
        ('Staff', 1),
      ]);
      // The system role lists the whole catalog (32 keys), not an empty list.
      expect(roles.first.isSystem, isTrue);
      expect(roles.first.permissions, hasLength(32));
      expect(roles.last.permissions, hasLength(12), reason: 'the seeded Staff role');
      for (final r in (jsonDecode(adminGetRoles) as Map<String, dynamic>)['data'] as List) {
        expect(r as Map, contains('user_count'), reason: 'never omitted, not even at 0');
      }
    });

    test('user_count counts deleted users too: Gudang says 2 while GET /users lists only 1 of them', () {
      // One of the two Gudang users was soft-deleted before the capture.
      expect(roleOf(adminGetRole).userCount, 2);
      final listed = ((jsonDecode(adminGetUsers) as Map<String, dynamic>)['data'] as List)
          .map((e) => UserModel.fromJson(e as Map<String, dynamic>).toEntity())
          .where((u) => u.roleId == 170);
      expect(listed, hasLength(1));
    });

    test('GET /roles/:id and POST /roles: user_count too; a new role has 0 and "permissions": []', () {
      final gudang = roleOf(adminGetRole);
      expect(gudang.permissions, ['products.view', 'inventory.view', 'inventory.record_movement']);
      final created = roleOf(adminPostRole);
      expect(created.userCount, 0);
      expect(created.permissions, isEmpty);
    });

    test('a role without user_count is rejected, never read as 0', () {
      final noCount = (jsonDecode(adminGetRole) as Map<String, dynamic>)['data'] as Map<String, dynamic>
        ..remove('user_count');
      expect(() => RoleModel.fromJson(noCount), throwsA(anything));
    });

    test('a user manager reads the same list (users.create/update, no roles.view)', () {
      expect(rolesOf(managerGetRoles).map((r) => (r.id, r.userCount)), rolesOf(adminGetRoles).map((r) => (r.id, r.userCount)));
    });

    test('…but not the detail nor the catalog: 403 naming roles.view', () {
      for (final body in [managerGetRole, managerGetPermissions]) {
        final f = _map(403, jsonDecode(body) as Map<String, dynamic>) as ServerFailure;
        expect(f.isForbidden, isTrue);
        expect(f.code, 'forbidden');
        expect(f.message, 'anda tidak punya izin roles.view');
      }
    });

    test('409 on delete: the count in the sentence is the role\'s user_count', () {
      final id = _map(409, jsonDecode(deleteRoleInUseId) as Map<String, dynamic>) as ServerFailure;
      final en = _map(409, jsonDecode(deleteRoleInUseEn) as Map<String, dynamic>) as ServerFailure;
      expect(id.isConflict, isTrue);
      expect(id.message, 'role 170 masih terhubung dengan 2 pengguna (termasuk yang sudah dihapus)');
      expect(en.message, 'role 170 is still linked to 2 user(s), including deleted ones');
      expect(roleOf(adminGetRole).userCount, 2);
    });

    test('request bodies: create, partial patch, and PUT with permission **keys**', () {
      expect(const CreateRoleRequest(name: 'Gudang', description: 'stok').toJson(), {'name': 'Gudang', 'description': 'stok'});
      expect(const UpdateRoleRequest(description: 'stok & gudang').toJson(), {'description': 'stok & gudang'},
          reason: 'omitted fields stay unchanged');
      // Differs from the brief ("id/code"): the endpoint takes keys.
      expect(const SetRolePermissionsRequest(permissionKeys: ['inventory.view', 'inventory.record_movement']).toJson(),
          {'permission_keys': ['inventory.view', 'inventory.record_movement']});
    });

    test('409 on delete while linked to users (deleted ones included) — the sentence is kept', () {
      final f = _map(409, {
        'error': {'code': 'conflict', 'message': 'role 53 masih terhubung dengan 1 pengguna (termasuk yang sudah dihapus)'},
      });
      expect(f, isA<ServerFailure>().having((s) => s.isConflict, 'conflict', isTrue));
      expect(f.message, 'role 53 masih terhubung dengan 1 pengguna (termasuk yang sudah dihapus)');
    });

    test('409 on the system role (rename, delete, permissions)', () {
      final f = _map(409, {
        'error': {'code': 'conflict', 'message': 'role sistem "Super Admin" tidak bisa dihapus, diganti nama, atau diatur izinnya'},
      });
      expect((f as ServerFailure).isConflict, isTrue);
    });

    test('422 on an unknown permission key, per index; 422 on an empty name', () {
      final unknown = _map(422, {
        'error': {
          'code': 'validation_failed',
          'message': 'request validation failed',
          'details': [
            {'field': 'permission_keys[1]', 'message': 'unknown permission "nope.nope"'},
          ],
        },
      });
      expect((unknown as ValidationFailure).messages, {'permission_keys[1]': 'unknown permission "nope.nope"'});

      final name = _map(422, {
        'error': {
          'code': 'validation_failed',
          'message': 'request validation failed',
          'details': [
            {'field': 'name', 'message': 'is required'},
          ],
        },
      });
      expect((name as ValidationFailure).messages, {'name': 'is required'});
    });

    test('403 without the permission', () {
      final f = _map(403, {
        'error': {'code': 'forbidden', 'message': 'anda tidak punya izin roles.assign_permissions'},
      });
      expect((f as ServerFailure).statusCode, 403);
      expect(f.code, 'forbidden');
    });
  });

  group('users', () {
    test('GET /users: role embedded with "permissions": null; meta', () {
      final body = {
        'data': [
          {
            'id': 2,
            'email': 'staff@example.com',
            'name': 'Staf Demo',
            'role_id': 2,
            'role': {
              'id': 2,
              'name': 'Staff',
              'description': 'Staf operasional: melihat semua data, membuat dan memproses pesanan.',
              'is_system': false,
              'created_at': '2026-09-26T13:09:00.686718+07:00',
              'updated_at': '2026-09-26T13:09:00.692974+07:00',
              'permissions': null,
            },
            'is_active': true,
            'created_at': '2026-09-26T13:09:00.839647+07:00',
            'updated_at': '2026-09-26T13:09:00.839647+07:00',
          },
        ],
        'meta': {'page': 1, 'page_size': 2, 'total': 3},
      };
      final u = UserModel.fromJson((body['data']! as List).first as Map<String, dynamic>).toEntity();

      expect(u.name, 'Staf Demo');
      expect(u.roleId, 2);
      expect(u.roleName, 'Staff');
      expect(u.roleIsSystem, isFalse);
      expect(u.isActive, isTrue);
      expect(((body['data']! as List).first as Map).containsKey('password_hash'), isFalse);
    });

    test('PATCH /users/:id response: the new role and is_active', () {
      final u = UserModel.fromJson({
        'id': 61,
        'email': 'e2e.capture@example.test',
        'name': 'E2E Capture Renamed',
        'role_id': 2,
        'role': {
          'id': 2,
          'name': 'Staff',
          'description': '',
          'is_system': false,
          'created_at': '2026-09-26T13:09:00.686718+07:00',
          'updated_at': '2026-09-26T13:09:00.692974+07:00',
          'permissions': ['products.view'],
        },
        'is_active': false,
        'created_at': '2026-09-29T12:57:52.66782+07:00',
        'updated_at': '2026-09-29T12:57:52.752212+07:00',
      }).toEntity();
      expect(u.isActive, isFalse);
      expect(u.roleId, 2);
    });

    test('request bodies: create has every field; PATCH only the changed ones (password included)', () {
      expect(
        const CreateUserRequest(email: 'a@b.co', password: 'rahasia123', name: 'A', roleId: 3, isActive: true).toJson(),
        {'email': 'a@b.co', 'password': 'rahasia123', 'name': 'A', 'role_id': 3, 'is_active': true},
      );
      expect(const UpdateUserRequest(roleId: 2, isActive: false).toJson(), {'role_id': 2, 'is_active': false});
      // The backend does accept a new password on PATCH (min 8).
      expect(const UpdateUserRequest(password: 'baru-rahasia').toJson(), {'password': 'baru-rahasia'});
    });

    test('422 with every invalid field; 409 duplicate email; 409 self-protection', () {
      final invalid = _map(422, {
        'error': {
          'code': 'validation_failed',
          'message': 'request validation failed',
          'details': [
            {'field': 'email', 'message': 'must be a valid email address'},
            {'field': 'name', 'message': 'is required'},
            {'field': 'password', 'message': 'must be at least 8 characters'},
            {'field': 'role_id', 'message': 'does not exist'},
          ],
        },
      }, path: '/api/v1/users');
      expect((invalid as ValidationFailure).messages.keys, ['email', 'name', 'password', 'role_id']);

      final dup = _map(409, {'error': {'code': 'conflict', 'message': 'email sudah dipakai pengguna lain'}}, path: '/api/v1/users');
      expect((dup as ServerFailure).isConflict, isTrue);

      final self = _map(409, {'error': {'code': 'conflict', 'message': 'tidak bisa menonaktifkan atau menghapus akun sendiri'}},
          path: '/api/v1/users/1');
      expect(self.message, 'tidak bisa menonaktifkan atau menghapus akun sendiri');
    });
  });
  group('users and the "only what you hold" rule (captured 2026-10-09)', () {
    Map<String, dynamic> dataOf(String json) => (jsonDecode(json) as Map<String, dynamic>)['data'] as Map<String, dynamic>;

    test('GET /users: the embedded role has "permissions": null and no user_count', () {
      final rows = (jsonDecode(adminGetUsers) as Map<String, dynamic>)['data'] as List;
      for (final row in rows) {
        final role = (row as Map<String, dynamic>)['role'] as Map<String, dynamic>;
        expect(role['permissions'], isNull);
        expect(role, isNot(contains('user_count')));
      }
      final u = UserModel.fromJson(rows.first as Map<String, dynamic>).toEntity();
      expect((u.roleId, u.roleName, u.roleIsSystem), (170, 'E2E Gudang 1791539033', false));
    });

    test('POST /users answer: its embedded role DOES carry permissions and a user_count taken before the insert', () {
      // Differs from the brief ("a role inside a user has no user_count"):
      // after a create the embedded role says 2 although the role now has 3.
      // The app reads only id/name/is_system from it, so nothing stale leaks.
      final role = dataOf(managerCreateGudang)['role'] as Map<String, dynamic>;
      expect(role['user_count'], 2);
      expect(role['permissions'], hasLength(3));
      final u = UserModel.fromJson(dataOf(managerCreateGudang)).toEntity();
      expect((u.roleId, u.roleName, u.roleIsSystem), (170, 'E2E Gudang 1791539033', false));
    });

    test('403 for a role beyond the caller\'s permissions: the translated sentence, kept as is', () {
      final id = _map(403, jsonDecode(managerAssignStaffId) as Map<String, dynamic>, path: '/api/v1/users') as ServerFailure;
      final en = _map(403, jsonDecode(managerAssignStaffEn) as Map<String, dynamic>, path: '/api/v1/users') as ServerFailure;
      expect(id.isForbidden, isTrue);
      expect(id.code, 'forbidden');
      expect(id.message,
          'tidak bisa memberikan role "Staff" karena role itu punya izin "categories.view" yang tidak anda miliki sendiri');
      expect(en.message,
          'you can\'t assign the "Staff" role because it has the "categories.view" permission, which you don\'t hold yourself');
    });

    test('403 for changing a user out of scope, and the older 403s, share the envelope', () {
      final cases = {
        managerPatchStaff:
            'tidak bisa mengubah atau menghapus pengguna dengan role "Staff" karena role itu punya izin "categories.view" yang tidak anda miliki sendiri',
        managerPatchSuperAdmin: 'hanya Super Admin yang bisa memberikan role sistem atau mengubah akun Super Admin',
        managerDeleteNoPerm: 'anda tidak punya izin users.delete',
      };
      cases.forEach((json, message) {
        final f = _map(403, jsonDecode(json) as Map<String, dynamic>, path: '/api/v1/users/2') as ServerFailure;
        expect((f.statusCode, f.code, f.message), (403, 'forbidden', message));
      });
    });
  });
}
