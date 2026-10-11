import '../../../../core/constants/api_constants.dart';
import '../../../../core/pagination/paged.dart';
import '../entities/managed_user.dart';
import '../repositories/user_repository.dart';

class GetUsers {
  const GetUsers(this._repository);

  final UserRepository _repository;

  Future<PageResult<ManagedUser>> call({int page = 1, int pageSize = ApiConstants.defaultPageSize, String search = ''}) =>
      _repository.getUsers(
        page: page < 1 ? 1 : page,
        pageSize: pageSize.clamp(1, ApiConstants.maxPageSize),
        search: search.trim(),
      );
}
