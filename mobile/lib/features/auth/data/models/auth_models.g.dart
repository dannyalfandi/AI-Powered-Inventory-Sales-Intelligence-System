// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TokenPairModel _$TokenPairModelFromJson(Map<String, dynamic> json) =>
    _TokenPairModel(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      tokenType: json['token_type'] as String,
      expiresIn: (json['expires_in'] as num).toInt(),
    );

Map<String, dynamic> _$TokenPairModelToJson(_TokenPairModel instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'token_type': instance.tokenType,
      'expires_in': instance.expiresIn,
    };

_RoleRefModel _$RoleRefModelFromJson(Map<String, dynamic> json) =>
    _RoleRefModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      isSystem: json['is_system'] as bool,
    );

Map<String, dynamic> _$RoleRefModelToJson(_RoleRefModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'is_system': instance.isSystem,
    };

_MeModel _$MeModelFromJson(Map<String, dynamic> json) => _MeModel(
  id: (json['id'] as num).toInt(),
  email: json['email'] as String,
  name: json['name'] as String,
  isActive: json['is_active'] as bool,
  role: RoleRefModel.fromJson(json['role'] as Map<String, dynamic>),
  permissions:
      (json['permissions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
);

Map<String, dynamic> _$MeModelToJson(_MeModel instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'name': instance.name,
  'is_active': instance.isActive,
  'role': instance.role.toJson(),
  'permissions': instance.permissions,
};

_LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) =>
    _LoginRequest(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$LoginRequestToJson(_LoginRequest instance) =>
    <String, dynamic>{'email': instance.email, 'password': instance.password};

_RefreshTokenRequest _$RefreshTokenRequestFromJson(Map<String, dynamic> json) =>
    _RefreshTokenRequest(refreshToken: json['refresh_token'] as String);

Map<String, dynamic> _$RefreshTokenRequestToJson(
  _RefreshTokenRequest instance,
) => <String, dynamic>{'refresh_token': instance.refreshToken};
