import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/datasources/dashboard_remote_data_source.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/usecases/get_business_insights.dart';
import '../../domain/usecases/get_category_breakdown.dart';
import '../../domain/usecases/get_demand_forecast.dart';
import '../../domain/usecases/get_dashboard_summary.dart';
import '../../domain/usecases/get_low_stock_alert_count.dart';
import '../../domain/usecases/get_sales_trend.dart';
import '../../domain/usecases/get_top_products.dart';

part 'dashboard_providers.g.dart';

// Dependency graph for the dashboard feature. Tests override
// dashboardRepositoryProvider (or a usecase provider) with a mock.

@Riverpod(keepAlive: true)
DashboardRemoteDataSource dashboardRemoteDataSource(Ref ref) => DashboardRemoteDataSourceImpl(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
DashboardRepository dashboardRepository(Ref ref) =>
    DashboardRepositoryImpl(ref.watch(dashboardRemoteDataSourceProvider));

@Riverpod(keepAlive: true)
GetDashboardSummary getDashboardSummaryUseCase(Ref ref) => GetDashboardSummary(ref.watch(dashboardRepositoryProvider));

@Riverpod(keepAlive: true)
GetSalesTrend getSalesTrendUseCase(Ref ref) => GetSalesTrend(ref.watch(dashboardRepositoryProvider));

@Riverpod(keepAlive: true)
GetTopProducts getTopProductsUseCase(Ref ref) => GetTopProducts(ref.watch(dashboardRepositoryProvider));

@Riverpod(keepAlive: true)
GetCategoryBreakdown getCategoryBreakdownUseCase(Ref ref) =>
    GetCategoryBreakdown(ref.watch(dashboardRepositoryProvider));

@Riverpod(keepAlive: true)
GetLowStockAlertCount getLowStockAlertCountUseCase(Ref ref) =>
    GetLowStockAlertCount(ref.watch(dashboardRepositoryProvider));

@Riverpod(keepAlive: true)
GetDemandForecast getDemandForecastUseCase(Ref ref) => GetDemandForecast(ref.watch(dashboardRepositoryProvider));

@Riverpod(keepAlive: true)
GetBusinessInsights getBusinessInsightsUseCase(Ref ref) => GetBusinessInsights(ref.watch(dashboardRepositoryProvider));
