import '../../features/auth/domain/entities/auth_user.dart';
import '../auth/permissions.dart';

/// The bottom-navigation tabs, in branch order (it must match the
/// StatefulShellRoute in app_router.dart), each with the permissions that
/// open it: any one of [anyOf]. They are what the backend demands for the
/// endpoints behind the tab (backend/internal/router/router.go), so a tab is
/// shown exactly when its first request can succeed:
///
///   Dashboard   GET /analytics/*      analytics.view | .insights | .forecast
///   Products    GET /products         products.view
///   Categories  GET /categories       categories.view
///   Customers   GET /customers        customers.view
///   Orders      GET /sales-orders     sales_orders.view
///
/// Settings is not a tab: it is reachable from every tab's app bar, and from
/// the no-access screen.
enum HomeTab {
  dashboard('/', Permissions.dashboard),
  products('/products', [Permissions.productsView]),
  categories('/categories', [Permissions.categoriesView]),
  customers('/customers', [Permissions.customersView]),
  salesOrders('/sales-orders', [Permissions.salesOrdersView]);

  const HomeTab(this.path, this.anyOf);

  final String path;
  final List<String> anyOf;

  /// Index of this tab's branch in the StatefulShellRoute.
  int get branch => index;

  bool allows(AuthUser? user) => user?.canAny(anyOf) ?? false;

  /// The tabs [user] may open, in order. Empty for a role without any view
  /// permission (and for nobody logged in).
  static List<HomeTab> allowedFor(AuthUser? user) => [
    for (final tab in values)
      if (tab.allows(user)) tab,
  ];
}

/// Where a user without access to a tab is sent: the first tab they may
/// open, or the no-access screen when there is none.
const noAccessPath = '/no-access';

String firstAllowedPath(AuthUser? user) => HomeTab.allowedFor(user).firstOrNull?.path ?? noAccessPath;
