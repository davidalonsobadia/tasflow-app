import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/config/themes/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
    this.actions,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(60);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: foregroundColor,
          size: ResponsiveConstants.getRelativeWidth(context, 20),
        ),
        onPressed: widget.onBackPressed ?? () => context.pop(),
        padding: EdgeInsets.all(
          ResponsiveConstants.getRelativeWidth(context, 8),
        ),
      ),
      title: Text(widget.title),
      actions:
          widget.actions ??
          [
            Padding(
              padding: EdgeInsets.only(
                right: ResponsiveConstants.getRelativeWidth(context, 16),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: foregroundColor,
                  size: ResponsiveConstants.getRelativeWidth(context, 24),
                ),
                onPressed: widget.onBackPressed ?? () => context.go('/main'),
                padding: EdgeInsets.all(
                  ResponsiveConstants.getRelativeWidth(context, 8),
                ),
              ),
            ),
          ],
      titleTextStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: foregroundColor,
      ),
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
    );
  }
}
