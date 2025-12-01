import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;

  const CustomHeader({
    super.key,
    required this.title,
    this.onBackPressed,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ResponsiveConstants.getRelativeHeight(context, 56),
      color: backgroundColor,
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveConstants.getRelativeWidth(context, 8),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: foregroundColor,
              size: ResponsiveConstants.getRelativeWidth(context, 20),
            ),
            onPressed: onBackPressed ?? () => context.pop(),
            padding: EdgeInsets.all(
              ResponsiveConstants.getRelativeWidth(context, 8),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: foregroundColor,
                ),
              ),
            ),
          ),
          ...(actions ??
              [
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: foregroundColor,
                    size: ResponsiveConstants.getRelativeWidth(context, 24),
                  ),
                  onPressed: onBackPressed ?? () => context.go('/main'),
                  padding: EdgeInsets.all(
                    ResponsiveConstants.getRelativeWidth(context, 8),
                  ),
                ),
              ]),
        ],
      ),
    );
  }
}
