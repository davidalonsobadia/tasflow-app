import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:flutter/material.dart';

class EmptyItemPlaceholder extends StatelessWidget {
  const EmptyItemPlaceholder({
    super.key,
    required this.iconItem,
    required this.noItemsAdded,
    required this.addItem,
    required this.onAdd,
  });

  final IconData iconItem;
  final String noItemsAdded;
  final String addItem;
  final Function() onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: ResponsiveConstants.getRelativeHeight(context, 10),
        bottom: ResponsiveConstants.getRelativeHeight(context, 16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            iconItem,
            size: ResponsiveConstants.getRelativeWidth(context, 40),
            color: lightGreyColor,
          ),
          SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 6)),
          Text(
            noItemsAdded,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: greyTextColor),
          ),
          SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 20)),
          InkWell(
            onTap: onAdd,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: primaryColor),
                SizedBox(
                  width: ResponsiveConstants.getRelativeWidth(context, 12),
                ),
                Text(addItem),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
