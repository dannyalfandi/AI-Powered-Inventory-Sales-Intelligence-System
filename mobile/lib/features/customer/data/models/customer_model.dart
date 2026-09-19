import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/customer.dart';

part 'customer_model.freezed.dart';
part 'customer_model.g.dart';

/// JSON shape of a customer (backend/internal/model/customer.go):
/// `{"id","name","email"|null,"phone","address","created_at","updated_at"}`.
@freezed
abstract class CustomerModel with _$CustomerModel {
  const CustomerModel._();

  const factory CustomerModel({
    required int id,
    required String name,
    String? email,
    @Default('') String phone,
    @Default('') String address,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CustomerModel;

  factory CustomerModel.fromJson(Map<String, dynamic> json) => _$CustomerModelFromJson(json);

  Customer toEntity() => Customer(
        id: id,
        name: name,
        email: email,
        phone: phone,
        address: address,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

/// Request body for POST /api/v1/customers. An empty email means none.
@freezed
abstract class CreateCustomerRequest with _$CreateCustomerRequest {
  const factory CreateCustomerRequest({
    required String name,
    required String email,
    required String phone,
    required String address,
  }) = _CreateCustomerRequest;

  factory CreateCustomerRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateCustomerRequestFromJson(json);

  factory CreateCustomerRequest.fromEntity(CustomerInput i) =>
      CreateCustomerRequest(name: i.name, email: i.email, phone: i.phone, address: i.address);
}

/// Request body for PATCH /api/v1/customers/:id. Null fields are omitted;
/// `"email": ""` removes the email.
@freezed
abstract class UpdateCustomerRequest with _$UpdateCustomerRequest {
  @JsonSerializable(includeIfNull: false)
  const factory UpdateCustomerRequest({
    String? name,
    String? email,
    String? phone,
    String? address,
  }) = _UpdateCustomerRequest;

  factory UpdateCustomerRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateCustomerRequestFromJson(json);

  factory UpdateCustomerRequest.fromEntity(CustomerPatch p) =>
      UpdateCustomerRequest(name: p.name, email: p.email, phone: p.phone, address: p.address);
}
