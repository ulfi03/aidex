import 'package:aidex/app/model/deck.dart';
import 'package:aidex/app/model/index_card.dart';
import 'package:aidex/ui/routes.dart';
import 'package:flutter/material.dart';

/// A widget used to display a deck item.
class DeckItemWidget extends StatelessWidget {

  /// Constructor for the [DeckItemWidget].
  ///
  /// The [deck] is the deck to be displayed.
  /// The [indexCards] are the index cards to be displayed.
  const DeckItemWidget({required this.deck, required this.indexCards, Key? key}) : super(key: key);

  /// The deck to be displayed.
  final Deck deck;

  /// The index cards to be displayed.
  final List<IndexCard> indexCards;

  @override
  Widget build(final BuildContext context) {
    final iconSize = MediaQuery.of(context).size.width / 4;

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (final context)
            => ItemOnDeckOverviewSelectedRoute(deck: deck, indexCards: indexCards),
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
          color: deck.color, // Set the background color from the deck
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
                    deck.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}