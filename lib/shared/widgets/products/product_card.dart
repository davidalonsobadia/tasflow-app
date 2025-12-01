import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/features/products/domain/entities/product_entity.dart';
import 'package:taskflow_app/shared/widgets/card_container.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback onSelected;

  const ProductCard({
    super.key,
    required this.product,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onSelected,
          child: CardContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: foregroundColor,
                  ),
                ),
                SizedBox(
                  height: ResponsiveConstants.getRelativeHeight(context, 10),
                ),
                Text(
                  product.vendorName,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: mutedForegroundColor),
                ),
                SizedBox(
                  height: ResponsiveConstants.getRelativeHeight(context, 26),
                ),
                Row(
                  children: [
                    Text(
                      'ID: ${product.id}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: mutedForegroundColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 24)),
      ],
    );
  }
}
