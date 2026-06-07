# BanHops Project Structure

## Directory Organization

```
ban_hops/
├── lib/                      # Main application code
│   ├── l10n/                 # Localization files
│   ├── screens/              # UI screens/pages
│   ├── services/             # Business logic & data services
│   ├── theme/                # App theming (colors, styles)
│   ├── utils/                # Utility functions & helpers
│   ├── widgets/              # Reusable UI components
│   └── main.dart             # App entry point
├── assets/
│   └── images/               # Image assets (logo, etc.)
├── test/                     # Test files
├── android/                  # Android-specific configuration
├── ios/                      # iOS-specific configuration
└── .kiro/                    # Kiro AI workspace configuration
    └── steering/             # AI assistant guidance rules
```

## Code Organization Patterns

### Screens (`lib/screens/`)
Each screen is a self-contained file representing a full page:
- `loading_screen.dart` - Initial app loading
- `language_selection_screen.dart` - Language picker
- `signin_screen.dart`, `signup_screen.dart`, `forgot_password_screen.dart` - Authentication
- `home_screen.dart` - Main dashboard with route search
- `route_details_screen.dart` - Detailed route instructions
- `train_lines_screen.dart` - Interactive train line visualization with multiple routes to Banha:
  - Cairo/Giza — Benha Line
  - Alexandria/Sidi Gaber — Benha Line
  - Damietta/Mansoura — Benha Line
  - Central Delta & Menoufia — Benha Line
  - Canal & Sharqia — Benha Line
  - Upper Egypt — Benha Line
- `history_screen.dart` - Trip history
- `profile_screen.dart` - User profile & settings
- `smart_chat_screen.dart`, `chat_screen.dart` - AI assistant chat
- `language_settings_screen.dart` - Language preferences

**Screen Conventions:**
- Stateless or StatefulWidget depending on needs
- Accept callback parameters for navigation (`onBack`, `onNavigate`, `onSuccess`)
- Use `AppLocalizations.of(context)` for translated strings
- Consistent use of AppTheme colors and styles

### Services (`lib/services/`)
Business logic and data management:
- `route_database.dart` - Route data storage & retrieval with SharedPreferences
- `history_service.dart` - Trip history management
- `signup_service.dart` - User registration logic
- `groq_service.dart` - AI chat API integration

**Service Conventions:**
- Singleton pattern or stateless service classes
- Async/await for asynchronous operations
- JSON serialization with `toJson()` and `fromJson()` factories
- Use `SharedPreferences` for local persistence

### Theme (`lib/theme/`)
- `app_theme.dart` - Centralized theming
  - `AppColors` class with const color definitions
  - `AppTheme.light` - Default light theme for entire app
  - `AppTheme.dark` - Dark theme (only for RouteDetailsScreen)

**Theme Conventions:**
- Always use `AppColors.*` constants, never hardcoded colors
- Primary color: `#4A90E2`
- Use Material 3 components
- Maintain consistent spacing and border radius (typically 12px)

### Widgets (`lib/widgets/`)
Reusable UI components:
- `bottom_nav_bar.dart` - App navigation bar

**Widget Conventions:**
- Extract reusable components into widgets
- Use const constructors where possible for performance
- Accept required styling parameters, provide sensible defaults

### Utilities (`lib/utils/`)
Helper functions and shared logic:
- `itinerary_builder.dart` - Route itinerary construction

### Localization (`lib/l10n/`)
- `app_en.arb` - English translations (source)
- `app_ar.arb` - Arabic translations
- `app_localizations*.dart` - Auto-generated (don't edit manually)

**Localization Conventions:**
- Never hardcode user-facing strings
- Always use `AppLocalizations.of(context)!.key`
- Add new keys to both `.arb` files
- Run `flutter gen-l10n` after updating `.arb` files
- Use descriptive key names (e.g., `usernameRequired` not `err1`)

## Naming Conventions

### Files
- Snake_case for all Dart files: `route_details_screen.dart`
- Match class name to file name: `RouteDetailsScreen` → `route_details_screen.dart`

### Classes & Types
- PascalCase: `BanHopsRoute`, `RouteDatabase`, `AppTheme`
- Prefix private classes with underscore: `_MainShellState`

### Variables & Functions
- camelCase: `onNavigate`, `tripHistory`, `currentLocale`
- Private members with underscore: `_initialized`, `_norm()`

### Constants
- camelCase for static const: `AppColors.primary`
- UPPER_SNAKE_CASE for top-level const: `_SEED_ROUTES` (rare)

## State Management

Currently using **built-in Flutter state management**:
- `StatefulWidget` with `setState()` for local state
- Callbacks (`onNavigate`, `onSuccess`) for parent-child communication
- `InheritedWidget` pattern via `BanHopsApp.of(context)` for app-level state (locale)

**State Patterns:**
- Screen-level state in `State<T>` classes
- App-level state in `_BanHopsAppState` (language, auth stage)
- Service-level state in service classes (RouteDatabase, HistoryService)

## Navigation

Using **imperative navigation** with `Navigator.push/pop`:
- `Navigator.push()` for forward navigation
- `Navigator.pushReplacement()` for auth flows
- `Navigator.pop()` to go back
- No named routes currently

**Navigation Pattern:**
```dart
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (_) => TargetScreen(
      onBack: () => Navigator.of(context).pop(),
    ),
  ),
);
```

## Data Models

Models as immutable classes with:
- `const` constructors
- `factory` constructors for `fromJson`
- `toJson()` methods for serialization
- Computed properties (getters) for derived data
- `copyWith()` methods for updates

Example: `BanHopsRoute`, `RouteStep`

## Code Style

Following Flutter/Dart conventions:
- Use `flutter_lints` rules
- Prefer `const` constructors
- Use trailing commas for better formatting
- Null safety enabled (`<4.0.0`)
- Prefer `final` over `var`
- Use meaningful variable names
- Add comments for complex logic (especially Arabic language normalization)

## Common Patterns

### Screen Callbacks
Screens use callbacks for coordination:
```dart
HomeScreen(
  onNavigate: (tab) => setState(() => _tab = tab),
  onShowDetails: (from, to) { /* ... */ },
)
```

### Localization
```dart
final l10n = AppLocalizations.of(context)!;
Text(l10n.signIn)
```

### Async Initialization
```dart
@override
void initState() {
  super.initState();
  _initAsync();
}

Future<void> _initAsync() async {
  await service.init();
  if (mounted) setState(() => _loaded = true);
}
```

## Testing Structure

- Test files mirror source structure in `test/` directory
- Use `flutter_test` package
- Widget tests for UI components
- Unit tests for services and utilities

## Build Artifacts

Generated/build files (not in git):
- `.dart_tool/` - Dart build cache
- `build/` - Flutter build outputs
- `lib/l10n/app_localizations*.dart` - Generated localization code
