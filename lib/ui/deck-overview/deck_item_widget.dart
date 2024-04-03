import 'package:aidex/bloc/deck_overview_bloc.dart';
import 'package:aidex/data/model/deck.dart';
import 'package:aidex/ui/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
/// A widget that represents a deck item.
class DeckItemWidget extends StatelessWidget {
  
  /// Creates a new deck item widget.
  const DeckItemWidget({
    required this.deck,
    required this.contextWithBloc,
    super.key,
  });

  /// A key used to identify the deck name widget in tests.
  static const deckNameKey = Key('deck_name');
  /// The deck to display.
  final Deck deck;
  /// The context with the DeckOverviewBloc.
  final BuildContext contextWithBloc; 

  @override
  Widget build(final BuildContext context) {
    final iconSize = MediaQuery.of(context).size.width / 4;

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (final context) => ItemOnDeckOverviewSelectedRoute(deck: 
            deck),
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
            color: Colors.white,
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
                color: const Color(0xFF20EFC0),
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
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (final value) {
                if (value == 'delete') {
                  showDialog(
                    context: context,
                    builder: (final context) => AlertDialog(
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
                            const TextSpan(
                              text: 'Are you sure you want to delete the Deck '),
                            TextSpan(
                              text: '${deck.name}',
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
                            contextWithBloc.read<DeckOverviewBloc>()
                            .add(DeleteDeck(deck: deck));
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
                    ),
                  );
                }
              },
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              itemBuilder: (final context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(
                      Icons.delete,
                      color: Color(0xFF20EFC0),
                    ),
                    title: Text(
                      'Delete Deck',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
              color: const Color(0xFF414141),
            ),
          ],
        ),
      ),
    );
  }
}
