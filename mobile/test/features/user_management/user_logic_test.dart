import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/core/validation/field_issue.dart';
import 'package:inventory_intel/features/user_management/domain/entities/managed_user.dart';
import 'package:inventory_intel/features/user_management/domain/usecases/create_user.dart';
import 'package:inventory_intel/features/user_management/domain/usecases/update_user.dart';
import 'package:inventory_intel/features/user_management/presentation/providers/user_form_provider.dart';
import 'package:inventory_intel/features/user_management/presentation/providers/user_list_provider.dart';
import 'package:inventory_intel/features/user_management/presentation/providers/user_providers.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/admin_fixtures.dart';

void main() {
  late MockUserRepository repo;

  setUpAll(registerAdminFallbacks);
  setUp(() => repo = MockUserRepository());

  group('UserRules', () {
    test('password: required on create, optional on edit, 8 chars to 72 bytes', () {
      expect(UserRules.validatePassword('', required: true)?.kind, FieldIssueKind.passwordRequired);
      expect(UserRules.validatePassword('', required: false), isNull, reason: 'empty = keep the current one');
      expect(UserRules.validatePassword('short', required: false)?.kind, FieldIssueKind.passwordTooShort);
      expect(UserRules.validatePassword('rahasia123', required: true), isNull);
      expect(UserRules.validatePassword('é' * 40, required: true)?.kind, FieldIssueKind.passwordTooLong,
          reason: '40 characters, but 80 UTF-8 bytes: over bcrypt\'s limit');
    });

    test('email and role', () {
      expect(UserRules.validateEmail('')?.kind, FieldIssueKind.emailRequired);
      expect(UserRules.validateEmail('nope')?.kind, FieldIssueKind.emailInvalid);
      expect(UserRules.validateRole(null)?.kind, FieldIssueKind.roleRequired);
      expect(UserRules.validateRole(2), isNull);
    });
  });

  group('usecases', () {
    test('CreateUser normalizes, and reports every invalid field before any request', () async {
      when(() => repo.createUser(any())).thenAnswer((_) async => managedUser(9));
      await CreateUser(repo)(
        const UserInput(email: ' Budi@Example.COM ', password: 'rahasia123', name: ' Budi ', roleId: 2),
      );
      verify(() => repo.createUser(
            const UserInput(email: 'budi@example.com', password: 'rahasia123', name: 'Budi', roleId: 2),
          )).called(1);

      await expectLater(
        CreateUser(repo)(const UserInput(email: 'x', password: 'short', name: '', roleId: null)),
        throwsA(isA<ValidationFailure>().having((f) => f.issues.keys.toSet(), 'fields', {'email', 'name', 'password', 'role_id'})),
      );
      verifyNoMoreInteractions(repo);
    });

    test('UpdateUser validates only the fields being changed', () async {
      when(() => repo.updateUser(any(), any())).thenAnswer((_) async => managedUser(9));
      await UpdateUser(repo)(9, const UserPatch(isActive: false));
      verify(() => repo.updateUser(9, const UserPatch(isActive: false))).called(1);
      expect(() => UpdateUser(repo)(9, const UserPatch(password: 'x')), throwsA(isA<ValidationFailure>()));
    });
  });

  group('notifiers', () {
    ProviderContainer container() =>
        ProviderContainer.test(overrides: [userRepositoryProvider.overrideWithValue(repo)], retry: (_, _) => null);

    final budi = managedUser(9, name: 'Budi', email: 'budi@example.com');

    test('create: POST with every field', () async {
      when(() => repo.createUser(any())).thenAnswer((_) async => budi);
      final c = container();

      await c.read(userFormProvider(null).notifier).create(
            const UserInput(email: 'budi@example.com', password: 'rahasia123', name: 'Budi', roleId: 2),
          );

      verify(() => repo.createUser(
            const UserInput(email: 'budi@example.com', password: 'rahasia123', name: 'Budi', roleId: 2),
          )).called(1);
    });

    test('edit: role change + deactivation, only those fields; empty password is "keep"', () async {
      when(() => repo.getUser(9)).thenAnswer((_) async => budi);
      when(() => repo.updateUser(any(), any())).thenAnswer((_) async => budi);
      final c = container();
      await c.read(userFormProvider(9).future);

      await c.read(userFormProvider(9).notifier).saveEdit(
            (email: 'budi@example.com', name: 'Budi', newPassword: '', roleId: 3, isActive: false),
          );

      verify(() => repo.updateUser(9, const UserPatch(roleId: 3, isActive: false))).called(1);
    });

    test('edit with a new password sends it', () async {
      when(() => repo.getUser(9)).thenAnswer((_) async => budi);
      when(() => repo.updateUser(any(), any())).thenAnswer((_) async => budi);
      final c = container();
      await c.read(userFormProvider(9).future);

      await c.read(userFormProvider(9).notifier).saveEdit(
            (email: 'budi@example.com', name: 'Budi', newPassword: 'baru-rahasia', roleId: 2, isActive: true),
          );

      verify(() => repo.updateUser(9, const UserPatch(password: 'baru-rahasia'))).called(1);
    });

    test('edit refused: 403 (a Super Admin account) and 409 (self) reach the form', () async {
      when(() => repo.getUser(9)).thenAnswer((_) async => budi);
      final c = container();
      await c.read(userFormProvider(9).future);
      const forbidden = ServerFailure('hanya Super Admin yang bisa ...', statusCode: 403, code: 'forbidden');
      const conflict = ServerFailure('tidak bisa menonaktifkan atau menghapus akun sendiri', statusCode: 409, code: 'conflict');

      when(() => repo.updateUser(any(), any())).thenThrow(forbidden);
      await expectLater(
        c.read(userFormProvider(9).notifier).saveEdit((email: 'budi@example.com', name: 'Budi', newPassword: '', roleId: 1, isActive: true)),
        throwsA(same(forbidden)),
      );
      when(() => repo.updateUser(any(), any())).thenThrow(conflict);
      await expectLater(
        c.read(userFormProvider(9).notifier).saveEdit((email: 'budi@example.com', name: 'Budi', newPassword: '', roleId: 2, isActive: false)),
        throwsA(same(conflict)),
      );
    });

    test('delete: the row goes; a refusal leaves it', () async {
      when(() => repo.getUsers(page: any(named: 'page'), pageSize: any(named: 'pageSize'), search: any(named: 'search')))
          .thenAnswer((_) async => userPage([budi, managedUser(10)]));
      when(() => repo.deleteUser(9)).thenAnswer((_) async {});
      when(() => repo.deleteUser(10)).thenThrow(const ServerFailure('x', statusCode: 403, code: 'forbidden'));
      final c = container();
      await c.read(userListProvider.future);

      await c.read(userListProvider.notifier).delete(9);
      expect(c.read(userListProvider).value!.items.map((u) => u.id), [10]);

      await expectLater(c.read(userListProvider.notifier).delete(10), throwsA(isA<ServerFailure>()));
      expect(c.read(userListProvider).value!.items.map((u) => u.id), [10]);
    });

    test('search reloads from page 1 with the query', () async {
      when(() => repo.getUsers(page: any(named: 'page'), pageSize: any(named: 'pageSize'), search: any(named: 'search')))
          .thenAnswer((_) async => userPage([budi]));
      final c = container();
      await c.read(userListProvider.future);

      c.read(userSearchQueryProvider.notifier).set('  budi ');
      await c.read(userListProvider.future);

      verify(() => repo.getUsers(page: 1, pageSize: 20, search: 'budi')).called(1);
    });
  });
}
