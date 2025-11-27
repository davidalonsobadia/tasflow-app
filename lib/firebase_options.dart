// Firebase Options for Taskflow App
// NOTE: This file contains placeholder values. Update with real values once
// Firebase project is created and configured.
//
// To configure Firebase:
// 1. Create a Firebase project at https://console.firebase.google.com
// 2. Run: flutterfire configure
// 3. This file will be regenerated with correct values
// 4. Set firebaseEnabled = true in main.dart
// 5. Change MockCrashlyticsService to FirebaseCrashlyticsService in service_locator.dart
//
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // TODO: Replace with real Firebase configuration values
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: '1:XXXXXXXXXXXX:android:XXXXXXXXXXXXXXXX',
    messagingSenderId: 'XXXXXXXXXXXX',
    projectId: 'taskflow-app-XXXXX',
    storageBucket: 'taskflow-app-XXXXX.firebasestorage.app',
  );

  // TODO: Replace with real Firebase configuration values
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: '1:XXXXXXXXXXXX:ios:XXXXXXXXXXXXXXXX',
    messagingSenderId: 'XXXXXXXXXXXX',
    projectId: 'taskflow-app-XXXXX',
    storageBucket: 'taskflow-app-XXXXX.firebasestorage.app',
    iosBundleId: 'com.taskflow.app',
  );
}
