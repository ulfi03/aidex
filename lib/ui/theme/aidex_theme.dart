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
      onPrimaryContainer: const Color(0xFF414141),
      onSurface: Colors.white,
      onSurfaceVariant: Colors.white38,
      onSecondary: Colors.white54,
      error: Colors.red,
      secondary: Colors.white,
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
      headlineLarge: TextStyle(color: Colors.white),
      headlineMedium: TextStyle(color: Colors.white),
      headlineSmall: TextStyle(color: Colors.white),
      titleLarge: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.white),
      titleSmall: TextStyle(color: Colors.white),
    ));
