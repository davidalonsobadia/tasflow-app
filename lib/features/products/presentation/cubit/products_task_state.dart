import 'package:taskflow_app/core/utils/error_handler.dart';
import 'package:taskflow_app/features/products/domain/entities/product_task_with_transfer_entity.dart';

abstract class ProductTaskState {}

class ProductTaskInitial extends ProductTaskState {}

class ProductTaskLoading extends ProductTaskState {}

class ProductTaskLoaded extends ProductTaskState {
  final List<ProductTaskWithTransferEntity> productTasksWithTransfer;

  ProductTaskLoaded(this.productTasksWithTransfer);
}

class ProductTaskFailure extends ProductTaskState {
  final AppError error;

  ProductTaskFailure(this.error);
}
