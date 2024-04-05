import 'package:aidex/bloc/deck_overview_bloc.dart';
import 'package:aidex/data/model/deck.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A dialog that asks the user if they want to delete a deck.
class DeleteDeckDialog extends StatelessWidget {
  /// Creates a new delete deck dialog.
  /// [deck] The deck to delete.
  const DeleteDeckDialog({required final Deck deck, super.key}) : _deck = deck;

  final Deck _deck;

  @override
  Widget build(final BuildContext context) => AlertDialog(
        title: Text(
          'Delete Deck',
          style: TextStyle(
            color: Theme.of(context).textTheme.titleMedium?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: RichText(
          text: TextSpan(
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
            children: [
              const TextSpan(text: 'Are you sure you want to delete the Deck '),
              TextSpan(
                text: _deck.name,
                style: TextStyle(
                  color: Theme.of(context).textTheme.titleMedium?.color,
                ),
              ),
              const TextSpan(text: '?'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Use the context passed to access DeckOverviewBloc
              context.read<DeckOverviewBloc>().add(DeleteDeck(deck: _deck));
              Navigator.pop(context);
            },
            child: Text(
              'Delete',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      );
}
