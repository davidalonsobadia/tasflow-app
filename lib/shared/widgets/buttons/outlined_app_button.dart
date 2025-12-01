import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/config/themes/theme_config.dart';
import 'package:flutter/material.dart';

/// Button variants following the design system
enum ButtonVariant { primary, secondary, outline, ghost, destructive }

class OutlinedAppButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? width;
  final ButtonVariant variant;

  const OutlinedAppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.width,
    this.variant = ButtonVariant.primary,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getVariantColors();
    final Color bgColor = backgroundColor ?? colors.background;
    final Color fgColor = textColor ?? colors.foreground;
    final Color border = borderColor ?? colors.border;

    return SizedBox(
      width: width,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(bgColor),
          foregroundColor: WidgetStatePropertyAll(fgColor),
          elevation: const WidgetStatePropertyAll(0),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(
              horizontal: AppSpacing.space4,
              vertical: AppSpacing.space2,
            ),
          ),
          side: WidgetStatePropertyAll(BorderSide(color: border, width: 1)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.radiusMd),
            ),
          ),
          minimumSize: const WidgetStatePropertyAll(
            Size(0, AppSizes.buttonHeightDefault),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: fgColor,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  _ButtonColors _getVariantColors() {
    switch (variant) {
      case ButtonVariant.primary:
        return _ButtonColors(
          background: buttonDefaultBgColor,
          foreground: buttonDefaultFgColor,
          border: buttonDefaultBgColor,
        );
      case ButtonVariant.secondary:
        return _ButtonColors(
          background: buttonSecondaryBgColor,
          foreground: buttonSecondaryFgColor,
          border: buttonSecondaryBgColor,
        );
      case ButtonVariant.outline:
        return _ButtonColors(
          background: Colors.transparent,
          foreground: buttonOutlineFgColor,
          border: buttonOutlineBorderColor,
        );
      case ButtonVariant.ghost:
        return _ButtonColors(
          background: Colors.transparent,
          foreground: buttonGhostFgColor,
          border: Colors.transparent,
        );
      case ButtonVariant.destructive:
        return _ButtonColors(
          background: buttonDestructiveBgColor,
          foreground: buttonDestructiveFgColor,
          border: buttonDestructiveBgColor,
        );
    }
  }
}

class _ButtonColors {
  final Color background;
  final Color foreground;
  final Color border;

  _ButtonColors({
    required this.background,
    required this.foreground,
    required this.border,
  });
}
