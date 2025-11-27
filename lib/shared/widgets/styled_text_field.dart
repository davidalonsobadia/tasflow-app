import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:flutter/material.dart';

class StyledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? prefixText;
  final TextInputType? keyboardType;
  final bool? autofocus;
  final int? maxLines;
  final int? minLines;
  final FocusNode? focusNode;
  final bool showBorder;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final TextCapitalization? textCapitalization;

  const StyledTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixText,
    this.keyboardType,
    this.autofocus,
    this.maxLines,
    this.minLines,
    this.focusNode,
    this.showBorder = true,
    this.onChanged,
    this.onEditingComplete,
    this.textCapitalization,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: ResponsiveConstants.getRelativeBorderRadius(context, 12),
        border: showBorder ? Border.all(color: Colors.grey.shade300) : null,
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          hintText: hintText,
          prefixText: prefixText,
          hintStyle: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade400),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: ResponsiveConstants.getRelativeWidth(context, 16),
            vertical: ResponsiveConstants.getRelativeHeight(context, 18),
          ),
        ),
        keyboardType: keyboardType ?? TextInputType.text,
        autofocus: autofocus ?? false,
        maxLines: maxLines ?? 1,
        minLines: minLines,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        textCapitalization: textCapitalization ?? TextCapitalization.sentences,
      ),
    );
  }
}
