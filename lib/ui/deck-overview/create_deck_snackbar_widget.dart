import 'package:flutter/material.dart';

/// A widget used to display the Snackbar for creating a deck.
class CreateDeckSnackbar extends SnackBar {

  /// Constructor for the [CreateDeckSnackbar].
  CreateDeckSnackbar({required final VoidCallback onManual,
    required final VoidCallback onAI,
    required final BuildContext context, super.key})
      : super(
    backgroundColor: Theme.of(context).colorScheme.background,
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
    ),
  );

  /// The key for the Snackbar title
  static const snackbarTitleKey = Key('create_deck_snackbar_title');

  /// The key for the create manually title
  static const createManuallyTitleKey = Key('create_manually_title');

  /// The key for the create AI title
  static const createAITitleKey = Key('create_ai_title');

  /// The key for the create manually button
  static const createManuallyButtonKey = Key('create_manually_button');
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
      {required this.onManual, required this.onAI});

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
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  Text(
                    key: CreateDeckSnackbar.snackbarTitleKey,
                    'Create Deck',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
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
            icon: Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.primary,
            ),
            label: Text(
              key: CreateDeckSnackbar.createManuallyTitleKey,
              'Create manually',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: EdgeInsets.zero,
              elevation: 0,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: onAI,
            icon: Icon(
              Icons.smart_toy,
              color: Theme.of(context).colorScheme.primary,
            ),
            label: Text(
              key: CreateDeckSnackbar.createAITitleKey,
              'Create with AI',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: EdgeInsets.zero,
              elevation: 0,
            ),
          ),
        ],
      );
}
