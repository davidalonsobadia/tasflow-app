import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/shared/widgets/comments/comments_section.dart';
import 'package:taskflow_app/shared/widgets/custom_app_bar.dart';
import 'package:taskflow_app/shared/widgets/images/attachments_section.dart';
import 'package:taskflow_app/shared/widgets/products/products_section.dart';
import 'package:taskflow_app/shared/widgets/vehicle_client_info_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: CustomAppBar(title: translate('newTask')),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveConstants.getRelativeWidth(context, 24),
        ),
        child: Column(
          children: [
            SizedBox(
              height: ResponsiveConstants.getRelativeHeight(context, 12),
            ),
            VehicleClientInfoSection(
              onScanQrTap: () {
                // Handle QR code scanning
              },
              onManualEntryTap: () {
                // Handle manual entry
              },
            ),
            SizedBox(
              height: ResponsiveConstants.getRelativeHeight(context, 30),
            ),
            ProductsSection(
              taskId: '',
              onDelete: (systemId) {},
              locationCode: '',
            ),
            SizedBox(
              height: ResponsiveConstants.getRelativeHeight(context, 30),
            ),
            AttachmentsSection(taskId: ''),
            SizedBox(
              height: ResponsiveConstants.getRelativeHeight(context, 30),
            ),
            CommentsSection(taskId: ''),
            SizedBox(
              height: ResponsiveConstants.getRelativeHeight(context, 30),
            ),
          ],
        ),
      ),
    );
  }
}
