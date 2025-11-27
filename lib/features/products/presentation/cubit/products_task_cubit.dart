import 'package:taskflow_app/core/mixins/error_reporting_mixin.dart';
import 'package:taskflow_app/core/utils/error_handler.dart';
import 'package:taskflow_app/features/products/domain/usecases/add_products.dart';
import 'package:taskflow_app/features/products/domain/usecases/delete_products.dart';
import 'package:taskflow_app/features/products/domain/usecases/get_products.dart';
import 'package:taskflow_app/features/products/domain/usecases/transfer_products.dart';
import 'package:taskflow_app/features/products/presentation/cubit/products_task_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductTaskCubit extends Cubit<ProductTaskState>
    with ErrorReportingMixin {
  final GetProductsUseCase getProductTasksUseCase;
  final AddProductUseCase addProductUseCase;
  final DeleteProductUseCase deleteProductUseCase;
  final TransferProductsUseCase transferProductsUseCase;

  ProductTaskCubit(
    this.getProductTasksUseCase,
    this.addProductUseCase,
    this.deleteProductUseCase,
    this.transferProductsUseCase,
  ) : super(ProductTaskInitial());

  Future<void> getProductTasksByTaskId(
    String taskId,
    String locationCode,
  ) async {
    emit(ProductTaskLoading());

    try {
      // Get products with their transfer status already combined
      final productsWithTransfer = await getProductTasksUseCase
          .getProductTasksWithTransferStatus(taskId, locationCode);
      emit(ProductTaskLoaded(productsWithTransfer));
    } catch (exception, stackTrace) {
      handleError(
        exception,
        stackTrace,
        shouldReport: true, // Report all operations
        context: 'getProductTasksByTaskId',
      );
      emit(ProductTaskFailure(ErrorHandler.handle(exception)));
    }
  }

  Future<void> addProductTask(
    String taskId,
    String productId,
    String productType,
    int quantity,
    String locationCode,
    String licensePlate,
  ) async {
    emit(ProductTaskLoading());

    try {
      // Add product to task
      await addProductUseCase.addProduct(
        taskId,
        productId,
        quantity,
        locationCode,
      );

      // If product type is 'Inventory', create transfer request
      if (productType == 'Inventory') {
        // Create transfer request
        await transferProductsUseCase.createTransferRequest(
          locationCode,
          productId,
          quantity.toDouble(),
          taskId,
          licensePlate,
        );
      }

      // Refresh product tasks to get updated list with transfer status
      await getProductTasksByTaskId(taskId, locationCode);
    } catch (exception, stackTrace) {
      handleError(
        exception,
        stackTrace,
        shouldReport: true, // Report - mutation operation
        context: 'addProductTask',
      );
      emit(ProductTaskFailure(ErrorHandler.handle(exception)));
    }
  }

  Future<void> deleteProductTask(
    String taskId,
    String locationCode,
    String systemId,
  ) async {
    emit(ProductTaskLoading());

    try {
      await deleteProductUseCase.deleteProduct(systemId);
      await getProductTasksByTaskId(taskId, locationCode);
    } catch (exception, stackTrace) {
      handleError(
        exception,
        stackTrace,
        shouldReport: true, // Report - mutation operation
        context: 'deleteProductTask',
      );
      emit(ProductTaskFailure(ErrorHandler.handle(exception)));
    }
  }

  Future<void> refreshTransferStatus(String taskId, String locationCode) async {
    emit(ProductTaskLoading());

    try {
      // Refresh products with their transfer status
      final productsWithTransfer = await getProductTasksUseCase
          .getProductTasksWithTransferStatus(taskId, locationCode);
      emit(ProductTaskLoaded(productsWithTransfer));
    } catch (exception, stackTrace) {
      handleError(
        exception,
        stackTrace,
        shouldReport: true, // Report all operations
        context: 'refreshTransferStatus',
      );
      emit(ProductTaskFailure(ErrorHandler.handle(exception)));
    }
  }
}
