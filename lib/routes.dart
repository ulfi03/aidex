import 'package:aidex/deck-view/ui/deck_view_widget.dart';
import 'package:flutter/cupertino.dart';

import 'shared/app/model/deck.dart';

class ItemOnDeckOverviewSelectedRoute extends StatelessWidget {
  final Deck deck;

  const ItemOnDeckOverviewSelectedRoute({super.key, required this.deck});

  @override
  Widget build(BuildContext context) {
    return DeckViewWidget(deck: deck);
  }
}
