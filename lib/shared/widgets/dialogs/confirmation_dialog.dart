import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/config/themes/theme_config.dart';
import 'package:taskflow_app/shared/widgets/buttons/outlined_app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? cancelText;
  final String? confirmText;
  final ButtonVariant cancelVariant;
  final ButtonVariant confirmVariant;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.cancelText,
    this.confirmText,
    this.cancelVariant = ButtonVariant.secondary,
    this.confirmVariant = ButtonVariant.primary,
  });

  @override
  Widget build(BuildContext context) {
    final String effectiveCancelText = cancelText ?? translate('cancel');
    final String effectiveConfirmText = confirmText ?? translate('confirm');

    return AlertDialog(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: foregroundColor,
        ),
      ),
      content: Text(
        message,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: foregroundColor),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            OutlinedAppButton(
              width: ResponsiveConstants.getRelativeWidth(context, 120),
              text: effectiveCancelText,
              onPressed: () => Navigator.pop(context, false),
              variant: cancelVariant,
            ),
            OutlinedAppButton(
              width: ResponsiveConstants.getRelativeWidth(context, 120),
              text: effectiveConfirmText,
              onPressed: () => Navigator.pop(context, true),
              variant: confirmVariant,
            ),
          ],
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.radiusLg),
        side: BorderSide(color: borderColor, width: 1),
      ),
      backgroundColor: backgroundColor,
    );
  }
}
