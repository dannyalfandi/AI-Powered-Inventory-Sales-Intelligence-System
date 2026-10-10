/// Permission keys, mirroring the backend catalog in
/// backend/internal/auth/permissions.go. The backend is what enforces them
/// (403 otherwise); the app only uses them to hide what the user can't do.
abstract final class Permissions {
  static const productsView = 'products.view';
  static const productsCreate = 'products.create';
  static const productsUpdate = 'products.update';
  static const productsDelete = 'products.delete';

  static const categoriesView = 'categories.view';
  static const categoriesCreate = 'categories.create';
  static const categoriesUpdate = 'categories.update';
  static const categoriesDelete = 'categories.delete';

  static const inventoryView = 'inventory.view';
  static const inventoryUpdate = 'inventory.update';
  static const inventoryRecordMovement = 'inventory.record_movement';

  static const customersView = 'customers.view';
  static const customersCreate = 'customers.create';
  static const customersUpdate = 'customers.update';
  static const customersDelete = 'customers.delete';

  static const salesOrdersView = 'sales_orders.view';
  static const salesOrdersCreate = 'sales_orders.create';
  static const salesOrdersConfirm = 'sales_orders.confirm';
  static const salesOrdersShip = 'sales_orders.ship';
  static const salesOrdersCancel = 'sales_orders.cancel';

  static const analyticsView = 'analytics.view';
  static const analyticsForecast = 'analytics.forecast';
  static const analyticsInsights = 'analytics.insights';

  static const usersView = 'users.view';
  static const usersCreate = 'users.create';
  static const usersUpdate = 'users.update';
  static const usersDelete = 'users.delete';

  static const rolesView = 'roles.view';
  static const rolesCreate = 'roles.create';
  static const rolesUpdate = 'roles.update';
  static const rolesDelete = 'roles.delete';
  static const rolesAssignPermissions = 'roles.assign_permissions';

  /// Any of these opens role management (list, form, permission editor).
  static const roleManagement = [rolesView, rolesCreate, rolesUpdate, rolesDelete, rolesAssignPermissions];

  /// Any of these opens user management.
  static const userManagement = [usersView, usersCreate, usersUpdate, usersDelete];

  /// Any of these opens the Dashboard: each of its sections needs one of
  /// them (analytics.view: summary, low stock, trend, top products,
  /// categories; analytics.insights: insights; analytics.forecast: forecast).
  static const dashboard = [analyticsView, analyticsInsights, analyticsForecast];

  /// Any of these may read the role *list* (GET /roles): the backend opens it
  /// to user managers too, for the user form's role picker. The role detail
  /// (GET /roles/:id) and the catalog (GET /permissions) stay [rolesView] only.
  static const roleList = [rolesView, usersCreate, usersUpdate];
}
