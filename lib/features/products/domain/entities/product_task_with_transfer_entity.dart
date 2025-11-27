import 'package:taskflow_app/features/products/domain/entities/product_task_entity.dart';

enum TransferStatus { pending, partial, completed, unknown, notApplicable }

class ProductTaskWithTransferEntity {
  final ProductTaskEntity product;
  final TransferStatus transferStatus;
  final double quantityReceived;
  final double quantityRequested;

  const ProductTaskWithTransferEntity({
    required this.product,
    required this.transferStatus,
    this.quantityReceived = 0,
    this.quantityRequested = 0,
  });
}
