import '../../../../core/constants/api_constants.dart';
import '../entities/role.dart';
import '../repositories/role_repository.dart';

/// Every role, for the list and the user form's role picker: pages of 100
/// until the end, capped at [maxPages] so a runaway backend can't loop.
class GetRoles {
  const GetRoles(this._repository);

  final RoleRepository _repository;

  Future<List<Role>> call({int maxPages = 10}) async {
    final result = <Role>[];
    for (var page = 1; page <= maxPages; page++) {
      final r = await _repository.getRoles(page: page, pageSize: ApiConstants.maxPageSize);
      result.addAll(r.items);
      if (!r.hasMore) break;
    }
    return result;
  }
}
