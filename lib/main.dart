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
          ),
          textTheme: Typography.whiteCupertino,
        ),
        //home: DeckOverviewWidget(),
        home: Scaffold(
          body: _quillEditorWidget,
        ));
  }
}
