import 'package:flutter/material.dart';

/// A dialog used to create an index card.
class CreateIndexCardDialog extends StatelessWidget {
  /// Constructor for the [CreateIndexCardDialog].
  const CreateIndexCardDialog({super.key});

  @override
  Widget build(final BuildContext context) => AlertDialog(
        title: const Text('Create Index Card'),
        content: Column(
          children: [
            TextFormField(
              key: const Key('InputTextField_question'),
              decoration: const InputDecoration(
                labelText: 'Question',
              ),
            ),
            TextFormField(
              key: const Key('InputTextField_answer'),
              decoration: const InputDecoration(
                labelText: 'Answer',
              ),
            ),
          ],
        ),
      );
}
