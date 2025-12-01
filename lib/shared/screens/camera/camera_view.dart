import 'package:camera/camera.dart';
import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CameraView extends StatelessWidget {
  final CameraController cameraController;
  final bool isFlashOn;
  final bool isCapturingImage;
  final Function() onFlashIcon;
  final Function() onPhotoIcon;
  final Function() onCameraSwitchIcon;
  final Function() onGalleryIcon;

  const CameraView({
    super.key,
    required this.cameraController,
    required this.onFlashIcon,
    required this.onPhotoIcon,
    required this.isFlashOn,
    required this.isCapturingImage,
    required this.onCameraSwitchIcon,
    required this.onGalleryIcon,
  });

  Widget cameraWidget(context) {
    return CameraPreview(cameraController);
  }

  @override
  Widget build(BuildContext context) {
    final bool isFrontCamera =
        cameraController.description.lensDirection == CameraLensDirection.front;

    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveConstants.getRelativeHeight(context, 4),
            horizontal: ResponsiveConstants.getRelativeWidth(context, 30),
          ),
          child: Row(
            children: [
              // Only show flash icon for back camera
              if (!isFrontCamera)
                IconButton(
                  onPressed: onFlashIcon,
                  icon: Icon(
                    isFlashOn
                        ? Icons.flash_on_outlined
                        : Icons.flash_off_outlined,
                    size: ResponsiveConstants.getRelativeHeight(context, 34),
                    color: primaryForegroundColor,
                  ),
                ),
              const Spacer(),
              IconButton(
                onPressed: () => context.pop(),
                icon: Icon(
                  Icons.close,
                  size: ResponsiveConstants.getRelativeHeight(context, 34),
                  color: primaryForegroundColor,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 8)),
        Expanded(
          flex: 1,
          child: Center(
            child: ClipRRect(
              borderRadius:
                  ResponsiveConstants.getRelativeBorderRadius(context, 12),
              child: cameraWidget(context),
            ),
          ),
        ),
        SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 12)),
        Container(
          color: Colors.black12,
          padding: EdgeInsets.only(
            bottom: ResponsiveConstants.getRelativeHeight(context, 20),
          ),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Gallery button on the left
              Expanded(
                flex: 1,
                child:
                    isCapturingImage
                        ? const SizedBox()
                        : IconButton(
                          icon: Icon(
                            Icons.photo_library_outlined,
                            color: Colors.white,
                            size: ResponsiveConstants.getRelativeHeight(
                              context,
                              30,
                            ),
                          ),
                          onPressed: onGalleryIcon,
                        ),
              ),
              // Camera capture button in the center
              SizedBox(
                height: ResponsiveConstants.getRelativeHeight(context, 63),
                width: ResponsiveConstants.getRelativeHeight(context, 63),
                child:
                    isCapturingImage
                        ? const CircularProgressIndicator(
                          color: backgroundColor,
                          strokeWidth: 3.5,
                        )
                        : CircleAvatar(
                          backgroundColor: backgroundColor,
                          radius: ResponsiveConstants.getRelativeHeight(
                            context,
                            34,
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.camera_alt,
                              size: ResponsiveConstants.getRelativeHeight(
                                context,
                                30,
                              ),
                              color: onBackgroundColor,
                            ),
                            onPressed: onPhotoIcon,
                          ),
                        ),
              ),
              // Camera switch button on the right
              Expanded(
                flex: 1,
                child:
                    isCapturingImage
                        ? const SizedBox()
                        : IconButton(
                          icon: Icon(
                            Icons.switch_camera,
                            color: Colors.white,
                            size: ResponsiveConstants.getRelativeHeight(
                              context,
                              30,
                            ),
                          ),
                          onPressed: onCameraSwitchIcon,
                        ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
