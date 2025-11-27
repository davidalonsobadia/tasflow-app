import 'package:taskflow_app/core/utils/paged_result.dart';
import 'package:taskflow_app/features/products/data/data_sources/product_remote_data_source.dart';
import 'package:taskflow_app/features/products/data/models/product_task_model.dart';
import 'package:taskflow_app/features/products/data/models/transfer_line_model.dart';
import 'package:taskflow_app/features/products/domain/entities/location_entity.dart';
import 'package:taskflow_app/features/products/domain/entities/product_entity.dart';
import 'package:taskflow_app/features/products/domain/entities/product_task_entity.dart';
import 'package:taskflow_app/features/products/domain/entities/transfer_line_entity.dart';
import 'package:taskflow_app/features/products/domain/entities/transfer_receipt_line_entity.dart';
import 'package:taskflow_app/features/products/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  // Cache for products
  final List<ProductEntity> _cachedProducts = [];

  @override
  Future<ProductEntity> getProductById(String productId) async {
    try {
      final cachedProduct = _cachedProducts.firstWhere(
        (product) => product.id == productId,
      );
      return cachedProduct;
    } catch (e) {
      // Product not found in cache, fetch from remote
      return await remoteDataSource.getProductById(productId);
    }
  }

  @override
  Future<ProductEntity> refreshProductById(String productId) async {
    final response = await remoteDataSource.getProductBySystemId(productId);
    final productEntity = ProductEntity(
      id: response.id,
      systemId: response.systemId,
      name: response.name,
      description: response.description,
      inventory: response.inventory,
      unit: response.unit,
      inventoriesByLocation: response.inventoriesByLocation,
      group: response.group,
      vendorName: response.vendorName,
      type: response.type,
    );
    return productEntity;
  }

  @override
  Future<ProductEntity> refreshProductBySystemId(String systemId) async {
    // We don't cache this because we want to get the latest data
    final response = await remoteDataSource.getProductBySystemId(systemId);
    final productEntity = ProductEntity(
      id: response.id,
      systemId: response.systemId,
      name: response.name,
      description: response.description,
      inventory: response.inventory,
      unit: response.unit,
      inventoriesByLocation: response.inventoriesByLocation,
      group: response.group,
      vendorName: response.vendorName,
      type: response.type,
    );
    return productEntity;
  }

  @override
  Future<List<ProductTaskEntity>> getProductTasks(String taskId) {
    return remoteDataSource.getProductTasks(taskId);
  }

  @override
  Future<void> addProductTask(ProductTaskEntity product) {
    return remoteDataSource.addProduct(
      ProductTaskModel(
        id: product.id,
        taskId: product.taskId,
        name: product.name,
        description: product.description,
        quantity: product.quantity,
        unit: product.unit,
        lineNumber: product.lineNumber,
        locationCode: product.locationCode,
        serviceItemNo: product.serviceItemNo,
        serviceItemLineNo: product.serviceItemLineNo,
        type: product.type,
      ),
    );
  }

  @override
  Future<void> deleteProductTask(String systemId) async {
    return await remoteDataSource.deleteProductTask(systemId);
  }

  @override
  Future<int> getProductTasksCount(String taskId) async {
    return remoteDataSource.getProductTasksCount(taskId);
  }

  @override
  Future<List<LocationEntity>> getLocations(String taskLocationCode) async {
    final locations = await remoteDataSource.getLocations(taskLocationCode);
    return locations
        .map(
          (location) => LocationEntity(
            code: location.code,
            name: location.name,
            consumptionLocationCode: location.consumptionLocationCode,
            requiresTransferOrder: location.requiresTransferOrder,
          ),
        )
        .toList();
  }

  @override
  Future<String> createTransferHeader(
    String transferFromCode,
    String transferToCode,
    String taskId,
    String licensePlate,
  ) {
    return remoteDataSource.createTransferHeader(
      transferFromCode,
      transferToCode,
      taskId,
      licensePlate,
    );
  }

  @override
  Future<List<TransferReceiptLineEntity>> getTransferReceiptLines(
    String taskId,
  ) async {
    final receiptLines = await remoteDataSource.getTransferReceiptLines(taskId);
    return receiptLines
        .map(
          (line) => TransferReceiptLineEntity(
            documentNo: line.documentNo,
            transferFromCode: line.transferFromCode,
            transferToCode: line.transferToCode,
            taskId: line.taskId,
            productId: line.productId,
          ),
        )
        .toList();
  }

  @override
  Future<TransferReceiptLineEntity?> getTransferReceiptLine(
    String taskId,
    String productId,
  ) async {
    final transferReceiptLine = await remoteDataSource.getTransferReceiptLine(
      taskId,
      productId,
    );

    if (transferReceiptLine == null) {
      return null;
    }

    return TransferReceiptLineEntity(
      documentNo: transferReceiptLine.documentNo,
      transferFromCode: transferReceiptLine.transferFromCode,
      transferToCode: transferReceiptLine.transferToCode,
      taskId: transferReceiptLine.taskId,
      productId: transferReceiptLine.productId,
    );
  }

  @override
  Future<void> createTransferLine(TransferLineEntity transferLine) {
    return remoteDataSource.createTransferLine(
      TransferLineModel(
        id: transferLine.id,
        productId: transferLine.productId,
        quantity: transferLine.quantity,
        taskId: transferLine.taskId,
      ),
    );
  }

  @override
  Future<List<TransferLineEntity>> getTransferLines(String taskId) async {
    final transferLines = await remoteDataSource.getTransferLines(taskId);
    return transferLines
        .map(
          (line) => TransferLineEntity(
            id: line.id,
            productId: line.productId,
            quantity: line.quantity,
            quantityReceived: line.quantityReceived,
            taskId: line.taskId,
          ),
        )
        .toList();
  }

  @override
  Future<PagedResult<ProductEntity>> getProductsPage({
    required int skip,
    required int top,
    String? searchQuery,
  }) async {
    final page = await remoteDataSource.getProductsPage(
      skip: skip,
      top: top,
      searchQuery: searchQuery,
    );
    final items =
        page.items
            .map(
              (product) => ProductEntity(
                id: product.id,
                systemId: product.systemId,
                name: product.name,
                description: product.description,
                inventory: product.inventory,
                unit: product.unit,
                inventoriesByLocation: product.inventoriesByLocation,
                group: product.group,
                vendorName: product.vendorName,
                type: product.type,
              ),
            )
            .toList();
    return PagedResult<ProductEntity>(
      items: items,
      totalCount: page.totalCount,
      skip: page.skip,
      top: page.top,
    );
  }
}
