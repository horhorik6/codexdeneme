import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';

class DarkTheme {
  static final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.accent,
      secondary: AppColors.primary,
      surface: const Color(0xFF1B1F1D),
      background: AppColors.darkBackground,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF101513),
    textTheme: Typography.englishLike2021.apply(
      bodyColor: AppColors.textLight,
      displayColor: AppColors.textLight,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.white,
      centerTitle: true,
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF1F2A25),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.white.withOpacity(0.08),
      labelStyle: const TextStyle(color: AppColors.textLight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF1A221E).withOpacity(0.92),
      indicatorColor: AppColors.accent.withOpacity(0.2),
      labelTextStyle: MaterialStateProperty.all(
        const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
  );
}
