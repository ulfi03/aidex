import 'package:aidex/ui/quill-poc/quill_editor_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

/// The main application widget.
///
/// This widget is the root of the application.
class MyApp extends StatelessWidget {
  /// Constructor for the main application widget.
  MyApp({super.key});

  final QuillEditorWidget _quillEditorWidget = QuillEditorWidget();

  /// The key for the QuillEditorWidget.
  @override
  Widget build(final BuildContext context) {
    //_quillEditorWidget.controller.document.toDelta().toJson();
    _quillEditorWidget.controller.document.insert(0, 'Hello World!');
    return MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF20EFC0),
            primary: const Color(0xFF20EFC0),
            onPrimary: Colors.black,
            background: Colors.black,
            onBackground: Colors.white,
            surface: Colors.white38,
            onSurface: Colors.white,
            onSurfaceVariant: Colors.white38,

          ),
          textTheme:
            const TextTheme(
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
            ),
          // change icon color to blue
        ),
        //home: DeckOverviewWidget(),
        home: Scaffold(
          body: _quillEditorWidget,
        ));
  }
}
