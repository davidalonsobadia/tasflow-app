import 'dart:io';

import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/features/products/domain/entities/product_entity.dart';
import 'package:taskflow_app/shared/widgets/loading_indicators/loading_indicator_in_card_item.dart';
import 'package:taskflow_app/shared/widgets/buttons/refresh_button_in_search_bar.dart';
import 'package:taskflow_app/shared/widgets/custom_search_bar.dart';
import 'package:taskflow_app/shared/widgets/dialogs/confirmation_dialog.dart';
import 'package:taskflow_app/shared/widgets/error_handler_widget.dart';
import 'package:taskflow_app/shared/widgets/filter_dropdown_filter.dart';
import 'package:taskflow_app/shared/widgets/loading_indicators/loading_indicator_in_screen.dart';
import 'package:taskflow_app/shared/widgets/products/product_card.dart';
import 'package:flutter/material.dart';
import 'package:taskflow_app/features/products/presentation/cubit/product_list_cubit.dart';
import 'package:taskflow_app/features/products/presentation/cubit/product_list_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ProductsListScreen extends StatefulWidget {
  final Function(ProductEntity) onProductSelected;
  final String locationCode;
  final bool showOnlyAvailable;
  final bool showFilter;

  const ProductsListScreen({
    super.key,
    required this.onProductSelected,
    required this.locationCode,
    this.showOnlyAvailable = false,
    this.showFilter = true,
  });

  @override
  State<ProductsListScreen> createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? _selectedProductGroup;

  @override
  void initState() {
    super.initState();
    // Set up infinite scroll trigger at 70%
    _scrollController.addListener(() {
      if (!_scrollController.hasClients) return;
      final position = _scrollController.position;
      if (!position.hasPixels || !position.hasContentDimensions) return;
      if (position.maxScrollExtent <= 0) {
        return; // avoid auto-loading when content doesn't fill viewport
      }
      final threshold = position.maxScrollExtent * 0.7;
      if (position.pixels >= threshold) {
        context.read<ProductListCubit>().loadNextPage();
      }
    });

    // Load initial page (first 100)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductListCubit>().loadInitial();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    // Delegate to cubit with debounce and >=3 chars rule
    context.read<ProductListCubit>().onQueryChanged(query);
  }

  void _onProductGroupSelected(String? group) {
    setState(() {
      _selectedProductGroup = group;
      // For now, group filter only affects local display; server-side filtering for group can be added later
    });
  }

  Widget _buildProductCard(BuildContext context, ProductEntity product) {
    return ProductCard(
      product: product,
      onSelected: () => widget.onProductSelected(product),
    );
  }

  List<String> _getUniqueProductGroups() {
    final state = context.read<ProductListCubit>().state;
    if (state is! ProductListLoaded) return [];
    final Set<String> groups = {};
    for (var product in state.products) {
      groups.add(product.group);
    }
    return groups.toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            right: ResponsiveConstants.getRelativeWidth(context, 16),
            left: ResponsiveConstants.getRelativeWidth(context, 16),
            top: _getPlatformBottomPadding(context),
          ),
          child: Row(
            children: [
              Expanded(
                child: CustomSearchBar(
                  controller: _searchController,
                  onSearch: _performSearch,
                  hintText: translate('searchProducts'),
                  onStateUpdate: () => setState(() {}),
                ),
              ),
              SizedBox(width: ResponsiveConstants.getRelativeWidth(context, 6)),
              RefreshButtonInSearchBar(
                onTap: () async {
                  final bool? confirm = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return ConfirmationDialog(
                        title: translate('refreshProducts'),
                        message: translate(
                          'refreshProductsConfirmationMessage',
                        ),
                      );
                    },
                  );
                  if (!mounted) return;
                  if (confirm == true) {
                    if (!context.mounted) return;
                    _searchController.clear();
                    context.read<ProductListCubit>().loadInitial();
                  }
                },
              ),
            ],
          ),
        ),

        // Add Filter
        if (widget.showFilter) ...[
          BlocBuilder<ProductListCubit, ProductListState>(
            builder: (context, state) {
              if (state is ProductListLoaded) {
                return Padding(
                  padding: EdgeInsets.only(
                    top: ResponsiveConstants.getRelativeHeight(context, 10),
                    right: ResponsiveConstants.getRelativeWidth(context, 16),
                    left: ResponsiveConstants.getRelativeWidth(context, 16),
                  ),
                  child: ProductGroupFilterWidget(
                    productGroups: _getUniqueProductGroups(),
                    selectedProductGroup: _selectedProductGroup,
                    onChanged: _onProductGroupSelected,
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
        SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 20)),
        Expanded(
          child: BlocBuilder<ProductListCubit, ProductListState>(
            builder: (context, state) {
              if (state is ProductListLoading || state is ProductListInitial) {
                return LoadingIndicatorInScreen();
              }
              if (state is ProductListFailure) {
                return ErrorHandlerWidget(
                  error: state.error,
                  onRetry:
                      () => context.read<ProductListCubit>().loadInitial(
                        query: null,
                      ),
                );
              }
              final loaded = state as ProductListLoaded;
              if (loaded.products.isEmpty) {
                return Center(child: Text(translate('noProductsFound')));
              }
              return ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveConstants.getRelativeWidth(context, 16),
                ),
                itemCount:
                    loaded.isLoadingMore
                        ? loaded.products.length + 1
                        : loaded.products.length,
                itemBuilder: (context, index) {
                  if (loaded.isLoadingMore && index == loaded.products.length) {
                    return const LoadingIndicatorInCardItem();
                  }
                  final product = loaded.products[index];
                  return _buildProductCard(context, product);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  double _getPlatformBottomPadding(BuildContext context) {
    if (Platform.isAndroid) {
      return ResponsiveConstants.getRelativeHeight(context, 24);
    }
    return ResponsiveConstants.getRelativeHeight(context, 16);
  }
}

// Specific implementation for Product Groups Filter
class ProductGroupFilterWidget extends StatelessWidget {
  final List<String> productGroups;
  final String? selectedProductGroup;
  final ValueChanged<String?> onChanged;
  final double? width;
  final double? height;

  const ProductGroupFilterWidget({
    super.key,
    required this.productGroups,
    required this.selectedProductGroup,
    required this.onChanged,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return FilterDropdownWidget<String>(
      items: productGroups,
      selectedValue: selectedProductGroup,
      itemDisplayText: (plate) => plate,
      onChanged: onChanged,
      hintText: translate('productGroups'),
      allItemsText: translate('allGroups'),
      width: width,
      height: height,
      prefixIcon: Icons.filter_list,
      showClearButton: true,
    );
  }
}
