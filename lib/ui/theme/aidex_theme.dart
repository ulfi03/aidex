import 'package:flutter/material.dart';

/// The theme for the application.
final ThemeData mainTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF20EFC0),
    primary: const Color(0xFF20EFC0),
    onPrimary: Colors.black,
    secondary: const Color(0xFF00CDBE),
    background: const Color(0xFF414141),
    onBackground: Colors.white,
    surface: const Color(0xFF121212).withOpacity(0.9),
    onSurface: Colors.white,
    onSurfaceVariant: Colors.white38,
    error: Colors.red,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: Colors.white),
    displayMedium: TextStyle(color: Colors.white),
    displaySmall: TextStyle(color: Colors.white),
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white, fontSize: 16),
    bodySmall: TextStyle(color: Colors.white, fontSize: 12),
    labelLarge: TextStyle(color: Colors.white),
    labelMedium: TextStyle(color: Colors.white),
    labelSmall: TextStyle(color: Colors.white),
    headlineLarge: TextStyle(color: Colors.white),
    headlineMedium: TextStyle(color: Colors.white),
    headlineSmall: TextStyle(color: Colors.white),
    titleLarge: TextStyle(
        color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(
        color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
    titleSmall: TextStyle(
        color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      backgroundColor:
          MaterialStateProperty.all<Color>(const Color(0xFF20EFC0)),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF20EFC0),
    foregroundColor: Colors.black,
    // set size of the floating action button
    sizeConstraints: BoxConstraints.tightFor(width: 56, height: 56),
  ),
);
