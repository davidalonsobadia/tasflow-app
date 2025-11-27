import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:flutter/material.dart';

class ModalBottomHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final bool showBackArrow;

  const ModalBottomHeader({
    super.key,
    required this.title,
    this.onBackPressed,
    this.showBackArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveConstants.getRelativeWidth(context, 16),
      ),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            ResponsiveConstants.getRelativeWidth(context, 16),
          ),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 16)),
          Container(
            width: ResponsiveConstants.getRelativeHeight(context, 48),
            height: ResponsiveConstants.getRelativeHeight(context, 4),
            decoration: BoxDecoration(
              color: onPrimaryColor,
              borderRadius:
                  ResponsiveConstants.getRelativeBorderRadius(context, 20),
            ),
          ),
          SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (showBackArrow && onBackPressed != null)
                    GestureDetector(
                      onTap: onBackPressed,
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: ResponsiveConstants.getRelativeWidth(
                            context,
                            8,
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: greyTextColor,
                          size: ResponsiveConstants.getRelativeWidth(
                            context,
                            20,
                          ),
                        ),
                      ),
                    ),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.close_rounded,
                  color: greyTextColor,
                  size: ResponsiveConstants.getRelativeWidth(context, 24),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 16)),
        ],
      ),
    );
  }
}
