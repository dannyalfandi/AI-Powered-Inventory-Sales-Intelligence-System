import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/page_meta_model.dart';
import '../models/role_models.dart';

/// Talks to `/api/v1/roles` and `/api/v1/permissions`. Throws [DioException]
/// or parsing errors; the repository converts both into `Failure`.
abstract interface class RoleRemoteDataSource {
  Future<(List<RoleModel>, PageMetaModel)> fetchRoles({required int page, required int pageSize});

  Future<RoleModel> fetchRole(int id);

  Future<RoleModel> createRole(CreateRoleRequest body);

  Future<RoleModel> updateRole(int id, UpdateRoleRequest body);

  Future<void> deleteRole(int id);

  Future<RoleModel> setPermissions(int id, SetRolePermissionsRequest body);

  Future<List<CatalogPermissionModel>> fetchPermissions();

  /// `meta.total` of GET /users?role_id=…&page_size=1.
  Future<int> countUsers(int roleId);
}

class RoleRemoteDataSourceImpl implements RoleRemoteDataSource {
  const RoleRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  static const _path = ApiConstants.rolesPath;

  @override
  Future<(List<RoleModel>, PageMetaModel)> fetchRoles({required int page, required int pageSize}) async {
    final res = await _dio.get<Map<String, dynamic>>(_path, queryParameters: {'page': page, 'page_size': pageSize});
    final body = res.data!;
    final items = (body['data'] as List<dynamic>).map((e) => RoleModel.fromJson(e as Map<String, dynamic>)).toList();
    return (items, PageMetaModel.fromJson(body['meta'] as Map<String, dynamic>));
  }

  @override
  Future<RoleModel> fetchRole(int id) async => _unwrap(await _dio.get<Map<String, dynamic>>('$_path/$id'));

  @override
  Future<RoleModel> createRole(CreateRoleRequest body) async =>
      _unwrap(await _dio.post<Map<String, dynamic>>(_path, data: body.toJson()));

  @override
  Future<RoleModel> updateRole(int id, UpdateRoleRequest body) async =>
      _unwrap(await _dio.patch<Map<String, dynamic>>('$_path/$id', data: body.toJson()));

  @override
  Future<void> deleteRole(int id) async {
    await _dio.delete<void>('$_path/$id'); // 204; 409 while in use or for the system role
  }

  @override
  Future<RoleModel> setPermissions(int id, SetRolePermissionsRequest body) async =>
      _unwrap(await _dio.put<Map<String, dynamic>>('$_path/$id/permissions', data: body.toJson()));

  @override
  Future<List<CatalogPermissionModel>> fetchPermissions() async {
    final res = await _dio.get<Map<String, dynamic>>(ApiConstants.permissionsPath);
    return (res.data!['data'] as List<dynamic>)
        .map((e) => CatalogPermissionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<int> countUsers(int roleId) async {
    final res = await _dio.get<Map<String, dynamic>>(
      ApiConstants.usersPath,
      queryParameters: {'role_id': roleId, 'page_size': 1},
    );
    return PageMetaModel.fromJson(res.data!['meta'] as Map<String, dynamic>).total;
  }

  RoleModel _unwrap(Response<Map<String, dynamic>> res) => RoleModel.fromJson(res.data!['data'] as Map<String, dynamic>);
}
