import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/datasources/sales_order_remote_data_source.dart';
import '../../data/repositories/sales_order_repository_impl.dart';
import '../../domain/repositories/sales_order_repository.dart';
import '../../domain/usecases/change_order_status.dart';
import '../../domain/usecases/create_sales_order.dart';
import '../../domain/usecases/get_sales_order_by_id.dart';
import '../../domain/usecases/get_sales_orders.dart';

part 'sales_order_providers.g.dart';

// Dependency graph for the sales order feature. Tests override
// salesOrderRepositoryProvider (or a usecase provider) with a mock.

@Riverpod(keepAlive: true)
SalesOrderRemoteDataSource salesOrderRemoteDataSource(Ref ref) =>
    SalesOrderRemoteDataSourceImpl(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
SalesOrderRepository salesOrderRepository(Ref ref) =>
    SalesOrderRepositoryImpl(ref.watch(salesOrderRemoteDataSourceProvider));

@Riverpod(keepAlive: true)
GetSalesOrders getSalesOrdersUseCase(Ref ref) => GetSalesOrders(ref.watch(salesOrderRepositoryProvider));

@Riverpod(keepAlive: true)
GetSalesOrderById getSalesOrderByIdUseCase(Ref ref) => GetSalesOrderById(ref.watch(salesOrderRepositoryProvider));

@Riverpod(keepAlive: true)
CreateSalesOrder createSalesOrderUseCase(Ref ref) => CreateSalesOrder(ref.watch(salesOrderRepositoryProvider));

@Riverpod(keepAlive: true)
ChangeOrderStatus changeOrderStatusUseCase(Ref ref) => ChangeOrderStatus(ref.watch(salesOrderRepositoryProvider));
