import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/features/dashboard/domain/entities/forecast.dart';
import 'package:inventory_intel/features/dashboard/presentation/providers/dashboard_data_providers.dart';
import 'package:inventory_intel/features/dashboard/presentation/providers/dashboard_filter_provider.dart';
import 'package:inventory_intel/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:inventory_intel/features/dashboard/presentation/widgets/forecast_section.dart';
import 'package:inventory_intel/features/dashboard/presentation/widgets/insights_section.dart';
import 'package:inventory_intel/features/dashboard/presentation/widgets/unavailable_view.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/dashboard_fixtures.dart';
import '../../helpers/forecast_fixtures.dart';
import '../../helpers/l10n_harness.dart';

void main() {
  late MockDashboardRepository repo;

  setUpAll(registerDashboardFallbacks);
  setUp(() => repo = MockDashboardRepository());

  ProviderContainer makeContainer() => ProviderContainer.test(
        overrides: [dashboardRepositoryProvider.overrideWithValue(repo)],
        retry: (_, _) => null,
      );

  group('providers', () {
    test('both sections load for the current range and the default limits', () async {
      stubDashboard(repo);
      final container = makeContainer();
      container.listen(dashboardForecastProvider, (_, _) {});
      container.listen(dashboardInsightsProvider, (_, _) {});

      final forecast = await container.read(dashboardForecastProvider.future);
      final insights = await container.read(dashboardInsightsProvider.future);

      expect(forecast.available, isTrue);
      expect(forecast.products, hasLength(2));
      expect(insights.products.single.summary, contains('naik'));
      verify(() => repo.getForecast(defaultRange(), limit: 5, horizonDays: 7)).called(1);
      verify(() => repo.getInsights(defaultRange(), limit: 5)).called(1);
    });

    test('changing the date range reloads both of them', () async {
      stubDashboard(repo);
      final container = makeContainer();
      container.listen(dashboardForecastProvider, (_, _) {});
      container.listen(dashboardInsightsProvider, (_, _) {});
      await container.read(dashboardForecastProvider.future);
      await container.read(dashboardInsightsProvider.future);

      container.read(dashboardDateRangeProvider.notifier).setPresetDays(7);
      await container.read(dashboardForecastProvider.future);
      await container.read(dashboardInsightsProvider.future);

      final next = rangeOfDays(7);
      verify(() => repo.getForecast(next, limit: 5, horizonDays: 7)).called(1);
      verify(() => repo.getInsights(next, limit: 5)).called(1);
    });

    test('an unavailable ML service is data, not an AsyncError', () async {
      stubDashboard(repo, forecast: unavailableForecast, insights: unavailableInsights);
      final container = makeContainer();
      container.listen(dashboardForecastProvider, (_, _) {});
      container.listen(dashboardInsightsProvider, (_, _) {});

      final forecast = await container.read(dashboardForecastProvider.future);

      expect(container.read(dashboardForecastProvider).hasError, isFalse);
      expect(forecast.available, isFalse);
      expect(forecast.products.every((p) => p.hasError), isTrue);
      expect((await container.read(dashboardInsightsProvider.future)).available, isFalse);
    });

    test('a partial failure keeps the report available', () async {
      stubDashboard(
        repo,
        forecast: forecastReport(products: [forecastOf(1), failedForecast(2)]),
      );
      final container = makeContainer();
      container.listen(dashboardForecastProvider, (_, _) {});

      final report = await container.read(dashboardForecastProvider.future);

      expect(report.available, isTrue);
      expect(report.isPartial, isTrue);
      expect(report.failedCount, 1);
    });

    test('a failure reaching our own API is still an error', () async {
      stubDashboard(repo);
      when(() => repo.getForecast(any(), limit: any(named: 'limit'), horizonDays: any(named: 'horizonDays')))
          .thenThrow(const NetworkFailure('Tidak ada koneksi internet'));
      final container = makeContainer();
      container.listen(dashboardForecastProvider, (_, _) {});

      await expectLater(container.read(dashboardForecastProvider.future), throwsA(isA<NetworkFailure>()));
      expect(container.read(dashboardForecastProvider).hasError, isTrue);
    });
  });

  group('ForecastSection', () {
    Widget wrap(Widget child) => localizedApp(home: Scaffold(body: SingleChildScrollView(child: child)));

    testWidgets('data: product rows with the horizon total and per-day average', (tester) async {
      await tester.pumpWidget(
        wrap(ForecastSection(report: forecastReport(products: [forecastOf(1, perDay: 2)]), onRetry: () {})),
      );

      expect(find.text('Produk 1'), findsOneWidget);
      expect(find.text('SKU-1'), findsOneWidget);
      expect(find.text(l10nOf(tester).dashboardForecastUnits('14')), findsOneWidget); // 7 days x 2
      expect(find.text(l10nOf(tester).dashboardForecastPerDay('2')), findsOneWidget);
      expect(find.text(l10nOf(tester).dashboardForecastHorizon(7)), findsOneWidget);
    });

    testWidgets('unavailable: a calm state, not a red error, and no product rows', (tester) async {
      await tester.pumpWidget(wrap(ForecastSection(report: unavailableForecast, onRetry: () {})));

      expect(find.byType(UnavailableView), findsOneWidget);
      expect(find.text(l10nOf(tester).dashboardForecastUnavailable), findsOneWidget);
      expect(find.text(l10nOf(tester).dashboardForecastUnavailableDetail), findsOneWidget);
      // The alarming icon of ErrorView must not appear here.
      expect(find.byIcon(Icons.cloud_off_outlined), findsNothing);
      expect(find.text('Produk 1'), findsNothing);
    });

    testWidgets('unavailable: the quiet retry calls back', (tester) async {
      var retried = 0;
      await tester.pumpWidget(wrap(ForecastSection(report: unavailableForecast, onRetry: () => retried++)));

      await tester.tap(find.text(l10nOf(tester).commonRetry));

      expect(retried, 1);
    });

    testWidgets('partial failure: the failed product is dimmed, the others keep their numbers', (tester) async {
      await tester.pumpWidget(
        wrap(
          ForecastSection(
            report: forecastReport(
              products: [forecastOf(1, perDay: 2), failedForecast(2, error: 'forecast gagal dihitung')],
            ),
            onRetry: () {},
          ),
        ),
      );

      expect(find.text(l10nOf(tester).dashboardForecastUnits('14')), findsOneWidget);
      expect(find.text('Produk 2'), findsOneWidget);
      expect(find.textContaining('forecast gagal dihitung'), findsOneWidget);
      // Dimmed, not hidden, and without a fake number.
      final opacities = tester.widgetList<Opacity>(find.byType(Opacity)).map((o) => o.opacity).toList();
      expect(opacities, containsAll(<double>[1, 0.6]));
    });

    testWidgets('empty: no sales to predict reads differently from unavailable', (tester) async {
      await tester.pumpWidget(wrap(ForecastSection(report: forecastReport(products: []), onRetry: () {})));

      expect(find.text(l10nOf(tester).dashboardForecastEmpty), findsOneWidget);
      expect(find.byType(UnavailableView), findsNothing);
    });
  });

  group('InsightsSection', () {
    Widget wrap(Widget child) => localizedApp(home: Scaffold(body: SingleChildScrollView(child: child)));

    testWidgets('data: summary sentence plus a coloured trend badge', (tester) async {
      await tester.pumpWidget(
        wrap(
          InsightsSection(
            report: insightReport(
              products: [
                insightOf(1, summary: 'Penjualan naik 32,0% dalam 4 minggu terakhir.'),
                insightOf(
                  2,
                  trend: TrendDirection.decreasing,
                  changePercent: -45,
                  summary: 'Penjualan turun 45,0% dalam 4 minggu terakhir.',
                ),
                insightOf(3, trend: TrendDirection.stable, changePercent: 0, summary: 'Penjualan relatif stabil.'),
              ],
            ),
            onRetry: () {},
          ),
        ),
      );

      expect(find.text('Penjualan naik 32,0% dalam 4 minggu terakhir.'), findsOneWidget);
      expect(find.text(l10nOf(tester).trendUpPercent(32)), findsOneWidget);
      expect(find.text(l10nOf(tester).trendDownPercent(45)), findsOneWidget);
      // A stable trend shows no percentage: "Stabil 0%" would read as noise.
      expect(find.text(l10nOf(tester).trendStable), findsOneWidget);
      expect(find.byKey(const ValueKey('trend_badge_increasing')), findsOneWidget);
      expect(find.byKey(const ValueKey('trend_badge_decreasing')), findsOneWidget);
      expect(find.byKey(const ValueKey('trend_badge_stable')), findsOneWidget);
    });

    testWidgets('unavailable: calm state with its own wording', (tester) async {
      await tester.pumpWidget(wrap(InsightsSection(report: unavailableInsights, onRetry: () {})));

      expect(find.byType(UnavailableView), findsOneWidget);
      expect(find.text(l10nOf(tester).dashboardInsightsUnavailable), findsOneWidget);
      expect(find.byType(TrendBadge), findsNothing);
    });

    testWidgets('partial failure: the failed product shows its message and no badge', (tester) async {
      await tester.pumpWidget(
        wrap(
          InsightsSection(
            report: insightReport(products: [insightOf(1), failedInsight(2, error: 'insight gagal dihitung')]),
            onRetry: () {},
          ),
        ),
      );

      expect(find.byType(TrendBadge), findsOneWidget);
      expect(find.text('insight gagal dihitung'), findsOneWidget);
    });

    testWidgets('empty: nothing sold in the range', (tester) async {
      await tester.pumpWidget(wrap(InsightsSection(report: insightReport(products: []), onRetry: () {})));

      expect(find.text(l10nOf(tester).dashboardInsightsEmpty), findsOneWidget);
      expect(find.byType(UnavailableView), findsNothing);
    });
  });

  group('dashboard screen sections', () {
    /// A tall surface so both new sections lay out at once.
    void useTallSurface(WidgetTester tester) {
      tester.view.physicalSize = const Size(1000, 4200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
    }

    Widget app() => ProviderScope(
          overrides: [dashboardRepositoryProvider.overrideWithValue(repo)],
          retry: (_, _) => null,
          child: localizedApp(home: const Scaffold(body: _SectionsUnderTest())),
        );

    testWidgets('a slow forecast keeps its own spinner while insights already render', (tester) async {
      stubDashboard(repo);
      final slow = Completer<ForecastReport>();
      when(() => repo.getForecast(any(), limit: any(named: 'limit'), horizonDays: any(named: 'horizonDays')))
          .thenAnswer((_) => slow.future);
      useTallSurface(tester);
      await tester.pumpWidget(app());
      await tester.pump();
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(TrendBadge), findsOneWidget, reason: 'insights do not wait for the forecast');

      slow.complete(healthyForecast);
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Produk 1'), findsWidgets);
    });

    testWidgets('ML service down: both sections show the calm state, side by side', (tester) async {
      stubDashboard(repo, forecast: unavailableForecast, insights: unavailableInsights);
      useTallSurface(tester);
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();

      expect(find.byType(UnavailableView), findsNWidgets(2));
      expect(find.text(l10nOf(tester).dashboardForecastUnavailable), findsOneWidget);
      expect(find.text(l10nOf(tester).dashboardInsightsUnavailable), findsOneWidget);
    });
  });
}

/// Only the two new sections, so the test does not depend on the rest of the
/// dashboard (charts, summary cards) laying out.
class _SectionsUnderTest extends ConsumerWidget {
  const _SectionsUnderTest();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insights = ref.watch(dashboardInsightsProvider);
    final forecast = ref.watch(dashboardForecastProvider);
    return SingleChildScrollView(
      child: Column(
        children: [
          switch (insights) {
            AsyncData(:final value) => InsightsSection(report: value, onRetry: () {}),
            AsyncError() => const Text('insights error'),
            _ => const CircularProgressIndicator(),
          },
          switch (forecast) {
            AsyncData(:final value) => ForecastSection(report: value, onRetry: () {}),
            AsyncError() => const Text('forecast error'),
            _ => const CircularProgressIndicator(),
          },
        ],
      ),
    );
  }
}
