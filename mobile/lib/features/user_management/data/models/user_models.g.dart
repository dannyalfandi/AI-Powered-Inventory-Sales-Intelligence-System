// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: (json['id'] as num).toInt(),
  email: json['email'] as String,
  name: json['name'] as String,
  roleId: (json['role_id'] as num).toInt(),
  role: json['role'] == null
      ? null
      : UserRoleModel.fromJson(json['role'] as Map<String, dynamic>),
  isActive: json['is_active'] as bool,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'role_id': instance.roleId,
      'role': instance.role?.toJson(),
      'is_active': instance.isActive,
      'created_at': instance.createdAt.toIso8601String(),
    };

_UserRoleModel _$UserRoleModelFromJson(Map<String, dynamic> json) =>
    _UserRoleModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      isSystem: json['is_system'] as bool? ?? false,
    );

Map<String, dynamic> _$UserRoleModelToJson(_UserRoleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'is_system': instance.isSystem,
    };

_CreateUserRequest _$CreateUserRequestFromJson(Map<String, dynamic> json) =>
    _CreateUserRequest(
      email: json['email'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
      roleId: (json['role_id'] as num).toInt(),
      isActive: json['is_active'] as bool,
    );

Map<String, dynamic> _$CreateUserRequestToJson(_CreateUserRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'name': instance.name,
      'role_id': instance.roleId,
      'is_active': instance.isActive,
    };

_UpdateUserRequest _$UpdateUserRequestFromJson(Map<String, dynamic> json) =>
    _UpdateUserRequest(
      email: json['email'] as String?,
      password: json['password'] as String?,
      name: json['name'] as String?,
      roleId: (json['role_id'] as num?)?.toInt(),
      isActive: json['is_active'] as bool?,
    );

Map<String, dynamic> _$UpdateUserRequestToJson(_UpdateUserRequest instance) =>
    <String, dynamic>{
      'email': ?instance.email,
      'password': ?instance.password,
      'name': ?instance.name,
      'role_id': ?instance.roleId,
      'is_active': ?instance.isActive,
    };
