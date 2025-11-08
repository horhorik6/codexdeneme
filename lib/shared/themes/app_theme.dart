import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.accent,
      background: const Color(0xFFF3F6F4),
      surface: Colors.white,
      surfaceTint: AppColors.gradientEnd,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFF3F6F4),
    textTheme: Typography.englishLike2021.apply(
      bodyColor: AppColors.textDark,
      displayColor: AppColors.textDark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: AppColors.textDark,
      centerTitle: true,
    ),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: Colors.white,
      surfaceTintColor: AppColors.gradientStart.withOpacity(0.1),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.glassSurface,
      labelStyle: const TextStyle(color: AppColors.textDark),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white.withOpacity(0.9),
      indicatorColor: AppColors.primary.withOpacity(0.12),
      labelTextStyle: MaterialStateProperty.all(
        const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
  );
}
