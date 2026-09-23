import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/core/router/app_router.dart';
import 'package:inventory_intel/features/dashboard/domain/entities/dashboard.dart';
import 'package:inventory_intel/shared/theme/app_motion.dart';
import 'package:inventory_intel/features/dashboard/presentation/providers/dashboard_data_providers.dart';
import 'package:inventory_intel/features/dashboard/presentation/providers/dashboard_filter_provider.dart';
import 'package:inventory_intel/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:inventory_intel/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/dashboard_fixtures.dart';
import '../../helpers/l10n_harness.dart';

void main() {
  late MockDashboardRepository repo;

  setUpAll(registerDashboardFallbacks);
  setUp(() => repo = MockDashboardRepository());

  ProviderContainer makeContainer() =>
      ProviderContainer.test(overrides: [dashboardRepositoryProvider.overrideWithValue(repo)], retry: (_, _) => null);

  /// Subscribes to every section so the providers stay alive like on the page.
  Future<ProviderContainer> loadedContainer() async {
    final container = makeContainer();
    container.listen(dashboardSummaryProvider, (_, _) {});
    container.listen(dashboardSalesTrendProvider, (_, _) {});
    container.listen(dashboardTopProductsProvider, (_, _) {});
    container.listen(dashboardCategoryBreakdownProvider, (_, _) {});
    container.listen(dashboardLowStockCountProvider, (_, _) {});
    await container.read(dashboardSummaryProvider.future);
    await container.read(dashboardSalesTrendProvider.future);
    await container.read(dashboardTopProductsProvider.future);
    await container.read(dashboardCategoryBreakdownProvider.future);
    await container.read(dashboardLowStockCountProvider.future);
    return container;
  }

  group('providers', () {
    test('default range is the last 30 days and the trend starts daily', () async {
      stubDashboard(repo);
      final container = await loadedContainer();
      final expected = defaultRange();

      expect(container.read(dashboardDateRangeProvider), expected);
      expect(container.read(dashboardSummaryProvider).requireValue.totalRevenue, 928000);
      verify(() => repo.getSummary(expected)).called(1);
      verify(() => repo.getSalesTrend(expected, TrendGranularity.daily)).called(1);
      verify(() => repo.getTopProducts(expected, limit: 10)).called(1);
      verify(() => repo.getCategoryBreakdown(expected)).called(1);
    });

    test('changing the date range refreshes every range-based section at once', () async {
      stubDashboard(repo);
      final container = await loadedContainer();
      final next = rangeOfDays(7);

      container.read(dashboardDateRangeProvider.notifier).setPresetDays(7);
      await container.read(dashboardSummaryProvider.future);
      await container.read(dashboardSalesTrendProvider.future);
      await container.read(dashboardTopProductsProvider.future);
      await container.read(dashboardCategoryBreakdownProvider.future);

      verify(() => repo.getSummary(next)).called(1);
      verify(() => repo.getSalesTrend(next, TrendGranularity.daily)).called(1);
      verify(() => repo.getTopProducts(next, limit: 10)).called(1);
      verify(() => repo.getCategoryBreakdown(next)).called(1);
      // The low-stock count is "right now" data, so it must not refetch.
      verify(repo.getLowStockAlertCount).called(1);
    });

    test('a custom range is used as picked, without touching the time of day', () async {
      stubDashboard(repo);
      final container = await loadedContainer();

      container
          .read(dashboardDateRangeProvider.notifier)
          .setCustomRange(DateTime(2026, 8, 1, 13, 45), DateTime(2026, 8, 31, 9, 5));
      await container.read(dashboardSummaryProvider.future);

      verify(() => repo.getSummary(AnalyticsRange(from: DateTime(2026, 8, 1), to: DateTime(2026, 8, 31)))).called(1);
    });

    test('switching granularity refetches only the trend', () async {
      stubDashboard(repo);
      final container = await loadedContainer();

      container.read(trendGranularityFilterProvider.notifier).set(TrendGranularity.weekly);
      final weekly = await container.read(dashboardSalesTrendProvider.future);

      expect(weekly.granularity, TrendGranularity.weekly);
      verify(() => repo.getSalesTrend(defaultRange(), TrendGranularity.weekly)).called(1);
      // Still exactly the one call from the initial load.
      verify(() => repo.getSummary(any())).called(1);
      verify(() => repo.getTopProducts(any(), limit: any(named: 'limit'))).called(1);
      verify(() => repo.getCategoryBreakdown(any())).called(1);
    });

    test('one failing endpoint leaves the other sections with data', () async {
      stubDashboard(repo);
      when(() => repo.getTopProducts(any(), limit: any(named: 'limit')))
          .thenThrow(const NetworkFailure('Tidak ada koneksi internet'));
      final container = makeContainer();
      container.listen(dashboardSummaryProvider, (_, _) {});
      container.listen(dashboardTopProductsProvider, (_, _) {});
      await container.read(dashboardSummaryProvider.future);
      await expectLater(container.read(dashboardTopProductsProvider.future), throwsA(isA<NetworkFailure>()));

      expect(container.read(dashboardTopProductsProvider).hasError, isTrue);
      expect(container.read(dashboardSummaryProvider).requireValue.totalOrders, 13);
    });
  });

  group('dashboard screen', () {
    /// A tall surface so every section is laid out at once; the real page
    /// scrolls, but scrolling in the test would only hide which section a
    /// widget belongs to.
    void useTallSurface(WidgetTester tester) {
      tester.view.physicalSize = const Size(1000, 3200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
    }

    Widget app() {
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(path: '/', builder: (_, _) => const DashboardScreen()),
          GoRoute(
            path: '/low-stock',
            name: AppRoutes.lowStock,
            builder: (_, _) => const Scaffold(body: Text('Halaman Stok Menipis')),
          ),
          GoRoute(
            path: '/settings',
            name: AppRoutes.settings,
            builder: (_, _) => const Scaffold(body: Text('Halaman Pengaturan')),
          ),
        ],
      );
      return ProviderScope(
        overrides: [dashboardRepositoryProvider.overrideWithValue(repo)],
        retry: (_, _) => null,
        child: localizedApp(routerConfig: router),
      );
    }

    testWidgets('a slow section keeps its own skeleton while the others already show data', (tester) async {
      stubDashboard(repo);
      final slowTopProducts = Completer<List<TopProduct>>();
      when(() => repo.getTopProducts(any(), limit: any(named: 'limit'))).thenAnswer((_) => slowTopProducts.future);
      useTallSurface(tester);
      await tester.pumpWidget(app());
      // Not pumpAndSettle: the slow section's shimmer loops forever.
      await tester.pump();
      await tester.pump(AppMotion.counter);

      // The four finished sections render; only the slow one is still loading,
      // and it is the list-shaped skeleton rather than a bare spinner.
      expect(find.text('Rp 928.000'), findsOneWidget);
      expect(find.text('11'), findsOneWidget);
      expect(find.byKey(const Key('skeleton_list')), findsOneWidget);

      slowTopProducts.complete(topProducts);
      await tester.pumpAndSettle();

      expect(find.text('Kopi Arabica'), findsOneWidget);
      expect(find.byKey(const Key('skeleton_list')), findsNothing);
    });

    testWidgets('data: summary in Rupiah, top products, categories and the low-stock badge', (tester) async {
      stubDashboard(repo);
      useTallSurface(tester);
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();

      expect(find.text('Rp 928.000'), findsOneWidget); // total revenue
      expect(find.text('13'), findsOneWidget); // orders
      expect(find.text('Rp 71.385'), findsOneWidget); // average order value
      expect(find.text('11'), findsOneWidget); // low-stock badge

      expect(find.text('Kopi Arabica'), findsOneWidget);
      expect(find.text(l10nOf(tester).dashboardTopProductSold('KOPI-001', 3)), findsOneWidget);

      // Comes from the API payload (`category_name`), so it is not translated.
      expect(find.text('Tanpa Kategori'), findsOneWidget);
      expect(find.text('Minuman'), findsOneWidget);
    });

    testWidgets('a failing section shows its own retry while the rest still renders', (tester) async {
      stubDashboard(repo);
      when(() => repo.getSummary(any())).thenThrow(const NetworkFailure('Tidak ada koneksi internet'));
      useTallSurface(tester);
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();

      expect(find.text(l10nOf(tester).networkUnreachable), findsOneWidget);
      expect(find.text(l10nOf(tester).commonRetry), findsOneWidget);
      expect(find.text('11'), findsOneWidget); // low-stock section unaffected

      when(() => repo.getSummary(any())).thenAnswer((_) async => summary());
      await tester.tap(find.text(l10nOf(tester).commonRetry));
      await tester.pumpAndSettle();

      expect(find.text('Rp 928.000'), findsOneWidget);
      expect(find.text(l10nOf(tester).commonRetry), findsNothing);
    });

    testWidgets('the low-stock card opens the Low Stock page, also when its count failed', (tester) async {
      stubDashboard(repo);
      when(repo.getLowStockAlertCount).thenThrow(const NetworkFailure('offline'));
      useTallSurface(tester);
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();

      expect(find.text(l10nOf(tester).dashboardLowStockCountFailed), findsOneWidget);
      await tester.tap(find.text(l10nOf(tester).dashboardLowStockTitle));
      await tester.pumpAndSettle();

      expect(find.text('Halaman Stok Menipis'), findsOneWidget);
    });

    testWidgets('picking a preset reloads the page for the new range', (tester) async {
      stubDashboard(repo);
      useTallSurface(tester);
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ChoiceChip, l10nOf(tester).dashboardRangeDays(7)));
      await tester.pumpAndSettle();

      final next = rangeOfDays(7);
      expect(find.text(l10nOf(tester).dashboardRangeDays(7)), findsWidgets);
      verify(() => repo.getSummary(next)).called(1);
      verify(() => repo.getCategoryBreakdown(next)).called(1);
    });

    testWidgets('the granularity toggle asks the backend for weekly buckets', (tester) async {
      stubDashboard(repo);
      useTallSurface(tester);
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();

      await tester.tap(find.text(l10nOf(tester).dashboardTrendWeekly));
      await tester.pumpAndSettle();

      verify(() => repo.getSalesTrend(defaultRange(), TrendGranularity.weekly)).called(1);
      verify(() => repo.getSummary(any())).called(1); // not refetched
    });

    testWidgets('the app bar opens Settings (the language lives there, not in a sixth tab)', (tester) async {
      stubDashboard(repo);
      useTallSurface(tester);
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('dashboard_settings_button')));
      await tester.pumpAndSettle();

      expect(find.text('Halaman Pengaturan'), findsOneWidget);
    });
  });
}
