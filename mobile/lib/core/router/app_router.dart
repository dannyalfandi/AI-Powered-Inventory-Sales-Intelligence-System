import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/domain/entities/auth_user.dart';
import '../../features/auth/presentation/providers/auth_controller.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/no_access_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/category/presentation/screens/category_form_screen.dart';
import '../../features/category/presentation/screens/category_list_screen.dart';
import '../../features/customer/presentation/screens/customer_form_screen.dart';
import '../../features/customer/presentation/screens/customer_list_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/inventory/presentation/screens/low_stock_screen.dart';
import '../../features/inventory/presentation/screens/product_stock_screen.dart';
import '../../features/product/presentation/screens/product_form_screen.dart';
import '../../features/product/presentation/screens/product_list_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/sales_order/presentation/screens/sales_order_detail_screen.dart';
import '../../features/sales_order/presentation/screens/sales_order_form_screen.dart';
import '../../features/sales_order/presentation/screens/sales_order_list_screen.dart';
import '../../features/role_management/presentation/screens/role_form_screen.dart';
import '../../features/role_management/presentation/screens/role_list_screen.dart';
import '../../features/role_management/presentation/screens/role_permission_editor_screen.dart';
import '../../features/user_management/presentation/screens/user_form_screen.dart';
import '../../features/user_management/presentation/screens/user_list_screen.dart';
import '../auth/permissions.dart';
import 'home_shell.dart';
import 'home_tabs.dart';

part 'app_router.g.dart';

/// Route names — navigate with `context.pushNamed(AppRoutes.x)`, never raw paths.
abstract final class AppRoutes {
  static const login = 'login';
  static const splash = 'splash';
  static const dashboard = 'dashboard';
  static const settings = 'settings';
  static const noAccess = 'no-access';
  static const products = 'products';
  static const productCreate = 'product-create';
  static const productDetail = 'product-detail';
  static const productEdit = 'product-edit';
  static const categories = 'categories';
  static const categoryCreate = 'category-create';
  static const categoryEdit = 'category-edit';
  static const lowStock = 'low-stock';
  static const customers = 'customers';
  static const customerCreate = 'customer-create';
  static const customerEdit = 'customer-edit';
  static const salesOrders = 'sales-orders';
  static const salesOrderCreate = 'sales-order-create';
  static const salesOrderDetail = 'sales-order-detail';
  static const roles = 'roles';
  static const roleCreate = 'role-create';
  static const roleEdit = 'role-edit';
  static const rolePermissions = 'role-permissions';
  static const users = 'users';
  static const userCreate = 'user-create';
  static const userEdit = 'user-edit';
}

/// Parses a positive integer path parameter, or returns null.
int? _positiveId(GoRouterState state) {
  final id = int.tryParse(state.pathParameters['id'] ?? '');
  return id == null || id <= 0 ? null : id;
}

/// The auth guard, as a pure function of the auth state and the location.
///
/// - While the stored session is being checked at start-up: /splash.
/// - Nobody logged in: /login, from anywhere. At /login already: stay — no
///   redirect loop, however many requests report the session ended.
/// - Logged in but on /login or /splash: the Dashboard.
/// - Otherwise: no redirect.
String? authRedirect(AsyncValue<AuthUser?> auth, String location) {
  const login = '/login';
  const splash = '/splash';
  if (auth.isLoading && !auth.hasValue) {
    return location == splash ? null : splash;
  }
  final loggedIn = auth.value != null;
  if (!loggedIn) {
    return location == login ? null : login;
  }
  if (location == login || location == splash) return '/';
  return null;
}

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  // The router is built once (keepAlive) and never rebuilt, so it doesn't
  // lose its navigation stack; it re-runs the guard whenever the auth state
  // changes — login, logout, or a session ended by any request.
  final auth = ValueNotifier<AsyncValue<AuthUser?>>(ref.read(authControllerProvider));
  ref.listen(authControllerProvider, (_, next) => auth.value = next);
  ref.onDispose(auth.dispose);

  /// The user every guard below decides on: the same value the router was
  /// just notified with. Reading `currentUserProvider` here instead would
  /// race the notification — during a refresh it can still hold the previous
  /// user, so a permission taken away (or a fresh login) would be judged
  /// against stale permissions.
  AuthUser? currentUser() => auth.value.value;

  /// Route-level permission gate: null (allowed) if the current user holds
  /// any of [anyOf], else back to Settings — where the entry points live.
  String? requireAny(List<String> anyOf) => (currentUser()?.canAny(anyOf) ?? false) ? null : '/settings';

  /// Tab gate: null (allowed) if the current user may open [tab], else the
  /// first tab they may open — or the no-access screen when there is none.
  /// The same check decides which tabs HomeShell shows (see HomeTab).
  String? requireTab(HomeTab tab) {
    final user = currentUser();
    return tab.allows(user) ? null : firstAllowedPath(user);
  }

  /// Like [requireAny], but every one of [allOf] is needed.
  String? requireAll(List<String> allOf) {
    final user = currentUser();
    return user != null && allOf.every(user.can) ? null : '/settings';
  }

  final router = GoRouter(
    initialLocation: '/',
    refreshListenable: auth,
    redirect: (context, state) => authRedirect(auth.value, state.matchedLocation),
    routes: [
      GoRoute(path: '/login', name: AppRoutes.login, builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/splash', name: AppRoutes.splash, builder: (context, state) => const SplashScreen()),

      // Tabs (bottom navigation). Each branch keeps its own stack.
      StatefulShellRoute(
        builder: (context, state, shell) => HomeShell(shell: shell),
        navigatorContainerBuilder: (context, shell, children) =>
            FadingBranchContainer(currentIndex: shell.currentIndex, children: children),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: AppRoutes.dashboard,
                // Also where login lands: someone without analytics goes on
                // to their first allowed tab from here.
                redirect: (context, state) => requireTab(HomeTab.dashboard),
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/products',
                name: AppRoutes.products,
                redirect: (context, state) => requireTab(HomeTab.products),
                builder: (context, state) => const ProductListScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/categories',
                name: AppRoutes.categories,
                redirect: (context, state) => requireTab(HomeTab.categories),
                builder: (context, state) => const CategoryListScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/customers',
                name: AppRoutes.customers,
                redirect: (context, state) => requireTab(HomeTab.customers),
                builder: (context, state) => const CustomerListScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/sales-orders',
                name: AppRoutes.salesOrders,
                redirect: (context, state) => requireTab(HomeTab.salesOrders),
                builder: (context, state) => const SalesOrderListScreen(),
              ),
            ],
          ),
        ],
      ),

      // Full-screen routes (root navigator, no bottom navigation).

      // A role without any view permission: nothing to show but the way to
      // Settings and to sign out. Leaves as soon as a tab opens up (the
      // permissions are refreshed on resume and after a 403).
      GoRoute(
        path: noAccessPath,
        name: AppRoutes.noAccess,
        redirect: (context, state) {
          final first = firstAllowedPath(currentUser());
          return first == noAccessPath ? null : first;
        },
        builder: (context, state) => const NoAccessScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),

      // Administration, reached from Settings. Each route also checks the
      // permission itself, so a deep link can't open a screen whose entry
      // point is hidden: without it, back to Settings.
      GoRoute(
        path: '/admin/roles',
        name: AppRoutes.roles,
        redirect: (context, state) => requireAny(Permissions.roleManagement),
        builder: (context, state) => const RoleListScreen(),
      ),
      // `roles/new` must come before `roles/:id`.
      GoRoute(
        path: '/admin/roles/new',
        name: AppRoutes.roleCreate,
        redirect: (context, state) => requireAny(const [Permissions.rolesCreate]),
        builder: (context, state) => const RoleFormScreen(),
      ),
      // A role's page loads GET /roles/:id, and its permission editor also
      // GET /permissions: both answer only to roles.view, so neither opens
      // without it (no request that can only be refused with 403).
      GoRoute(
        path: '/admin/roles/:id',
        name: AppRoutes.roleEdit,
        redirect: (context, state) =>
            _positiveId(state) == null ? '/admin/roles' : requireAny(const [Permissions.rolesView]),
        builder: (context, state) => RoleFormScreen(roleId: _positiveId(state)),
        routes: [
          GoRoute(
            path: 'permissions',
            name: AppRoutes.rolePermissions,
            redirect: (context, state) =>
                requireAll(const [Permissions.rolesView, Permissions.rolesAssignPermissions]),
            builder: (context, state) => RolePermissionEditorScreen(roleId: _positiveId(state)!),
          ),
        ],
      ),
      GoRoute(
        path: '/admin/users',
        name: AppRoutes.users,
        redirect: (context, state) => requireAny(Permissions.userManagement),
        builder: (context, state) => const UserListScreen(),
      ),
      GoRoute(
        path: '/admin/users/new',
        name: AppRoutes.userCreate,
        redirect: (context, state) => requireAny(const [Permissions.usersCreate]),
        builder: (context, state) => const UserFormScreen(),
      ),
      GoRoute(
        path: '/admin/users/:id',
        name: AppRoutes.userEdit,
        redirect: (context, state) =>
            _positiveId(state) == null ? '/admin/users' : requireAny(Permissions.userManagement),
        builder: (context, state) => UserFormScreen(userId: _positiveId(state)),
      ),

      // Low stock is reached from the low-stock card on the dashboard.
      // It lists GET /inventory/low-stock, which needs inventory.view.
      GoRoute(
        path: '/low-stock',
        name: AppRoutes.lowStock,
        redirect: (context, state) =>
            (currentUser()?.can(Permissions.inventoryView) ?? false) ? null : firstAllowedPath(currentUser()),
        builder: (context, state) => const LowStockScreen(),
      ),
      // `products/new` must come before `products/:id`.
      GoRoute(
        path: '/products/new',
        name: AppRoutes.productCreate,
        redirect: (context, state) => requireTab(HomeTab.products),
        builder: (context, state) => const ProductFormScreen(),
      ),
      GoRoute(
        path: '/products/:id',
        name: AppRoutes.productDetail,
        redirect: (context, state) => _positiveId(state) == null ? '/' : requireTab(HomeTab.products),
        builder: (context, state) => ProductStockScreen(productId: _positiveId(state)!),
        routes: [
          GoRoute(
            path: 'edit',
            name: AppRoutes.productEdit,
            builder: (context, state) => ProductFormScreen(productId: _positiveId(state)!),
          ),
        ],
      ),
      GoRoute(
        path: '/categories/new',
        name: AppRoutes.categoryCreate,
        redirect: (context, state) => requireTab(HomeTab.categories),
        builder: (context, state) => const CategoryFormScreen(),
      ),
      GoRoute(
        path: '/categories/:id/edit',
        name: AppRoutes.categoryEdit,
        redirect: (context, state) => _positiveId(state) == null ? '/categories' : requireTab(HomeTab.categories),
        builder: (context, state) => CategoryFormScreen(categoryId: _positiveId(state)!),
      ),
      GoRoute(
        path: '/customers/new',
        name: AppRoutes.customerCreate,
        redirect: (context, state) => requireTab(HomeTab.customers),
        builder: (context, state) => const CustomerFormScreen(),
      ),
      GoRoute(
        path: '/customers/:id/edit',
        name: AppRoutes.customerEdit,
        redirect: (context, state) => _positiveId(state) == null ? '/customers' : requireTab(HomeTab.customers),
        builder: (context, state) => CustomerFormScreen(customerId: _positiveId(state)!),
      ),
      // `sales-orders/new` must come before `sales-orders/:id`.
      GoRoute(
        path: '/sales-orders/new',
        name: AppRoutes.salesOrderCreate,
        redirect: (context, state) => requireTab(HomeTab.salesOrders),
        builder: (context, state) => const SalesOrderFormScreen(),
      ),
      GoRoute(
        path: '/sales-orders/:id',
        name: AppRoutes.salesOrderDetail,
        redirect: (context, state) =>
            _positiveId(state) == null ? '/sales-orders' : requireTab(HomeTab.salesOrders),
        builder: (context, state) => SalesOrderDetailScreen(orderId: _positiveId(state)!),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
}
