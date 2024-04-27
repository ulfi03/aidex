import 'package:aidex/ui/theme/aidex_theme.dart';
import 'package:flutter/material.dart';

/// This widget is used to display the create deck modal bottom sheet.
class CreateDeckModalBottomSheet extends StatelessWidget {
  /// Constructor for the [CreateDeckModalBottomSheet].
  ///
  /// The [key] is used to identify the widget in the widget tree.
  ///
  /// The [onManual] callback is called when the user presses the button to
  /// create a deck manually.
  ///
  /// The [onAI] callback is called when the user presses the button to create
  /// a deck with AI.
  const CreateDeckModalBottomSheet(
      {required this.onManual, required this.onAI, super.key});

  /// The key for the create deck modal bottom sheet title
  static const modalBottomSheetTitleKey =
      Key('create_deck_modal_bottom_sheet_title');

  /// The key for the create manually title
  static const createManuallyTitleKey = Key('create_manually_title');

  /// The key for the create AI title
  static const createAITitleKey = Key('create_ai_title');

  /// The key for the create manually button
  static const createManuallyButtonKey = Key('create_manually_button');

  /// The callback called when the user presses the button to create a deck
  /// manually
  final VoidCallback onManual;

  /// The callback called when the user presses the button to create a deck with
  /// AI
  final VoidCallback onAI;

  @override
  Widget build(final BuildContext context) => Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                  key: modalBottomSheetTitleKey,
                  'Create Deck',
                  style: mainTheme.textTheme.titleLarge),
            ),
            ElevatedButton.icon(
              key: createManuallyButtonKey,
              onPressed: onManual,
              icon: Icon(
                Icons.person,
                color: mainTheme.colorScheme.primary,
              ),
              label: Text(
                  key: createManuallyTitleKey,
                  'Create manually',
                  style: mainTheme.textTheme.bodyMedium),
              style: ElevatedButton.styleFrom(
                alignment: Alignment.centerLeft,
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: EdgeInsets.zero,
                elevation: 0,
              ),
            ),
            ElevatedButton.icon(
              onPressed: onAI,
              icon: Icon(
                Icons.smart_toy,
                color: mainTheme.colorScheme.primary,
              ),
              label: Text(
                key: createAITitleKey,
                'Create with AI',
                style: mainTheme.textTheme.bodyMedium,
              ),
              style: ElevatedButton.styleFrom(
                alignment: Alignment.centerLeft,
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: EdgeInsets.zero,
                elevation: 0,
              ),
            )
          ],
        ),
      );
}
