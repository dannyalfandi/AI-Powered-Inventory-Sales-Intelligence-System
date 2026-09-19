import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/datasources/inventory_remote_data_source.dart';
import '../../data/repositories/inventory_repository_impl.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../../domain/usecases/get_inventory.dart';
import '../../domain/usecases/get_low_stock_items.dart';
import '../../domain/usecases/get_stock_movements.dart';
import '../../domain/usecases/record_stock_movement.dart';

part 'inventory_providers.g.dart';

// Dependency graph for the inventory feature. Tests override
// inventoryRepositoryProvider (or a usecase provider) with a mock.

@Riverpod(keepAlive: true)
InventoryRemoteDataSource inventoryRemoteDataSource(Ref ref) =>
    InventoryRemoteDataSourceImpl(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
InventoryRepository inventoryRepository(Ref ref) =>
    InventoryRepositoryImpl(ref.watch(inventoryRemoteDataSourceProvider));

@Riverpod(keepAlive: true)
GetInventory getInventoryUseCase(Ref ref) => GetInventory(ref.watch(inventoryRepositoryProvider));

@Riverpod(keepAlive: true)
RecordStockMovement recordStockMovementUseCase(Ref ref) =>
    RecordStockMovement(ref.watch(inventoryRepositoryProvider));

@Riverpod(keepAlive: true)
GetStockMovements getStockMovementsUseCase(Ref ref) =>
    GetStockMovements(ref.watch(inventoryRepositoryProvider));

@Riverpod(keepAlive: true)
GetLowStockItems getLowStockItemsUseCase(Ref ref) =>
    GetLowStockItems(ref.watch(inventoryRepositoryProvider));
