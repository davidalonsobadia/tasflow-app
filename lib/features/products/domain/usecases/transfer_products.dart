import 'package:taskflow_app/features/products/domain/entities/transfer_line_entity.dart';
import 'package:taskflow_app/features/products/domain/repositories/product_repository.dart';

class TransferProductsUseCase {
  final ProductRepository repository;

  TransferProductsUseCase(this.repository);

  Future<void> createTransferRequest(
    String taskLocationCode,
    String productId,
    double quantity,
    String taskId,
    String licensePlate,
  ) async {
    // 1. Get locations to find consumption location
    final locations = await repository.getLocations(taskLocationCode);
    final taskLocation = locations.first;

    // 2. Check if transfer order is required
    if (!taskLocation.requiresTransferOrder) {
      return;
    }

    // 3. Create transfer header
    final transferNo = await repository.createTransferHeader(
      taskLocation.consumptionLocationCode,
      taskLocationCode,
      taskId,
      licensePlate,
    );

    // 4. Create transfer line
    final transferLine = TransferLineEntity(
      id: transferNo,
      productId: productId,
      quantity: quantity,
      taskId: taskId,
    );
    await repository.createTransferLine(transferLine);
  }
}
