import 'package:flutter/material.dart';

/// A widget used to display the Snackbar for creating a deck.
class CreateDeckSnackbar extends SnackBar {

  /// The key for the Snackbar title
  static const snackbarTitleKey = Key('create_deck_snackbar_title');

  /// The key for the create manually title
  static const createManuallyTitleKey = Key('create_manually_title');

  /// The key for the create AI title
  static const createAITitleKey = Key('create_ai_title');

  /// The key for the create manually button
  static const createManuallyButtonKey = Key('create_manually_button');

  /// Constructor for the [CreateDeckSnackbar].
  CreateDeckSnackbar({required final VoidCallback onManual,
    required final VoidCallback onAI,
    super.key})
      : super(
    backgroundColor: const Color(0xFF414141),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    duration: const Duration(days: 365),
    content: _CreateDeckSnackbarWidget(
      onManual: onManual,
      onAI: onAI,
      key: CreateDeckSnackbar.snackbarTitleKey,
    ),
  );
}

/// A widget used to display the Snackbar for creating a deck.
///
/// This widget is used to display the Snackbar for creating a deck.
///
/// It displays two buttons for the user to create a deck manually or with AI.
///
/// The [_CreateDeckSnackbarWidget] requires a [onManual] and [onAI] callback
/// to be provided.
///
/// The [onManual] callback is called when the user presses the button to create
/// a deck manually.
///
/// The [onAI] callback is called when the user presses the button to create
/// a deck with AI.
///
/// This snippet can be used in the `DeckOverviewWidget` to display the
/// Snackbar for creating a deck.
///
/// ```dart
/// ScaffoldMessenger.of(context).showSnackBar(
///   SnackBar(
///     content: CreateDeckSnackbarWidget(
///       onManual: () {
///         // Create deck manually
///       },
///       onAI: () {
///         // Create deck with AI
///       },
///     ),
///   ),
/// );
/// ```
///
/// {@category Widget}
class _CreateDeckSnackbarWidget extends StatelessWidget {
  /// Constructor for the [_CreateDeckSnackbarWidget].
  ///
  /// The [key] is used to identify the widget in the widget tree.
  ///
  /// The [onManual] callback is called when the user presses the button to
  /// create a deck manually.
  ///
  /// The [onAI] callback is called when the user presses the button to create
  /// a deck with AI.
  const _CreateDeckSnackbarWidget(
      {required this.onManual, required this.onAI, super.key});

  /// The callback called when the user presses the button to create a deck
  /// manually
  final VoidCallback onManual;

  /// The callback called when the user presses the button to create a deck with
  /// AI
  final VoidCallback onAI;

  @override
  Widget build(final BuildContext context) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  Text(
                    key: CreateDeckSnackbar.snackbarTitleKey,
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
            key: CreateDeckSnackbar.createManuallyButtonKey,
            onPressed: onManual,
            icon: const Icon(
              Icons.person,
              color: Color(0xFF20EFC0),
            ),
            label: const Text(
              key: CreateDeckSnackbar.createManuallyTitleKey,
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
              key: CreateDeckSnackbar.createAITitleKey,
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
