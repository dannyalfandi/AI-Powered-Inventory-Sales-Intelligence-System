import 'package:flutter_riverpod/misc.dart';
import 'package:inventory_intel/core/auth/permissions.dart';
import 'package:inventory_intel/features/auth/domain/entities/auth_user.dart';
import 'package:inventory_intel/features/auth/domain/repositories/auth_repository.dart';
import 'package:inventory_intel/features/auth/presentation/providers/auth_controller.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

/// A Super Admin: the system role passes every permission check.
const superAdmin = AuthUser(
  id: 1,
  email: 'admin@example.com',
  name: 'Super Admin',
  role: AuthRole(id: 1, name: 'Super Admin', isSystem: true),
  permissions: {},
);

/// The seeded Staff role (backend cmd/seed/accounts.go): views everything,
/// takes and processes orders; creates, edits and deletes nothing else.
const staff = AuthUser(
  id: 2,
  email: 'staff@example.com',
  name: 'Staf Demo',
  role: AuthRole(id: 2, name: 'Staff', isSystem: false),
  permissions: {
    Permissions.productsView,
    Permissions.categoriesView,
    Permissions.inventoryView,
    Permissions.customersView,
    Permissions.salesOrdersView,
    Permissions.salesOrdersCreate,
    Permissions.salesOrdersConfirm,
    Permissions.salesOrdersShip,
    Permissions.salesOrdersCancel,
    Permissions.analyticsView,
    Permissions.analyticsForecast,
    Permissions.analyticsInsights,
  },
);

/// A non-system user holding exactly [permissions].
AuthUser userWith(Set<String> permissions) => AuthUser(
  id: 9,
  email: 'custom@example.com',
  name: 'Custom',
  role: const AuthRole(id: 9, name: 'Custom', isSystem: false),
  permissions: permissions,
);

/// Puts [user] in the app as the logged-in user (null: nobody).
Override signedInAs(AuthUser? user) => currentUserProvider.overrideWithValue(user);
