import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/managed_user.dart';

part 'user_models.freezed.dart';
part 'user_models.g.dart';

// Shapes from backend/internal/model/auth.go, checked against real responses
// in test/contract/admin_json_contract_test.dart.

/// A user: `{"id","email","name","role_id","role":{...},"is_active","created_at","updated_at"}`.
/// `password_hash` is never sent (`json:"-"` on the backend).
@freezed
abstract class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required int id,
    required String email,
    required String name,
    required int roleId,
    UserRoleModel? role,
    required bool isActive,
    required DateTime createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  ManagedUser toEntity() => ManagedUser(
    id: id,
    email: email,
    name: name,
    roleId: roleId,
    roleName: role?.name ?? '',
    roleIsSystem: role?.isSystem ?? false,
    isActive: isActive,
    createdAt: createdAt,
  );
}

/// The `role` embedded in a user: a full role object, of which only these
/// fields matter here (its `permissions` is null in user responses).
@freezed
abstract class UserRoleModel with _$UserRoleModel {
  const factory UserRoleModel({required int id, required String name, @Default(false) bool isSystem}) =
      _UserRoleModel;

  factory UserRoleModel.fromJson(Map<String, dynamic> json) => _$UserRoleModelFromJson(json);
}

/// Body of POST /api/v1/users.
@freezed
abstract class CreateUserRequest with _$CreateUserRequest {
  const factory CreateUserRequest({
    required String email,
    required String password,
    required String name,
    required int roleId,
    required bool isActive,
  }) = _CreateUserRequest;

  factory CreateUserRequest.fromJson(Map<String, dynamic> json) => _$CreateUserRequestFromJson(json);

  factory CreateUserRequest.fromEntity(UserInput input) => CreateUserRequest(
    email: input.email,
    password: input.password,
    name: input.name,
    roleId: input.roleId!,
    isActive: input.isActive,
  );
}

/// Body of PATCH /api/v1/users/:id. Null fields are omitted: unchanged.
@freezed
abstract class UpdateUserRequest with _$UpdateUserRequest {
  @JsonSerializable(includeIfNull: false)
  const factory UpdateUserRequest({String? email, String? password, String? name, int? roleId, bool? isActive}) =
      _UpdateUserRequest;

  factory UpdateUserRequest.fromJson(Map<String, dynamic> json) => _$UpdateUserRequestFromJson(json);

  factory UpdateUserRequest.fromEntity(UserPatch p) => UpdateUserRequest(
    email: p.email,
    password: p.password,
    name: p.name,
    roleId: p.roleId,
    isActive: p.isActive,
  );
}
