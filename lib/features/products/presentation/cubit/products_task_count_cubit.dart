import 'package:taskflow_app/features/products/domain/usecases/get_products.dart';
import 'package:taskflow_app/features/products/presentation/cubit/products_task_count_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsTaskCountCubit extends Cubit<ProductsTaskCountState> {
  final GetProductsUseCase getProductsUseCase;

  ProductsTaskCountCubit(this.getProductsUseCase)
    : super(ProductsTaskCountInitial());

  Future<void> getProductsTaskCount(String taskId) async {
    emit(ProductsTaskCountLoading());

    try {
      final count = await getProductsUseCase.getProductTasksCount(taskId);
      emit(ProductsTaskCountLoaded(count));
    } catch (exception) {
      emit(ProductsTaskCountFailure(exception.toString()));
    }
  }
}
