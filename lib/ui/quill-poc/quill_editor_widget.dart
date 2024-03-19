import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// Rich text editor widget.
class QuillEditorWidget extends StatelessWidget {

  /// Constructor for the [QuillEditorWidget].
  const QuillEditorWidget({super.key});

  @override
  Widget build(final BuildContext context) {
    final controller = QuillController.basic();
    return Flex(
      direction: Axis.vertical,
      children: [
        QuillToolbar.simple(
          configurations: QuillSimpleToolbarConfigurations(
            controller: controller,
            sharedConfigurations: const QuillSharedConfigurations(
              locale: Locale('de'),
            ),
          ),
        ),
        Expanded(
          child: QuillEditor.basic(
            configurations: QuillEditorConfigurations(
              controller: controller,
              readOnly: false,
              sharedConfigurations: const QuillSharedConfigurations(
                locale: Locale('de'),
              ),
            ),
          ),
        )
      ],
    );
  }
}