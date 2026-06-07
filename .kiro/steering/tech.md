# BanHops Tech Stack

## Framework & Language

- **Flutter**: >=3.10.0
- **Dart SDK**: >=3.0.0 <4.0.0
- **Material Design**: Material 3 (useMaterial3: true)

## Dependencies

### Core Flutter
- `flutter`: SDK
- `flutter_localizations`: SDK (for i18n support)

### State Management & Storage
- `shared_preferences`: ^2.3.0 - Local data persistence for routes, user preferences

### Networking & API
- `http`: ^1.1.0 - HTTP client for API calls
- `url_launcher`: ^6.2.5 - Opening external URLs (maps, links)

### Localization
- `intl`: any - Internationalization and formatting
- Flutter's built-in l10n generator (`flutter gen-l10n`)

### UI
- `cupertino_icons`: ^1.0.6 - iOS-style icons

## Development Tools

- `flutter_test`: SDK - Testing framework
- `flutter_lints`: ^3.0.0 - Dart linting rules

## Build System

Flutter uses its standard build system with the following configurations:

### Material Design
```yaml
flutter:
  uses-material-design: true
  generate: true  # Enables automatic l10n code generation
```

### Assets
- Images located in `assets/images/`

## Common Commands

### Setup
```bash
# Initial setup (if needed)
flutter create . --project-name ban_hops --platforms=android,ios

# Install dependencies
flutter pub get

# Generate localization files
flutter gen-l10n
```

### Development
```bash
# Run app in debug mode
flutter run

# Run on specific device
flutter run -d <device-id>

# Hot reload (press 'r' in terminal while app is running)
# Hot restart (press 'R' in terminal while app is running)
```

### Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run tests with coverage
flutter test --coverage
```

### Code Quality
```bash
# Analyze code for issues
flutter analyze

# Format code
flutter format .

# Format specific file
flutter format lib/main.dart
```

### Build
```bash
# Build APK (Android)
flutter build apk

# Build App Bundle (Android)
flutter build appbundle

# Build iOS (requires macOS)
flutter build ios
```

### Localization
```bash
# Regenerate localization files after updating .arb files
flutter gen-l10n
```

## Platform Support

- **Android**: Primary platform
- **iOS**: Configured but not primary focus
- **Web/Desktop**: Not configured

## Development Environment

- Requires Android SDK for Android builds
- Requires Xcode for iOS builds (macOS only)
- IDE support: Android Studio, VS Code, IntelliJ IDEA
