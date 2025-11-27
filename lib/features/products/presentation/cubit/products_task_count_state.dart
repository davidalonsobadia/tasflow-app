abstract class ProductsTaskCountState {}

class ProductsTaskCountInitial extends ProductsTaskCountState {}

class ProductsTaskCountLoading extends ProductsTaskCountState {}

class ProductsTaskCountLoaded extends ProductsTaskCountState {
  final int count;
  ProductsTaskCountLoaded(this.count);
}

class ProductsTaskCountFailure extends ProductsTaskCountState {
  final String error;
  ProductsTaskCountFailure(this.error);
}
