import 'package:inventory_intel/features/dashboard/domain/entities/dashboard.dart';
import 'package:inventory_intel/features/dashboard/domain/entities/forecast.dart';
import 'package:inventory_intel/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:mocktail/mocktail.dart';

import 'forecast_fixtures.dart';

class MockDashboardRepository extends Mock implements DashboardRepository {}

/// The range the dashboard starts on (same default as the backend).
AnalyticsRange defaultRange() => AnalyticsRange.last30Days(DateTime.now());

AnalyticsRange rangeOfDays(int days) => AnalyticsRange.lastDays(DateTime.now(), days);

DashboardSummary summary({
  AnalyticsRange? range,
  int revenue = 928000,
  int orders = 13,
  int items = 42,
  int aov = 71385,
}) => DashboardSummary(
  range: range ?? defaultRange(),
  totalRevenue: revenue,
  totalOrders: orders,
  totalItemsSold: items,
  averageOrderValue: aov,
);

/// A trend whose points carry [revenues], one per day starting at the range start.
SalesTrend trend({
  AnalyticsRange? range,
  TrendGranularity granularity = TrendGranularity.daily,
  List<int> revenues = const [0, 120000, 928000],
}) {
  final r = range ?? defaultRange();
  return SalesTrend(
    range: r,
    granularity: granularity,
    points: [
      for (var i = 0; i < revenues.length; i++)
        SalesTrendPoint(
          periodStart: r.from.add(Duration(days: i)),
          periodEnd: r.from.add(Duration(days: i)),
          revenue: revenues[i],
          orders: revenues[i] == 0 ? 0 : 1,
        ),
    ],
  );
}

const topProducts = [
  TopProduct(productId: 17, sku: 'KOPI-001', name: 'Kopi Arabica', quantitySold: 3, revenue: 135000),
  TopProduct(productId: 4, sku: 'TEH-001', name: 'Teh Melati', quantitySold: 2, revenue: 90000),
];

/// Mirrors the live payload: the uncategorized bucket comes first and biggest.
const categoryBreakdown = [
  CategoryBreakdown(categoryName: 'Tanpa Kategori', quantitySold: 34, revenue: 778000),
  CategoryBreakdown(categoryId: 8, categoryName: 'Minuman', quantitySold: 2, revenue: 90000),
];

/// Stubs all five endpoints with happy-path data. The trend echoes back the
/// granularity it was asked for, like the backend does.
void stubDashboard(
  MockDashboardRepository repo, {
  int lowStockCount = 11,
  List<TopProduct> products = topProducts,
  List<CategoryBreakdown> categories = categoryBreakdown,
  ForecastReport? forecast,
  InsightReport? insights,
}) {
  when(() => repo.getSummary(any()))
      .thenAnswer((i) async => summary(range: i.positionalArguments[0] as AnalyticsRange));
  when(() => repo.getSalesTrend(any(), any())).thenAnswer(
    (i) async => trend(
      range: i.positionalArguments[0] as AnalyticsRange,
      granularity: i.positionalArguments[1] as TrendGranularity,
    ),
  );
  when(() => repo.getTopProducts(any(), limit: any(named: 'limit'))).thenAnswer((_) async => products);
  when(() => repo.getCategoryBreakdown(any())).thenAnswer((_) async => categories);
  when(repo.getLowStockAlertCount).thenAnswer((_) async => lowStockCount);
  when(
    () => repo.getForecast(
      any(),
      limit: any(named: 'limit'),
      horizonDays: any(named: 'horizonDays'),
    ),
  ).thenAnswer((i) async => forecast ?? forecastReport(range: i.positionalArguments[0] as AnalyticsRange));
  when(() => repo.getInsights(any(), limit: any(named: 'limit')))
      .thenAnswer((i) async => insights ?? insightReport(range: i.positionalArguments[0] as AnalyticsRange));
}

/// Call once in `setUpAll` so `any()` works for these argument types.
void registerDashboardFallbacks() {
  registerFallbackValue(defaultRange());
  registerFallbackValue(TrendGranularity.daily);
}
