import 'package:aidex/bloc/deck_overview_bloc.dart';
import 'package:aidex/data/model/deck.dart';
import 'package:aidex/ui/components/custom_buttons.dart';
import 'package:aidex/ui/theme/aidex_theme.dart';
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
          style: mainTheme.textTheme.titleMedium,
        ),
        content: RichText(
          text: TextSpan(
            style: mainTheme.textTheme.bodyMedium,
            children: [
              const TextSpan(text: 'Are you sure you want to delete the Deck '),
              TextSpan(
                text: _deck.name,
                style: TextStyle(
                  color: mainTheme.colorScheme.primary,
                ),
              ),
              const TextSpan(text: '?'),
            ],
          ),
        ),
        actions: [
          DeleteButton(onPressed: () {
            // Use the context passed to access DeckOverviewBloc
            context.read<DeckOverviewBloc>().add(DeleteDeck(deck: _deck));
            Navigator.pop(context);
          }),
          CancelButton(onPressed: () => Navigator.pop(context)),
        ],
        backgroundColor: mainTheme.colorScheme.background,
      );
}
