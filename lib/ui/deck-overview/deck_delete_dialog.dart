import 'package:aidex/bloc/deck_overview_bloc.dart';
import 'package:aidex/data/model/deck.dart';
import 'package:aidex/ui/components/delete_dialog.dart';
import 'package:aidex/ui/deck-overview/deck_overview_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A dialog that asks the user, if they want to delete a [Deck],
/// from [DeckOverview].
class DeleteDeckDialog extends DeleteDialog {
  /// Creates a new delete deck dialog.
  /// [deck] The deck to delete.
  DeleteDeckDialog({required this.deck, super.key})
      : super(
          objectCategory: 'Deck',
          deleteMessage: 'Are you sure you want to delete the Deck ',
          deleteSubject: deck.name,
        );

  /// The deck to be deleted.
  final Deck deck;

  @override
  void onDelete(final BuildContext context) {
    // Use the context passed to access DeckOverviewBloc
    context.read<DeckOverviewBloc>().add(DeleteDeck(deck: deck));
    Navigator.pop(context);
  }
}
