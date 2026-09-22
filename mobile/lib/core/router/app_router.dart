import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
import 'home_shell.dart';

part 'app_router.g.dart';

/// Route names — navigate with `context.pushNamed(AppRoutes.x)`, never raw paths.
abstract final class AppRoutes {
  static const dashboard = 'dashboard';
  static const settings = 'settings';
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
}

/// Parses a positive integer path parameter, or returns null.
int? _positiveId(GoRouterState state) {
  final id = int.tryParse(state.pathParameters['id'] ?? '');
  return id == null || id <= 0 ? null : id;
}

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      // Tabs (bottom navigation). Each branch keeps its own stack.
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => HomeShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/', name: AppRoutes.dashboard, builder: (context, state) => const DashboardScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/products',
                name: AppRoutes.products,
                builder: (context, state) => const ProductListScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/categories',
                name: AppRoutes.categories,
                builder: (context, state) => const CategoryListScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/customers',
                name: AppRoutes.customers,
                builder: (context, state) => const CustomerListScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/sales-orders',
                name: AppRoutes.salesOrders,
                builder: (context, state) => const SalesOrderListScreen(),
              ),
            ],
          ),
        ],
      ),

      // Full-screen routes (root navigator, no bottom navigation).
      GoRoute(
        path: '/settings',
        name: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      // Low stock is reached from the low-stock card on the dashboard.
      GoRoute(path: '/low-stock', name: AppRoutes.lowStock, builder: (context, state) => const LowStockScreen()),
      // `products/new` must come before `products/:id`.
      GoRoute(
        path: '/products/new',
        name: AppRoutes.productCreate,
        builder: (context, state) => const ProductFormScreen(),
      ),
      GoRoute(
        path: '/products/:id',
        name: AppRoutes.productDetail,
        redirect: (context, state) => _positiveId(state) == null ? '/' : null,
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
        builder: (context, state) => const CategoryFormScreen(),
      ),
      GoRoute(
        path: '/categories/:id/edit',
        name: AppRoutes.categoryEdit,
        redirect: (context, state) => _positiveId(state) == null ? '/categories' : null,
        builder: (context, state) => CategoryFormScreen(categoryId: _positiveId(state)!),
      ),
      GoRoute(
        path: '/customers/new',
        name: AppRoutes.customerCreate,
        builder: (context, state) => const CustomerFormScreen(),
      ),
      GoRoute(
        path: '/customers/:id/edit',
        name: AppRoutes.customerEdit,
        redirect: (context, state) => _positiveId(state) == null ? '/customers' : null,
        builder: (context, state) => CustomerFormScreen(customerId: _positiveId(state)!),
      ),
      // `sales-orders/new` must come before `sales-orders/:id`.
      GoRoute(
        path: '/sales-orders/new',
        name: AppRoutes.salesOrderCreate,
        builder: (context, state) => const SalesOrderFormScreen(),
      ),
      GoRoute(
        path: '/sales-orders/:id',
        name: AppRoutes.salesOrderDetail,
        redirect: (context, state) => _positiveId(state) == null ? '/sales-orders' : null,
        builder: (context, state) => SalesOrderDetailScreen(orderId: _positiveId(state)!),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
}
