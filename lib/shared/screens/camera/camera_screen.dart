import 'dart:io' show Directory, File, Platform;

import 'package:camera/camera.dart';
import 'package:taskflow_app/core/utils/ui_utils.dart';
import 'package:taskflow_app/shared/screens/camera/camera_view.dart';
import 'package:taskflow_app/shared/screens/camera/captured_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen>
    with AutomaticKeepAliveClientMixin {
  CameraController? _cameraController;
  late List<CameraDescription> _cameras;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isCameraInitialized = false;
  bool _isCapturingImage = false;
  bool _isFlashOn = false;
  XFile? _capturedImage;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _requestPermission() async {
    const permission = Permission.camera;
    final status = await permission.status;

    print('Initial camera permission status: $status');

    if (!status.isGranted) {
      print('Requesting permissions to the user...');
      final result = await permission.request();
      print('Permission request result: $result');
    }
  }

  Future<bool> _isCameraPermissionGranted() async {
    const permission = Permission.camera;
    // Get fresh status instead of reusing previous check
    final status = await permission.status;
    print('Camera permission status check: $status');

    // On some devices, we need to check if it's limited or granted
    return status.isGranted || status.isLimited;
  }

  Future<void> _initCamera() async {
    await _requestPermission();
    final hasPermission = await _isCameraPermissionGranted();
    print('Has camera permission: $hasPermission');

    if (hasPermission) {
      try {
        _cameras = await availableCameras();
        if (_cameras.isEmpty) {
          print('No cameras available');
          if (mounted) {
            UIUtils.showErrorSnackBar(context, translate('noCameraAvailable'));
            context.pop();
          }
          return;
        }

        _cameraController = CameraController(
          _cameras[0],
          ResolutionPreset.max,
          enableAudio: false,
        );
        await _cameraController!
            .initialize()
            .then((_) {
              if (!mounted) {
                return;
              }
              setState(() {
                _isCameraInitialized = true;
              });
            })
            .catchError((error) {
              print('Error initializing camera: $error');
              if (mounted) {
                UIUtils.showErrorSnackBar(
                  context,
                  translate('errorInitializingCamera'),
                );
                context.pop();
              }
            });
        await _cameraController!.lockCaptureOrientation();
        await _cameraController!.setFlashMode(FlashMode.off);
      } catch (e) {
        print('Error initializing camera: $e');
        if (mounted) {
          UIUtils.showErrorSnackBar(
            context,
            translate('errorInitializingCamera'),
          );
          context.pop();
        }
      }
    } else {
      print('No camera permissions...');
      if (mounted) {
        UIUtils.showErrorSnackBar(
          context,
          translate('errorInitializingCamera'),
        );
        context.pop();
      }
    }
  }

  @override
  void dispose() {
    if (_cameraController != null) {
      _cameraController!.dispose();
    }
    super.dispose();
  }

  Future<void> _onCameraSwitch() async {
    setState(() {
      _isCameraInitialized = false;
    });

    final CameraDescription cameraDescription =
        (_cameraController!.description == _cameras[0])
            ? _cameras[1]
            : _cameras[0];

    await _cameraController?.dispose();

    _cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.max,
      enableAudio: false,
    );

    try {
      await _cameraController!.initialize();

      // Always ensure flash is off for front camera
      if (cameraDescription.lensDirection == CameraLensDirection.front) {
        _isFlashOn = false;
        await _cameraController!.setFlashMode(FlashMode.off);
      }

      await _cameraController!.lockCaptureOrientation();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      print('Error switching camera: $e');
    }
  }

  Future<XFile?> _captureImage() async {
    print('Capturing the Image...');
    XFile? imageFromCamera;

    if (!_cameraController!.value.isInitialized) {
      print('Controller was not initialized, so no Photo could be taken');
      return null;
    }

    try {
      SystemSound.play(SystemSoundType.click);
      final Directory extDir = await getApplicationDocumentsDirectory();
      final String dirPath = '${extDir.path}/media';
      await Directory(dirPath).create(recursive: true);

      imageFromCamera = await _cameraController!.takePicture();

      // Compress the image right after capture
      imageFromCamera = await _compressImage(imageFromCamera);

      // Handle image mirroring based on platform and camera direction
      if (_cameraController!.description.lensDirection ==
          CameraLensDirection.front) {
        if (Platform.isIOS ||
            (Platform.isAndroid && await _shouldMirrorAndroidFrontImage())) {
          final bytes = await imageFromCamera.readAsBytes();
          final image = img.decodeImage(bytes);
          if (image != null) {
            final flippedImage = img.flipHorizontal(image);
            final tempDir = await getTemporaryDirectory();
            final tempPath =
                '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
            File(
              tempPath,
            ).writeAsBytesSync(img.encodeJpg(flippedImage, quality: 70));
            imageFromCamera = XFile(tempPath);
          }
        }
      }

      // Reset flash after capture
      if (_cameraController!.description.lensDirection ==
          CameraLensDirection.front) {
        await _cameraController!.setFlashMode(FlashMode.off);
        setState(() {
          _isFlashOn = false;
        });
      }
    } catch (e) {
      print('Error capturing image: $e');
      if (mounted) {
        UIUtils.showErrorSnackBar(context, translate('errorCapturingImage'));
      }
    }

    return imageFromCamera;
  }

  Future<XFile> _compressImage(XFile originalImage) async {
    try {
      final bytes = await originalImage.readAsBytes();
      final originalSize = bytes.length;

      final image = img.decodeImage(bytes);
      if (image != null) {
        // Resize if too large (max 1920px width)
        final resizedImage =
            image.width > 1920 ? img.copyResize(image, width: 1920) : image;

        // Compress as JPEG with 70% quality
        final compressedBytes = img.encodeJpg(resizedImage, quality: 70);

        // Save compressed image to new file
        final tempDir = await getTemporaryDirectory();
        final compressedPath =
            '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';
        await File(compressedPath).writeAsBytes(compressedBytes);

        print(
          '📷 Image compressed: ${(originalSize / 1024 / 1024).toStringAsFixed(2)} MB → ${(compressedBytes.length / 1024 / 1024).toStringAsFixed(2)} MB',
        );

        return XFile(compressedPath);
      }
    } catch (e) {
      print('Image compression failed: $e');
    }

    // Return original if compression fails
    return originalImage;
  }

  Future<void> handleImage() async {
    XFile? imageFile = await _captureImage();
    if (imageFile != null) {
      setState(() {
        _capturedImage = imageFile;
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? imageFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85, // Compress image to reduce file size
      );

      if (imageFile != null) {
        // Return to previous screen with the selected image data
        final newPhoto = {'path': imageFile.path};
        if (mounted) {
          context.pop(newPhoto);
        }
      }
    } catch (e) {
      print('Error picking image from gallery: $e');
      if (mounted) {
        UIUtils.showErrorSnackBar(context, translate('errorSelectingImage'));
      }
    }
  }

  // Helper method to check if Android front camera image needs mirroring
  Future<bool> _shouldMirrorAndroidFrontImage() async {
    try {
      final String manufacturer =
          (await _getDeviceManufacturer()).toLowerCase();
      final String model = (await _getDeviceModel()).toLowerCase();

      // Manufacturers that typically need mirroring
      final needsMirroringManufacturers = [
        'samsung', // Most Samsung devices need mirroring
        'huawei', // Huawei devices typically need mirroring
        'xiaomi', // Many Xiaomi devices need mirroring
        'oppo', // OPPO devices often need mirroring
        'vivo', // Vivo devices typically need mirroring
        'oneplus', // OnePlus devices often need mirroring
        'realme', // Realme devices typically need mirroring
      ];

      // Manufacturers that typically don't need mirroring
      final noMirroringManufacturers = [
        'google', // Pixel devices typically don't need mirroring
        'motorola', // Motorola devices usually don't need mirroring
        'nokia', // Nokia devices usually don't need mirroring
      ];

      // Specific model exceptions (where the manufacturer's general rule doesn't apply)
      final specificModelExceptions = {
        // Format: 'manufacturer:model': shouldMirror
        'samsung:sm-f700':
            false, // Samsung Fold devices might not need mirroring
        'google:pixel 6': true, // Some newer Pixels might need mirroring
        // Add more exceptions as you discover them
      };

      // Check for specific model exceptions first
      final deviceIdentifier = '$manufacturer:$model';
      if (specificModelExceptions.containsKey(deviceIdentifier)) {
        return specificModelExceptions[deviceIdentifier]!;
      }

      // Log device info for debugging
      print('Android device info - Manufacturer: $manufacturer, Model: $model');

      // Check manufacturer lists
      if (needsMirroringManufacturers.any(
        (mfr) => manufacturer.contains(mfr),
      )) {
        return true;
      }
      if (noMirroringManufacturers.any((mfr) => manufacturer.contains(mfr))) {
        return false;
      }

      // Default behavior: mirror the image
      // It's better to mirror by default as it's the more common expectation
      return true;
    } catch (e) {
      print('Error checking device info: $e');
      return true; // Default to mirroring on error
    }
  }

  // Helper method to get clean manufacturer name
  Future<String> _getDeviceManufacturer() async {
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.manufacturer.trim().toLowerCase();
    }
    return '';
  }

  // Helper method to get clean model name
  Future<String> _getDeviceModel() async {
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.model.trim().toLowerCase();
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (!_isCameraInitialized) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        body: const Center(
          child: SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black12,
      key: _scaffoldKey,
      extendBody: true,
      body: SafeArea(
        child:
            _capturedImage == null
                ? CameraView(
                  cameraController: _cameraController!,
                  onFlashIcon: () {
                    // Disable flash toggle for front camera
                    if (_cameraController?.description.lensDirection ==
                        CameraLensDirection.front) {
                      UIUtils.showErrorSnackBar(
                        context,
                        translate('flashNotAvailableForFrontCamera'),
                      );
                      return;
                    }

                    if (_isFlashOn) {
                      _cameraController?.setFlashMode(FlashMode.off);
                    } else {
                      _cameraController?.setFlashMode(FlashMode.always);
                    }
                    setState(() {
                      _isFlashOn = !_isFlashOn;
                    });
                  },
                  onPhotoIcon: () async {
                    setState(() {
                      _isCapturingImage = true;
                    });
                    await handleImage();
                    setState(() {
                      _isCapturingImage = false;
                    });
                  },
                  onCameraSwitchIcon: () {
                    _onCameraSwitch();
                  },
                  onGalleryIcon: () {
                    _pickImageFromGallery();
                  },
                  isFlashOn: _isFlashOn,
                  isCapturingImage: _isCapturingImage,
                )
                : CapturedImageView(
                  capturedImage: _capturedImage!,
                  isProcessing: _isProcessing,
                  retake: () {
                    setState(() {
                      _isProcessing = true;
                    });
                    setState(() {
                      _capturedImage = null;
                    });
                    setState(() {
                      _isProcessing = false;
                    });
                  },
                  done: () async {
                    setState(() {
                      _isProcessing = true;
                    });

                    // Create a photo object with the captured image path
                    final newPhoto = {'path': _capturedImage!.path};

                    // Return to previous screen with the new photo data
                    if (mounted) {
                      context.pop(newPhoto);
                    }

                    setState(() {
                      _isProcessing = false;
                    });
                  },
                ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
