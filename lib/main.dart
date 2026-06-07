import 'package:flutter/material.dart';
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
import 'screens/smart_chat_screen.dart';
import 'screens/route_details_screen.dart';
import 'screens/language_settings_screen.dart';
import 'services/trip_history_service.dart';
import 'services/user_session.dart';
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
      darkTheme: AppTheme.light,
      themeMode: ThemeMode.light,
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
  String _currentUsername = 'guest';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final username = await UserSession.getUsername();
    setState(() => _currentUsername = username);
    await _loadTripsFromApi(username);
  }

  Future<void> _loadTripsFromApi(String username) async {
    try {
      final trips = await TripHistoryService.getHistory(username);
      // حفظ العدد في الـ session
      await UserSession.saveTripCount(trips.length);

      setState(() {
        _tripHistory.clear();
        for (final t in trips) {
          _tripHistory.add(TripHistoryItem(
            from: t['fromLocation'] ?? '',
            to: t['toLocation'] ?? '',
            line: t['lineName'] ?? '',
            date: DateTime.parse(t['date']),
          ));
        }
      });
    } catch (e) {
      print('Error loading trips: $e');
    }
  }

  // ✅ 1. تحديث متغيرات الـ State لاستيعاب بيانات تفاصيل الرحلة الجديدة بدلاً من _chatRouteType
  String? _chatFrom;
  String? _chatTo;
  String? _chatTransportMode;
  String? _chatCostMin;
  String? _chatCostMax;
  String? _chatTimeMin;
  String? _chatTimeMax;

  void _addTrip(String from, String to, String line) async {
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

    TripHistoryService.addTrip(
      username: _currentUsername,
      fromLocation: from,
      toLocation: to,
      lineName: line,
    );
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
              Navigator.of(ctx).push(
                MaterialPageRoute(
                  builder: (_) => RouteDetailsScreen(
                    from: from,
                    to: to,
                    onBack: () => Navigator.of(ctx).pop(),
                    // ✅ 2. تحديث الـ Callback ليستقبل الـ Named Parameters الممررة من RouteDetailsScreen وتخزينها
                    onOpenChat: ({
                      required String from,
                      required String to,
                      String? transportMode,
                      String? costMin,
                      String? costMax,
                      String? timeMin,
                      String? timeMax,
                    }) {
                      Navigator.of(ctx).pop();
                      setState(() {
                        _chatFrom = from;
                        _chatTo = to;
                        _chatTransportMode = transportMode;
                        _chatCostMin = costMin;
                        _chatCostMax = costMax;
                        _chatTimeMin = timeMin;
                        _chatTimeMax = timeMax;
                        _tab = NavTab.chat;
                      });
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
      // ✅ 3. تحديث استدعاء SmartChatScreen وتمرير كافة المتغيرات الجديدة بنجاح
        return SmartChatScreen(
          onNavigate: (t) => setState(() => _tab = t),
          from: _chatFrom,
          to: _chatTo,
          transportMode: _chatTransportMode,
          costMin: _chatCostMin,
          costMax: _chatCostMax,
          timeMin: _chatTimeMin,
          timeMax: _chatTimeMax,
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