import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../sales_order/presentation/providers/sales_order_list_provider.dart';
import '../../domain/entities/customer.dart';
import 'customer_list_provider.dart';
import 'customer_providers.dart';

part 'customer_form_provider.g.dart';

/// Backs the create/edit form. `customerId == null` → create mode (state is
/// `null`); otherwise loads the customer.
@riverpod
class CustomerForm extends _$CustomerForm {
  @override
  Future<Customer?> build(int? customerId) async {
    if (customerId == null) return null;
    return ref.watch(getCustomerByIdUseCaseProvider)(customerId);
  }

  /// Creates or updates (PATCH with only the changed fields). Throws
  /// `Failure` so the form can show field errors.
  Future<Customer> save(CustomerInput input) async {
    final id = customerId;
    final data = input.trimmed();
    final Customer saved;
    if (id == null) {
      saved = await ref.read(createCustomerUseCaseProvider)(input);
    } else {
      final existing = state.value;
      final patch = existing == null
          ? CustomerPatch(name: data.name, email: data.email, phone: data.phone, address: data.address)
          : CustomerPatch(
              name: data.name != existing.name ? data.name : null,
              email: data.email != (existing.email ?? '') ? data.email : null,
              phone: data.phone != existing.phone ? data.phone : null,
              address: data.address != existing.address ? data.address : null,
            );
      saved = patch.isEmpty ? existing! : await ref.read(updateCustomerUseCaseProvider)(id, patch);
    }

    ref.invalidate(customerListProvider);
    // Orders show the customer's current name.
    ref.invalidate(salesOrderListProvider);
    if (ref.mounted) state = AsyncData(saved);
    return saved;
  }
}
