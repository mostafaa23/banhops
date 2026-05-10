import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF4A90E2);
  static const Color primaryDark = Color(0xFF3B7DD6);
  static const Color background = Colors.white;
  static const Color surfaceGrey = Color(0xFFF9FAFB);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF99A1AF);
  static const Color textPlaceholder = Color(0xFFD1D5DC);
  static const Color iconBg = Color(0xFFEFF6FF);
  static const Color border = Color(0xFFE5E7EB);

  // ✅ Dark background للـ RouteDetailsScreen فقط
  static const Color darkBackground = Color(0xFF0A0F1E);
}

class AppTheme {
  // ── Light theme (الـ default للتطبيق كله) ──────────────────────
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      brightness: Brightness.light,
    ),
    fontFamily: 'Roboto',
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceGrey,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
        const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    ),
  );

  // ── Dark theme — للـ RouteDetailsScreen فقط ─────────────────────
  // استخدمه كـ Theme(data: AppTheme.dark, child: RouteDetailsScreen(...))
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    // ✅ ده هو المفتاح — بيخلي الـ Scaffold background مش بيأثر على غيره
    scaffoldBackgroundColor: AppColors.darkBackground,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      brightness: Brightness.dark,
      surface: AppColors.darkBackground,
    ),
    fontFamily: 'Roboto',
  );
}