import 'package:flutter/material.dart';

/// The theme for the application.
final ThemeData mainTheme = ThemeData(
    colorScheme: ColorScheme.dark(
      //standard colors - black isnt really used, white is used mainly for text
      primary: Colors.black,
      secondary: Colors.white,

      // our main accent color
      tertiary: const Color(0xFF20EFC0),

      //our two background colors - onBackground is for the background of 
      //widgets and background is for the scaffold 
      background: const Color(0xFF121212).withOpacity(0.9),
      onBackground: const Color(0xFF414141),

      //this grey is only used once or twice in the app
      onSecondary: Colors.white54,

      //error or danger color
      error: Colors.red,
    ),
    );
