import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AmedsporColors.primaryGreen),
    useMaterial3: true,
    scaffoldBackgroundColor: AmedsporColors.lightBackground,
    appBarTheme: const AppBarTheme(centerTitle: true),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: AmedsporColors.primaryGreen,
    ),
  );
}
