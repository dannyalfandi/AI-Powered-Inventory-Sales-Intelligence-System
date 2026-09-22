import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/features/category/presentation/providers/category_providers.dart';
import 'package:inventory_intel/features/product/domain/entities/product.dart';
import 'package:inventory_intel/features/product/domain/entities/product_input.dart';
import 'package:inventory_intel/features/product/presentation/providers/product_providers.dart';
import 'package:inventory_intel/features/product/presentation/screens/product_form_screen.dart';
import 'package:inventory_intel/features/product/presentation/screens/product_list_screen.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/category_fixtures.dart';
import '../../../../helpers/product_fixtures.dart';
import '../../../../helpers/l10n_harness.dart';

void main() {
  late MockProductRepository repo;
  late MockCategoryRepository categories;

  setUpAll(registerProductFallbacks);
  setUp(() {
    repo = MockProductRepository();
    categories = MockCategoryRepository();
    // The form's category picker loads categories; never hit the network.
    stubCategoryOptions(categories, [category(3, name: 'Minuman'), category(4, name: 'Makanan')]);
  });

  Widget app(Widget home) => ProviderScope(
        overrides: [
          productRepositoryProvider.overrideWithValue(repo),
          categoryRepositoryProvider.overrideWithValue(categories),
        ],
        retry: (_, _) => null,
        child: localizedApp(home: home),
      );

  void stubList(Object result) {
    final call = when(
      () => repo.getProducts(page: any(named: 'page'), pageSize: any(named: 'pageSize'), search: any(named: 'search')),
    );
    if (result is Failure) {
      call.thenThrow(result);
    } else {
      call.thenAnswer((_) async => result as dynamic);
    }
  }

  group('ProductListScreen', () {
    testWidgets('shows products', (tester) async {
      stubList(productPage([product(1, name: 'Kopi Arabica', price: 45000)]));
      await tester.pumpWidget(app(const ProductListScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Kopi Arabica'), findsOneWidget);
      expect(find.text('Rp 45.000'), findsOneWidget);
    });

    testWidgets('shows the category name of categorized products', (tester) async {
      stubList(
        productPage([
          product(1, name: 'Kopi', category: const ProductCategory(id: 3, name: 'Minuman')),
          product(2, name: 'Roti'),
        ]),
      );
      await tester.pumpWidget(app(const ProductListScreen()));
      await tester.pumpAndSettle();

      expect(find.textContaining('Minuman', findRichText: true), findsOneWidget);
    });

    testWidgets('shows empty state', (tester) async {
      stubList(productPage([]));
      await tester.pumpWidget(app(const ProductListScreen()));
      await tester.pumpAndSettle();

      expect(find.text(l10nOf(tester).productsEmptyHint), findsOneWidget);
    });

    testWidgets('shows error state and retries', (tester) async {
      stubList(const NetworkFailure('Tidak dapat terhubung ke server.'));
      await tester.pumpWidget(app(const ProductListScreen()));
      await tester.pumpAndSettle();

      expect(find.text(l10nOf(tester).networkUnreachable), findsOneWidget);

      stubList(productPage([product(1, name: 'Teh')]));
      await tester.tap(find.text(l10nOf(tester).commonRetry));
      await tester.pumpAndSettle();

      expect(find.text('Teh'), findsOneWidget);
    });
  });

  group('ProductFormScreen', () {
    Future<void> fill(WidgetTester tester, {String sku = '', String name = '', String price = ''}) async {
      await tester.enterText(find.byKey(const Key('product_form_sku')), sku);
      await tester.enterText(find.byKey(const Key('product_form_name')), name);
      await tester.enterText(find.byKey(const Key('product_form_price')), price);
    }

    Future<void> submit(WidgetTester tester) async {
      await tester.tap(find.byKey(const Key('product_form_submit')));
      await tester.pumpAndSettle();
    }

    testWidgets('shows required errors and does not call the API', (tester) async {
      await tester.pumpWidget(app(const ProductFormScreen()));
      await tester.pumpAndSettle();

      await submit(tester);

      expect(find.text(l10nOf(tester).validationSkuRequired), findsOneWidget);
      expect(find.text(l10nOf(tester).validationNameRequired), findsOneWidget);
      expect(find.text(l10nOf(tester).validationPriceRequired), findsOneWidget);
      verifyNever(() => repo.createProduct(any()));
    });

    testWidgets('price field rejects a minus sign', (tester) async {
      await tester.pumpWidget(app(const ProductFormScreen()));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('product_form_price')), '-500');

      expect(find.text('500'), findsOneWidget);
    });

    testWidgets('duplicate SKU (409) is shown on the SKU field', (tester) async {
      when(() => repo.createProduct(any()))
          .thenThrow(const ServerFailure('conflict', statusCode: 409, code: 'conflict'));
      await tester.pumpWidget(app(const ProductFormScreen()));
      await tester.pumpAndSettle();

      await fill(tester, sku: 'KOPI-001', name: 'Kopi', price: '45000');
      await submit(tester);

      expect(find.text(l10nOf(tester).productSkuTaken), findsOneWidget);
    });

    testWidgets('backend 422 field errors are shown under the fields', (tester) async {
      when(() => repo.createProduct(any())).thenThrow(
        const ValidationFailure('request validation failed', messages: {'name': 'is required'}),
      );
      await tester.pumpWidget(app(const ProductFormScreen()));
      await tester.pumpAndSettle();

      await fill(tester, sku: 'A', name: 'B', price: '1');
      await submit(tester);

      expect(find.text('is required'), findsOneWidget);
    });

    testWidgets('category picker offers "Tanpa Kategori" plus the loaded categories', (tester) async {
      // Fail the request so the form stays open (success pops via GoRouter,
      // which this harness doesn't provide); we only check what was sent.
      when(() => repo.createProduct(any())).thenThrow(const NetworkFailure('offline'));
      await tester.pumpWidget(app(const ProductFormScreen()));
      await tester.pumpAndSettle();

      expect(find.text(l10nOf(tester).productNoCategory), findsOneWidget); // default selection
      await tester.tap(find.byKey(const Key('product_form_category')));
      await tester.pumpAndSettle();
      expect(find.text('Makanan'), findsOneWidget);
      await tester.tap(find.text('Minuman').last);
      await tester.pumpAndSettle();

      await fill(tester, sku: 'KOPI-1', name: 'Kopi', price: '1000');
      await submit(tester);

      final sent = verify(() => repo.createProduct(captureAny())).captured.single as ProductInput;
      expect(sent.categoryId, 3);
    });

    testWidgets('backend 422 on category_id is shown under the picker', (tester) async {
      when(() => repo.createProduct(any())).thenThrow(
        const ValidationFailure('request validation failed', messages: {'category_id': 'does not exist'}),
      );
      await tester.pumpWidget(app(const ProductFormScreen()));
      await tester.pumpAndSettle();

      await fill(tester, sku: 'A', name: 'B', price: '1');
      await submit(tester);

      expect(find.text('does not exist'), findsOneWidget);
    });

    testWidgets('edit mode pre-selects the product category', (tester) async {
      when(() => repo.getProductById(3)).thenAnswer(
        (_) async => product(3, category: const ProductCategory(id: 4, name: 'Makanan')),
      );
      await tester.pumpWidget(app(const ProductFormScreen(productId: 3)));
      await tester.pumpAndSettle();

      expect(find.text('Makanan'), findsOneWidget);
      expect(find.text(l10nOf(tester).productNoCategory), findsNothing);
    });

    testWidgets('edit mode pre-fills the loaded product', (tester) async {
      when(() => repo.getProductById(3)).thenAnswer((_) async => product(3, sku: 'GULA-1', price: 15000));
      await tester.pumpWidget(app(const ProductFormScreen(productId: 3)));
      await tester.pumpAndSettle();

      expect(find.text(l10nOf(tester).productEdit), findsOneWidget);
      expect(find.text('GULA-1'), findsOneWidget);
      expect(find.text('15000'), findsOneWidget);
    });
  });
}
