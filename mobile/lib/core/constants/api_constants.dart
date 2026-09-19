/// API configuration. Values come from `--dart-define` / `--dart-define-from-file`
/// at build time so no environment URL is hardcoded for release builds.
abstract final class ApiConstants {
  /// Go backend base URL. Android emulator: use http://10.0.2.2:8080.
  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );

  static const connectTimeout = Duration(seconds: 10);
  static const receiveTimeout = Duration(seconds: 15);

  static const productsPath = '/api/v1/products';
  static const categoriesPath = '/api/v1/categories';
  static const inventoryPath = '/api/v1/inventory';
  static const customersPath = '/api/v1/customers';
  static const salesOrdersPath = '/api/v1/sales-orders';

  /// Mirrors backend service.MaxPageSize.
  static const maxPageSize = 100;

  /// Mirrors backend service.DefaultPageSize.
  static const defaultPageSize = 20;
}
