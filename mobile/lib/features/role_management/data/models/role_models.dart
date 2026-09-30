import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/role.dart';

part 'role_models.freezed.dart';
part 'role_models.g.dart';

// Shapes from backend/internal/model/auth.go, checked against real responses
// in test/contract/admin_json_contract_test.dart.

/// A role: `{"id","name","description","is_system","created_at","updated_at","permissions":[...]}`.
/// `permissions` is a list of keys; the system role lists the whole catalog.
/// Inside a *user* the role comes with `"permissions": null`.
@freezed
abstract class RoleModel with _$RoleModel {
  const RoleModel._();

  const factory RoleModel({
    required int id,
    required String name,
    @Default('') String description,
    required bool isSystem,
    List<String>? permissions,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RoleModel;

  factory RoleModel.fromJson(Map<String, dynamic> json) => _$RoleModelFromJson(json);

  Role toEntity() => Role(
    id: id,
    name: name,
    description: description,
    isSystem: isSystem,
    permissions: permissions ?? const [],
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

/// A catalog entry: `{"id","key","description","resource_group"}`.
@freezed
abstract class CatalogPermissionModel with _$CatalogPermissionModel {
  const CatalogPermissionModel._();

  const factory CatalogPermissionModel({
    required int id,
    required String key,
    @Default('') String description,
    required String resourceGroup,
  }) = _CatalogPermissionModel;

  factory CatalogPermissionModel.fromJson(Map<String, dynamic> json) => _$CatalogPermissionModelFromJson(json);

  CatalogPermission toEntity() => CatalogPermission(id: id, key: key, description: description, group: resourceGroup);
}

/// Body of POST /api/v1/roles.
@freezed
abstract class CreateRoleRequest with _$CreateRoleRequest {
  const factory CreateRoleRequest({required String name, required String description}) = _CreateRoleRequest;

  factory CreateRoleRequest.fromJson(Map<String, dynamic> json) => _$CreateRoleRequestFromJson(json);
}

/// Body of PATCH /api/v1/roles/:id. Null fields are omitted: unchanged.
@freezed
abstract class UpdateRoleRequest with _$UpdateRoleRequest {
  @JsonSerializable(includeIfNull: false)
  const factory UpdateRoleRequest({String? name, String? description}) = _UpdateRoleRequest;

  factory UpdateRoleRequest.fromJson(Map<String, dynamic> json) => _$UpdateRoleRequestFromJson(json);
}

/// Body of PUT /api/v1/roles/:id/permissions: the full list of **keys**
/// (`"inventory.view"`, not ids). It replaces the role's list.
@freezed
abstract class SetRolePermissionsRequest with _$SetRolePermissionsRequest {
  const factory SetRolePermissionsRequest({required List<String> permissionKeys}) = _SetRolePermissionsRequest;

  factory SetRolePermissionsRequest.fromJson(Map<String, dynamic> json) => _$SetRolePermissionsRequestFromJson(json);
}
