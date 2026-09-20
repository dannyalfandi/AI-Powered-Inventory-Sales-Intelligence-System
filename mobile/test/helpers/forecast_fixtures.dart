import 'package:inventory_intel/features/dashboard/domain/entities/dashboard.dart';
import 'package:inventory_intel/features/dashboard/domain/entities/forecast.dart';

import 'dashboard_fixtures.dart';

/// A product whose forecast worked: [days] flat days of [perDay] units.
ProductForecast forecastOf(int id, {String? name, double perDay = 2, int days = 7}) => ProductForecast(
  productId: id,
  productName: name ?? 'Produk $id',
  sku: 'SKU-$id',
  method: 'moving_average',
  forecast: [
    for (var i = 0; i < days; i++)
      ForecastPoint(
        date: DateTime(2026, 9, 21).add(Duration(days: i)),
        predictedQuantity: perDay,
      ),
  ],
);

/// A product the ML service could not answer for.
ProductForecast failedForecast(int id, {String? name, String? error}) => ProductForecast(
  productId: id,
  productName: name ?? 'Produk $id',
  sku: 'SKU-$id',
  error: error ?? 'layanan forecasting sedang tidak tersedia',
);

ForecastReport forecastReport({
  List<ProductForecast>? products,
  bool available = true,
  int horizonDays = 7,
  AnalyticsRange? range,
}) => ForecastReport(
  range: range ?? defaultRange(),
  horizonDays: horizonDays,
  available: available,
  products: products ?? [forecastOf(1), forecastOf(2, perDay: 0.5)],
);

ProductInsight insightOf(
  int id, {
  String? name,
  TrendDirection trend = TrendDirection.increasing,
  double changePercent = 32,
  String? summary,
}) => ProductInsight(
  productId: id,
  productName: name ?? 'Produk $id',
  sku: 'SKU-$id',
  trend: trend,
  changePercent: changePercent,
  summary: summary ?? 'Penjualan naik 32,0% dalam 4 minggu terakhir.',
);

ProductInsight failedInsight(int id, {String? name, String? error}) => ProductInsight(
  productId: id,
  productName: name ?? 'Produk $id',
  sku: 'SKU-$id',
  error: error ?? 'layanan forecasting sedang tidak tersedia',
);

InsightReport insightReport({List<ProductInsight>? products, bool available = true, AnalyticsRange? range}) =>
    InsightReport(range: range ?? defaultRange(), available: available, products: products ?? [insightOf(1)]);

/// The reports a healthy backend + ML service return.
ForecastReport get healthyForecast => forecastReport();

InsightReport get healthyInsights => insightReport();

/// What the API returns while the ML service is down: 200, but nothing usable.
ForecastReport get unavailableForecast =>
    forecastReport(available: false, products: [failedForecast(1), failedForecast(2)]);

InsightReport get unavailableInsights =>
    insightReport(available: false, products: [failedInsight(1), failedInsight(2)]);
