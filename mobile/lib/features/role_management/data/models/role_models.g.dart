// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RoleModel _$RoleModelFromJson(Map<String, dynamic> json) => _RoleModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String? ?? '',
  isSystem: json['is_system'] as bool,
  permissions: (json['permissions'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$RoleModelToJson(_RoleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'is_system': instance.isSystem,
      'permissions': instance.permissions,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_CatalogPermissionModel _$CatalogPermissionModelFromJson(
  Map<String, dynamic> json,
) => _CatalogPermissionModel(
  id: (json['id'] as num).toInt(),
  key: json['key'] as String,
  description: json['description'] as String? ?? '',
  resourceGroup: json['resource_group'] as String,
);

Map<String, dynamic> _$CatalogPermissionModelToJson(
  _CatalogPermissionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'key': instance.key,
  'description': instance.description,
  'resource_group': instance.resourceGroup,
};

_CreateRoleRequest _$CreateRoleRequestFromJson(Map<String, dynamic> json) =>
    _CreateRoleRequest(
      name: json['name'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$CreateRoleRequestToJson(_CreateRoleRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
    };

_UpdateRoleRequest _$UpdateRoleRequestFromJson(Map<String, dynamic> json) =>
    _UpdateRoleRequest(
      name: json['name'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$UpdateRoleRequestToJson(_UpdateRoleRequest instance) =>
    <String, dynamic>{
      'name': ?instance.name,
      'description': ?instance.description,
    };

_SetRolePermissionsRequest _$SetRolePermissionsRequestFromJson(
  Map<String, dynamic> json,
) => _SetRolePermissionsRequest(
  permissionKeys: (json['permission_keys'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$SetRolePermissionsRequestToJson(
  _SetRolePermissionsRequest instance,
) => <String, dynamic>{'permission_keys': instance.permissionKeys};
