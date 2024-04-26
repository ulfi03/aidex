import 'package:aidex/bloc/index_cards_overview_bloc.dart';
import 'package:aidex/data/model/deck.dart';
import 'package:aidex/data/repo/index_card_repository.dart';
import 'package:aidex/ui/components/error_display_widget.dart';
import 'package:aidex/ui/deck-view/card_serach_bar.dart';
import 'package:aidex/ui/deck-view/index_card_item_widget.dart';
import 'package:aidex/ui/routes.dart';
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
      create: (final context) => IndexCardOverviewBloc(
          context.read<IndexCardRepository>(), deck.deckId!),
      child: IndexCardOverview(deck: deck));
}

/// The view of the index cards.
class IndexCardOverview extends StatelessWidget {
  /// Constructor for the [IndexCardOverview].
  const IndexCardOverview({required this.deck, super.key});

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
          Padding(
              padding: const EdgeInsets.all(8),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Expanded(
                    child: CardSearchBar(
                        indexCardOverviewBloc:
                            context.read<IndexCardOverviewBloc>())),
                AddCardButton(deck: deck)
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
                  return const Center(child: Text('No index cards found!'));
                } else {
                  return SingleChildScrollView(
                    child: Wrap(
                      children: state.indexCards
                          .map((final indexCard) => IndexCardItemWidget(
                                indexCard: indexCard,
                                onTap: (final context) async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (final context) =>
                                          ItemOnDeckViewWidgetSelectedRoute(
                                        indexCard: indexCard,
                                        deckName: deck.name,
                                      ),
                                    ),
                                  ).then((final value) => context
                                      .read<IndexCardOverviewBloc>()
                                      .add(const FetchIndexCards()));
                                },
                              ))
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

/// The state of the AddCardButton.
class AddCardButton extends StatelessWidget {
  /// Constructor for the [AddCardButton].
  const AddCardButton({required final Deck deck, super.key}) : _deck = deck;

  final Deck _deck;

  @override
  Widget build(final BuildContext context) => FloatingActionButton(
        onPressed: () => onAddCardButtonPressed(context),
        backgroundColor: mainTheme.colorScheme.primary,
        child: const Icon(Icons.add),
      );

  /// Handles the addCard event when button is pressed.
  Future<void> onAddCardButtonPressed(
    final BuildContext context,
  ) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(
          builder: (final context) =>
              IndexCardCreateRoute(deckId: _deck.deckId!, deckName: _deck.name),
        ))
        .then((final value) => context.read<IndexCardOverviewBloc>().add(
              const FetchIndexCards(),
            ));
  }
}
