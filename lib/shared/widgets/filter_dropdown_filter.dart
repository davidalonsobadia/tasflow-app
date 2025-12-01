import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/config/themes/theme_config.dart';
import 'package:flutter/material.dart';

class FilterDropdownWidget<T> extends StatelessWidget {
  final List<T> items;
  final T? selectedValue;
  final String Function(T) itemDisplayText;
  final ValueChanged<T?> onChanged;
  final String hintText;
  final String allItemsText;
  final double? width;
  final double? height;
  final IconData? prefixIcon;
  final bool showClearButton;

  const FilterDropdownWidget({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.itemDisplayText,
    required this.onChanged,
    required this.hintText,
    required this.allItemsText,
    this.width,
    this.height,
    this.prefixIcon = Icons.filter_list,
    this.showClearButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: width ?? ResponsiveConstants.getRelativeWidth(context, 198),
        height: height ?? ResponsiveConstants.getRelativeHeight(context, 40),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveConstants.getRelativeWidth(context, 12),
        ),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(AppRadius.radiusLg),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (prefixIcon != null) ...[
              Icon(
                prefixIcon!,
                size: ResponsiveConstants.getRelativeWidth(context, 16),
                color: mutedForegroundColor,
              ),
              SizedBox(width: ResponsiveConstants.getRelativeWidth(context, 8)),
            ],
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<T?>(
                  isExpanded: true,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: mutedForegroundColor,
                    size: ResponsiveConstants.getRelativeWidth(context, 20),
                  ),
                  hint: Text(
                    hintText,
                    style: TextStyle(
                      fontSize: 13,
                      color: mutedForegroundColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  value: selectedValue,
                  items: [
                    DropdownMenuItem<T?>(
                      value: null,
                      child: Text(
                        allItemsText,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: foregroundColor,
                        ),
                      ),
                    ),
                    ...items.map(
                      (item) => DropdownMenuItem<T?>(
                        value: item,
                        child: Text(
                          itemDisplayText(item),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: foregroundColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                  onChanged: onChanged,
                  dropdownColor: cardColor,
                  menuMaxHeight: ResponsiveConstants.getRelativeHeight(
                    context,
                    500,
                  ),
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            if (showClearButton && selectedValue != null) ...[
              SizedBox(width: ResponsiveConstants.getRelativeWidth(context, 4)),
              GestureDetector(
                onTap: () => onChanged(null),
                child: Icon(
                  Icons.clear,
                  size: ResponsiveConstants.getRelativeWidth(context, 16),
                  color: mutedForegroundColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
