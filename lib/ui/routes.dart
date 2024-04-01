import 'package:aidex/data/model/deck.dart';
import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/ui/deck-view/deck_view_widget.dart';
import 'package:aidex/ui/indexCard-view/index_card_view_widget.dart';
import 'package:flutter/cupertino.dart';

/// A route used to display the selected deck.
class ItemOnDeckOverviewSelectedRoute extends StatelessWidget {
  /// Constructor for the [ItemOnDeckOverviewSelectedRoute].
  ///
  /// The [deck] is the deck to be displayed.
  /// The [key] is used to identify the widget in the widget tree.
  const ItemOnDeckOverviewSelectedRoute({required this.deck, super.key});

  /// The deck to be displayed.
  final Deck deck;

  @override
  Widget build(final BuildContext context) => DeckViewWidget(deck: deck);
}

///A route used to display the selected index card.
class ItemOnDeckViewWidgetSelectedRoute extends StatelessWidget {
  /// Constructor for the [ItemOnDeckViewWidgetSelectedRoute].
  ///
  /// The [indexCard] is the index card to be displayed.
  /// The [key] is used to identify the widget in the widget tree.
  const ItemOnDeckViewWidgetSelectedRoute({required this.indexCard, super.key});

  /// The index card to be displayed.
  final IndexCard indexCard;

  @override
  Widget build(final BuildContext context) =>
      IndexCardViewWidget(indexCard: indexCard);
}
