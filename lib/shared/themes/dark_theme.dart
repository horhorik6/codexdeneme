import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';

class DarkTheme {
  DarkTheme._();

  static final ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AmedsporColors.primaryGreen,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
    scaffoldBackgroundColor: AmedsporColors.darkBackground,
  );
}
