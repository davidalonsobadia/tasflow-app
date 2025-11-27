import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'dart:math';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:mobile_device_identifier/mobile_device_identifier.dart';

class DeviceUtils {
  static Future<String> getDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String rawId;

    if (Platform.isAndroid) {
      final mobileDeviceIdentifier = await MobileDeviceIdentifier().getDeviceId();
      if (mobileDeviceIdentifier != null) {
        rawId = mobileDeviceIdentifier;
      } else {
        throw Exception(translate('failedToGetDeviceIdAndroid'));
      }
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      if (iosInfo.identifierForVendor != null) {
        rawId = iosInfo.identifierForVendor!;
      } else {
        throw Exception(translate('failedToGetDeviceIdiOS'));
      }
    } else {
      throw UnsupportedError('Unsupported platform');
    }

    // Hash the device ID
    return sha256.convert(utf8.encode(rawId)).toString();
  }

  /// Generates a random string of specified length
  static String getRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    return String.fromCharCodes(List.generate(length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }
}
