import 'package:taskflow_app/core/utils/error_handler.dart';
import 'package:taskflow_app/features/products/domain/entities/product_entity.dart';

abstract class ProductDetailsState {}

class ProductDetailsInitial extends ProductDetailsState {}

class ProductDetailsLoading extends ProductDetailsState {}

class ProductDetailsLoaded extends ProductDetailsState {
  final ProductEntity product;
  ProductDetailsLoaded(this.product);
}

class ProductDetailsFailure extends ProductDetailsState {
  final AppError error;
  ProductDetailsFailure(this.error);
}
