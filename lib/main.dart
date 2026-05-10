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

class TripHistoryItem {
  final String from;
  final String to;
  final String line;
  final DateTime date;

  const TripHistoryItem({
    required this.from,
    required this.to,
    required this.line,
    required this.date,
  });
}

abstract class BanHopsAppController {
  Locale? get currentLocale;
  void setLocale(Locale locale);
}

class BanHopsApp extends StatefulWidget {
  const BanHopsApp({super.key});

  @override
  State<BanHopsApp> createState() => _BanHopsAppState();

  static BanHopsAppController? of(BuildContext context) =>
      context.findAncestorStateOfType<_BanHopsAppState>();
}

enum _AppStage { languageSelection, loading, ready }

class _BanHopsAppState extends State<BanHopsApp>
    implements BanHopsAppController {
  Locale? _locale;
  _AppStage _stage = _AppStage.languageSelection;

  @override
  Locale? get currentLocale => _locale;

  @override
  void setLocale(Locale locale) => setState(() => _locale = locale);

  void _onLanguageSelected(Locale locale) {
    setState(() {
      _locale = locale;
      _stage = _AppStage.loading;
    });
  }

  void _onLoadingComplete() => setState(() => _stage = _AppStage.ready);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BanHops',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.light, // ✅ يمنع dark mode من يأثر على الشاشات
      themeMode: ThemeMode.light, // ✅ دايماً light theme للتطبيق كله
      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: _buildHome(),
    );
  }

  Widget _buildHome() {
    switch (_stage) {
      case _AppStage.languageSelection:
        return LanguageSelectionScreen(
          onLanguageSelected: _onLanguageSelected,
        );
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
                    onSignUpSuccess: () => Navigator.of(ctx).pop(),
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
  const _MainShell();

  @override
  State<_MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<_MainShell> {
  NavTab _tab = NavTab.home;

  final List<TripHistoryItem> _tripHistory = [];

  void _addTrip(String from, String to, String line) {
    setState(() {
      _tripHistory.insert(
        0,
        TripHistoryItem(
          from: from,
          to: to,
          line: line,
          date: DateTime.now(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_tab) {
      case NavTab.home:
        return Builder(
          builder: (ctx) => HomeScreen(
            onNavigate: (t) => setState(() => _tab = t),
            onShowRouteDetails: (from, to) {
              _addTrip(from, to, 'Line 1');

              // ✅ PageRouteBuilder عشان اللون الداكن للـ RouteDetailsScreen
              // ميتسربش للـ HomeScreen أو أي شاشة تانية
              Navigator.of(ctx).push(
                PageRouteBuilder(
                  opaque: true,
                  pageBuilder: (_, __, ___) => RouteDetailsScreen(
                    from: from,
                    to: to,
                    onBack: () => Navigator.of(ctx).pop(),
                    onOpenChat: () {
                      Navigator.of(ctx).pop();
                      setState(() => _tab = NavTab.chat);
                    },
                  ),
                  // ✅ Slide من تحت لفوق — أحلى من الـ default fade
                  transitionsBuilder:
                      (_, animation, __, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      )
                          .chain(CurveTween(curve: Curves.easeOutCubic))
                          .animate(animation),
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 400),
                  reverseTransitionDuration:
                  const Duration(milliseconds: 300),
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
          trips: _tripHistory,
          onClearHistory: () => setState(() => _tripHistory.clear()),
        );

      case NavTab.profile:
        return Builder(
          builder: (ctx) => ProfileScreen(
            onNavigate: (t) => setState(() => _tab = t),
            tripCount: _tripHistory.length,
            locale: Localizations.localeOf(ctx).languageCode,
            onOpenLanguageSettings: () {
              final app = BanHopsApp.of(ctx);
              Navigator.of(ctx).push(
                MaterialPageRoute(
                  builder: (_) => LanguageSettingsScreen(
                    current: app?.currentLocale ?? const Locale('en'),
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