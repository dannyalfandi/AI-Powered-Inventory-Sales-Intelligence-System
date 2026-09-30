import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/core/validation/field_issue.dart';
import 'package:inventory_intel/features/role_management/domain/entities/role.dart';
import 'package:inventory_intel/features/role_management/domain/usecases/create_role.dart';
import 'package:inventory_intel/features/role_management/domain/usecases/get_roles.dart';
import 'package:inventory_intel/features/role_management/domain/usecases/set_role_permissions.dart';
import 'package:inventory_intel/features/role_management/domain/usecases/update_role.dart';
import 'package:inventory_intel/features/role_management/presentation/providers/role_form_provider.dart';
import 'package:inventory_intel/features/role_management/presentation/providers/role_list_provider.dart';
import 'package:inventory_intel/features/role_management/presentation/providers/role_providers.dart';
import 'package:inventory_intel/core/pagination/paged.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/admin_fixtures.dart';

const _conflict = ServerFailure(
  'role 3 masih terhubung dengan 2 pengguna (termasuk yang sudah dihapus)',
  statusCode: 409,
  code: 'conflict',
);
const _forbidden = ServerFailure('anda tidak punya izin roles.assign_permissions', statusCode: 403, code: 'forbidden');
const _nameRequired = ValidationFailure('request validation failed', messages: {'name': 'is required'});

void main() {
  late MockRoleRepository repo;

  setUpAll(registerAdminFallbacks);
  setUp(() => repo = MockRoleRepository());

  group('usecases', () {
    test('GetRoles pages through every role', () async {
      when(() => repo.getRoles(page: 1, pageSize: 100))
          .thenAnswer((_) async => PageResult(items: [staffRole], page: 1, pageSize: 100, total: 101));
      when(() => repo.getRoles(page: 2, pageSize: 100))
          .thenAnswer((_) async => PageResult(items: [gudangRole], page: 2, pageSize: 100, total: 101));

      expect(await GetRoles(repo)(), [staffRole, gudangRole]);
    });

    test('CreateRole trims, and rejects an empty name before any request', () async {
      when(() => repo.createRole(any())).thenAnswer((_) async => gudangRole);
      await CreateRole(repo)(const RoleInput(name: '  Gudang ', description: ' stok '));
      verify(() => repo.createRole(const RoleInput(name: 'Gudang', description: 'stok'))).called(1);

      await expectLater(
        CreateRole(repo)(const RoleInput(name: '   ')),
        throwsA(isA<ValidationFailure>().having((f) => f.issues['name']?.kind, 'issue', FieldIssueKind.nameRequired)),
      );
      verifyNoMoreInteractions(repo);
    });

    test('UpdateRole validates only a name that is being changed', () async {
      when(() => repo.updateRole(any(), any())).thenAnswer((_) async => gudangRole);
      await UpdateRole(repo)(3, const RolePatch(description: ' baru '));
      verify(() => repo.updateRole(3, const RolePatch(description: 'baru'))).called(1);
      expect(() => UpdateRole(repo)(3, const RolePatch(name: '')), throwsA(isA<ValidationFailure>()));
    });

    test('SetRolePermissions sends the full list, de-duplicated', () async {
      when(() => repo.setPermissions(any(), any())).thenAnswer((_) async => gudangRole);
      await SetRolePermissions(repo)(3, ['inventory.view', 'products.view', 'inventory.view']);
      verify(() => repo.setPermissions(3, ['inventory.view', 'products.view'])).called(1);
    });

    test('groupPermissions keeps the API order and unknown groups', () {
      final groups = groupPermissions(const [
        CatalogPermission(id: 1, key: 'a.x', description: '', group: 'a'),
        CatalogPermission(id: 2, key: 'future.x', description: '', group: 'future'),
        CatalogPermission(id: 3, key: 'a.y', description: '', group: 'a'),
      ]);
      expect(groups.map((g) => g.code), ['a', 'future']);
      expect(groups.first.permissions.map((p) => p.key), ['a.x', 'a.y']);
    });
  });

  group('notifiers', () {
    ProviderContainer container() =>
        ProviderContainer.test(overrides: [roleRepositoryProvider.overrideWithValue(repo)], retry: (_, _) => null);

    setUp(() => when(() => repo.getRoles(page: any(named: 'page'), pageSize: any(named: 'pageSize')))
        .thenAnswer((_) async => rolePage([superAdminRole, staffRole, gudangRole])));

    test('delete: the row goes once the server confirms', () async {
      when(() => repo.deleteRole(3)).thenAnswer((_) async {});
      final c = container();
      await c.read(roleListProvider.future);

      await c.read(roleListProvider.notifier).delete(3);

      expect(c.read(roleListProvider).value!.map((r) => r.id), [1, 2]);
    });

    test('delete refused (409, still in use): the Failure reaches the UI and the row stays', () async {
      when(() => repo.deleteRole(3)).thenThrow(_conflict);
      final c = container();
      await c.read(roleListProvider.future);

      await expectLater(c.read(roleListProvider.notifier).delete(3), throwsA(same(_conflict)));
      expect(c.read(roleListProvider).value!.map((r) => r.id), [1, 2, 3]);
    });

    test('create: POST, then the lists reload', () async {
      when(() => repo.createRole(any())).thenAnswer((_) async => gudangRole);
      final c = container();
      await c.read(roleListProvider.future);

      final saved = await c.read(roleFormProvider(null).notifier).save(const RoleInput(name: 'Gudang'));

      expect(saved, gudangRole);
      verify(() => repo.getRoles(page: 1, pageSize: 100)).called(1);
      await c.read(roleListProvider.future);
      verify(() => repo.getRoles(page: 1, pageSize: 100)).called(1); // reloaded after the save
    });

    test('edit: PATCH carries only what changed; nothing changed → no request', () async {
      when(() => repo.getRole(3)).thenAnswer((_) async => role(3, name: 'Gudang', description: 'lama'));
      when(() => repo.updateRole(any(), any())).thenAnswer((_) async => gudangRole);
      final c = container();
      await c.read(roleFormProvider(3).future);

      await c.read(roleFormProvider(3).notifier).save(const RoleInput(name: 'Gudang', description: 'baru'));
      verify(() => repo.updateRole(3, const RolePatch(description: 'baru'))).called(1);

      when(() => repo.getRole(3)).thenAnswer((_) async => role(3, name: 'Gudang', description: 'baru'));
      c.invalidate(roleFormProvider(3));
      await c.read(roleFormProvider(3).future);
      await c.read(roleFormProvider(3).notifier).save(const RoleInput(name: 'Gudang', description: 'baru'));
      verifyNever(() => repo.updateRole(3, const RolePatch()));
    });

    test('edit refused with 422: the field error reaches the form', () async {
      when(() => repo.getRole(3)).thenAnswer((_) async => gudangRole);
      when(() => repo.updateRole(any(), any())).thenThrow(_nameRequired);
      final c = container();
      await c.read(roleFormProvider(3).future);

      await expectLater(
        c.read(roleFormProvider(3).notifier).save(const RoleInput(name: 'Baru')),
        throwsA(isA<ValidationFailure>()),
      );
    });

    test('assign permissions: PUT with the whole list, the role updates', () async {
      final updated = role(3, name: 'Gudang', permissions: const ['inventory.view', 'inventory.record_movement']);
      when(() => repo.getRole(3)).thenAnswer((_) async => gudangRole);
      when(() => repo.setPermissions(any(), any())).thenAnswer((_) async => updated);
      final c = container();
      await c.read(roleFormProvider(3).future);

      await c.read(roleFormProvider(3).notifier).savePermissions(['inventory.view', 'inventory.record_movement']);

      verify(() => repo.setPermissions(3, ['inventory.view', 'inventory.record_movement'])).called(1);
      expect(c.read(roleFormProvider(3)).value, updated);
    });

    test('assign permissions refused (403): the Failure reaches the editor, the role is unchanged', () async {
      when(() => repo.getRole(3)).thenAnswer((_) async => gudangRole);
      when(() => repo.setPermissions(any(), any())).thenThrow(_forbidden);
      final c = container();
      await c.read(roleFormProvider(3).future);

      await expectLater(c.read(roleFormProvider(3).notifier).savePermissions(['users.delete']), throwsA(same(_forbidden)));
      expect(c.read(roleFormProvider(3)).value, gudangRole);
    });
  });
}
