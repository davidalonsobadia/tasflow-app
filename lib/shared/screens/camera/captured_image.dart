import 'dart:io';

import 'package:camera/camera.dart';
import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/shared/widgets/buttons/outlined_app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class CapturedImageView extends StatelessWidget {
  final XFile capturedImage;
  final Function() retake;
  final Function() done;
  final bool isProcessing;

  const CapturedImageView({
    super.key,
    required this.capturedImage,
    required this.retake,
    required this.done,
    required this.isProcessing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 17)),
        Expanded(
          flex: 1,
          child: Center(
            child: ClipRRect(
              borderRadius:
                  ResponsiveConstants.getRelativeBorderRadius(context, 12),
              child: Image.file(File(capturedImage.path), fit: BoxFit.cover),
            ),
          ),
        ),
        SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 13)),
        Container(
          color: blackColor.withAlpha((0.2 * 255).toInt()),
          padding: EdgeInsets.only(
            bottom: ResponsiveConstants.getRelativeHeight(context, 21),
          ),
          width: double.infinity,
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedAppButton(
                  text: translate('retake'),
                  onPressed: isProcessing ? null : retake,
                  textColor: backgroundColor,
                ),
                Container(
                  width: 1,
                  height: ResponsiveConstants.getRelativeHeight(context, 42),
                  color: whiteColor,
                ),
                OutlinedAppButton(
                  text: translate('done'),
                  onPressed: isProcessing ? null : done,
                  textColor: backgroundColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
