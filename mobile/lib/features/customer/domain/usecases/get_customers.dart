import '../../../../core/constants/api_constants.dart';
import '../../../../core/pagination/paged.dart';
import '../entities/customer.dart';
import '../repositories/customer_repository.dart';

class GetCustomers {
  const GetCustomers(this._repository);

  final CustomerRepository _repository;

  Future<PageResult<Customer>> call({
    int page = 1,
    int pageSize = ApiConstants.defaultPageSize,
    String search = '',
  }) {
    return _repository.getCustomers(
      page: page < 1 ? 1 : page,
      pageSize: pageSize.clamp(1, ApiConstants.maxPageSize),
      search: search.trim(),
    );
  }
}
