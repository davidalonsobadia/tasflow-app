import 'package:taskflow_app/core/network/exceptions.dart';
import 'package:taskflow_app/features/products/domain/entities/product_task_entity.dart';
import 'package:taskflow_app/features/products/domain/repositories/product_repository.dart';
import 'package:taskflow_app/features/tasks/domain/repositories/task_repository.dart';
import 'package:flutter_translate/flutter_translate.dart';

class AddProductUseCase {
  final ProductRepository productRepository;
  final TaskRepository taskRepository;

  AddProductUseCase(this.productRepository, this.taskRepository);

  Future<void> addProduct(
    String taskId,
    String productId,
    int quantity,
    String locationCode,
  ) async {
    // 1. get task lines
    final taskLines = await taskRepository.getTaskLines(taskId);
    if (taskLines.isEmpty) {
      throw NotFoundException(
        translate('noTaskLinesFound', args: {'taskId': taskId}),
      );
    }
    final taskLine = taskLines.first;

    // 2. get line number
    int lineNumber;
    final productsTask = await productRepository.getProductTasks(taskId);
    if (productsTask.isEmpty) {
      lineNumber = 10000; // Default starting line number if no products exist
    } else {
      // Find the highest line number among existing products
      lineNumber = productsTask.fold(
        0,
        (maxLine, product) =>
            product.lineNumber > maxLine ? product.lineNumber : maxLine,
      );
      // Add 10000 to the highest line number for the new product
      lineNumber += 10000;
    }

    // 3. create productTaskEntity
    final productTaskEntity = ProductTaskEntity(
      id: productId,
      name: '',
      description: '',
      unit: '',
      locationCode: locationCode,
      taskId: taskId,
      quantity: quantity.toDouble(),
      lineNumber: lineNumber,
      serviceItemNo: taskLine.serviceItemNo,
      serviceItemLineNo: taskLine.lineNumber,
      type: 'Item',
    );

    // 4. add product, calling repo
    return await productRepository.addProductTask(productTaskEntity);
  }
}
