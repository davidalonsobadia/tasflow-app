import 'dart:async';

import 'package:taskflow_app/core/utils/error_handler.dart';
import 'package:taskflow_app/core/utils/paged_result.dart';
import 'package:taskflow_app/features/products/domain/entities/product_entity.dart';
import 'package:taskflow_app/features/products/domain/usecases/get_products.dart';
import 'package:taskflow_app/features/products/presentation/cubit/product_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductListCubit extends Cubit<ProductListState> {
  final GetProductsUseCase _useCase;
  static const int pageSize = 100;

  Timer? _debounceTimer;
  int _skip = 0;
  String? _currentQuery;
  bool _isLoading = false;

  ProductListCubit(this._useCase) : super(ProductListInitial());

  Future<void> loadInitial({String? query}) async {
    if (_isLoading) return;
    _isLoading = true;
    _skip = 0;
    _currentQuery = query;
    emit(ProductListLoading());
    try {
      final PagedResult<ProductEntity> page = await _useCase.getProductsPage(
        skip: _skip,
        top: pageSize,
        searchQuery: _currentQuery,
      );
      _skip += page.items.length;
      emit(
        ProductListLoaded(
          products: page.items,
          totalCount: page.totalCount,
          hasMore: page.hasMore,
          isLoadingMore: false,
          query: _currentQuery,
        ),
      );
    } catch (e) {
      // If the error was due to a cancelled request, ignore it silently
      final message = e.toString();
      if (message.contains('DioExceptionType.cancel') ||
          message.contains('isCancelled')) {
        // No state change
      } else {
        emit(ProductListFailure(ErrorHandler.handle(e)));
      }
    } finally {
      _isLoading = false;
    }
  }

  Future<void> loadNextPage() async {
    final current = state;
    if (_isLoading || current is! ProductListLoaded || !current.hasMore) return;
    _isLoading = true;
    emit(current.copyWith(isLoadingMore: true));
    try {
      final page = await _useCase.getProductsPage(
        skip: _skip,
        top: pageSize,
        searchQuery: _currentQuery,
      );
      _skip += page.items.length;
      final updated = List<ProductEntity>.from(current.products)
        ..addAll(page.items);
      emit(
        current.copyWith(
          products: updated,
          totalCount: page.totalCount,
          hasMore: page.hasMore,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      // If the error was due to a cancelled request, ignore it silently
      final message = e.toString();
      if (message.contains('DioExceptionType.cancel') ||
          message.contains('isCancelled')) {
        // No state change
      } else {
        emit(ProductListFailure(ErrorHandler.handle(e)));
      }
    } finally {
      _isLoading = false;
    }
  }

  void onQueryChanged(String query) {
    // Start searching only when user has typed 3+ characters, otherwise clear search and show initial list
    _debounceTimer?.cancel();

    if (query.trim().length < 3) {
      _currentQuery = null;
      // Reload initial non-search list
      loadInitial(query: null);
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 350), () {
      _currentQuery = query.trim();
      loadInitial(query: _currentQuery);
    });
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
