import 'package:flutter/material.dart';
import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:flutter_translate/flutter_translate.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSearch;
  final String? hintText;
  final VoidCallback? onStateUpdate;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
    this.hintText,
    this.onStateUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final String effectiveHintText = hintText ?? translate('search');
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: ResponsiveConstants.getRelativeBorderRadius(context, 8),
        border: Border.all(color: lightGreyColor, width: 1),
      ),
      child: TextField(
        controller: controller,
        onChanged: (query) {
          onSearch(query);
          if (onStateUpdate != null) {
            onStateUpdate!();
          }
        },
        decoration: InputDecoration(
          hintText: effectiveHintText,
          hintStyle: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: mediumGreyColor),
          prefixIcon: Icon(Icons.search, color: primaryColor),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: ResponsiveConstants.getRelativeHeight(context, 12),
          ),
        ),
        style: TextStyle(color: blackColor),
      ),
    );
  }
}
