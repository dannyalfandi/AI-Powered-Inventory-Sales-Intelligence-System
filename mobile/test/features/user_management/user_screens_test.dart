import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_intel/core/auth/permissions.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/features/auth/domain/entities/auth_user.dart';
import 'package:inventory_intel/features/role_management/presentation/providers/role_providers.dart';
import 'package:inventory_intel/features/user_management/presentation/providers/user_providers.dart';
import 'package:inventory_intel/features/user_management/presentation/screens/user_form_screen.dart';
import 'package:inventory_intel/features/user_management/presentation/screens/user_list_screen.dart';
import 'package:inventory_intel/shared/widgets/skeleton.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/admin_fixtures.dart';
import '../../helpers/auth_fixtures.dart';
import '../../helpers/l10n_harness.dart';

void main() {
  late MockUserRepository users;
  late MockRoleRepository roles;

  setUpAll(registerAdminFallbacks);
  setUp(() {
    users = MockUserRepository();
    roles = MockRoleRepository();
    when(() => roles.getRoles(page: any(named: 'page'), pageSize: any(named: 'pageSize')))
        .thenAnswer((_) async => rolePage([superAdminRole, staffRole, gudangRole]));
  });

  /// [screen] as a route over a home page, so `context.pop()` works.
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
        overrides: <Override>[
          userRepositoryProvider.overrideWithValue(users),
          roleRepositoryProvider.overrideWithValue(roles),
          signedInAs(user),
        ],
        retry: (_, _) => null,
        child: localizedApp(routerConfig: router),
      ),
    );
    settle ? await tester.pumpAndSettle() : await tester.pump();
  }

  void stubUsers(List<dynamic> items) =>
      when(() => users.getUsers(page: any(named: 'page'), pageSize: any(named: 'pageSize'), search: any(named: 'search')))
          .thenAnswer((_) async => userPage(items.cast()));

  // superAdmin (id 1) is "me" in these tests.
  final me = managedUser(1, name: 'Super Admin', email: 'admin@example.com', role: superAdminRole);
  final budi = managedUser(9, name: 'Budi', email: 'budi@example.com');
  final off = managedUser(10, name: 'Ani', email: 'ani@example.com', isActive: false);

  group('UserListScreen', () {
    testWidgets('loading: a skeleton', (tester) async {
      final answer = Completer<Never>();
      when(() => users.getUsers(page: any(named: 'page'), pageSize: any(named: 'pageSize'), search: any(named: 'search')))
          .thenAnswer((_) => answer.future);
      await pump(tester, const UserListScreen(), superAdmin, settle: false);
      await tester.pump();
      expect(find.byType(SkeletonList), findsOneWidget);
    });

    testWidgets('data: name, email, role, and active / inactive status', (tester) async {
      stubUsers([me, budi, off]);
      await pump(tester, const UserListScreen(), superAdmin);
      final l10n = l10nOf(tester);

      expect(find.textContaining('budi@example.com'), findsOneWidget);
      expect(find.textContaining('Staff'), findsNWidgets(2));
      expect(find.descendant(of: find.byKey(const ValueKey('user_status_9')), matching: find.text(l10n.userActive)),
          findsOneWidget);
      expect(find.descendant(of: find.byKey(const ValueKey('user_status_10')), matching: find.text(l10n.userInactive)),
          findsOneWidget);
      expect(find.text('(${l10n.userYou})'), findsOneWidget, reason: 'your own row is marked');
    });

    testWidgets('error and empty', (tester) async {
      when(() => users.getUsers(page: any(named: 'page'), pageSize: any(named: 'pageSize'), search: any(named: 'search')))
          .thenThrow(const NetworkFailure('offline', issue: FailureIssue.unreachable));
      await pump(tester, const UserListScreen(), superAdmin);
      expect(find.text(l10nOf(tester).networkUnreachable), findsOneWidget);

      stubUsers([]);
      await tester.tap(find.text(l10nOf(tester).commonRetry));
      await tester.pumpAndSettle();
      expect(find.text(l10nOf(tester).usersEmpty), findsOneWidget);
    });

    testWidgets('add and delete follow users.create / users.delete', (tester) async {
      stubUsers([me, budi]);
      await pump(tester, const UserListScreen(), superAdmin);
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byType(Dismissible), findsNWidgets(2));

      await pump(tester, const UserListScreen(), userWith({Permissions.usersView}));
      expect(find.byType(FloatingActionButton), findsNothing);
      expect(find.byType(Dismissible), findsNothing);
    });

    testWidgets('swiping your own row: a short message, no request, the row stays', (tester) async {
      stubUsers([me, budi]);
      await pump(tester, const UserListScreen(), superAdmin);

      await tester.drag(find.byKey(const ValueKey('user_tile_1')), const Offset(-500, 0));
      await tester.pumpAndSettle();

      expect(find.text(l10nOf(tester).userSelfDelete), findsOneWidget);
      verifyNever(() => users.deleteUser(any()));
      expect(find.byKey(const ValueKey('user_tile_1')), findsOneWidget);
    });

    testWidgets('delete another user: confirmed, then gone', (tester) async {
      stubUsers([me, budi]);
      when(() => users.deleteUser(9)).thenAnswer((_) async {});
      await pump(tester, const UserListScreen(), superAdmin);

      await tester.drag(find.byKey(const ValueKey('user_tile_9')), const Offset(-500, 0));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('user_delete_confirm')));
      await tester.pumpAndSettle();

      verify(() => users.deleteUser(9)).called(1);
      expect(find.byKey(const ValueKey('user_tile_9')), findsNothing);
    });
  });

  group('UserFormScreen', () {
    testWidgets('create: every required field checked before any request', (tester) async {
      await pump(tester, const UserFormScreen(), superAdmin);

      await tester.tap(find.byKey(const Key('user_form_submit')));
      await tester.pumpAndSettle();

      final l10n = l10nOf(tester);
      expect(find.text(l10n.validationNameRequired), findsOneWidget);
      expect(find.text(l10n.validationEmailRequired), findsOneWidget);
      expect(find.text(l10n.validationPasswordRequired), findsOneWidget);
      expect(find.text(l10n.validationRoleRequired), findsOneWidget);
      verifyNever(() => users.createUser(any()));
    });

    testWidgets('create: a short password and a bad email', (tester) async {
      await pump(tester, const UserFormScreen(), superAdmin);

      await tester.enterText(find.byKey(const Key('user_form_email')), 'nope');
      await tester.enterText(find.byKey(const Key('user_form_password')), 'short');
      await tester.tap(find.byKey(const Key('user_form_submit')));
      await tester.pumpAndSettle();

      final l10n = l10nOf(tester);
      expect(find.text(l10n.validationEmailInvalid), findsOneWidget);
      expect(find.text(l10n.validationPasswordTooShort(8)), findsOneWidget);
    });

    testWidgets('editing yourself: role and active switch locked, with the reason', (tester) async {
      when(() => users.getUser(1)).thenAnswer((_) async => me);
      await pump(tester, const UserFormScreen(userId: 1), superAdmin);

      final dropdown = tester.widget<DropdownButton<int?>>(find.byType(DropdownButton<int?>));
      expect(dropdown.onChanged, isNull);
      expect(find.text(l10nOf(tester).userSelfRole), findsOneWidget);
      expect(tester.widget<SwitchListTile>(find.byKey(const Key('user_form_active'))).onChanged, isNull);
      expect(find.byKey(const Key('user_self_deactivate_note')), findsOneWidget);
    });

    testWidgets('editing someone else: deactivate + change role sends just that', (tester) async {
      when(() => users.getUser(9)).thenAnswer((_) async => budi);
      when(() => users.updateUser(any(), any())).thenAnswer((_) async => budi);
      await pump(tester, const UserFormScreen(userId: 9), superAdmin);

      await tester.tap(find.byKey(const Key('user_form_active')));
      await tester.tap(find.byType(DropdownButton<int?>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Gudang').last);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const Key('user_form_submit')));
      await tester.tap(find.byKey(const Key('user_form_submit')));
      await tester.pumpAndSettle();

      final patch = verify(() => users.updateUser(9, captureAny())).captured.single;
      expect(patch.roleId, 3);
      expect(patch.isActive, isFalse);
      expect(patch.password, isNull, reason: 'empty new password = keep the current one');
      expect(patch.email, isNull);
    });

    testWidgets('a non-Super-Admin is not offered the Super Admin role, nor a role beyond their permissions', (tester) async {
      // Holds Staff's permissions, not Gudang's (inventory.view).
      await pump(tester, const UserFormScreen(),
          userWith({...Permissions.userManagement, Permissions.productsView, Permissions.salesOrdersCreate}));

      await tester.tap(find.byType(DropdownButton<int?>));
      await tester.pumpAndSettle();
      expect(find.text('Staff'), findsWidgets);
      expect(find.text('Gudang'), findsNothing);
      expect(find.text('Super Admin'), findsNothing);
    });

    testWidgets('a refusal (409/403) shows the server\'s sentence in the form', (tester) async {
      when(() => users.getUser(9)).thenAnswer((_) async => budi);
      when(() => users.updateUser(any(), any()))
          .thenThrow(const ServerFailure('email sudah dipakai pengguna lain', statusCode: 409, code: 'conflict'));
      await pump(tester, const UserFormScreen(userId: 9), superAdmin);

      await tester.enterText(find.byKey(const Key('user_form_email')), 'staff@example.com');
      await tester.ensureVisible(find.byKey(const Key('user_form_submit')));
      await tester.tap(find.byKey(const Key('user_form_submit')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('user_form_error')), findsOneWidget);
      expect(find.text('email sudah dipakai pengguna lain'), findsOneWidget);
    });

    testWidgets('view only: nothing to save', (tester) async {
      when(() => users.getUser(9)).thenAnswer((_) async => budi);
      await pump(tester, const UserFormScreen(userId: 9), userWith({Permissions.usersView}));
      expect(find.byKey(const Key('user_form_submit')), findsNothing);
    });
  });
  // "Only what you hold" (backend grant_scope.go, app grant_scope.dart).
  // The actor below is a user manager whose permissions cover Staff but
  // not Gudang (inventory.view) — and never the Super Admin role.
  group('scope', () {
    final manager = userWith({
      Permissions.usersView,
      Permissions.usersCreate,
      Permissions.usersUpdate,
      Permissions.usersDelete,
      Permissions.productsView,
      Permissions.salesOrdersCreate,
    });
    final staffUser = managedUser(11, name: 'Sari', role: staffRole);
    final adminUser = managedUser(12, name: 'Admin Dua', role: superAdminRole);
    final gudangUser = managedUser(13, name: 'Gita', role: gudangRole);

    Future<List<String>> dropdownItems(WidgetTester tester) async {
      await tester.tap(find.byType(DropdownButton<int?>));
      await tester.pumpAndSettle();
      final items = tester
          .widgetList<DropdownMenuItem<int?>>(find.byType(DropdownMenuItem<int?>))
          .map((i) => ((i.child as Text).data)!)
          .toSet()
          .toList()
        ..sort();
      await tester.tapAt(Offset.zero); // close the menu
      await tester.pumpAndSettle();
      return items;
    }

    testWidgets('role dropdown: Super Admin sees every role', (tester) async {
      await pump(tester, const UserFormScreen(), superAdmin);
      expect(await dropdownItems(tester), ['Gudang', 'Staff', 'Super Admin']);
    });

    testWidgets('role dropdown: a user manager sees only the roles they may grant', (tester) async {
      await pump(tester, const UserFormScreen(), manager);
      expect(await dropdownItems(tester), ['Staff']);
    });

    testWidgets('role dropdown: users.create alone (no roles.view) still loads GET /roles', (tester) async {
      when(() => roles.getRoles(page: any(named: 'page'), pageSize: any(named: 'pageSize')))
          .thenAnswer((_) async => rolePage([superAdminRole, staffRole, gudangRole, role(6, name: 'Tamu')]));
      await pump(tester, const UserFormScreen(), userWith({Permissions.usersCreate}));

      verify(() => roles.getRoles(page: any(named: 'page'), pageSize: any(named: 'pageSize'))).called(1);
      expect(await dropdownItems(tester), ['Tamu'], reason: 'the only role within an empty scope grants nothing');
      verifyNever(() => roles.getRole(any()));
      verifyNever(() => roles.getPermissionCatalog());
    });

    testWidgets('role dropdown: users.view alone never asks for GET /roles (it would be a 403)', (tester) async {
      when(() => users.getUser(11)).thenAnswer((_) async => staffUser);
      await pump(tester, const UserFormScreen(userId: 11), userWith({Permissions.usersView}));

      verifyNever(() => roles.getRoles(page: any(named: 'page'), pageSize: any(named: 'pageSize')));
      expect(find.text('Staff'), findsOneWidget, reason: 'the current role still shows');
    });

    testWidgets('user list: rows beyond the scope are locked — no swipe, a tap only explains', (tester) async {
      stubUsers([staffUser, adminUser, gudangUser]);
      await pump(tester, const UserListScreen(), manager);
      final l10n = l10nOf(tester);

      expect(find.byKey(const ValueKey('user_locked_11')), findsNothing);
      expect(find.byKey(const ValueKey('user_locked_12')), findsOneWidget, reason: 'a Super Admin');
      expect(find.byKey(const ValueKey('user_locked_13')), findsOneWidget, reason: 'Gudang has inventory.view');
      expect(find.textContaining(l10n.userOutOfScope), findsNWidgets(2));
      expect(find.byType(Dismissible), findsOneWidget, reason: 'only Sari (Staff) can be swiped');

      await tester.tap(find.byKey(const ValueKey('user_tile_12')));
      await tester.pumpAndSettle();
      expect(find.byType(UserListScreen), findsOneWidget, reason: 'no form opened');
      expect(find.descendant(of: find.byType(SnackBar), matching: find.text(l10n.userOutOfScope)), findsOneWidget);
      verifyNever(() => users.getUser(any()));
    });

    testWidgets('user list: Super Admin locks nothing', (tester) async {
      stubUsers([staffUser, adminUser, gudangUser]);
      await pump(tester, const UserListScreen(), superAdmin);
      expect(find.byIcon(Icons.lock_outline), findsNothing);
      expect(find.byType(Dismissible), findsNWidgets(3));
    });

    testWidgets('user list: roles not readable → unknown → nothing hidden except the known Super Admin', (tester) async {
      stubUsers([staffUser, adminUser, gudangUser]);
      await pump(tester, const UserListScreen(), userWith({Permissions.usersView, Permissions.usersDelete}));

      verifyNever(() => roles.getRoles(page: any(named: 'page'), pageSize: any(named: 'pageSize')));
      expect(find.byKey(const ValueKey('user_locked_13')), findsNothing, reason: 'unknown: the backend decides');
      expect(find.byKey(const ValueKey('user_locked_12')), findsOneWidget, reason: 'is_system is in the user itself');
      expect(find.byType(Dismissible), findsNWidgets(2));
    });

    testWidgets('user form opened for a user out of scope (deep link): back, with the same message', (tester) async {
      when(() => users.getUser(13)).thenAnswer((_) async => gudangUser);
      await pump(tester, const UserFormScreen(userId: 13), manager);

      expect(find.text('home'), findsOneWidget);
      expect(find.byType(UserFormScreen), findsNothing);
      expect(find.descendant(of: find.byType(SnackBar), matching: find.text(l10nOf(tester).userOutOfScope)),
          findsOneWidget);
      verifyNever(() => users.updateUser(any(), any()));
    });

    testWidgets('user form in scope stays open', (tester) async {
      when(() => users.getUser(11)).thenAnswer((_) async => staffUser);
      await pump(tester, const UserFormScreen(userId: 11), manager);
      expect(find.byKey(const Key('user_form_submit')), findsOneWidget);
    });

    // The backend's 403 sentences (captured, see test/helpers/admin_json.dart)
    // appear exactly as sent; nothing in the app matches or rewrites them.
    const assignRefused =
        'tidak bisa memberikan role "Staff" karena role itu punya izin "categories.view" yang tidak anda miliki sendiri';
    const changeRefused =
        'tidak bisa mengubah atau menghapus pengguna dengan role "Staff" karena role itu punya izin "categories.view" yang tidak anda miliki sendiri';

    testWidgets('403 on save: the server\'s sentence in the form banner, as is', (tester) async {
      when(() => users.createUser(any()))
          .thenThrow(const ServerFailure(assignRefused, statusCode: 403, code: 'forbidden'));
      await pump(tester, const UserFormScreen(), manager);

      await tester.enterText(find.byKey(const Key('user_form_name')), 'Baru');
      await tester.enterText(find.byKey(const Key('user_form_email')), 'baru@example.com');
      await tester.enterText(find.byKey(const Key('user_form_password')), 'rahasia123');
      await tester.tap(find.byType(DropdownButton<int?>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Staff').last);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const Key('user_form_submit')));
      await tester.tap(find.byKey(const Key('user_form_submit')));
      await tester.pumpAndSettle();

      final banner = find.byKey(const Key('user_form_error'));
      expect(find.descendant(of: banner, matching: find.text(assignRefused)), findsOneWidget);
    });

    testWidgets('403 on delete: the server\'s sentence in the snack bar, as is; the row stays', (tester) async {
      stubUsers([staffUser]);
      when(() => users.deleteUser(11)).thenThrow(const ServerFailure(changeRefused, statusCode: 403, code: 'forbidden'));
      await pump(tester, const UserListScreen(), manager);

      await tester.drag(find.byKey(const ValueKey('user_tile_11')), const Offset(-500, 0));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('user_delete_confirm')));
      await tester.pumpAndSettle();

      expect(find.descendant(of: find.byType(SnackBar), matching: find.text(changeRefused)), findsOneWidget);
      expect(find.byKey(const ValueKey('user_tile_11')), findsOneWidget);
    });
  });
}
