import 'package:flutter/material.dart';

class NordivexColors {
  NordivexColors._();

  static const Color alpineBlack = Color(0xFF0D1117);
  static const Color slateRock = Color(0xFF161B22);
  static const Color stoneElevated = Color(0xFF21262D);
  static const Color stoneBorder = Color(0xFF30363D);

  static const Color pineEmerald = Color(0xFF10B981);
  static const Color glacierCyan = Color(0xFF38BDF8);
  static const Color mountainGold = Color(0xFFF59E0B);
  static const Color summitOrange = Color(0xFFF97316);

  static const Color textBright = Color(0xFFF0F6FC);
  static const Color textMuted = Color(0xFF8B949E);
}

class NordivexTheme {
  NordivexTheme._();

  static ThemeData themeData() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: NordivexColors.alpineBlack,
      fontFamily: 'AppFont',
      colorScheme: const ColorScheme.dark(
        primary: NordivexColors.pineEmerald,
        secondary: NordivexColors.glacierCyan,
        surface: NordivexColors.slateRock,
        onSurface: NordivexColors.textBright,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: NordivexColors.alpineBlack,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'AppFont',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: NordivexColors.textBright,
        ),
        iconTheme: IconThemeData(color: NordivexColors.textBright),
      ),
      cardTheme: CardThemeData(
        color: NordivexColors.slateRock,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: NordivexColors.stoneBorder),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: NordivexColors.slateRock,
        indicatorColor: NordivexColors.pineEmerald.withValues(alpha: 0.18),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: NordivexColors.pineEmerald,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            );
          }
          return const TextStyle(
            color: NordivexColors.textMuted,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: NordivexColors.pineEmerald);
          }
          return const IconThemeData(color: NordivexColors.textMuted);
        }),
      ),
    );
  }
}
