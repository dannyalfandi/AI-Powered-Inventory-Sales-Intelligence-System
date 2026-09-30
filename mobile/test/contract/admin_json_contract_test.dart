import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/core/error/failure_mapper.dart';
import 'package:inventory_intel/core/network/page_meta_model.dart';
import 'package:inventory_intel/features/role_management/data/models/role_models.dart';
import 'package:inventory_intel/features/role_management/domain/entities/role.dart';
import 'package:inventory_intel/features/user_management/data/models/user_models.dart';

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
    final staffJson = {
      'id': 2,
      'name': 'Staff',
      'description': 'Staf operasional: melihat semua data, membuat dan memproses pesanan.',
      'is_system': false,
      'created_at': '2026-09-26T13:09:00.686718+07:00',
      'updated_at': '2026-09-26T13:09:00.692974+07:00',
      'permissions': ['products.view', 'categories.view', 'sales_orders.create'],
    };

    test('GET /roles: list with permission keys and meta — but no user count', () {
      final body = {
        'data': [
          {
            'id': 1,
            'name': 'Super Admin',
            'description': 'Akses penuh ke seluruh sistem, termasuk pengguna dan role. Tidak bisa dihapus.',
            'is_system': true,
            'created_at': '2026-09-26T13:09:00.678113+07:00',
            'updated_at': '2026-09-26T13:09:00.678113+07:00',
            'permissions': ['products.view', 'roles.assign_permissions'],
          },
          staffJson,
        ],
        'meta': {'page': 1, 'page_size': 20, 'total': 14},
      };
      final roles = (body['data']! as List).map((e) => RoleModel.fromJson(e as Map<String, dynamic>).toEntity()).toList();
      final meta = PageMetaModel.fromJson(body['meta']! as Map<String, dynamic>);

      expect(roles.first.isSystem, isTrue);
      expect(roles.last.permissions, hasLength(3), reason: 'the permission count is derivable');
      expect(meta.total, 14);
      // Differs from the brief: there is no user count on a role. The app
      // reads it from GET /users?role_id=…&page_size=1 → meta.total.
      expect((body['data']! as List).first as Map, isNot(contains('user_count')));
    });

    test('GET /roles/:id and POST /roles: a new role has "permissions": []', () {
      final created = RoleModel.fromJson({
        'id': 51,
        'name': 'E2E Gudang Capture',
        'description': 'stok saja',
        'is_system': false,
        'created_at': '2026-09-29T12:57:52.5005255+07:00',
        'updated_at': '2026-09-29T12:57:52.5005255+07:00',
        'permissions': <String>[],
      }).toEntity();
      expect(created.permissions, isEmpty);
      expect(RoleModel.fromJson(staffJson).toEntity().name, 'Staff');
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
}
