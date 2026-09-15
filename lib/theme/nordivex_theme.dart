import 'package:flutter/material.dart';

class NordivexTheme {
  static const bg = Color(0xFF0D1117);
  static const surface = Color(0xFF161B22);
  static const edge = Color(0xFF21262D);
  static const accent = Color(0xFF22C55E); // Alpine green
  static const accentLight = Color(0xFF86EFAC);
  static const ink = Color(0xFFF0FDF4);
  static const muted = Color(0xFF8B949E);

  static ThemeData get themeData {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      fontFamily: 'AppFont',
      primaryColor: accent,
      colorScheme: const ColorScheme.dark(
        primary: accent,
        surface: surface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bg,
        elevation: 0,
        foregroundColor: ink,
      ),
    );
  }
}
