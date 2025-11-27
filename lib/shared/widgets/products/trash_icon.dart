import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TrashIcon extends StatelessWidget {
  const TrashIcon({super.key, required this.onDelete});

  final Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onDelete,
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(
            left: ResponsiveConstants.getRelativeWidth(context, 6),
            right: ResponsiveConstants.getRelativeWidth(context, 2),
            top: ResponsiveConstants.getRelativeHeight(context, 6),
            bottom: ResponsiveConstants.getRelativeHeight(context, 6),
          ),

          child: SvgPicture.asset(
            'assets/icons/icon_bin.svg',
            width: ResponsiveConstants.getRelativeWidth(context, 14),
            height: ResponsiveConstants.getRelativeHeight(context, 16),
            colorFilter: ColorFilter.mode(mediumGreyColor, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}
