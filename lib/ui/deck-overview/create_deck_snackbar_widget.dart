import 'package:flutter/material.dart';

class CreateDeckSnackbarWidget extends StatelessWidget {
  static const snackbarTitleKey = Key('create_deck_snackbar_title');
  static const createManuallyTitleKey = Key('create_manually_title');
  static const createAITitleKey = Key('create_ai_title');
  static const createManuallyButtonKey = Key('create_manually_button');
  final VoidCallback onManual;
  final VoidCallback onAI;

  const CreateDeckSnackbarWidget(
      {super.key, required this.onManual, required this.onAI});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Column(
              children: [
                Text(
                  key: snackbarTitleKey,
                  'Create Deck',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        ElevatedButton.icon(
          key: createManuallyButtonKey,
          onPressed: onManual,
          icon: const Icon(
            Icons.person,
            color: Color(0xFF20EFC0),
          ),
          label: const Text(
            key: createManuallyTitleKey,
            'Create manually',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: EdgeInsets.zero,
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: onAI,
          icon: const Icon(
            Icons.smart_toy,
            color: Color(0xFF20EFC0),
          ),
          label: const Text(
            key: createAITitleKey,
            'Create with AI',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}
