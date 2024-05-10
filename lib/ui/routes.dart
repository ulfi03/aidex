import 'package:aidex/data/model/deck.dart';
import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/ui/deck-view/index_cards_overview_widget.dart';
import 'package:aidex/ui/index-card-view/index_card_create_view.dart';
import 'package:aidex/ui/index-card-view/index_card_edit_view.dart';
import 'package:aidex/ui/index-card-view/index_card_view.dart';
import 'package:aidex/ui/learning-function/learning_function.dart';
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
  const ItemOnDeckViewWidgetSelectedRoute(
      {required this.indexCard, required this.deck, super.key});

  /// The index card to be displayed.
  final IndexCard indexCard;

  /// The name of the deck the index card belongs to.
  final Deck deck;

  @override
  Widget build(final BuildContext context) =>
      IndexCardViewPage(indexCardId: indexCard.indexCardId!, deck: deck);
}

/// A route used to create an index card.
class IndexCardCreateRoute extends StatelessWidget {
  /// Constructor for the [IndexCardCreateRoute].
  const IndexCardCreateRoute({required this.deck, super.key});

  /// The name of the deck the index card belongs to.
  final Deck deck;

  @override
  Widget build(final BuildContext context) => IndexCardCreateViewPage(
        deck: deck,
      );
}

/// A route used to edit an index card.
class IndexCardEditRoute extends StatelessWidget {
  /// Constructor for the [IndexCardEditRoute].
  const IndexCardEditRoute(
      {required final IndexCard initialIndexCard,
      required final Deck deck,
      super.key})
      : _initialIndexCard = initialIndexCard,
        _deck = deck;

  final IndexCard _initialIndexCard;
  final Deck _deck;

  @override
  Widget build(final BuildContext context) => IndexCardEditViewPage(
        initialIndexCard: _initialIndexCard,
        deck: _deck,
      );
}

/// A route used for the learning function.
class LearningFunctionRoute extends StatelessWidget {
  /// Constructor for the [LearningFunctionRoute].
  const LearningFunctionRoute({required final Deck deck, super.key})
      : _deck = deck;

  final Deck _deck;

  @override
  Widget build(final BuildContext context) => LearningFunctionPage(deck: _deck);
}
