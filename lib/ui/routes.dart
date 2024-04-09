import 'package:aidex/data/model/deck.dart';
import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/ui/deck-view/index_cards_overview_widget.dart';
import 'package:aidex/ui/index-card-view/index_card_create_view.dart';
import 'package:aidex/ui/index-card-view/index_card_edit_view.dart';
import 'package:aidex/ui/index-card-view/index_card_view.dart';
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
  Widget build(final BuildContext context) => DeckViewWidgetPage(deck: deck);
}

///A route used to display the selected index card.
class ItemOnDeckViewWidgetSelectedRoute extends StatelessWidget {
  /// Constructor for the [ItemOnDeckViewWidgetSelectedRoute].
  ///
  /// The [indexCard] is the index card to be displayed.
  /// The [key] is used to identify the widget in the widget tree.
  const ItemOnDeckViewWidgetSelectedRoute(
      {required this.indexCard, required this.deckName, super.key});

  /// The index card to be displayed.
  final IndexCard indexCard;

  /// The name of the deck the index card belongs to.
  final String deckName;

  @override
  Widget build(final BuildContext context) => IndexCardViewPage(
      indexCardId: indexCard.indexCardId!, deckName: deckName);
}

/// A route used to create an index card.
class IndexCardCreateRoute extends StatelessWidget {
  /// Constructor for the [IndexCardCreateRoute].
  const IndexCardCreateRoute(
      {required this.deckId, required this.deckName, super.key});

  /// The id of the deck the index card belongs to.
  final int deckId;

  /// The name of the deck the index card belongs to.
  final String deckName;

  @override
  Widget build(final BuildContext context) => IndexCardCreateViewPage(
        deckId: deckId,
        deckName: deckName,
      );
}

/// A route used to edit an index card.
class IndexCardEditRoute extends StatelessWidget {
  /// Constructor for the [IndexCardEditRoute].
  const IndexCardEditRoute(
      {required final IndexCard initialIndexCard,
      required final String deckName,
      super.key})
      : _initialIndexCard = initialIndexCard,
        _deckName = deckName;

  final IndexCard _initialIndexCard;
  final String _deckName;

  @override
  Widget build(final BuildContext context) => IndexCardEditViewPage(
        initialIndexCard: _initialIndexCard,
        deckName: _deckName,
      );
}
