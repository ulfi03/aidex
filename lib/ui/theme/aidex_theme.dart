import 'package:flutter/material.dart';

/// The theme for the application.
final ThemeData mainTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF20EFC0),
      primary: const Color(0xFF20EFC0),
      onPrimary: Colors.black,
      background: Colors.black,
      onBackground: Colors.white,
      surface: const Color(0xFF121212).withOpacity(0.9),
      onSurface: Colors.white,
      onSurfaceVariant: Colors.white38,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Colors.white),
      displayMedium: TextStyle(color: Colors.white),
      displaySmall: TextStyle(color: Colors.white),
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.white),
      labelLarge: TextStyle(color: Colors.white),
      labelMedium: TextStyle(color: Colors.white),
      labelSmall: TextStyle(color: Colors.white),
      headlineLarge: TextStyle(color: Colors.white, fontSize: 24),
      headlineMedium: TextStyle(color: Colors.white, fontSize: 18),
      headlineSmall: TextStyle(color: Colors.white, fontSize: 16),
      titleLarge: TextStyle(color: Colors.white, fontSize: 24),
      titleMedium: TextStyle(color: Colors.white, fontSize: 20),
      titleSmall: TextStyle(color: Colors.white, fontSize: 16),
    ));
