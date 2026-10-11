import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/auth_user.dart';

part 'auth_models.freezed.dart';
part 'auth_models.g.dart';

// Shapes from backend/internal/model/auth.go, checked against real responses
// in test/contract/backend_json_contract_test.dart.

/// `data` of POST /api/v1/auth/login and /auth/refresh:
/// `{"access_token","refresh_token","token_type":"Bearer","expires_in":900,"user":{...}}`.
/// `user` is only on login, and has no permissions — those come from /auth/me.
@freezed
abstract class TokenPairModel with _$TokenPairModel {
  const factory TokenPairModel({
    required String accessToken,
    required String refreshToken,
    required String tokenType,
    required int expiresIn,
  }) = _TokenPairModel;

  factory TokenPairModel.fromJson(Map<String, dynamic> json) => _$TokenPairModelFromJson(json);
}

/// `role` inside a user: `{"id","name","is_system"}`.
@freezed
abstract class RoleRefModel with _$RoleRefModel {
  const RoleRefModel._();

  const factory RoleRefModel({required int id, required String name, required bool isSystem}) = _RoleRefModel;

  factory RoleRefModel.fromJson(Map<String, dynamic> json) => _$RoleRefModelFromJson(json);

  AuthRole toEntity() => AuthRole(id: id, name: name, isSystem: isSystem);
}

/// `data` of GET /api/v1/auth/me:
/// `{"id","email","name","is_active","role":{...},"permissions":["products.view",...]}`.
/// A Super Admin gets every catalog key in `permissions`.
@freezed
abstract class MeModel with _$MeModel {
  const MeModel._();

  const factory MeModel({
    required int id,
    required String email,
    required String name,
    required bool isActive,
    required RoleRefModel role,
    @Default(<String>[]) List<String> permissions,
  }) = _MeModel;

  factory MeModel.fromJson(Map<String, dynamic> json) => _$MeModelFromJson(json);

  AuthUser toEntity() =>
      AuthUser(id: id, email: email, name: name, role: role.toEntity(), permissions: permissions.toSet());
}

/// Body of POST /api/v1/auth/login.
@freezed
abstract class LoginRequest with _$LoginRequest {
  const factory LoginRequest({required String email, required String password}) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);
}

/// Body of POST /api/v1/auth/logout (and /refresh).
@freezed
abstract class RefreshTokenRequest with _$RefreshTokenRequest {
  const factory RefreshTokenRequest({required String refreshToken}) = _RefreshTokenRequest;

  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) => _$RefreshTokenRequestFromJson(json);
}
