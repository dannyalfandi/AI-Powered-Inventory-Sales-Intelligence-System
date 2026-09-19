import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/page_meta_model.dart';
import '../models/customer_model.dart';

/// Talks to the Go backend `/api/v1/customers` endpoints. Throws
/// [DioException] or parsing errors; the repository converts both into `Failure`.
abstract interface class CustomerRemoteDataSource {
  Future<(List<CustomerModel>, PageMetaModel)> fetchCustomers({
    required int page,
    required int pageSize,
    String search = '',
  });

  Future<CustomerModel> fetchCustomer(int id);

  Future<CustomerModel> createCustomer(CreateCustomerRequest body);

  Future<CustomerModel> updateCustomer(int id, UpdateCustomerRequest body);

  Future<void> deleteCustomer(int id);
}

class CustomerRemoteDataSourceImpl implements CustomerRemoteDataSource {
  const CustomerRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  static const _path = ApiConstants.customersPath;

  @override
  Future<(List<CustomerModel>, PageMetaModel)> fetchCustomers({
    required int page,
    required int pageSize,
    String search = '',
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      _path,
      queryParameters: {
        'page': page,
        'page_size': pageSize,
        if (search.isNotEmpty) 'search': search,
      },
    );
    final body = res.data!;
    final items = (body['data'] as List<dynamic>)
        .map((e) => CustomerModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return (items, PageMetaModel.fromJson(body['meta'] as Map<String, dynamic>));
  }

  @override
  Future<CustomerModel> fetchCustomer(int id) async =>
      _unwrap(await _dio.get<Map<String, dynamic>>('$_path/$id'));

  @override
  Future<CustomerModel> createCustomer(CreateCustomerRequest body) async =>
      _unwrap(await _dio.post<Map<String, dynamic>>(_path, data: body.toJson()));

  @override
  Future<CustomerModel> updateCustomer(int id, UpdateCustomerRequest body) async =>
      _unwrap(await _dio.patch<Map<String, dynamic>>('$_path/$id', data: body.toJson()));

  @override
  Future<void> deleteCustomer(int id) async {
    await _dio.delete<void>('$_path/$id'); // 204 No Content, 409 while it has active orders
  }

  /// Unwraps the `{"data": {...}}` envelope.
  CustomerModel _unwrap(Response<Map<String, dynamic>> res) =>
      CustomerModel.fromJson(res.data!['data'] as Map<String, dynamic>);
}
