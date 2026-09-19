import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/features/customer/domain/entities/customer.dart';
import 'package:inventory_intel/features/customer/domain/usecases/create_customer.dart';
import 'package:inventory_intel/features/customer/domain/usecases/delete_customer.dart';
import 'package:inventory_intel/features/customer/domain/usecases/get_customers.dart';
import 'package:inventory_intel/features/customer/domain/usecases/update_customer.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/customer_fixtures.dart';

void main() {
  late MockCustomerRepository repo;

  setUpAll(registerCustomerFallbacks);
  setUp(() => repo = MockCustomerRepository());

  group('CreateCustomer', () {
    test('trims input and lowercases the email', () async {
      const sent = CustomerInput(name: 'Budi', email: 'budi@example.com', phone: '+62 812-3456', address: 'Jl. A');
      when(() => repo.createCustomer(sent)).thenAnswer((_) async => customer(1));

      await CreateCustomer(repo)(
        const CustomerInput(name: ' Budi ', email: ' Budi@Example.COM ', phone: ' +62 812-3456 ', address: ' Jl. A '),
      );

      verify(() => repo.createCustomer(sent)).called(1);
    });

    test('only the name is required', () async {
      when(() => repo.createCustomer(any())).thenAnswer((_) async => customer(1));

      await CreateCustomer(repo)(const CustomerInput(name: 'Siti'));

      verify(() => repo.createCustomer(const CustomerInput(name: 'Siti'))).called(1);
    });

    final invalid = <({String name, CustomerInput input, Set<String> fields})>[
      (name: 'blank name', input: const CustomerInput(name: ' '), fields: {'name'}),
      (name: 'bad email', input: const CustomerInput(name: 'A', email: 'nope'), fields: {'email'}),
      (name: 'email with display name', input: const CustomerInput(name: 'A', email: 'B <b@x.id>'), fields: {'email'}),
      (name: 'bad phone', input: const CustomerInput(name: 'A', phone: 'call me'), fields: {'phone'}),
      (name: 'address too long', input: CustomerInput(name: 'A', address: 'x' * 1001), fields: {'address'}),
    ];
    for (final c in invalid) {
      test('rejects locally: ${c.name}', () async {
        await expectLater(
          CreateCustomer(repo)(c.input),
          throwsA(isA<ValidationFailure>().having((f) => f.messages.keys.toSet(), 'fields', c.fields)),
        );
        verifyNever(() => repo.createCustomer(any()));
      });
    }

    test('propagates duplicate email (409)', () async {
      when(() => repo.createCustomer(any())).thenThrow(const ServerFailure('conflict', statusCode: 409));

      await expectLater(
        CreateCustomer(repo)(const CustomerInput(name: 'A', email: 'a@b.id')),
        throwsA(isA<ServerFailure>().having((f) => f.isConflict, 'isConflict', true)),
      );
    });
  });

  group('UpdateCustomer', () {
    test('empty email is a valid patch (removes it)', () async {
      when(() => repo.updateCustomer(3, const CustomerPatch(email: ''))).thenAnswer((_) async => customer(3));

      await UpdateCustomer(repo)(3, const CustomerPatch(email: '  '));

      verify(() => repo.updateCustomer(3, const CustomerPatch(email: ''))).called(1);
    });

    test('validates only present fields', () async {
      await expectLater(
        UpdateCustomer(repo)(3, const CustomerPatch(name: '', phone: 'x')),
        throwsA(isA<ValidationFailure>().having((f) => f.messages.keys.toSet(), 'fields', {'name', 'phone'})),
      );
    });
  });

  test('DeleteCustomer propagates 409 while orders are active', () async {
    when(() => repo.deleteCustomer(9)).thenThrow(customerHasOrdersFailure);

    await expectLater(DeleteCustomer(repo)(9), throwsA(isA<ServerFailure>()));
  });

  test('GetCustomers clamps pagination and trims search', () async {
    when(() => repo.getCustomers(page: 1, pageSize: 100, search: 'budi')).thenAnswer((_) async => customerPage([]));

    await GetCustomers(repo)(page: 0, pageSize: 500, search: ' budi ');

    verify(() => repo.getCustomers(page: 1, pageSize: 100, search: 'budi')).called(1);
  });
}
