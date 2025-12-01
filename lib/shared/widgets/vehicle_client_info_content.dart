import 'package:dotted_border/dotted_border.dart';
import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class VehicleClientInfoContent extends StatelessWidget {
  final VoidCallback? onScanQrTap;
  final VoidCallback? onManualEntryTap;
  final String? errorMessage;

  const VehicleClientInfoContent({
    super.key,
    this.onScanQrTap,
    this.onManualEntryTap,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onScanQrTap,
          child: DottedBorder(
            borderType: BorderType.RRect,
            radius: Radius.circular(
              ResponsiveConstants.getRelativeWidth(context, 8),
            ),
            color: borderColor,
            child: Padding(
              padding: EdgeInsets.all(
                ResponsiveConstants.getRelativeWidth(context, 24),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.qr_code_outlined,
                    color: foregroundColor,
                    size: ResponsiveConstants.getRelativeWidth(context, 24),
                  ),
                  SizedBox(
                    width: ResponsiveConstants.getRelativeWidth(context, 10),
                  ),
                  Text(
                    translate('scanQrCode'),
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: foregroundColor),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 12)),
        SizedBox(
          width: double.infinity,
          child: Text(
            translate('or'),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: mutedForegroundColor),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 12)),
        GestureDetector(
          onTap: onManualEntryTap,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius:
                  ResponsiveConstants.getRelativeBorderRadius(context, 8),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: ResponsiveConstants.getRelativeHeight(context, 16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.keyboard,
                    color: mutedForegroundColor,
                    size: ResponsiveConstants.getRelativeWidth(context, 24),
                  ),
                  SizedBox(
                    width: ResponsiveConstants.getRelativeWidth(context, 10),
                  ),
                  Text(
                    translate('enterManually'),
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: foregroundColor),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (errorMessage != null) ...[
          SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 8)),
          Text(
            errorMessage!,
            style: TextStyle(color: destructiveColor, fontSize: 12),
          ),
        ],
        SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 16)),
      ],
    );
  }
}
