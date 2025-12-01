import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/core/utils/image_utils.dart';
import 'package:flutter/material.dart';

class ThumbnailUploading extends StatelessWidget {
  const ThumbnailUploading({super.key, required this.photo});

  final Map<String, dynamic> photo;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ResponsiveConstants.getRelativeWidth(context, 90),
      height: ResponsiveConstants.getRelativeHeight(context, 90),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius:
            ResponsiveConstants.getRelativeBorderRadius(context, 12),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: () {},
            child: ClipRRect(
              borderRadius:
                  ResponsiveConstants.getRelativeBorderRadius(context, 12),
              child: _buildImage(photo['base64']),
            ),
          ),
          // Image should be with a blurry grey (indicating it is loading)
          Container(
            decoration: BoxDecoration(
              color: mutedColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
          ),

          // Loading indicator
          Center(
            child: CircularProgressIndicator(
              strokeWidth: 3.5,
              color: foregroundColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String base64Image) {
    return ImageUtils.buildImageFromBase64(base64Image);
  }
}
