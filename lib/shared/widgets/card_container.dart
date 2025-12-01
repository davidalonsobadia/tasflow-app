import 'package:flutter/material.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/config/themes/theme_config.dart';

class CardContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final double? width;
  final double? height;

  const CardContainer({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.borderRadius,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(borderRadius ?? AppRadius.radiusXl),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: AppShadows.shadowSm,
      ),
      child:
          padding != null
              ? Padding(padding: padding!, child: child)
              : Padding(
                padding: const EdgeInsets.all(AppSpacing.space6),
                child: child,
              ),
    );
  }
}
