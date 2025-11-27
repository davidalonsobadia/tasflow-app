import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:flutter/material.dart';

class OutlinedAppButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? width;

  const OutlinedAppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor =
        backgroundColor ?? whiteColor.withAlpha((0.20 * 255).toInt());
    // Create a darker version of the background color for the border
    final Color border = borderColor ?? _getDarkerColor(bgColor);

    return SizedBox(
      width: width ?? ResponsiveConstants.getRelativeWidth(context, 140),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(bgColor),
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(
              vertical: ResponsiveConstants.getRelativeHeight(context, 10),
            ),
          ),
          side: WidgetStatePropertyAll(BorderSide(color: border)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius:
                  ResponsiveConstants.getRelativeBorderRadius(context, 8),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium!.copyWith(color: textColor ?? backgroundColor),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }

  // Helper method to create a darker version of a color
  Color _getDarkerColor(Color color) {
    // If the color is already very dark, use a lighter shade for contrast
    if (_isColorDark(color)) {
      return color.withOpacity(0.8);
    }

    // Create a darker version by reducing brightness by 20%
    final HSLColor hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - 0.2).clamp(0.0, 1.0)).toColor();
  }

  // Helper to determine if a color is dark
  bool _isColorDark(Color color) {
    // Calculate perceived brightness using the formula
    // (299*R + 587*G + 114*B) / 1000
    final double brightness =
        (299 * color.red + 587 * color.green + 114 * color.blue) / 1000;
    return brightness < 128; // If less than 128, considered dark
  }
}
