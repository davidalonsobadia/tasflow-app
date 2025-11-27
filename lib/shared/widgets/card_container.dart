import 'package:flutter/material.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/config/constants/responsive_constants.dart';

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
        color: whiteColor,
        borderRadius: ResponsiveConstants.getRelativeBorderRadius(
          context,
          borderRadius ?? 12,
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(158, 158, 158, 0.2),
            spreadRadius: ResponsiveConstants.getRelativeWidth(context, 2),
            blurRadius: ResponsiveConstants.getRelativeWidth(context, 4),
            offset: Offset(0, ResponsiveConstants.getRelativeHeight(context, 2)),
          ),
        ],
      ),
      child:
          padding != null
              ? Padding(padding: padding!, child: child)
              : Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveConstants.getRelativeWidth(context, 16),
                  vertical: ResponsiveConstants.getRelativeHeight(context, 16),
                ),
                child: child,
              ),
    );
  }
}
