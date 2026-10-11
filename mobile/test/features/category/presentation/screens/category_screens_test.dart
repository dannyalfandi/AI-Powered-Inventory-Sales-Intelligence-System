import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/features/category/presentation/providers/category_providers.dart';
import 'package:inventory_intel/features/category/presentation/screens/category_form_screen.dart';
import 'package:inventory_intel/features/category/presentation/screens/category_list_screen.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/auth_fixtures.dart';
import '../../../../helpers/category_fixtures.dart';
import '../../../../helpers/l10n_harness.dart';

void main() {
  late MockCategoryRepository repo;

  setUpAll(registerCategoryFallbacks);
  setUp(() => repo = MockCategoryRepository());

  Widget app(Widget home) => ProviderScope(
        overrides: [categoryRepositoryProvider.overrideWithValue(repo), signedInAs(superAdmin)],
        retry: (_, _) => null,
        child: localizedApp(home: home),
      );

  group('CategoryListScreen', () {
    Future<void> swipeDelete(WidgetTester tester, String name) async {
      await tester.drag(find.text(name), const Offset(-600, 0));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, l10nOf(tester).commonDelete));
      await tester.pumpAndSettle();
    }

    testWidgets('lists categories with descriptions', (tester) async {
      stubCategoryOptions(repo, [category(1, name: 'Minuman', description: 'Kopi, teh')]);
      await tester.pumpWidget(app(const CategoryListScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Minuman'), findsOneWidget);
      expect(find.text('Kopi, teh'), findsOneWidget);
    });

    testWidgets('deleting a category that products still use explains why (409)', (tester) async {
      stubCategoryOptions(repo, [category(9, name: 'Minuman')]);
      when(() => repo.deleteCategory(9)).thenThrow(categoryInUseFailure);
      await tester.pumpWidget(app(const CategoryListScreen()));
      await tester.pumpAndSettle();

      await swipeDelete(tester, 'Minuman');

      expect(find.text(l10nOf(tester).categoryDeleteBlockedTitle), findsOneWidget);
      expect(find.textContaining(categoryInUseFailure.message), findsOneWidget);
      await tester.tap(find.text(l10nOf(tester).commonUnderstood));
      await tester.pumpAndSettle();
      expect(find.text('Minuman'), findsOneWidget); // restored in the list
    });

    testWidgets('deleting an unused category removes it', (tester) async {
      stubCategoryOptions(repo, [category(1, name: 'Snack')]);
      when(() => repo.deleteCategory(1)).thenAnswer((_) async {});
      await tester.pumpWidget(app(const CategoryListScreen()));
      await tester.pumpAndSettle();

      await swipeDelete(tester, 'Snack');

      expect(find.text(l10nOf(tester).categoryDeleted('Snack')), findsOneWidget);
      verify(() => repo.deleteCategory(1)).called(1);
    });

    testWidgets('shows empty state', (tester) async {
      stubCategoryOptions(repo, []);
      await tester.pumpWidget(app(const CategoryListScreen()));
      await tester.pumpAndSettle();

      expect(find.text(l10nOf(tester).categoriesEmptyHint), findsOneWidget);
    });
  });

  group('CategoryFormScreen', () {
    testWidgets('requires a name', (tester) async {
      await tester.pumpWidget(app(const CategoryFormScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('category_form_submit')));
      await tester.pumpAndSettle();

      expect(find.text(l10nOf(tester).validationNameRequired), findsOneWidget);
      verifyNever(() => repo.createCategory(any()));
    });

    testWidgets('duplicate name (409) is shown on the name field', (tester) async {
      when(() => repo.createCategory(any()))
          .thenThrow(const ServerFailure('conflict', statusCode: 409, code: 'conflict'));
      await tester.pumpWidget(app(const CategoryFormScreen()));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('category_form_name')), 'Minuman');
      await tester.tap(find.byKey(const Key('category_form_submit')));
      await tester.pumpAndSettle();

      expect(find.text(l10nOf(tester).categoryNameTaken), findsOneWidget);
    });
  });
}
