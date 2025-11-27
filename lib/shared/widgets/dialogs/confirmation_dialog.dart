import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/shared/widgets/buttons/outlined_app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? cancelText;
  final String? confirmText;
  final Color cancelColor;
  final Color confirmColor;
  final Color cancelTextColor;
  final Color confirmTextColor;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.cancelText,
    this.confirmText,
    this.cancelColor = lightGreyColor,
    this.confirmColor = primaryColor,
    this.cancelTextColor = blackColor,
    this.confirmTextColor = whiteColor,
  });

  @override
  Widget build(BuildContext context) {
    final String effectiveCancelText = cancelText ?? translate('cancel');
    final String effectiveConfirmText = confirmText ?? translate('confirm');

    return AlertDialog(
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      content: Text(message, style: Theme.of(context).textTheme.bodyMedium),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            OutlinedAppButton(
              width: ResponsiveConstants.getRelativeWidth(context, 120),
              text: effectiveCancelText,
              onPressed: () => Navigator.pop(context, false),
              backgroundColor: cancelColor,
              textColor: cancelTextColor,
            ),
            OutlinedAppButton(
              width: ResponsiveConstants.getRelativeWidth(context, 120),
              text: effectiveConfirmText,
              onPressed: () => Navigator.pop(context, true),
              backgroundColor: confirmColor,
              textColor: confirmTextColor,
            ),
          ],
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: ResponsiveConstants.getRelativeBorderRadius(context, 12),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }
}
