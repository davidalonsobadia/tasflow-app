import 'dart:convert';
import 'dart:typed_data';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ImageUtils {
  /// Build image widget from binary data (new preferred method)
  static Widget buildImageFromBinary(
    Uint8List imageData, {
    BoxFit fit = BoxFit.cover,
  }) {
    if (imageData.isEmpty) {
      return SvgPicture.asset('assets/images/placeholder.svg', fit: fit);
    }
    try {
      return Image.memory(
        imageData,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          print('Error loading image: $error');
          return SvgPicture.asset('assets/images/placeholder.svg', fit: fit);
        },
      );
    } catch (e) {
      print('Error displaying image: $e');
      return SvgPicture.asset('assets/images/placeholder.svg', fit: fit);
    }
  }

  /// Build placeholder for uploading images
  static Widget buildUploadingPlaceholder({BoxFit fit = BoxFit.cover}) {
    return Container(
      color: onPrimaryColor,
      width: double.infinity,
      height: double.infinity,
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  /// Legacy method for backward compatibility (deprecated)
  @Deprecated(
    'Use buildImageFromBinary instead. This will be removed in a future version.',
  )
  static Widget buildImageFromBase64(
    String base64Image, {
    BoxFit fit = BoxFit.cover,
  }) {
    if (base64Image == 'GREY_PLACEHOLDER') {
      return buildUploadingPlaceholder(fit: fit);
    }
    if (base64Image.isEmpty) {
      return SvgPicture.asset('assets/images/placeholder.svg', fit: fit);
    }
    try {
      return Image.memory(
        base64Decode(base64Image),
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          print('Error loading image: $error');
          return SvgPicture.asset('assets/images/placeholder.svg', fit: fit);
        },
      );
    } catch (e) {
      print('Error decoding image: $e');
      return SvgPicture.asset('assets/images/placeholder.svg', fit: fit);
    }
  }
}
