import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_embeds.dart';

/// Rich text editor widget.
class RichTextEditorWidget extends StatelessWidget {
  /// Constructor for the [RichTextEditorWidget].
  RichTextEditorWidget({required final readonly, super.key})
      : _readonly = readonly;

  final bool _readonly;

  /// The controller for the quill editor.
  final _controller = QuillController.basic();

  /// Converts the content of the editor to JSON.
  String toJson() => jsonEncode(_controller.document.toDelta().toJson());

  /// Inserts the content described by the passed [json] in the editor.
  void fromJson(final String json) =>
      _controller.document = Document.fromJson(jsonDecode(json));

  @override
  Widget build(final BuildContext context) => Flex(
        direction: Axis.vertical,
        children: [
          Visibility(
            visible: !_readonly,
            child: QuillToolbar.simple(
              configurations: QuillSimpleToolbarConfigurations(
                controller: _controller,
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
                controller: _controller,
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
