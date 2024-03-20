import 'package:aidex/model/deck.dart';
import 'package:flutter/material.dart';

/// A widget used to display the deck view.
///
/// The [DeckViewWidget] requires a [deck] to be provided.
class DeckViewWidget extends StatelessWidget {

  /// Constructor for the [DeckViewWidget].
  const DeckViewWidget({required this.deck, super.key});

  /// The deck to be displayed.
  final Deck deck;

  @override
  Widget build(final BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(deck.name),
      ),
      body: Center(
        child: Text('Content of ${deck.name}'),
      ),
    );
}
