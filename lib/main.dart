import 'package:aidex/ui/quill-poc/quill_editor_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// The main application widget.
///
/// This widget is the root of the application.
class MyApp extends StatelessWidget {

  /// Constructor for the main application widget.
  const MyApp({super.key});

  @override
  Widget build(final BuildContext context) => const MaterialApp(
      //home: DeckOverviewWidget(),
    home: QuillEditorWidget(key: Key('quill-editor-widget'),),
    );
}
