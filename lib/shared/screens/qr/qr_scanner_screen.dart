import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController _qrController = MobileScannerController();
  bool _isFlashOn = false;
  bool _hasDetectedCode = false; // Add this flag

  @override
  void dispose() {
    _qrController.dispose();
    super.dispose();
  }

  void _onQrDetect(BarcodeCapture capture) {
    // Prevent multiple detections
    if (_hasDetectedCode) return;
    final List<Barcode> barcodes = capture.barcodes;

    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        // Set flag to prevent multiple detections
        setState(() {
          _hasDetectedCode = true;
        });
        // Return the QR data and close the scanner screen
        print('QR code detected: ${barcode.rawValue}');
        context.pop({'qrData': barcode.rawValue});
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Building QR scanner screen');
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Top controls
            Container(
              padding: EdgeInsets.symmetric(
                vertical: ResponsiveConstants.getRelativeHeight(context, 4),
                horizontal: ResponsiveConstants.getRelativeWidth(context, 30),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (_isFlashOn) {
                        _qrController.toggleTorch();
                      } else {
                        _qrController.toggleTorch();
                      }
                      setState(() {
                        _isFlashOn = !_isFlashOn;
                      });
                    },
                    icon: Icon(
                      _isFlashOn
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

            // QR Scanner view
            Expanded(
              flex: 1,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius:
                        ResponsiveConstants.getRelativeBorderRadius(context, 12),
                    child: MobileScanner(
                      controller: _qrController,
                      onDetect: _onQrDetect,
                    ),
                  ),
                  // Scanning area indicator
                  Container(
                    width: ResponsiveConstants.getRelativeWidth(context, 250),
                    height: ResponsiveConstants.getRelativeWidth(context, 250),
                    decoration: BoxDecoration(
                      border: Border.all(color: backgroundColor, width: 2),
                      borderRadius:
                          ResponsiveConstants.getRelativeBorderRadius(context, 12),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom section with instructions
            Container(
              color: Colors.black12,
              padding: EdgeInsets.only(
                bottom: ResponsiveConstants.getRelativeHeight(context, 20),
                top: ResponsiveConstants.getRelativeHeight(context, 20),
              ),
              width: double.infinity,
              child: Column(
                children: [
                  Text(
                    translate('scanQrCode'),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: primaryForegroundColor,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: ResponsiveConstants.getRelativeHeight(context, 8),
                  ),
                  Text(
                    translate('positionQrCodeWithinFrame'),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: primaryForegroundColor.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
