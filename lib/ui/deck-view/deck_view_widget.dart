import 'package:aidex/bloc/index_cards_overview_bloc.dart';
import 'package:aidex/data/model/deck.dart';
import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/data/repo/index_card_repository.dart';
import 'package:aidex/ui/components/error_display_widget.dart';
import 'package:aidex/ui/deck-view/index_card_item_Widget.dart';
import 'package:aidex/ui/theme/aidex_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///This widget is used to display the deck view.
class DeckViewWidgetPage extends StatelessWidget {
  /// Constructor for the [DeckViewWidgetPage].
  const DeckViewWidgetPage({required this.deck, super.key});

  /// The deck to be displayed.
  final Deck deck;

  @override
  Widget build(final BuildContext context) => BlocProvider(
      create: (final context) =>
          IndexCardOverviewBloc(context.read<IndexCardRepository>()),
      child: DeckViewWidget(deck: deck));
}

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
        centerTitle: true,
        title: Text(deck.name),
      ),
      body: Column(
        children: [
          const Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: CardSearchBar()),
                    AddCardButton()
                  ])),
          BlocBuilder<IndexCardOverviewBloc, IndexCardState>(
              builder: (final context, final state) {
            if (state is IndexCardsLoading) {
              return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                  mainTheme.colorScheme.primary,
                )),
              );
            } else if (state is IndexCardsLoaded) {
              return Expanded(child: () {
                if (state.indexCards.isEmpty) {
                  return Center(child: Text('Content of ${deck.name}'));
                } else {
                  return SingleChildScrollView(
                    child: Wrap(
                      children: state.indexCards
                          .map((final indexCard) =>
                              IndexCardItemWidget(indexCard: indexCard))
                          .toList(),
                    ),
                  );
                }
              }());
            } else if (state is IndexCardsError) {
              return ErrorDisplayWidget(errorMessage: state.message);
            } else {
              return const ErrorDisplayWidget(
                  errorMessage: 'Something went wrong!');
            }
          }),
        ],
      ));
}

/// This widget is used to display the search bar.
class CardSearchBar extends StatefulWidget {
  /// Constructor for the [SearchBar].
  const CardSearchBar({super.key});

  @override
  SearchBarState createState() => SearchBarState();
}

/// The state of the [SearchBar].
class SearchBarState extends State<CardSearchBar> {
  /// Whether to search by label.
  bool sort = false;

  @override
  Widget build(final BuildContext context) => SearchAnchor(
      isFullScreen: false,
      viewConstraints: const BoxConstraints(minHeight: 100, maxHeight: 230),
      builder: (final context, final controller) => SearchBar(
            controller: controller,
            padding: const MaterialStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16)),
            onTap: controller.openView,
            onChanged: (final _) {
              controller.openView();
            },
            leading: const Icon(Icons.search),
            trailing: <Widget>[
              Tooltip(
                message: 'Toggle Sort',
                child: IconButton(
                  isSelected: sort,
                  onPressed: () {
                    setState(() {
                      sort = !sort;
                    });
                  },
                  icon: const Icon(Icons.type_specimen_outlined),
                  selectedIcon: const Icon(Icons.type_specimen),
                ),
              )
            ],
          ),
      suggestionsBuilder: (final context, final controller) =>
          List<ListTile>.generate(50, (final index) {
            final String item = 'Card $index';
            return ListTile(
              title: Text(item),
              onTap: () {
                setState(() {
                  controller.closeView(item);
                });
              },
            );
          }));
}

/// The widget used to display AddCardButton.
class AddCardButton extends StatefulWidget {
  /// Constructor for the [AddCardButton] widget.
  const AddCardButton({super.key});

  @override
  AddCardButtonState createState() => AddCardButtonState();
}

/// The state of the AddCardButton.
class AddCardButtonState extends State<AddCardButton> {
  @override
  Widget build(final BuildContext context) => FloatingActionButton(
        onPressed: () => onAddCardButtonPressed(context),
        backgroundColor: mainTheme.colorScheme.primary,
        child: const Icon(Icons.add),
      );

  /// Handles the addCard event when button is pressed.
  Future<void> onAddCardButtonPressed(final BuildContext context) async {
    final parentDeck = context.read<DeckViewWidget>().deck;
    final indexCardId = context.read<IndexCardsLoaded>().indexCards.length;
    context.read<IndexCardOverviewBloc>().add(AddIndexCard(
        indexCard: IndexCard(indexCardId,
            title: 'Added Card',
            contentJson: 'Lorem Ipsum',
            deckId: parentDeck.deckId!)));
    parentDeck.cardsCount++;
  }
}
