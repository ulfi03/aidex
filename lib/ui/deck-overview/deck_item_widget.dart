import 'package:aidex/bloc/deck_overview_bloc.dart';
import 'package:aidex/data/model/deck.dart';
import 'package:aidex/ui/deck-overview/delete_deck_dialog.dart';
import 'package:aidex/ui/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A widget that represents a deck item.
class DeckItemWidget extends StatelessWidget {
  /// Creates a new deck item widget.
  const DeckItemWidget({
    required this.deck,
    super.key,
  });

  /// A key used to identify the deck name widget in tests.
  static const deckNameKey = Key('deck_name');

  /// The deck to display.
  final Deck deck;

  @override
  Widget build(final BuildContext context) {
    final iconSize = MediaQuery.of(context).size.width / 4;

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (final context) =>
                ItemOnDeckOverviewSelectedRoute(deck: deck),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 32,
          vertical: MediaQuery.of(context).size.width / 64,
        ),
        width: iconSize * 1.7,
        height: iconSize * 0.8,
        decoration: BoxDecoration(
          color: deck.color,
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.layers,
                size: iconSize * 0.4,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Align(
                  alignment: const Alignment(-1.2, -0.5),
                  child: Text(
                    key: deckNameKey,
                    deck.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Theme.of(context)
                    .colorScheme.secondary),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (final value) async {
                if (value == 'delete') {
                  final DeckOverviewBloc deckOverviewBloc =
                      context.read<DeckOverviewBloc>();
                  await showDialog(
                      context: context,
                      builder: (final context) => BlocProvider.value(
                          value: deckOverviewBloc,
                          child: DeleteDeckDialog(deck: deck)));
                }
              },
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).colorScheme.secondary,
              ),
              itemBuilder: (final context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      'Delete Deck',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
              ],
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ],
        ),
      ),
    );
  }
}
