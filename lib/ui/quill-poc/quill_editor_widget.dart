import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_embeds.dart';

/// Rich text editor widget.
class QuillEditorWidget extends StatelessWidget {
  /// Constructor for the [QuillEditorWidget].
  QuillEditorWidget({super.key});

  /// The controller for the quill editor.
  final controller = QuillController.basic();

  @override
  Widget build(final BuildContext context) => Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
            child: QuillEditor.basic(
              configurations: QuillEditorConfigurations(
                controller: controller,
                sharedConfigurations: const QuillSharedConfigurations(
                  locale: Locale('de'),
                ),
                embedBuilders: FlutterQuillEmbeds.editorBuilders(),
              ),
            ),
          ),
          _buildCollapsable(
            'Toolbar',
            QuillToolbar.simple(
              configurations: QuillSimpleToolbarConfigurations(
                controller: controller,
                sharedConfigurations:
                    const QuillSharedConfigurations(locale: Locale('de'),),
                embedButtons: FlutterQuillEmbeds.toolbarButtons(),
              ),
            ),
          ),
        ],
      );

  Widget _buildCollapsable(final String title, final Widget body) =>
      ExpansionTile(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        children: [body],
      );
}
