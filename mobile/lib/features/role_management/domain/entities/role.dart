import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/validation/field_issue.dart';

part 'role.freezed.dart';

/// A role (backend model.Role). [permissions] are permission keys; the
/// system role (Super Admin) reports every key in the catalog.
@freezed
abstract class Role with _$Role {
  const factory Role({
    required int id,
    required String name,
    required String description,
    required bool isSystem,
    required List<String> permissions,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Role;
}

/// One entry of the fixed permission catalog (GET /api/v1/permissions).
/// [description] is already in the request's language; [group] is the
/// backend's `resource_group` code (e.g. `sales_orders`).
@freezed
abstract class CatalogPermission with _$CatalogPermission {
  const factory CatalogPermission({
    required int id,
    required String key,
    required String description,
    required String group,
  }) = _CatalogPermission;
}

/// Permissions of one `resource_group`, in catalog order.
@freezed
abstract class PermissionGroup with _$PermissionGroup {
  const factory PermissionGroup({required String code, required List<CatalogPermission> permissions}) =
      _PermissionGroup;
}

/// Groups [catalog] by the backend's `resource_group`, keeping the order the
/// API returns (groups by first appearance, permissions as listed). Nothing
/// about the grouping is decided here: a group the app has never seen still
/// shows up, under its code.
List<PermissionGroup> groupPermissions(List<CatalogPermission> catalog) {
  final byCode = <String, List<CatalogPermission>>{};
  for (final p in catalog) {
    byCode.putIfAbsent(p.group, () => []).add(p);
  }
  return [for (final e in byCode.entries) PermissionGroup(code: e.key, permissions: e.value)];
}

/// Data to create a role (POST /api/v1/roles). Permissions are set afterwards
/// with PUT /roles/:id/permissions — the create endpoint doesn't take them.
@freezed
abstract class RoleInput with _$RoleInput {
  const RoleInput._();

  const factory RoleInput({required String name, @Default('') String description}) = _RoleInput;

  RoleInput trimmed() => RoleInput(name: name.trim(), description: description.trim());
}

/// Partial update (PATCH /api/v1/roles/:id): null fields stay unchanged.
@freezed
abstract class RolePatch with _$RolePatch {
  const RolePatch._();

  const factory RolePatch({String? name, String? description}) = _RolePatch;

  bool get isEmpty => name == null && description == null;
}

/// Role rules, mirroring backend `validateRole` (role_service.go). Name
/// uniqueness and the system-role lock are only known to the backend (409).
abstract final class RoleRules {
  static const nameMaxLength = 100;

  static FieldIssue? validateName(String value) {
    final v = value.trim();
    if (v.isEmpty) return const FieldIssue(FieldIssueKind.nameRequired);
    if (v.length > nameMaxLength) return const FieldIssue(FieldIssueKind.nameTooLong, max: nameMaxLength);
    return null;
  }
}
