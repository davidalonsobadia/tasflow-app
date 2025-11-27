import 'package:taskflow_app/core/utils/paged_result.dart';
import 'package:taskflow_app/features/products/domain/entities/product_entity.dart';
import 'package:taskflow_app/features/products/domain/entities/product_task_entity.dart';
import 'package:taskflow_app/features/products/domain/entities/product_task_with_transfer_entity.dart';
import 'package:taskflow_app/features/products/domain/entities/transfer_line_entity.dart';
import 'package:taskflow_app/features/products/domain/repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<ProductEntity> refreshProductBySystemId(String systemId) {
    return repository.refreshProductBySystemId(systemId);
  }

  Future<List<ProductTaskEntity>> getProductTasks(String taskId) {
    return repository.getProductTasks(taskId);
  }

  Future<int> getProductTasksCount(String taskId) async {
    final amount = await repository.getProductTasksCount(taskId);
    return amount;
  }

  Future<PagedResult<ProductEntity>> getProductsPage({
    required int skip,
    required int top,
    String? searchQuery,
  }) {
    return repository.getProductsPage(
      skip: skip,
      top: top,
      searchQuery: searchQuery,
    );
  }

  Future<List<ProductTaskWithTransferEntity>> getProductTasksWithTransferStatus(
    String taskId,
    String taskLocationCode,
  ) async {
    // Get product tasks
    final productTasks = await repository.getProductTasks(taskId);

    // Get transfer lines for this task
    final transferLines = await repository.getTransferLines(taskId);

    // Create a list to store results
    final List<ProductTaskWithTransferEntity> results = [];

    // Process each product task to determine transfer status
    for (final productTask in productTasks) {
      // Get productEntity by Id
      ProductEntity? productEntity;
      try {
        productEntity = await repository.getProductById(productTask.id);
      } catch (e) {
        print('Error getting product by id: ${e.toString()}');
        productEntity = null;
      }

      // Get location to check if transfer order is required
      final locations = await repository.getLocations(taskLocationCode);
      final taskLocation = locations.first;

      // If product is not type 'Inventory' in productEntity or transfer order is not required, TransferStatus is not applicable
      if (productEntity == null ||
          productEntity.type != 'Inventory' ||
          !taskLocation.requiresTransferOrder) {
        results.add(
          ProductTaskWithTransferEntity(
            product: productTask,
            transferStatus: TransferStatus.notApplicable,
            quantityReceived: productTask.quantity,
            quantityRequested: productTask.quantity,
          ),
        );
        continue;
      }

      // Find matching transfer line
      TransferLineEntity? matchingTransferLine;
      try {
        matchingTransferLine = transferLines.firstWhere(
          (tl) => tl.productId == productTask.id && tl.taskId == taskId,
        );
      } catch (e) {
        matchingTransferLine = null;
      }

      // If transfer line found, determine status based on quantities
      if (matchingTransferLine != null) {
        TransferStatus status;
        if (matchingTransferLine.quantityReceived == 0) {
          status = TransferStatus.pending;
        } else if (matchingTransferLine.quantityReceived! <
            matchingTransferLine.quantity) {
          status = TransferStatus.partial;
        } else {
          status = TransferStatus.completed;
        }

        results.add(
          ProductTaskWithTransferEntity(
            product: productTask,
            transferStatus: status,
            quantityReceived: matchingTransferLine.quantityReceived ?? 0,
            quantityRequested: matchingTransferLine.quantity,
          ),
        );
      } else {
        // If no transfer line found, check if there is a transfer receipt line
        final transferReceiptLine = await repository.getTransferReceiptLine(
          taskId,
          productTask.id,
        );
        if (transferReceiptLine != null) {
          // If transfer receipt line exists, status is completed
          results.add(
            ProductTaskWithTransferEntity(
              product: productTask,
              transferStatus: TransferStatus.completed,
              quantityReceived: productTask.quantity,
              quantityRequested: productTask.quantity,
            ),
          );
        } else {
          // If no transfer receipt line, status is unknown/pending
          results.add(
            ProductTaskWithTransferEntity(
              product: productTask,
              transferStatus: TransferStatus.unknown,
              quantityReceived: 0,
              quantityRequested: 0,
            ),
          );
        }
      }
    }

    return results;
  }
}
