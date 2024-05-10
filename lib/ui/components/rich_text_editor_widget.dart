import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_embeds.dart';

/// Rich text editor widget.
class RichTextEditorWidget extends StatelessWidget {
  /// Constructor for the [RichTextEditorWidget].
  RichTextEditorWidget(
      {required final readonly,
      final RichTextEditorController? controller,
      super.key})
      : _readonly = readonly,
        _controller =
            (controller != null) ? controller : RichTextEditorController();

  /// The controller for the quill editor.
  final RichTextEditorController _controller;

  final bool _readonly;

  /// Converts the content of the editor to JSON.
  String toJson() =>
      jsonEncode(_controller.quillController.document.toDelta().toJson());

  /// Inserts the content described by the passed [json] in the editor.
  void fromJson(final String json) => _controller.quillController.document =
      Document.fromJson(jsonDecode(json));

  @override
  Widget build(final BuildContext context) => Flex(
        direction: Axis.vertical,
        children: [
          Visibility(
            visible: !_readonly,
            child: QuillToolbar.simple(
              configurations: QuillSimpleToolbarConfigurations(
                controller: _controller.quillController,
                multiRowsDisplay: false,
                toolbarSize: 40,
                sharedConfigurations: const QuillSharedConfigurations(
                  locale: Locale('de'),
                ),
                embedButtons: FlutterQuillEmbeds.toolbarButtons(),
              ),
            ),
          ),
          Expanded(
            child: QuillEditor.basic(
              configurations: QuillEditorConfigurations(
                readOnly: _readonly,
                showCursor: !_readonly,
                controller: _controller.quillController,
                sharedConfigurations: const QuillSharedConfigurations(
                  locale: Locale('de'),
                ),
                embedBuilders: FlutterQuillEmbeds.editorBuilders(),
              ),
            ),
          ),
        ],
      );
}

/// Controller for the rich text editor.
class RichTextEditorController {
  /// Constructor for the [RichTextEditorController].
  RichTextEditorController({final String? contentJson})
      : _quillController = QuillController.basic() {
    if (contentJson != null) {
      fromJson(contentJson);
    }
  }

  final QuillController _quillController;

  /// The controller for the quill editor.
  QuillController get quillController => _quillController;

  /// Converts the content of the editor to JSON.
  String toJson() => jsonEncode(_quillController.document.toDelta().toJson());

  /// Inserts the content described by the passed [json] in the editor.
  void fromJson(final String json) =>
      _quillController.document = Document.fromJson(jsonDecode(json));
}
