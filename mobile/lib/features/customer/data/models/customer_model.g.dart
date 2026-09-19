// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CustomerModel _$CustomerModelFromJson(Map<String, dynamic> json) =>
    _CustomerModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String? ?? '',
      address: json['address'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$CustomerModelToJson(_CustomerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'address': instance.address,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_CreateCustomerRequest _$CreateCustomerRequestFromJson(
  Map<String, dynamic> json,
) => _CreateCustomerRequest(
  name: json['name'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String,
  address: json['address'] as String,
);

Map<String, dynamic> _$CreateCustomerRequestToJson(
  _CreateCustomerRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'address': instance.address,
};

_UpdateCustomerRequest _$UpdateCustomerRequestFromJson(
  Map<String, dynamic> json,
) => _UpdateCustomerRequest(
  name: json['name'] as String?,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  address: json['address'] as String?,
);

Map<String, dynamic> _$UpdateCustomerRequestToJson(
  _UpdateCustomerRequest instance,
) => <String, dynamic>{
  'name': ?instance.name,
  'email': ?instance.email,
  'phone': ?instance.phone,
  'address': ?instance.address,
};
