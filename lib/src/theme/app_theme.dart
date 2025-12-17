import 'package:flutter/material.dart';

class BarengTheme {
  static ThemeData theme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0F1115),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF89CFF3),
      secondary: Color(0xFF7A7FFF),
      surface: Color(0xFF1A1D24),
    ),
    useMaterial3: true,
    textTheme: const TextTheme(
      displaySmall: TextStyle(fontWeight: FontWeight.w700, letterSpacing: -0.5),
      titleLarge: TextStyle(fontWeight: FontWeight.w600),
      bodyMedium: TextStyle(height: 1.4),
    ),
  );

  static BoxDecoration glass({double blur = 16, double opacity = 0.18}) => BoxDecoration(
        color: Colors.white.withAlpha((opacity * 255).round()),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withAlpha((0.12 * 255).round())),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.35 * 255).round()),
            blurRadius: blur,
            offset: const Offset(0, 10),
          ),
        ],
      );
}
