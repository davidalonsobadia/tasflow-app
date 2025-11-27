import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:flutter/material.dart';

class BottomButton extends StatelessWidget {
  const BottomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
  });

  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? primaryColor,
        minimumSize: Size(
          double.infinity,
          ResponsiveConstants.getRelativeHeight(context, 48),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: ResponsiveConstants.getRelativeBorderRadius(context, 8),
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: whiteColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
