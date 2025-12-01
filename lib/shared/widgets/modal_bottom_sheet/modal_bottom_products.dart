import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/features/products/domain/entities/product_entity.dart';
import 'package:taskflow_app/features/products/presentation/pages/products_list_screen.dart';
import 'package:taskflow_app/shared/widgets/modal_bottom_sheet/modal_bottom_header.dart';
import 'package:taskflow_app/shared/widgets/modal_bottom_sheet/modal_bottom_products_quantity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ModalBottomProducts extends StatefulWidget {
  final String locationCode;
  final Function(ProductEntity, int)? onProductWithQuantitySelected;
  final double? heightPercentage;

  const ModalBottomProducts({
    super.key,
    required this.locationCode,
    this.onProductWithQuantitySelected,
    this.heightPercentage,
  });

  void show(BuildContext context) {
    // Use a unique context for the modal to avoid key conflicts
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext modalContext) {
        // Create a new instance instead of using 'this' to avoid key reuse
        return ModalBottomProducts(
          heightPercentage: heightPercentage,
          locationCode: locationCode,
          onProductWithQuantitySelected: onProductWithQuantitySelected,
        );
      },
    );
  }

  @override
  State<ModalBottomProducts> createState() => _ModalBottomProductsState();
}

class _ModalBottomProductsState extends State<ModalBottomProducts> {
  bool _showQuantityScreen = false;
  ProductEntity? _selectedProduct;

  @override
  Widget build(BuildContext context) {
    final effectiveHeightPercentage = widget.heightPercentage ?? 0.90;
    return SizedBox(
      height: MediaQuery.of(context).size.height * effectiveHeightPercentage,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildHeader(context),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(color: backgroundColor),
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 250),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin:
                          _showQuantityScreen
                              ? Offset(1.0, 0.0)
                              : Offset(-1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
                child:
                    _showQuantityScreen && _selectedProduct != null
                        ? _buildQuantityContent(context)
                        : _buildProductsContent(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return ModalBottomHeader(
      title:
          _showQuantityScreen
              ? translate('productQuantity')
              : translate('products'),
      onBackPressed:
          _showQuantityScreen
              ? () => setState(() {
                _showQuantityScreen = false;
              })
              : null,
      showBackArrow: _showQuantityScreen,
    );
  }

  Widget _buildProductsContent(BuildContext context) {
    return ProductsListScreen(
      locationCode: widget.locationCode,
      showOnlyAvailable: true,
      showFilter: false,
      onProductSelected: (product) {
        setState(() {
          _selectedProduct = product;
          _showQuantityScreen = true;
        });
      },
    );
  }

  Widget _buildQuantityContent(BuildContext context) {
    return ProductQuantityContent(
      product: _selectedProduct!,
      locationCode: widget.locationCode,
      onQuantityConfirmed: (quantity) {
        if (widget.onProductWithQuantitySelected != null) {
          widget.onProductWithQuantitySelected!(_selectedProduct!, quantity);
        }
      },
    );
  }
}
