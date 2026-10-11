import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_intel/core/auth/permissions.dart';
import 'package:inventory_intel/core/locale/locale_provider.dart';
import 'package:inventory_intel/core/router/app_router.dart';
import 'package:inventory_intel/features/auth/domain/entities/auth_user.dart';
import 'package:inventory_intel/features/auth/presentation/providers/auth_providers.dart';
import 'package:inventory_intel/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:inventory_intel/features/role_management/presentation/providers/role_providers.dart';
import 'package:inventory_intel/features/role_management/presentation/screens/role_list_screen.dart';
import 'package:inventory_intel/features/role_management/presentation/screens/role_permission_editor_screen.dart';
import 'package:inventory_intel/features/settings/presentation/screens/settings_screen.dart';
import 'package:inventory_intel/features/user_management/presentation/providers/user_providers.dart';
import 'package:inventory_intel/features/user_management/presentation/screens/user_form_screen.dart';
import 'package:inventory_intel/features/user_management/presentation/screens/user_list_screen.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/admin_fixtures.dart';
import '../helpers/auth_fixtures.dart';
import '../helpers/dashboard_fixtures.dart';
import '../helpers/l10n_harness.dart';

const _rolesEntry = Key('settings_admin_roles');
const _usersEntry = Key('settings_admin_users');

void main() {
  setUpAll(() {
    registerDashboardFallbacks();
    registerAdminFallbacks();
  });

  group('Settings → Administration entry points', () {
    Future<void> pumpSettings(WidgetTester tester, AuthUser user) async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [sharedPreferencesProvider.overrideWithValue(preferences), signedInAs(user)],
          child: localizedApp(home: const SettingsScreen()),
        ),
      );
      await tester.pumpAndSettle();
    }

    final cases = <(String, AuthUser, bool, bool)>[
      ('Super Admin: both', superAdmin, true, true),
      ('Staff: neither, and no section at all', staff, false, false),
      ('a role manager (roles.view only): roles, not users', userWith({Permissions.rolesView}), true, false),
      ('assign-only (roles.assign_permissions): roles', userWith({Permissions.rolesAssignPermissions}), true, false),
      ('a user manager (users.delete only): users, not roles', userWith({Permissions.usersDelete}), false, true),
      ('both halves from a custom role', userWith({Permissions.rolesCreate, Permissions.usersView}), true, true),
    ];
    for (final (name, user, roles, users) in cases) {
      testWidgets(name, (tester) async {
        await pumpSettings(tester, user);
        expect(find.byKey(_rolesEntry), roles ? findsOneWidget : findsNothing);
        expect(find.byKey(_usersEntry), users ? findsOneWidget : findsNothing);
        expect(find.text(l10nOf(tester).settingsAdminSection), roles || users ? findsOneWidget : findsNothing);
      });
    }
  });

  group('the real router', () {
    late ProviderContainer container;
    late GoRouter router;
    late MockRoleRepository roles;

    Future<void> start(WidgetTester tester, AuthUser user) async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final auth = MockAuthRepository();
      when(() => auth.hasSession).thenReturn(true);
      when(() => auth.currentUser()).thenAnswer((_) async => user);
      final dashboard = MockDashboardRepository();
      stubDashboard(dashboard);
      roles = MockRoleRepository();
      when(() => roles.getRoles(page: any(named: 'page'), pageSize: any(named: 'pageSize')))
          .thenAnswer((_) async => rolePage([staffRole, gudangRole]));
      when(() => roles.getRole(any())).thenAnswer((_) async => gudangRole);
      when(() => roles.getPermissionCatalog()).thenAnswer((_) async => catalog);
      final users = MockUserRepository();
      when(() => users.getUsers(page: any(named: 'page'), pageSize: any(named: 'pageSize'), search: any(named: 'search')))
          .thenAnswer((_) async => userPage([managedUser(9)]));

      container = ProviderContainer.test(
        overrides: [
          authRepositoryProvider.overrideWithValue(auth),
          dashboardRepositoryProvider.overrideWithValue(dashboard),
          roleRepositoryProvider.overrideWithValue(roles),
          userRepositoryProvider.overrideWithValue(users),
          sharedPreferencesProvider.overrideWithValue(preferences),
        ],
        retry: (_, _) => null,
      );
      router = container.read(appRouterProvider);
      await tester.pumpWidget(UncontrolledProviderScope(container: container, child: localizedApp(routerConfig: router)));
      await tester.pumpAndSettle();
    }

    String location() => router.routerDelegate.currentConfiguration.uri.path;

    testWidgets('Super Admin: Settings → Roles → a role → its permissions; Settings → Users', (tester) async {
      await start(tester, superAdmin);
      router.go('/settings');
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(_rolesEntry));
      await tester.pumpAndSettle();
      expect(find.byType(RoleListScreen), findsOneWidget);

      await tester.tap(find.text('Gudang'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('role_edit_permissions')));
      await tester.pumpAndSettle();
      expect(find.byType(RolePermissionEditorScreen), findsOneWidget);

      router.go('/settings');
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(_usersEntry));
      await tester.tap(find.byKey(_usersEntry));
      await tester.pumpAndSettle();
      expect(find.byType(UserListScreen), findsOneWidget);
    });

    testWidgets('Staff: every admin deep link lands back on Settings', (tester) async {
      await start(tester, staff);
      for (final path in ['/admin/roles', '/admin/roles/new', '/admin/roles/3', '/admin/roles/3/permissions', '/admin/users', '/admin/users/new', '/admin/users/9']) {
        router.go(path);
        await tester.pumpAndSettle();
        expect(location(), '/settings', reason: path);
        expect(find.byType(SettingsScreen), findsOneWidget);
      }
    });

    // GET /roles/:id and GET /permissions answer only to roles.view: without
    // it, no path in the app may request them.
    void expectNoRoleDetailRequests() {
      verifyNever(() => roles.getRole(any()));
      verifyNever(() => roles.getPermissionCatalog());
    }

    testWidgets('a user manager (users.*, no roles.*): the user form loads the role list, never the detail', (tester) async {
      await start(tester, userWith({...Permissions.userManagement}));

      router.go('/admin/users/new');
      await tester.pumpAndSettle();
      expect(find.byType(UserFormScreen), findsOneWidget);
      verify(() => roles.getRoles(page: any(named: 'page'), pageSize: any(named: 'pageSize'))).called(greaterThan(0));

      for (final path in ['/admin/roles', '/admin/roles/3', '/admin/roles/3/permissions']) {
        router.go(path);
        await tester.pumpAndSettle();
        expect(location(), '/settings', reason: path);
      }
      expectNoRoleDetailRequests();
    });

    testWidgets('roles.create + users.create, no roles.view: the list opens, a row leads nowhere', (tester) async {
      await start(tester, userWith({Permissions.rolesCreate, Permissions.usersCreate}));

      router.go('/admin/roles');
      await tester.pumpAndSettle();
      expect(find.byType(RoleListScreen), findsOneWidget);
      await tester.tap(find.text('Gudang'));
      await tester.pumpAndSettle();
      expect(location(), '/admin/roles');

      router.go('/admin/roles/3');
      await tester.pumpAndSettle();
      expect(location(), '/settings');
      expectNoRoleDetailRequests();
    });

    testWidgets('roles.assign_permissions without roles.view: the editor does not open', (tester) async {
      await start(tester, userWith({Permissions.rolesAssignPermissions, Permissions.rolesUpdate}));
      for (final path in ['/admin/roles/3', '/admin/roles/3/permissions']) {
        router.go(path);
        await tester.pumpAndSettle();
        expect(location(), '/settings', reason: path);
      }
      expectNoRoleDetailRequests();
    });

    testWidgets('roles.view without roles.assign_permissions: the list opens, the editor does not', (tester) async {
      await start(tester, userWith({Permissions.rolesView}));
      router.go('/admin/roles');
      await tester.pumpAndSettle();
      expect(find.byType(RoleListScreen), findsOneWidget);

      router.go('/admin/roles/3/permissions');
      await tester.pumpAndSettle();
      expect(location(), '/settings');
    });
  });
}
