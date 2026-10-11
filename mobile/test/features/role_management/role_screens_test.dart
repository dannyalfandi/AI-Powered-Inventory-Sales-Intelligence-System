import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_intel/core/auth/permissions.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/features/auth/domain/entities/auth_user.dart';
import 'package:inventory_intel/features/role_management/domain/entities/role.dart';
import 'package:inventory_intel/features/role_management/presentation/providers/role_providers.dart';
import 'package:inventory_intel/features/role_management/presentation/screens/role_form_screen.dart';
import 'package:inventory_intel/features/role_management/presentation/screens/role_list_screen.dart';
import 'package:inventory_intel/features/role_management/presentation/screens/role_permission_editor_screen.dart';
import 'package:inventory_intel/shared/widgets/skeleton.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/admin_fixtures.dart';
import '../../helpers/auth_fixtures.dart';
import '../../helpers/l10n_harness.dart';

void main() {
  late MockRoleRepository repo;

  setUpAll(registerAdminFallbacks);
  setUp(() => repo = MockRoleRepository());

  /// Pumps [screen] as a route pushed over a home page, so the screen's own
  /// `context.pop()` works as in the app.
  Future<void> pump(WidgetTester tester, Widget screen, AuthUser user, {bool settle = true}) async {
    final router = GoRouter(
      initialLocation: '/screen',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => const Scaffold(body: Text('home')),
          routes: [GoRoute(path: 'screen', builder: (_, _) => screen)],
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[roleRepositoryProvider.overrideWithValue(repo), signedInAs(user)],
        retry: (_, _) => null,
        child: localizedApp(routerConfig: router),
      ),
    );
    settle ? await tester.pumpAndSettle() : await tester.pump();
  }

  void stubRoles(List<Role> roles) =>
      when(() => repo.getRoles(page: any(named: 'page'), pageSize: any(named: 'pageSize')))
          .thenAnswer((_) async => rolePage(roles));

  group('RoleListScreen', () {
    testWidgets('loading: a skeleton, no rows yet', (tester) async {
      final answer = Completer<Never>();
      when(() => repo.getRoles(page: any(named: 'page'), pageSize: any(named: 'pageSize'))).thenAnswer((_) => answer.future);
      await pump(tester, const RoleListScreen(), userWith({Permissions.rolesView}), settle: false);
      await tester.pump();
      expect(find.byType(SkeletonList), findsOneWidget);
      expect(find.byType(ListTile), findsNothing);
    });

    testWidgets('data: name, permission count, system badge', (tester) async {
      stubRoles([superAdminRole, gudangRole]);
      await pump(tester, const RoleListScreen(), userWith({Permissions.rolesView}));
      final l10n = l10nOf(tester);
      expect(find.text('Gudang'), findsOneWidget);
      expect(find.textContaining(l10n.rolePermissionCount(1)), findsOneWidget);
      expect(find.textContaining(l10n.roleAllPermissions), findsOneWidget, reason: 'the system role: every permission');
      expect(find.text(l10n.roleSystemBadge), findsOneWidget);
    });

    testWidgets('error: the message and a retry', (tester) async {
      when(() => repo.getRoles(page: any(named: 'page'), pageSize: any(named: 'pageSize')))
          .thenThrow(const ServerFailure('anda tidak punya izin roles.view', statusCode: 403, code: 'forbidden'));
      await pump(tester, const RoleListScreen(), userWith({Permissions.rolesCreate}));

      expect(find.text('anda tidak punya izin roles.view'), findsOneWidget);
      stubRoles([gudangRole]);
      await tester.tap(find.text(l10nOf(tester).commonRetry));
      await tester.pumpAndSettle();
      expect(find.text('Gudang'), findsOneWidget);
    });

    testWidgets('empty', (tester) async {
      stubRoles([]);
      await pump(tester, const RoleListScreen(), superAdmin);
      expect(find.text(l10nOf(tester).rolesEmpty), findsOneWidget);
    });

    testWidgets('every row shows its user_count, in neutral words ("linked"), with no extra request', (tester) async {
      stubRoles([superAdminRole, staffRole, role(4, name: 'Gudang Besar', userCount: 7), gudangRole]);
      await pump(tester, const RoleListScreen(), superAdmin);
      final l10n = l10nOf(tester);

      String subtitle(int id) => tester.widget<Text>(find.byKey(ValueKey('role_subtitle_$id'))).data!;
      expect(subtitle(1), contains(l10n.roleUserCount(1)));
      expect(subtitle(4), contains(l10n.roleUserCount(7)));
      expect(subtitle(3), contains(l10n.roleUserCount(0)));
      verify(() => repo.getRoles(page: any(named: 'page'), pageSize: any(named: 'pageSize'))).called(1);
      verifyNoMoreInteractions(repo);
    });

    testWidgets('view only: no add, no delete — and the counts still show (no users.view needed)', (tester) async {
      stubRoles([staffRole, gudangRole]);
      await pump(tester, const RoleListScreen(), userWith({Permissions.rolesView}));

      expect(find.byType(FloatingActionButton), findsNothing);
      expect(find.byType(Dismissible), findsNothing);
      expect(find.textContaining(l10nOf(tester).roleUserCount(1)), findsOneWidget);
    });

    // Swipe-to-delete is offered only where the backend would say yes.
    for (final (name, r, offered) in [
      ('no linked user (userCount 0)', gudangRole, true),
      ('linked users (userCount 1)', staffRole, false),
      ('linked users, deleted ones too (userCount 2)', role(4, name: 'Arsip', userCount: 2), false),
      ('the system role', superAdminRole, false),
    ]) {
      testWidgets('swipe delete — $name: ${offered ? 'offered' : 'not offered'}', (tester) async {
        stubRoles([r]);
        await pump(tester, const RoleListScreen(), superAdmin);
        expect(find.byType(Dismissible), offered ? findsOneWidget : findsNothing);
      });
    }

    testWidgets('a user manager without roles.view: the list and counts, but rows don\'t open the detail', (tester) async {
      stubRoles([staffRole, gudangRole]);
      await pump(tester, const RoleListScreen(), userWith({Permissions.usersCreate, Permissions.rolesDelete}));

      expect(find.text('Gudang'), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsNothing, reason: 'nothing to open');
      await tester.tap(find.text('Gudang'));
      await tester.pumpAndSettle();
      expect(find.byType(RoleListScreen), findsOneWidget);
      verifyNever(() => repo.getRole(any()));
    });

    testWidgets('delete refused (409): the server\'s sentence, as is, and the row stays', (tester) async {
      stubRoles([gudangRole]);
      const message = 'role 3 masih terhubung dengan 2 pengguna (termasuk yang sudah dihapus)';
      when(() => repo.deleteRole(3)).thenThrow(const ServerFailure(message, statusCode: 409, code: 'conflict'));
      await pump(tester, const RoleListScreen(), userWith({Permissions.rolesView, Permissions.rolesDelete}));

      await tester.drag(find.text('Gudang'), const Offset(-500, 0));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('role_delete_confirm')));
      await tester.pumpAndSettle();

      expect(tester.widget<Text>(find.byKey(const Key('role_delete_blocked_message'))).data, message);
      await tester.tap(find.text(l10nOf(tester).commonUnderstood));
      await tester.pumpAndSettle();
      expect(find.text('Gudang'), findsOneWidget);
    });

    testWidgets('delete accepted: the row goes', (tester) async {
      stubRoles([gudangRole]);
      when(() => repo.deleteRole(3)).thenAnswer((_) async {});
      await pump(tester, const RoleListScreen(), superAdmin);

      await tester.drag(find.text('Gudang'), const Offset(-500, 0));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('role_delete_confirm')));
      await tester.pumpAndSettle();

      verify(() => repo.deleteRole(3)).called(1);
      expect(find.byKey(const ValueKey('role_tile_3')), findsNothing);
    });
  });

  group('RolePermissionEditorScreen', () {
    setUp(() {
      when(() => repo.getRole(3)).thenAnswer((_) async => gudangRole); // has inventory.view
      when(() => repo.getPermissionCatalog()).thenAnswer((_) async => catalog);
    });

    bool? checked(WidgetTester tester, String key) => tester.widget<CheckboxListTile>(find.byKey(Key(key))).value;

    testWidgets('grouped as the API groups them, starting from the role\'s current permissions', (tester) async {
      await pump(tester, const RolePermissionEditorScreen(roleId: 3), superAdmin);
      final l10n = l10nOf(tester);

      expect(find.text(l10n.permissionGroupProducts), findsOneWidget);
      expect(find.text(l10n.permissionGroupInventory), findsOneWidget);
      expect(find.text(l10n.permissionGroupUsers), findsOneWidget);
      expect(checked(tester, 'permission_inventory.view'), isTrue);
      expect(checked(tester, 'permission_products.view'), isFalse);
      expect(tester.widget<FilledButton>(find.byKey(const Key('permission_editor_save'))).onPressed, isNull,
          reason: 'nothing changed yet');
    });

    testWidgets('toggle, then save sends the FULL desired list in catalog order', (tester) async {
      when(() => repo.setPermissions(any(), any()))
          .thenAnswer((_) async => role(3, name: 'Gudang', permissions: const ['products.view', 'inventory.record_movement']));
      await pump(tester, const RolePermissionEditorScreen(roleId: 3), superAdmin);

      await tester.tap(find.byKey(const Key('permission_inventory.view'))); // off
      await tester.tap(find.byKey(const Key('permission_inventory.record_movement'))); // on
      await tester.tap(find.byKey(const Key('permission_products.view'))); // on
      await tester.pump();
      expect(find.text(l10nOf(tester).permissionEditorSelected(2, 5)), findsOneWidget);

      await tester.tap(find.byKey(const Key('permission_editor_save')));
      await tester.pumpAndSettle();

      verify(() => repo.setPermissions(3, ['products.view', 'inventory.record_movement'])).called(1);
    });

    testWidgets('a group box selects the whole group', (tester) async {
      await pump(tester, const RolePermissionEditorScreen(roleId: 3), superAdmin);

      await tester.tap(find.byKey(const Key('permission_group_products')));
      await tester.pump();

      expect(checked(tester, 'permission_products.view'), isTrue);
      expect(checked(tester, 'permission_products.create'), isTrue);
    });

    testWidgets('a non-Super-Admin: what they don\'t hold is shown but locked', (tester) async {
      await pump(
        tester,
        const RolePermissionEditorScreen(roleId: 3),
        userWith({Permissions.rolesAssignPermissions, Permissions.inventoryView, Permissions.inventoryRecordMovement}),
      );

      expect(find.byKey(const Key('permission_editor_not_held')), findsOneWidget);
      expect(tester.widget<CheckboxListTile>(find.byKey(const Key('permission_products.view'))).onChanged, isNull);
      expect(tester.widget<CheckboxListTile>(find.byKey(const Key('permission_inventory.record_movement'))).onChanged,
          isNotNull);
    });

    testWidgets('save refused (403): the server\'s reason, and the editor stays open', (tester) async {
      when(() => repo.setPermissions(any(), any()))
          .thenThrow(const ServerFailure('anda tidak punya izin roles.assign_permissions', statusCode: 403, code: 'forbidden'));
      await pump(tester, const RolePermissionEditorScreen(roleId: 3), superAdmin);

      await tester.tap(find.byKey(const Key('permission_products.view')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('permission_editor_save')));
      await tester.pumpAndSettle();

      expect(find.textContaining('anda tidak punya izin roles.assign_permissions'), findsOneWidget);
      expect(find.byType(RolePermissionEditorScreen), findsOneWidget);
    });
  });

  group('RoleFormScreen', () {
    testWidgets('create without roles.view: back to the list, never GET /roles/:id', (tester) async {
      when(() => repo.createRole(any())).thenAnswer((_) async => role(7, name: 'Kasir'));
      await pump(tester, const RoleFormScreen(), userWith({Permissions.rolesCreate}));

      await tester.enterText(find.byKey(const Key('role_form_name')), 'Kasir');
      await tester.tap(find.byKey(const Key('role_form_submit')));
      await tester.pumpAndSettle();

      expect(find.text('home'), findsOneWidget, reason: 'popped back');
      verify(() => repo.createRole(const RoleInput(name: 'Kasir'))).called(1);
      verifyNever(() => repo.getRole(any()));
    });

    testWidgets('create: an empty name is rejected before any request', (tester) async {
      await pump(tester, const RoleFormScreen(), superAdmin);

      await tester.tap(find.byKey(const Key('role_form_submit')));
      await tester.pumpAndSettle();

      expect(find.text(l10nOf(tester).validationNameRequired), findsOneWidget);
      verifyNever(() => repo.createRole(any()));
    });

    testWidgets('edit: a 409 duplicate name shows under the field', (tester) async {
      when(() => repo.getRole(3)).thenAnswer((_) async => gudangRole);
      when(() => repo.updateRole(any(), any()))
          .thenThrow(const ServerFailure('role name "Staff" already exists', statusCode: 409, code: 'conflict'));
      await pump(tester, const RoleFormScreen(roleId: 3), superAdmin);

      await tester.enterText(find.byKey(const Key('role_form_name')), 'Staff');
      await tester.tap(find.byKey(const Key('role_form_submit')));
      await tester.pumpAndSettle();

      expect(find.text('role name "Staff" already exists'), findsOneWidget);
    });

    testWidgets('the system role: explained, name locked, no permission editor', (tester) async {
      when(() => repo.getRole(1)).thenAnswer((_) async => superAdminRole);
      await pump(tester, const RoleFormScreen(roleId: 1), superAdmin);

      expect(find.byKey(const Key('role_system_note')), findsOneWidget);
      final name = tester.widget<EditableText>(
        find.descendant(of: find.byKey(const Key('role_form_name')), matching: find.byType(EditableText)),
      );
      expect(name.readOnly, isTrue);
      expect(find.byKey(const Key('role_edit_permissions')), findsNothing);
    });

    testWidgets('"Edit permissions" only with roles.assign_permissions; saving only with roles.update', (tester) async {
      when(() => repo.getRole(3)).thenAnswer((_) async => gudangRole);
      await pump(tester, const RoleFormScreen(roleId: 3), userWith({Permissions.rolesView}));
      expect(find.byKey(const Key('role_edit_permissions')), findsNothing);
      expect(find.byKey(const Key('role_form_submit')), findsNothing);

      await pump(tester, const RoleFormScreen(roleId: 3), userWith({Permissions.rolesView, Permissions.rolesAssignPermissions}));
      expect(find.byKey(const Key('role_edit_permissions')), findsOneWidget);
    });
  });
}
