import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/core/utils/format_utils.dart';
import 'package:taskflow_app/features/products/domain/entities/product_entity.dart';
import 'package:taskflow_app/features/products/presentation/cubit/product_details_cubit.dart';
import 'package:taskflow_app/features/products/presentation/cubit/product_details_state.dart';
import 'package:taskflow_app/shared/widgets/card_container.dart';
import 'package:taskflow_app/shared/widgets/custom_header.dart';
import 'package:taskflow_app/shared/widgets/error_handler_widget.dart';
import 'package:taskflow_app/shared/widgets/loading_indicators/loading_indicator_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductEntity product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late ProductEntity _currentProduct;

  @override
  void initState() {
    super.initState();
    _currentProduct = widget.product;
    // Load product details when widget initializes
    _loadProductDetails();
  }

  void _loadProductDetails() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductDetailsCubit>().getProductDetails(
        _currentProduct.systemId,
      );
    });
  }

  void _refreshProduct() {
    _loadProductDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomHeader(
          title: translate('productDetails'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _refreshProduct,
              tooltip: translate('refreshProducts'),
            ),
          ],
        ),
        Expanded(
          child: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
            builder: (context, state) {
              if (state is ProductDetailsFailure) {
                return ErrorHandlerWidget(
                  error: state.error,
                  onRetry: () => _loadProductDetails(),
                );
              } else if (state is ProductDetailsLoading) {
                return LoadingIndicatorInScreen();
              } else if (state is ProductDetailsLoaded) {
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveConstants.getRelativeWidth(
                      context,
                      16,
                    ),
                    vertical: ResponsiveConstants.getRelativeHeight(
                      context,
                      16,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProductHeader(context),
                      SizedBox(
                        height: ResponsiveConstants.getRelativeHeight(
                          context,
                          24,
                        ),
                      ),
                      _buildDescriptionSection(context),
                      SizedBox(
                        height: ResponsiveConstants.getRelativeHeight(
                          context,
                          24,
                        ),
                      ),
                      _buildInventorySection(context),
                    ],
                  ),
                );
              }
              return LoadingIndicatorInScreen();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductHeader(BuildContext context) {
    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _currentProduct.name,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 8)),
          Text(
            'ID: ${_currentProduct.id}',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: mediumGreyColor),
          ),
          SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 16)),
          Container(
            decoration: BoxDecoration(
              borderRadius:
                  ResponsiveConstants.getRelativeBorderRadius(context, 8),
              color: lightBlue,
            ),
            padding: EdgeInsets.symmetric(
              vertical: ResponsiveConstants.getRelativeHeight(context, 5),
              horizontal: ResponsiveConstants.getRelativeWidth(context, 10),
            ),
            child: Text(
              translate(
                'inStock',
                args: {
                  'quantity': FormatUtils.formatAmount(
                    _currentProduct.inventory,
                  ),
                  'unit': _currentProduct.unit,
                },
              ),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: onLightBlue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(BuildContext context) {
    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            translate('description'),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 16)),
          Text(
            _currentProduct.description,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildInventorySection(BuildContext context) {
    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            translate('inventoryDetails'),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 16)),
          _buildInventoryItem(
            context,
            translate('totalInventory'),
            '${FormatUtils.formatAmount(_currentProduct.inventory)} ${_currentProduct.unit}',
          ),
          for (var location in _currentProduct.inventoriesByLocation) ...[
            Divider(height: ResponsiveConstants.getRelativeHeight(context, 24)),
            _buildInventoryItem(
              context,
              location.displayName,
              '${FormatUtils.formatAmount(location.quantity)} ${_currentProduct.unit}',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInventoryItem(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
