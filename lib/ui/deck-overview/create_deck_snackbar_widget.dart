import 'package:flutter/material.dart';

/// A widget used to display the Snackbar for creating a deck.
///
/// This widget is used to display the Snackbar for creating a deck.
///
/// It displays two buttons for the user to create a deck manually or with AI.
///
/// The [CreateDeckSnackbarWidget] requires a [onManual] and [onAI] callback
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
class CreateDeckSnackbarWidget extends StatelessWidget {
  /// Constructor for the [CreateDeckSnackbarWidget].
  ///
  /// The [key] is used to identify the widget in the widget tree.
  ///
  /// The [onManual] callback is called when the user presses the button to
  /// create a deck manually.
  ///
  /// The [onAI] callback is called when the user presses the button to create
  /// a deck with AI.
  const CreateDeckSnackbarWidget(
      {required this.onManual, required this.onAI, super.key});

  /// The callback called when the user presses the button to create a deck
  /// manually
  final VoidCallback onManual;

  /// The callback called when the user presses the button to create a deck with
  /// AI
  final VoidCallback onAI;

  @override
  Widget build(final BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  Text(
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
            onPressed: onManual,
            icon: const Icon(
              Icons.person,
              color: Color(0xFF20EFC0),
            ),
            label: const Text(
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
