import 'package:aidex/bloc/deck_overview_bloc.dart';
import 'package:aidex/ui/components/custom_buttons.dart';
import 'package:aidex/ui/theme/aidex_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
/// A dialog that asks the user if they want to delete a deck.
class DeleteAllDecksDialog extends StatelessWidget {
  /// Creates a new delete deck dialog.
  const DeleteAllDecksDialog({super.key});


  @override
  Widget build(final BuildContext context) => AlertDialog(
        title: Text(
          'Delete all Decks',
          style: mainTheme.textTheme.titleMedium,
        ),
        content: RichText(
          text: TextSpan(
            style: mainTheme.textTheme.bodyMedium,
            children: [
              const TextSpan(text: 'Are you sure you want to delete  '),
              TextSpan(
                text: 'all decks',
                style: TextStyle(
                  color: mainTheme.colorScheme.primary,
                ),
              ),
              const TextSpan(text: '?\n\n'),
              TextSpan(
                text: 'This action cannot be undone!',
                style: TextStyle(
                  color: mainTheme.colorScheme.error,
                ),
              ),
            ],
          ),
        ),
        actions: [
          CancelButton(onPressed: () => Navigator.pop(context)),
          DeleteButton(onPressed: () {
            BlocProvider.of<DeckOverviewBloc>(context)
                .add(const RemoveAllDecks());
            Navigator.pop(context);
          }),
        ],
        backgroundColor: mainTheme.colorScheme.background,
      );
}
