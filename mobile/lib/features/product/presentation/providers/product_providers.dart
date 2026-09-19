import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/datasources/product_remote_data_source.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/create_product.dart';
import '../../domain/usecases/delete_product.dart';
import '../../domain/usecases/get_product_by_id.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/update_product.dart';

part 'product_providers.g.dart';

// Dependency graph for the product feature. Tests override
// productRepositoryProvider (or a usecase provider) with a mock.

@Riverpod(keepAlive: true)
ProductRemoteDataSource productRemoteDataSource(Ref ref) =>
    ProductRemoteDataSourceImpl(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
ProductRepository productRepository(Ref ref) =>
    ProductRepositoryImpl(ref.watch(productRemoteDataSourceProvider));

@Riverpod(keepAlive: true)
GetProducts getProductsUseCase(Ref ref) => GetProducts(ref.watch(productRepositoryProvider));

@Riverpod(keepAlive: true)
GetProductById getProductByIdUseCase(Ref ref) => GetProductById(ref.watch(productRepositoryProvider));

@Riverpod(keepAlive: true)
CreateProduct createProductUseCase(Ref ref) => CreateProduct(ref.watch(productRepositoryProvider));

@Riverpod(keepAlive: true)
UpdateProduct updateProductUseCase(Ref ref) => UpdateProduct(ref.watch(productRepositoryProvider));

@Riverpod(keepAlive: true)
DeleteProduct deleteProductUseCase(Ref ref) => DeleteProduct(ref.watch(productRepositoryProvider));
