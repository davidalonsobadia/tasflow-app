import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RefreshButtonInSearchBar extends StatelessWidget {
  final VoidCallback? onTap;

  const RefreshButtonInSearchBar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(
          ResponsiveConstants.getRelativeWidth(context, 13),
        ),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: ResponsiveConstants.getRelativeBorderRadius(context, 8),
          border: Border.all(color: lightGreyColor, width: 1),
        ),
        child: Icon(
          CupertinoIcons.arrow_2_circlepath,
          size: ResponsiveConstants.getRelativeWidth(context, 24),
        ),
      ),
    );
  }
}
