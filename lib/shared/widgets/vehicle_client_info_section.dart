import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/shared/widgets/card_container.dart';
import 'package:taskflow_app/shared/widgets/vehicle_client_info_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class VehicleClientInfoSection extends StatelessWidget {
  final VoidCallback? onScanQrTap;
  final VoidCallback? onManualEntryTap;

  const VehicleClientInfoSection({
    super.key,
    this.onScanQrTap,
    this.onManualEntryTap,
  });

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      margin: EdgeInsets.only(
        bottom: ResponsiveConstants.getRelativeHeight(context, 10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            translate('searchTask'),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
          SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 16)),
          VehicleClientInfoContent(
            onScanQrTap: onScanQrTap,
            onManualEntryTap: onManualEntryTap,
          ),
        ],
      ),
    );
  }
}
