import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'theme/app_theme.dart';
import 'screens/loading_screen.dart';
import 'screens/language_selection_screen.dart';
import 'screens/signin_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/home_screen.dart';
import 'screens/train_lines_screen.dart';
import 'screens/history_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/route_details_screen.dart';
import 'screens/language_settings_screen.dart';
import 'widgets/bottom_nav_bar.dart';

void main() {
  runApp(const BanHopsApp());
}

class BanHopsApp extends StatefulWidget {
  const BanHopsApp({super.key});

  @override
  State<BanHopsApp> createState() => _BanHopsAppState();

  static _BanHopsAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_BanHopsAppState>();
}

enum _AppStage { languageSelection, loading, ready }

class _BanHopsAppState extends State<BanHopsApp> {
  Locale? _locale;
  _AppStage _stage = _AppStage.languageSelection;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  void _onLanguageSelected(Locale locale) {
    setState(() {
      _locale = locale;
      _stage = _AppStage.loading;
    });
  }

  void _onLoadingComplete() {
    setState(() => _stage = _AppStage.ready);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BanHops',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: _buildHome(),
    );
  }

  Widget _buildHome() {
    switch (_stage) {
      case _AppStage.languageSelection:
        return LanguageSelectionScreen(onLanguageSelected: _onLanguageSelected);
      case _AppStage.loading:
        return LoadingScreen(onLoadingComplete: _onLoadingComplete);
      case _AppStage.ready:
        return Builder(
          builder: (ctx) => SignInScreen(
            onSignInSuccess: () {
              Navigator.of(ctx).pushReplacement(
                MaterialPageRoute(builder: (_) => const _MainShell()),
              );
            },
            onSignUpTap: () {
              Navigator.of(ctx).push(
                MaterialPageRoute(
                  builder: (_) => SignUpScreen(
                    onSignInTap: () => Navigator.of(ctx).pop(),
                    onSignUpSuccess: () {
                      Navigator.of(ctx).pop();
                    },
                  ),
                ),
              );
            },
            onForgotPasswordTap: () {
              Navigator.of(ctx).push(
                MaterialPageRoute(
                  builder: (_) => ForgotPasswordScreen(
                    onBack: () => Navigator.of(ctx).pop(),
                    onResetSuccess: () => Navigator.of(ctx).pop(),
                  ),
                ),
              );
            },
          ),
        );
    }
  }
}

class _MainShell extends StatefulWidget {
  const _MainShell({super.key});

  @override
  State<_MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<_MainShell> {
  NavTab _tab = NavTab.home;

  @override
  Widget build(BuildContext context) {
    switch (_tab) {
      case NavTab.home:
        return Builder(
          builder: (ctx) => HomeScreen(
            onNavigate: (t) => setState(() => _tab = t),
            onShowRouteDetails: (from, to) {
              Navigator.of(ctx).push(
                MaterialPageRoute(
                  builder: (_) => RouteDetailsScreen(
                    from: from,
                    to: to,
                    onBack: () => Navigator.of(ctx).pop(),
                    onOpenChat: () {
                      Navigator.of(ctx).pop();
                      setState(() => _tab = NavTab.chat);
                    },
                  ),
                ),
              );
            },
          ),
        );
      case NavTab.trainLines:
        return TrainLinesScreen(
          onNavigate: (t) => setState(() => _tab = t),
        );
      case NavTab.chat:
        return ChatScreen(
          onNavigate: (t) => setState(() => _tab = t),
        );
      case NavTab.history:
        return HistoryScreen(
          onNavigate: (t) => setState(() => _tab = t),
        );
      case NavTab.profile:
        return Builder(
          builder: (ctx) => ProfileScreen(
            onNavigate: (t) => setState(() => _tab = t),
            onOpenLanguageSettings: () {
              final app = BanHopsApp.of(ctx);
              Navigator.of(ctx).push(
                MaterialPageRoute(
                  builder: (_) => LanguageSettingsScreen(
                    current: app?._locale ?? const Locale('en'),
                    onBack: () => Navigator.of(ctx).pop(),
                    onApply: (locale) {
                      app?.setLocale(locale);
                      Navigator.of(ctx).pop();
                    },
                  ),
                ),
              );
            },
          ),
        );
    }
  }
}
