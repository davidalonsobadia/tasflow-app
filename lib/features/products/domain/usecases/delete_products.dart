import 'package:taskflow_app/features/products/domain/repositories/product_repository.dart';

class DeleteProductUseCase {
  final ProductRepository repository;

  DeleteProductUseCase(this.repository);

  Future<void> deleteProduct(String systemId) {
    return repository.deleteProductTask(systemId);
  }
}
