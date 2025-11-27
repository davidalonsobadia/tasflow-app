import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/core/utils/format_utils.dart';
import 'package:taskflow_app/shared/widgets/modal_bottom_sheet/base_modal_bottom_sheet.dart';
import 'package:taskflow_app/shared/widgets/products/product_card.dart';
import 'package:taskflow_app/features/products/domain/entities/product_entity.dart';
import 'package:taskflow_app/shared/widgets/bottom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ModalBottomProductsQuantity {
  final ProductEntity product;
  final String locationCode;
  final Function(int)? onQuantityConfirmed;

  const ModalBottomProductsQuantity({
    required this.product,
    required this.locationCode,
    this.onQuantityConfirmed,
  });

  void show(BuildContext context) {
    BaseModalBottomSheet.show(
      context: context,
      title: translate('productQuantity'),
      heightFactor: 0.70,
      content: ProductQuantityContent(
        product: product,
        locationCode: locationCode,
        onQuantityConfirmed: onQuantityConfirmed,
      ),
    );
  }
}

class ProductQuantityContent extends StatefulWidget {
  final ProductEntity product;
  final String locationCode;
  final Function(int)? onQuantityConfirmed;

  const ProductQuantityContent({
    super.key,
    required this.product,
    required this.locationCode,
    this.onQuantityConfirmed,
  });

  @override
  State<ProductQuantityContent> createState() => _ProductQuantityContentState();
}

class _ProductQuantityContentState extends State<ProductQuantityContent> {
  int _selectedQuantity = 1;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveConstants.getRelativeWidth(context, 16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: ResponsiveConstants.getRelativeHeight(context, 16),
                  ),
                  _buildProductCard(context, widget.product),
                  SizedBox(
                    height: ResponsiveConstants.getRelativeHeight(context, 29),
                  ),
                  _buildQuantityInput(context),
                ],
              ),
            ),
          ),
        ),
        _buildConfirmButton(context),
      ],
    );
  }

  Widget _buildProductCard(BuildContext context, ProductEntity product) {
    return ProductCard(product: product, onSelected: () {});
  }

  Widget _buildQuantityInput(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translate('selectQuantity'),
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 14)),
        Container(
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveConstants.getRelativeHeight(context, 16),
            horizontal: ResponsiveConstants.getRelativeWidth(context, 16),
          ),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius:
                ResponsiveConstants.getRelativeBorderRadius(context, 10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: onPrimaryColor,
                  shape: BoxShape.circle,
                ),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (_selectedQuantity > 1) {
                        _selectedQuantity--;
                        _errorMessage = null; // Clear error when decreasing
                      }
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.all(
                      ResponsiveConstants.getRelativeWidth(context, 16),
                    ),
                    child: Icon(Icons.remove),
                  ),
                ),
              ),
              Text(
                '$_selectedQuantity',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              Container(
                decoration: BoxDecoration(
                  color: onPrimaryColor,
                  shape: BoxShape.circle,
                ),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      final maxQuantity = _getMaxAvailableQuantity(
                        widget.product,
                        widget.locationCode,
                      );
                      if (_selectedQuantity < maxQuantity) {
                        _selectedQuantity++;
                        _errorMessage =
                            null; // Clear error when valid increment
                      } else {
                        _errorMessage = translate(
                          'cannotExceedAvailableQuantity',
                          args: {
                            'quantity': FormatUtils.formatAmount(maxQuantity),
                          },
                        );
                      }
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.all(
                      ResponsiveConstants.getRelativeWidth(context, 16),
                    ),
                    child: Icon(Icons.add),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_errorMessage != null) ...[
          SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 8)),
          SizedBox(
            width: double.infinity,
            child: Text(
              _errorMessage!,
              style: TextStyle(color: errorColor, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ],
        SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 16)),
        _buildAvailableInOtherLocations(
          context,
          widget.product,
          widget.locationCode,
        ),
      ],
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: ResponsiveConstants.getRelativeWidth(context, 16),
        left: ResponsiveConstants.getRelativeWidth(context, 16),
        bottom: ResponsiveConstants.getRelativeHeight(context, 32),
      ),
      child: BottomButton(
        label: translate('addToTask'),
        onPressed: () {
          if (widget.onQuantityConfirmed != null) {
            widget.onQuantityConfirmed!(_selectedQuantity);
          }
          Navigator.pop(context);
        },
      ),
    );
  }

  double _getMaxAvailableQuantity(ProductEntity product, locationCode) {
    return product.inventoriesByLocation
        .firstWhere((inventory) => inventory.locationCode == locationCode)
        .quantity;
  }

  Widget _buildAvailableInOtherLocations(
    BuildContext context,
    ProductEntity product,
    String locationCode,
  ) {
    final availableInOtherLocations =
        product.inventoriesByLocation
            .where(
              (inventory) =>
                  inventory.locationCode != locationCode &&
                  inventory.quantity > 0,
            )
            .toList();

    if (availableInOtherLocations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 24)),
        Divider(height: ResponsiveConstants.getRelativeHeight(context, 24)),
        Text(
          translate('availableInOtherLocations'),
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 10)),
        for (var location in availableInOtherLocations) ...[
          Text(
            '${location.displayName}: ${FormatUtils.formatAmount(location.quantity)} ${product.unit}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 4)),
        ],
      ],
    );
  }
}
