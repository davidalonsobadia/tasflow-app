# Taskflow App

A Flutter application for task management with scanning capabilities.

## Environment Setup

### Prerequisites
- Flutter SDK (^3.7.2)
- Dart SDK (^3.7.2)
- Android Studio / Xcode for mobile development

### Configuration
1. Copy `assets/config/conf.sample.json` to `assets/config/conf.json`
2. Update the configuration values with your API credentials

## Running the App

### Development Environment
```bash
# Run the app in development mode
flutter run --flavor dev -t lib/main.dart

# Build for specific platforms in development
flutter build apk --flavor dev
flutter build ios --flavor dev
```

### Production Environment
```bash
# Run the app in production mode
flutter run --flavor prod -t lib/main.dart

# Build for specific platforms in production
flutter build apk --flavor prod
flutter build ios --flavor prod
```

### Web Support
```bash
# Enable web support if needed
flutter config --enable-web

# Run on Chrome
flutter run -d chrome

# Build for web deployment
flutter build web
```

## Project Structure
- `lib/` - Application source code
- `assets/` - Images, fonts, translations, and configuration
- `android/` - Android-specific configuration
- `ios/` - iOS-specific configuration

## Features
- Product scanning and management
- Multilingual support (Spanish default)
- Camera integration
- QR/Barcode scanning

## Dependencies
- State management: flutter_bloc
- Routing: go_router
- Networking: dio, http
- Localization: flutter_translate
- Scanning: mobile_scanner
- Device info: device_info_plus

## Building for Release
See [Flutter deployment documentation](https://docs.flutter.dev/deployment) for platform-specific release instructions.
