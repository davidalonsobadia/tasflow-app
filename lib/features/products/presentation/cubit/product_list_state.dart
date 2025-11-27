import 'package:taskflow_app/core/utils/error_handler.dart';
import 'package:taskflow_app/features/products/domain/entities/product_entity.dart';

abstract class ProductListState {}

class ProductListInitial extends ProductListState {}

class ProductListLoading extends ProductListState {}

class ProductListLoaded extends ProductListState {
  final List<ProductEntity> products;
  final int totalCount;
  final bool hasMore;
  final bool isLoadingMore;
  final String? query;

  ProductListLoaded({
    required this.products,
    required this.totalCount,
    required this.hasMore,
    required this.isLoadingMore,
    this.query,
  });

  ProductListLoaded copyWith({
    List<ProductEntity>? products,
    int? totalCount,
    bool? hasMore,
    bool? isLoadingMore,
    String? query,
  }) {
    return ProductListLoaded(
      products: products ?? this.products,
      totalCount: totalCount ?? this.totalCount,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      query: query ?? this.query,
    );
  }
}

class ProductListFailure extends ProductListState {
  final AppError error;
  ProductListFailure(this.error);
}
