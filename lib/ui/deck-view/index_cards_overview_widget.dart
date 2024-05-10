import 'package:aidex/bloc/index_cards_overview_bloc.dart';
import 'package:aidex/data/model/deck.dart';
import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/data/repo/index_card_repository.dart';
import 'package:aidex/ui/components/app_bar_components.dart';
import 'package:aidex/ui/components/error_display_widget.dart';
import 'package:aidex/ui/deck-view/card_serach_bar.dart';
import 'package:aidex/ui/deck-view/index_card_delete_dialog.dart';
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

  /// The key to find the arrow_back button
  static const arrowBackButtonKey = Key('arrowBackButton');

  /// The key to find the deleteButton
  static const deleteButtonKey = Key('deleteButton');

  /// The key to find the selectAllButton (unchecked)
  static const selectAllButtonUncheckedKey = Key('selectAllButton_unchecked');

  /// The key to find the selectAllButton (checked)
  static const selectAllButtonCheckedKey = Key('selectAllButton_checked');

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(
            leading: BlocBuilder<IndexCardOverviewBloc, IndexCardState>(
                builder: (final context, final state) => IconButton(
                      key: arrowBackButtonKey,
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        if (state is IndexCardSelectionMode) {
                          context
                              .read<IndexCardOverviewBloc>()
                              .add(const ExitIndexCardSelectionMode());
                        } else {
                          Navigator.pop(context);
                        }
                      },
                    )),
            centerTitle: true,
            title: Text(deck.name),
            bottom: DeckColorIndicator(color: deck.color),
            actions: _getActions(context)),
        body: _buildBody(),
        floatingActionButton: _buildFloatingButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      );

  Widget _buildBody() => Column(
        children: [
          _buildSearchBarRow(),
          Expanded(child: _buildIndexCardsContainer())
        ],
      );

  /// Builds the search bar row.
  Widget _buildSearchBarRow() =>
      BlocBuilder<IndexCardOverviewBloc, IndexCardState>(
          buildWhen: (final previous, final current) =>
              current is IndexCardInitial ||
              current is IndexCardSelectionMode ||
              current is IndexCardsLoaded && previous is IndexCardSelectionMode,
          builder: (final context, final state) {
            if (state is! IndexCardSelectionMode) {
              return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: CardSearchBar(
                                indexCardOverviewBloc:
                                    context.read<IndexCardOverviewBloc>(),
                                query: getQuery(state))),
                        AddCardButton(deck: deck)
                      ]));
            } else {
              return const SizedBox.shrink();
            }
          });

  Widget _buildIndexCardsContainer() =>
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
          return IndexCardsContainer(state: state, deck: deck);
        } else if (state is IndexCardsLoaded) {
          return IndexCardsContainer(
            state: state,
            deck: deck,
          );
        } else if (state is IndexCardsError) {
          return ErrorDisplayWidget(errorMessage: state.message);
        } else {
          return const ErrorDisplayWidget(
              errorMessage: 'Something went wrong!');
        }
      });

  Widget _buildFloatingButton() =>
      BlocBuilder<IndexCardOverviewBloc, IndexCardState>(
          builder: (final context, final state) {
        if (state is IndexCardsLoaded && state.indexCards.isNotEmpty) {
          return FloatingActionButton(
            heroTag: 'playButton',
            backgroundColor: mainTheme.colorScheme.primary,
            child: const Icon(Icons.play_arrow),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (final context) => LearningFunctionRoute(deck: deck),
                ),
              );
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      });
}

/// Contains the index cards of current deck.
class IndexCardsContainer extends StatelessWidget {
  /// Constructor for the [IndexCardsContainer].
  const IndexCardsContainer(
      {required final IndexCardState state,
      required final Deck deck,
      super.key})
      : _state = state,
        _deck = deck;

  /// state to determine indexCards, selectedCards and selectedMode
  final IndexCardState _state;

  /// The name of the deck for routing.
  final Deck _deck;

  /// Returns the index cards based on the state.
  List<IndexCard> get indexCards => (_state is IndexCardsLoaded)
      ? _state.indexCards
      : (_state as IndexCardSelectionMode).indexCards;

  @override
  Widget build(final BuildContext context) => (indexCards.isEmpty)
      ? Center(
          child: Text('No index cards found, create one!',
              style: mainTheme.textTheme.bodyMedium))
      : SingleChildScrollView(
          padding: EdgeInsets.only(
              bottom: mainTheme
                      .floatingActionButtonTheme.sizeConstraints!.maxHeight *
                  2),
          child: Wrap(
            children: _getIndexCardItems(context),
          ),
        );

  List<Widget> _getIndexCardItems(final BuildContext context) => indexCards
      .map((final indexCard) => IndexCardItemWidget(
            ordinalNo: indexCards.indexOf(indexCard) + 1,
            indexCard: indexCard,
            state: _state,
            onTap: (final context) async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (final context) => ItemOnDeckViewWidgetSelectedRoute(
                    indexCard: indexCard,
                    deck: _deck,
                  ),
                ),
              ).then((final value) => context
                  .read<IndexCardOverviewBloc>()
                  .add(SearchIndexCards(query: getQuery(_state))));
            },
          ))
      .toList();
}

/// Returns the query based on the state.
String getQuery(final IndexCardState state) {
  if (state is IndexCardsLoading) {
    return state.query;
  } else if (state is IndexCardsLoaded) {
    return state.query;
  } else {
    return '';
  }
}

/// The state of the AddCardButton.
class AddCardButton extends StatelessWidget {
  /// Constructor for the [AddCardButton].
  const AddCardButton({required final Deck deck, super.key}) : _deck = deck;

  final Deck _deck;

  @override
  Widget build(final BuildContext context) => FloatingActionButton(
        heroTag: 'addButton',
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
          builder: (final context) => IndexCardCreateRoute(deck: _deck),
        ))
        .then((final value) => context.read<IndexCardOverviewBloc>().add(
              const FetchIndexCards(),
            ));
  }
}

List<Widget> _getActions(final BuildContext context) => [
      BlocBuilder<IndexCardOverviewBloc, IndexCardState>(
          builder: (final context, final state) {
        bool isSelectAllButtonChecked = state is IndexCardSelectionMode &&
            state.indexCards.length == state.indexCardIds.length;
        return Visibility(
            visible: state is IndexCardSelectionMode,
            child: StatefulBuilder(
              builder: (final context, final setState) => IconButton(
                icon: isSelectAllButtonChecked
                    ? Icon(
                        key: IndexCardOverview.selectAllButtonCheckedKey,
                        Icons.check_circle,
                        color: mainTheme.colorScheme.primary,
                      )
                    : Icon(
                        key: IndexCardOverview.selectAllButtonUncheckedKey,
                        Icons.circle_outlined,
                        color: mainTheme.colorScheme.primary,
                      ),
                onPressed: (state is IndexCardSelectionMode)
                    ? () {
                        _onSelectAll(context, state, isSelectAllButtonChecked);
                        setState(() {
                          isSelectAllButtonChecked = !isSelectAllButtonChecked;
                        });
                      }
                    : () => {},
              ),
            ));
      }),
      BlocBuilder<IndexCardOverviewBloc, IndexCardState>(
          builder: (final context, final state) => Visibility(
              key: IndexCardOverview.deleteButtonKey,
              visible: state is IndexCardSelectionMode &&
                  state.indexCardIds.isNotEmpty,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: mainTheme.colorScheme.primary,
                  ),
                  onPressed: (state is IndexCardSelectionMode)
                      ? () => _onRemove(context, state.indexCardIds)
                      : () => {}))),
    ];

/// Handle the delete button.
/// -> initiate a dialog to confirm the deletion of the selected index cards.
Future<void> _onRemove(
    final BuildContext context, final List<int> indexCardIds) async {
  final IndexCardOverviewBloc indexCardOverviewBloc =
      context.read<IndexCardOverviewBloc>();
  await showDialog(
    context: context,
    builder: (final context) => BlocProvider.value(
        value: indexCardOverviewBloc,
        child: DeleteIndexCardsDialog(indexCardIds: indexCardIds)),
  );
}

/// Handles the Button to select all index cards or deselect them.
void _onSelectAll(final BuildContext context,
    final IndexCardSelectionMode state, final bool selectAllChecked) {
  if (!selectAllChecked) {
    final selectedIndexCardIds = state.indexCards
        .map((final indexCard) => indexCard.indexCardId!)
        .toList();
    context
        .read<IndexCardOverviewBloc>()
        .add(UpdateSelectedIndexCards(indexCardIds: selectedIndexCardIds));
  } else {
    /// get selected card ids before all cards where selected
    context
        .read<IndexCardOverviewBloc>()
        .add(UpdateSelectedIndexCards(indexCardIds: []));
  }
}
