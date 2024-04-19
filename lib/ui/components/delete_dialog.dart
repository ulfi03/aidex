import 'package:aidex/bloc/deck_overview_bloc.dart';
import 'package:aidex/bloc/index_cards_overview_bloc.dart';
import 'package:aidex/data/model/deck.dart';
import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/ui/deck-overview/deck_overview_widget.dart';
import 'package:aidex/ui/deck-view/index_cards_overview_widget.dart';
import 'package:aidex/ui/theme/aidex_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A dialog that asks the user, if they want to
/// delete a [deleteSubject], from [objectCategory].
abstract class DeleteDialog extends StatelessWidget {
  /// Creates a new delete dialog.
  DeleteDialog({super.key});

  /// The function to be called when the widget is tapped.
  void onDelete(final BuildContext context);

  /// The function to be called when the widget is tapped.
  late final Function(BuildContext context) onCancel = Navigator.pop;

  ///What king of Item is going to be deleted
  late final String objectCategory;

  ///The message that will be displayed in the dialog
  late final String deleteMessage;

  ///What specific item is going to be deleted
  late final String deleteSubject;

  @override
  Widget build(final BuildContext context) => AlertDialog(
        title: Text(
          'Delete $objectCategory',
          style: mainTheme.textTheme.titleMedium,
        ),
        content: RichText(
          text: TextSpan(
            style: mainTheme.textTheme.bodyMedium,
            children: [
              TextSpan(text: deleteMessage),
              TextSpan(
                text: deleteSubject,
                style: TextStyle(
                  color: mainTheme.colorScheme.primary,
                ),
              ),
              const TextSpan(text: '?'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => onDelete(context),
            child: Text(
              'Delete',
              style: TextStyle(
                color: mainTheme.colorScheme.error,
                fontSize: 16,
              ),
            ),
          ),
          TextButton(
            onPressed: () => onCancel(context),
            child: Text('Cancel', style: mainTheme.textTheme.bodyMedium),
          ),
        ],
        backgroundColor: mainTheme.colorScheme.background,
      );
}

/// A dialog that asks the user, if they want to delete a [Deck],
/// from [DeckOverview].
class DeleteDeckDialog extends DeleteDialog {
  /// Creates a new delete deck dialog.
  /// [deck] The deck to delete.
  DeleteDeckDialog({required this.deck, super.key}) {
    objectCategory = 'Deck';
    deleteSubject = deck.name;
    deleteMessage = 'Are you sure you want to delete the $objectCategory ';
  }

  /// The deck to be deleted.
  final Deck deck;

  @override
  void onDelete(final BuildContext context) {
    // Use the context passed to access DeckOverviewBloc
    context.read<DeckOverviewBloc>().add(DeleteDeck(deck: deck));
    Navigator.pop(context);
  }
}

/// A dialog that asks the user, if they want to delete an (or multiple) [IndexCard]/s, from [IndexCardOverview].
class DeleteIndexCardsDialog extends DeleteDialog {
  /// Creates a new delete index card dialog.
  DeleteIndexCardsDialog({required this.indexCardIds, super.key}) {
    objectCategory = indexCardIds.length > 1 ? 'Index Cards' : 'Index Card';
    deleteMessage = 'Are you sure you want to delete ';
    deleteSubject = '${indexCardIds.length} $objectCategory';
  }

  /// The slected index cards to be deleted.
  final List<int> indexCardIds;

  @override
  void onDelete(final BuildContext context) {
    context
        .read<IndexCardOverviewBloc>()
        .add(RemoveIndexCard(selectedIndexCardsIds: indexCardIds));
    context
        .read<IndexCardOverviewBloc>()
        .add(const ExitIndexCardSelectionMode());
    Navigator.pop(context);
  }
}
