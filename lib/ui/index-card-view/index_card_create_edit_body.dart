import 'package:aidex/ui/components/rich_text_editor_widget.dart';
import 'package:flutter/material.dart';

/// A widget that displays a text field for a question and a rich text editor
/// for an answer.
class IndexCardCreateEditBody extends StatelessWidget {
  /// Constructor for the [IndexCardCreateEditBody].
  IndexCardCreateEditBody({
    final TextEditingController? questionController,
    final RichTextEditorController? answerController,
    super.key,
  })  : _questionController = questionController ?? TextEditingController(),
        _answerController = answerController ?? RichTextEditorController();

  /// The key for the question field.
  static const Key questionKey = Key('question_key');

  final TextEditingController _questionController;
  final RichTextEditorController _answerController;

  @override
  Widget build(final BuildContext context) => Column(
        children: <Widget>[
          TextField(
            key: questionKey,
            decoration: const InputDecoration(
              labelText: 'Question',
            ),
            controller: _questionController,
          ),
          const Align(alignment: Alignment.centerLeft, child: Text('Answer')),
          Expanded(
            child: RichTextEditorWidget(
              controller: _answerController,
              readonly: false,
            ),
          ),
        ],
      );
}
