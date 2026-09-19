import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/datasources/category_remote_data_source.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/usecases/create_category.dart';
import '../../domain/usecases/delete_category.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/get_category_by_id.dart';
import '../../domain/usecases/update_category.dart';

part 'category_providers.g.dart';

// Dependency graph for the category feature. Tests override
// categoryRepositoryProvider (or a usecase provider) with a mock.

@Riverpod(keepAlive: true)
CategoryRemoteDataSource categoryRemoteDataSource(Ref ref) =>
    CategoryRemoteDataSourceImpl(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
CategoryRepository categoryRepository(Ref ref) =>
    CategoryRepositoryImpl(ref.watch(categoryRemoteDataSourceProvider));

@Riverpod(keepAlive: true)
GetCategories getCategoriesUseCase(Ref ref) => GetCategories(ref.watch(categoryRepositoryProvider));

@Riverpod(keepAlive: true)
GetCategoryById getCategoryByIdUseCase(Ref ref) => GetCategoryById(ref.watch(categoryRepositoryProvider));

@Riverpod(keepAlive: true)
CreateCategory createCategoryUseCase(Ref ref) => CreateCategory(ref.watch(categoryRepositoryProvider));

@Riverpod(keepAlive: true)
UpdateCategory updateCategoryUseCase(Ref ref) => UpdateCategory(ref.watch(categoryRepositoryProvider));

@Riverpod(keepAlive: true)
DeleteCategory deleteCategoryUseCase(Ref ref) => DeleteCategory(ref.watch(categoryRepositoryProvider));
