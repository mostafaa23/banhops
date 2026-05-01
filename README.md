# BanHops (Flutter)

Flutter port of the BanHops smart transportation app.

## Setup

```bash
cd flutter_app/ban_hops
flutter create . --project-name ban_hops --platforms=android,ios
flutter pub get
flutter gen-l10n
flutter run
```

## Notes

- Primary color: `#4A90E2`
- Localization: English + Arabic with full RTL support (handled automatically by `MaterialApp` via `Locale('ar')`).
- Add the logo image at `assets/images/logo.png` (the loading screen falls back to an icon if missing).

## Progress

- [x] `main.dart` + theme + LoadingScreen
- [ ] LanguageSelection
- [ ] SignIn / SignUp / ForgotPassword
- [ ] Home / RouteDetails
- [ ] TrainLines / History / Profile / LanguageSettings
- [ ] Chat
