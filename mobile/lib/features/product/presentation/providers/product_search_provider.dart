import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/product.dart';
import 'product_providers.dart';

part 'product_search_provider.g.dart';

/// First page of products matching [query] (name or SKU), for pickers such
/// as the order form. Refine the query to find others.
@riverpod
Future<List<Product>> productSearch(Ref ref, String query) async =>
    (await ref.watch(getProductsUseCaseProvider)(search: query)).items;
