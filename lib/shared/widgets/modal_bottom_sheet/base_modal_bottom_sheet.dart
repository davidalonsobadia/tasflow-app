import 'package:flutter/material.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/shared/widgets/modal_bottom_sheet/modal_bottom_header.dart';
import 'package:taskflow_app/shared/services/modal_service.dart';

class BaseModalBottomSheet extends StatefulWidget {
  final String title;
  final Widget content;
  final VoidCallback? onBackPressed;
  final bool showBackArrow;
  final bool resizeToChildHeight;

  const BaseModalBottomSheet({
    super.key,
    required this.title,
    required this.content,
    this.onBackPressed,
    this.showBackArrow = false,
    this.resizeToChildHeight = false,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget content,
    required double heightFactor,
    VoidCallback? onBackPressed,
    bool showBackArrow = false,
    double? viewInsetsBottom,
    bool resizeToChildHeight = false,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        // This will rebuild whenever keyboard changes
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: BaseModalBottomSheet(
            title: title,
            content: content,
            onBackPressed: onBackPressed,
            showBackArrow: showBackArrow,
            resizeToChildHeight: resizeToChildHeight,
          ),
        );
      },
    );
  }

  @override
  State<BaseModalBottomSheet> createState() => _BaseModalBottomSheetState();
}

class _BaseModalBottomSheetState extends State<BaseModalBottomSheet> {
  @override
  void initState() {
    super.initState();
    // Register this modal with the service
    ModalService().registerModal(context);
  }

  @override
  void dispose() {
    // Unregister when disposed
    ModalService().unregisterModal(context);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize:
          widget.resizeToChildHeight ? MainAxisSize.min : MainAxisSize.max,
      children: [
        ModalBottomHeader(
          title: widget.title,
          onBackPressed: widget.onBackPressed,
          showBackArrow: widget.showBackArrow,
        ),
        if (widget.resizeToChildHeight)
          // When we want to resize to content
          Container(
            width: double.infinity,
            decoration: BoxDecoration(color: backgroundColor),
            child: widget.content,
          )
        else
          // Fixed size with scrolling
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(color: backgroundColor),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: widget.content,
              ),
            ),
          ),
      ],
    );
  }
}
