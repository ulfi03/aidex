import 'package:aidex/bloc/index_cards_overview_bloc.dart';
import 'package:aidex/data/model/deck.dart';
import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/data/repo/index_card_repository.dart';
import 'package:aidex/ui/components/error_display_widget.dart';
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

/// A widget used to display the deck view.
///
/// The [IndexCardOverview] requires a [deck] to be provided.
class IndexCardOverview extends StatelessWidget {
  /// Constructor for the [IndexCardOverview].
  const IndexCardOverview({required this.deck, super.key});

  /// The deck to be displayed.
  final Deck deck;

  @override
  Widget build(final BuildContext context) =>
      BlocBuilder<IndexCardOverviewBloc, IndexCardState>(
        buildWhen: (final previous, final current) =>
            current is IndexCardInitial ||
            current is IndexCardsLoaded ||
            current is IndexCardSelectionMode,
        builder: (final context, final state) => Scaffold(
            appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: (state is IndexCardSelectionMode)
                      ? () => context
                          .read<IndexCardOverviewBloc>()
                          .add(const ExitIndexCardSelectionMode())
                      : () => Navigator.pop(context),
                ),
                centerTitle: true,
                title: Text(deck.name),
                actions: _getActions(context, state)),
            body: Column(
              children: [
                if (state is! IndexCardSelectionMode)
                  Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Expanded(child: CardSearchBar()),
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
                  } else if (state is IndexCardSelectionMode) {
                    return IndexCardsContainer(
                        indexCards: state.indexCards,
                        deckName: deck.name,
                        isSelected: true);
                  } else if (state is IndexCardsLoaded) {
                    return IndexCardsContainer(
                        indexCards: state.indexCards,
                        deckName: deck.name,
                        isSelected: false);
                  } else if (state is IndexCardsError) {
                    return ErrorDisplayWidget(errorMessage: state.message);
                  } else {
                    return const ErrorDisplayWidget(
                        errorMessage: 'Something went wrong!');
                  }
                }),
              ],
            )),
      );
}

/// Contains the index cards of current deck.
class IndexCardsContainer extends StatelessWidget {
  /// Constructor for the [IndexCardsContainer].
  const IndexCardsContainer(
      {required final List<IndexCard> indexCards,
      required final String deckName,
      required final bool isSelected,
      super.key})
      : _deckName = deckName,
        _indexCards = indexCards,
        _isSelected = isSelected;

  /// The index cards to be displayed.
  final List<IndexCard> _indexCards;

  /// The name of the deck for routing.
  final String _deckName;

  /// Whether the index card is selected.
  final bool _isSelected;

  @override
  Widget build(final BuildContext context) => Expanded(
      child: (_indexCards.isEmpty)
          ? const Center(child: Text('No index cards found!'))
          : SingleChildScrollView(
              child: Wrap(
                children: _indexCards
                    .map((final indexCard) => IndexCardItemWidget(
                          indexCard: indexCard,
                          onTap: (final context) async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (final context) =>
                                    ItemOnDeckViewWidgetSelectedRoute(
                                  indexCard: indexCard,
                                  deckName: _deckName,
                                ),
                              ),
                            ).then((final value) => context
                                .read<IndexCardOverviewBloc>()
                                .add(const FetchIndexCards()));
                          },
                        ))
                    .toList(),
              ),
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

  ///Key to identify the sort button (for testing).
  static const Key sortButtonKey = Key('sortButton');

  ///Icon for IconButton when indexCards are unsorted.
  static const Icon unsortedIcon = Icon(Icons.type_specimen_outlined);

  ///Icon for IconButton when indexCards are sorted.
  static const Icon sortedIcon = Icon(Icons.type_specimen);

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
                  key: sortButtonKey,
                  isSelected: sort,
                  onPressed: () {
                    setState(() {
                      sort = !sort;
                    });
                  },
                  icon: unsortedIcon,
                  selectedIcon: sortedIcon,
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

List<Widget> _getActions(
    final BuildContext context, final IndexCardState state) {
  if (state is IndexCardSelectionMode) {
    return [
      IconButton(
        icon: Icon(
          Icons.delete,
          color: mainTheme.colorScheme.primary,
        ),
        onPressed: () => _onRemove(context, state.indexCardId),
      )
    ];
  } else {
    return [];
  }
}

/// The state of the DeleteCardButton.
void _onRemove(final BuildContext context, final int indexCardId) {
  context
      .read<IndexCardOverviewBloc>()
      .add(RemoveIndexCard(indexCardId: indexCardId));
}
