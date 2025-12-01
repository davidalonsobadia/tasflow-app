import 'package:flutter/material.dart';
import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/config/themes/theme_config.dart';
import 'package:flutter_translate/flutter_translate.dart';

class LoadingOverlay {
  OverlayEntry? _overlayEntry;
  bool _isVisible = false;

  // Private constructor for singleton pattern
  LoadingOverlay._privateConstructor();

  // Singleton instance
  static final LoadingOverlay _instance = LoadingOverlay._privateConstructor();

  // Factory constructor to return instance
  factory LoadingOverlay() {
    return _instance;
  }

  void show(BuildContext context, {String? message}) {
    message ?? translate('processing');
    if (_isVisible) return; // Don't show multiple overlays

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Material(
            color: overlayColor, // Semi-transparent background
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveConstants.getRelativeWidth(context, 24),
                  vertical: ResponsiveConstants.getRelativeHeight(context, 16),
                ),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(AppRadius.radiusLg),
                  border: Border.all(color: borderColor, width: 1),
                  boxShadow: AppShadows.shadowLg,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: primaryColor),
                    SizedBox(
                      height:
                          ResponsiveConstants.getRelativeHeight(context, 16),
                    ),
                    Text(
                      message!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: foregroundColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _isVisible = true;
  }

  void hide() {
    if (!_isVisible) return;

    _overlayEntry?.remove();
    _overlayEntry = null;
    _isVisible = false;
  }

  // Convenience method for handling futures
  Future<T> during<T>(
    BuildContext context,
    Future<T> future, {
    String? message,
  }) async {
    message ?? translate('processing');
    show(context, message: message);
    try {
      final result = await future;
      hide();
      return result;
    } catch (e) {
      hide();
      rethrow;
    }
  }
}
