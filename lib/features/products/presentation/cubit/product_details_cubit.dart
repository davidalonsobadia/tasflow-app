import 'package:taskflow_app/core/utils/error_handler.dart';
import 'package:taskflow_app/features/products/domain/usecases/get_products.dart';
import 'package:taskflow_app/features/products/presentation/cubit/product_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final GetProductsUseCase getProductsUseCase;

  ProductDetailsCubit(this.getProductsUseCase) : super(ProductDetailsInitial());

  Future<void> getProductDetails(String systemId) async {
    try {
      emit(ProductDetailsLoading());
      final product = await getProductsUseCase.refreshProductBySystemId(
        systemId,
      );
      emit(ProductDetailsLoaded(product));
    } catch (exception) {
      print('Error getting product details: ${exception.toString()}');
      emit(ProductDetailsFailure(ErrorHandler.handle(exception)));
    }
  }
}
