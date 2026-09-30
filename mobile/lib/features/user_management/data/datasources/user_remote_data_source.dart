import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/page_meta_model.dart';
import '../models/user_models.dart';

/// Talks to `/api/v1/users`. Throws [DioException] or parsing errors; the
/// repository converts both into `Failure`.
abstract interface class UserRemoteDataSource {
  Future<(List<UserModel>, PageMetaModel)> fetchUsers({required int page, required int pageSize, String search = ''});

  Future<UserModel> fetchUser(int id);

  Future<UserModel> createUser(CreateUserRequest body);

  Future<UserModel> updateUser(int id, UpdateUserRequest body);

  Future<void> deleteUser(int id);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  const UserRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  static const _path = ApiConstants.usersPath;

  @override
  Future<(List<UserModel>, PageMetaModel)> fetchUsers({
    required int page,
    required int pageSize,
    String search = '',
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      _path,
      queryParameters: {'page': page, 'page_size': pageSize, if (search.isNotEmpty) 'search': search},
    );
    final body = res.data!;
    final items = (body['data'] as List<dynamic>).map((e) => UserModel.fromJson(e as Map<String, dynamic>)).toList();
    return (items, PageMetaModel.fromJson(body['meta'] as Map<String, dynamic>));
  }

  @override
  Future<UserModel> fetchUser(int id) async => _unwrap(await _dio.get<Map<String, dynamic>>('$_path/$id'));

  @override
  Future<UserModel> createUser(CreateUserRequest body) async =>
      _unwrap(await _dio.post<Map<String, dynamic>>(_path, data: body.toJson()));

  @override
  Future<UserModel> updateUser(int id, UpdateUserRequest body) async =>
      _unwrap(await _dio.patch<Map<String, dynamic>>('$_path/$id', data: body.toJson()));

  @override
  Future<void> deleteUser(int id) async {
    await _dio.delete<void>('$_path/$id'); // 204; 409 for yourself
  }

  UserModel _unwrap(Response<Map<String, dynamic>> res) => UserModel.fromJson(res.data!['data'] as Map<String, dynamic>);
}
