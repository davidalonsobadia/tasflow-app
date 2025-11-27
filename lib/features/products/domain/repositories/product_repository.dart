import 'package:taskflow_app/core/utils/paged_result.dart';
import 'package:taskflow_app/features/products/domain/entities/product_entity.dart';
import 'package:taskflow_app/features/products/domain/entities/product_task_entity.dart';
import 'package:taskflow_app/features/products/domain/entities/location_entity.dart';
import 'package:taskflow_app/features/products/domain/entities/transfer_line_entity.dart';
import 'package:taskflow_app/features/products/domain/entities/transfer_receipt_line_entity.dart';

abstract class ProductRepository {
  Future<ProductEntity> getProductById(String productId);
  Future<ProductEntity> refreshProductById(String productId);
  Future<ProductEntity> refreshProductBySystemId(String systemId);
  Future<PagedResult<ProductEntity>> getProductsPage({
    required int skip,
    required int top,
    String? searchQuery,
  });
  Future<List<ProductTaskEntity>> getProductTasks(String taskId);
  Future<void> addProductTask(ProductTaskEntity product);
  Future<void> deleteProductTask(String systemId);
  Future<int> getProductTasksCount(String taskId);

  Future<List<LocationEntity>> getLocations(String taskLocationCode);
  Future<String> createTransferHeader(
    String transferFromCode,
    String transferToCode,
    String taskId,
    String licensePlate,
  );
  Future<void> createTransferLine(TransferLineEntity transferLine);
  Future<List<TransferReceiptLineEntity>> getTransferReceiptLines(
    String taskId,
  );
  Future<TransferReceiptLineEntity?> getTransferReceiptLine(
    String taskId,
    String productId,
  );
  Future<List<TransferLineEntity>> getTransferLines(String taskId);
}
