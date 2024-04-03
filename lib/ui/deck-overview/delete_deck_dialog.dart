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
        title: const Text(
          'Delete Deck',
          style: TextStyle(
            color: Color(0xFF20EFC0),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: RichText(
          text: TextSpan(
            style: const TextStyle(
              color: Colors.white,
            ),
            children: [
              const TextSpan(text: 'Are you sure you want to delete the Deck '),
              TextSpan(
                text: _deck.name,
                style: const TextStyle(
                  color: Color(0xFF20EFC0),
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
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
        backgroundColor: const Color(0xFF414141),
      );
}
