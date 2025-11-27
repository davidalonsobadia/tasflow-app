import 'dart:typed_data';
import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/core/utils/image_utils.dart';
import 'package:taskflow_app/features/images/domain/entities/image_entity.dart';
import 'package:flutter/material.dart';

class Thumbnail extends StatelessWidget {
  const Thumbnail({
    super.key,
    this.photo,
    this.imageEntity,
    this.onClose,
    this.onTap,
  });

  // Legacy support for Map-based photo data (deprecated)
  final Map<String, dynamic>? photo;
  // New preferred way using ImageEntity
  final ImageEntity? imageEntity;
  final VoidCallback? onClose;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ResponsiveConstants.getRelativeWidth(context, 90),
      height: ResponsiveConstants.getRelativeHeight(context, 90),
      decoration: BoxDecoration(
        color: onPrimaryColor,
        borderRadius: ResponsiveConstants.getRelativeBorderRadius(context, 12),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image should be below the close button
          GestureDetector(
            onTap: onTap,
            child: ClipRRect(
              borderRadius: ResponsiveConstants.getRelativeBorderRadius(context, 12),
              child: _buildImage(),
            ),
          ),
          // Close button should be on top of the image
          if (onClose != null)
            Positioned(
              top: ResponsiveConstants.getRelativeWidth(context, 5),
              right: ResponsiveConstants.getRelativeWidth(context, 5),
              child: GestureDetector(
                onTap: onClose,
                child: Container(
                  padding: EdgeInsets.all(
                    ResponsiveConstants.getRelativeWidth(context, 2),
                  ),
                  decoration: BoxDecoration(
                    color: blackColor.withAlpha(120),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: whiteColor,
                    size: ResponsiveConstants.getRelativeWidth(context, 20),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    // Prefer ImageEntity if available
    if (imageEntity != null) {
      if (imageEntity!.isUploading) {
        return ImageUtils.buildUploadingPlaceholder();
      }
      return ImageUtils.buildImageFromBinary(imageEntity!.imageData);
    }

    // Fallback to legacy Map-based photo data
    if (photo != null && photo!['base64'] != null) {
      return ImageUtils.buildImageFromBase64(photo!['base64']);
    }

    // Default placeholder
    return ImageUtils.buildImageFromBinary(Uint8List(0));
  }
}
