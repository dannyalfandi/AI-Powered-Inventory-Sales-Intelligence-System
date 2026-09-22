import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/validation/field_issue.dart';

part 'customer.freezed.dart';

/// Customer who places sales orders (backend model.Customer).
@freezed
abstract class Customer with _$Customer {
  const factory Customer({
    required int id,
    required String name,

    /// Null when the customer has no email.
    String? email,
    required String phone,
    required String address,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Customer;
}

/// Data needed to create a customer (POST /api/v1/customers).
@freezed
abstract class CustomerInput with _$CustomerInput {
  const CustomerInput._();

  const factory CustomerInput({
    required String name,
    @Default('') String email,
    @Default('') String phone,
    @Default('') String address,
  }) = _CustomerInput;

  /// Trims; the email is lowercased like the backend stores it.
  CustomerInput trimmed() => CustomerInput(
        name: name.trim(),
        email: email.trim().toLowerCase(),
        phone: phone.trim(),
        address: address.trim(),
      );
}

/// Partial update (PATCH /api/v1/customers/:id): null fields stay unchanged,
/// an empty [email] removes it.
@freezed
abstract class CustomerPatch with _$CustomerPatch {
  const CustomerPatch._();

  const factory CustomerPatch({
    String? name,
    String? email,
    String? phone,
    String? address,
  }) = _CustomerPatch;

  bool get isEmpty => name == null && email == null && phone == null && address == null;

  CustomerPatch trimmed() => CustomerPatch(
        name: name?.trim(),
        email: email?.trim().toLowerCase(),
        phone: phone?.trim(),
        address: address?.trim(),
      );
}

/// Customer rules, mirroring backend `validateCustomer` in
/// backend/internal/service/customer_service.go. Email uniqueness is only
/// checked by the backend (HTTP 409).
abstract final class CustomerRules {
  static const nameMaxLength = 255;
  static const emailMaxLength = 255;
  static const phoneMaxLength = 32;
  static const addressMaxLength = 1000;

  static final _email = RegExp(r'^[^\s@<>]+@[^\s@<>]+\.[^\s@<>]+$');
  static final _phone = RegExp(r'^\+?[0-9 ()\-]{6,32}$');

  static FieldIssue? validateName(String value) {
    final v = value.trim();
    if (v.isEmpty) return const FieldIssue(FieldIssueKind.nameRequired);
    if (v.length > nameMaxLength) return const FieldIssue(FieldIssueKind.nameTooLong, max: nameMaxLength);
    return null;
  }

  /// Empty is valid (email is optional).
  static FieldIssue? validateEmail(String value) {
    final v = value.trim();
    if (v.isEmpty) return null;
    if (v.length > emailMaxLength) return const FieldIssue(FieldIssueKind.emailTooLong, max: emailMaxLength);
    if (!_email.hasMatch(v)) return const FieldIssue(FieldIssueKind.emailInvalid);
    return null;
  }

  /// Empty is valid (phone is optional).
  static FieldIssue? validatePhone(String value) {
    final v = value.trim();
    if (v.isEmpty) return null;
    if (!_phone.hasMatch(v)) return const FieldIssue(FieldIssueKind.phoneInvalid, max: phoneMaxLength);
    return null;
  }

  static FieldIssue? validateAddress(String value) {
    if (value.trim().length > addressMaxLength) {
      return const FieldIssue(FieldIssueKind.addressTooLong, max: addressMaxLength);
    }
    return null;
  }
}
