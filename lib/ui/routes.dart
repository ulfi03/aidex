import 'package:aidex/data/model/deck.dart';
import 'package:aidex/data/model/index_card.dart';
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
  Widget build(final BuildContext context) => IndexCardViewPage(
          card: IndexCard(
        1,
        deckId: deck.deckId!,
        title: 'Was ist das Skalarprodukt?',
        contentJson: '[{"insert":"hallo\\n"}]',
      ));
}
