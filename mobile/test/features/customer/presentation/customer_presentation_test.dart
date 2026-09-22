import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/features/customer/domain/entities/customer.dart';
import 'package:inventory_intel/features/customer/presentation/providers/customer_form_provider.dart';
import 'package:inventory_intel/features/customer/presentation/providers/customer_list_provider.dart';
import 'package:inventory_intel/features/customer/presentation/providers/customer_providers.dart';
import 'package:inventory_intel/features/customer/presentation/screens/customer_form_screen.dart';
import 'package:inventory_intel/features/customer/presentation/screens/customer_list_screen.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/customer_fixtures.dart';
import '../../../helpers/l10n_harness.dart';

void main() {
  late MockCustomerRepository repo;

  setUpAll(registerCustomerFallbacks);
  setUp(() => repo = MockCustomerRepository());

  ProviderContainer makeContainer() => ProviderContainer.test(
        overrides: [customerRepositoryProvider.overrideWithValue(repo)],
        retry: (_, _) => null,
      );

  group('customerListProvider', () {
    test('search reloads page 1 with the query', () async {
      when(() => repo.getCustomers(page: 1, pageSize: 20, search: '')).thenAnswer((_) async => customerPage([customer(1)]));
      when(() => repo.getCustomers(page: 1, pageSize: 20, search: '0812'))
          .thenAnswer((_) async => customerPage([customer(2, phone: '0812')]));
      final container = makeContainer();
      container.listen(customerListProvider, (_, _) {});
      await container.read(customerListProvider.future);

      container.read(customerSearchQueryProvider.notifier).set(' 0812 ');

      expect((await container.read(customerListProvider.future)).items.single.id, 2);
    });

    test('409 on delete keeps the customer and rethrows', () async {
      stubCustomers(repo, [customer(9), customer(2)]);
      when(() => repo.deleteCustomer(9)).thenThrow(customerHasOrdersFailure);
      final container = makeContainer();
      container.listen(customerListProvider, (_, _) {});
      await container.read(customerListProvider.future);

      await expectLater(container.read(customerListProvider.notifier).delete(9), throwsA(isA<ServerFailure>()));

      expect(container.read(customerListProvider).requireValue.items.map((c) => c.id), [9, 2]);
    });

    test('successful delete removes the row', () async {
      stubCustomers(repo, [customer(9), customer(2)]);
      when(() => repo.deleteCustomer(9)).thenAnswer((_) async {});
      final container = makeContainer();
      container.listen(customerListProvider, (_, _) {});
      await container.read(customerListProvider.future);

      await container.read(customerListProvider.notifier).delete(9);

      expect(container.read(customerListProvider).requireValue.items.map((c) => c.id), [2]);
    });
  });

  for (final locale in testLocales) {
    testWidgets('customerDeleteErrorMessage quotes the 409 in ${locale.languageCode}', (tester) async {
      await withL10n(tester, locale, (context, l10n) {
        expect(
          customerDeleteErrorMessage(context, customerHasOrdersFailure, customer(9, name: 'Budi')),
          l10n.customerDeleteBlockedBody('Budi', customerHasOrdersFailure.message),
        );
        expect(
          customerDeleteErrorMessage(context, const NetworkFailure('offline'), customer(9)),
          l10n.customerDeleteFailed(l10n.networkUnreachable),
        );
      });
    });
  }

  group('customerFormProvider', () {
    final existing = customer(5, name: 'Budi', email: 'budi@example.com', phone: '0812');

    final cases = <({String name, CustomerInput input, CustomerPatch? want})>[
      (
        name: 'clearing the email sends email ""',
        input: const CustomerInput(name: 'Budi', phone: '0812'),
        want: const CustomerPatch(email: ''),
      ),
      (
        name: 'email case change after lowercasing is not a change',
        input: const CustomerInput(name: 'Budi', email: 'BUDI@example.com', phone: '0812'),
        want: null,
      ),
      (
        name: 'address added',
        input: const CustomerInput(name: 'Budi', email: 'budi@example.com', phone: '0812', address: 'Bandung'),
        want: const CustomerPatch(address: 'Bandung'),
      ),
    ];

    for (final c in cases) {
      test(c.name, () async {
        when(() => repo.getCustomerById(5)).thenAnswer((_) async => existing);
        when(() => repo.updateCustomer(5, any())).thenAnswer((_) async => existing);
        final container = makeContainer();
        container.listen(customerFormProvider(5), (_, _) {});
        await container.read(customerFormProvider(5).future);

        await container.read(customerFormProvider(5).notifier).save(c.input);

        if (c.want == null) {
          verifyNever(() => repo.updateCustomer(any(), any()));
        } else {
          verify(() => repo.updateCustomer(5, c.want!)).called(1);
        }
      });
    }
  });

  group('screens', () {
    Widget app(Widget home) => ProviderScope(
          overrides: [customerRepositoryProvider.overrideWithValue(repo)],
          retry: (_, _) => null,
          child: localizedApp(home: home),
        );

    testWidgets('list shows contact info; deleting a customer with orders explains why', (tester) async {
      stubCustomers(repo, [customer(9, name: 'Budi', email: 'budi@example.com', phone: '0812')]);
      when(() => repo.deleteCustomer(9)).thenThrow(customerHasOrdersFailure);
      await tester.pumpWidget(app(const CustomerListScreen()));
      await tester.pumpAndSettle();

      expect(find.text('budi@example.com · 0812'), findsOneWidget);
      await tester.drag(find.text('Budi'), const Offset(-600, 0));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, l10nOf(tester).commonDelete));
      await tester.pumpAndSettle();

      expect(find.text(l10nOf(tester).customerDeleteBlockedTitle), findsOneWidget);
      expect(find.textContaining(customerHasOrdersFailure.message), findsOneWidget);
      await tester.tap(find.text(l10nOf(tester).commonUnderstood));
      await tester.pumpAndSettle();
      expect(find.text('Budi'), findsOneWidget);
    });

    testWidgets('form: duplicate email (409) is shown on the email field', (tester) async {
      when(() => repo.createCustomer(any())).thenThrow(const ServerFailure('conflict', statusCode: 409));
      await tester.pumpWidget(app(const CustomerFormScreen()));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('customer_form_name')), 'Budi');
      await tester.enterText(find.byKey(const Key('customer_form_email')), 'budi@example.com');
      await tester.tap(find.byKey(const Key('customer_form_submit')));
      await tester.pumpAndSettle();

      expect(find.text(l10nOf(tester).customerEmailTaken), findsOneWidget);
    });

    testWidgets('form: local validation for name, email and phone', (tester) async {
      await tester.pumpWidget(app(const CustomerFormScreen()));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('customer_form_email')), 'nope');
      await tester.enterText(find.byKey(const Key('customer_form_phone')), 'abc');
      await tester.tap(find.byKey(const Key('customer_form_submit')));
      await tester.pumpAndSettle();

      expect(find.text(l10nOf(tester).validationNameRequired), findsOneWidget);
      expect(find.text(l10nOf(tester).validationEmailInvalid), findsOneWidget);
      expect(find.text(l10nOf(tester).validationPhoneInvalid(CustomerRules.phoneMaxLength)), findsOneWidget);
      verifyNever(() => repo.createCustomer(any()));
    });
  });
}
