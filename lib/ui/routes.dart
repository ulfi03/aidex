import 'package:aidex/ui/deck-view/deck_view_widget.dart';
import 'package:flutter/cupertino.dart';
import '../app/model/deck.dart';

class ItemOnDeckOverviewSelectedRoute extends StatelessWidget {
  final Deck deck;

  const ItemOnDeckOverviewSelectedRoute({super.key, required this.deck});

  @override
  Widget build(BuildContext context) {
    return DeckViewWidget(deck: deck);
  }
}
