import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/data/repo/index_card_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The index card business logic component.
class IndexCardOverviewBloc extends Bloc<IndexCardEvent, IndexCardState> {
  /// Creates a new index card business logic component.
  IndexCardOverviewBloc(this._indexCardRepository, this._deckId)
      : super(const IndexCardInitial()) {
    _initEventHandlers();
    add(const FetchIndexCards());
  }

  final int _deckId;

  String _query = '';

  final List<IndexCard> _indexCards = List.empty(growable: true);

  final IndexCardRepository _indexCardRepository;

  void _initEventHandlers() {
    on<FetchIndexCards>((final event, final emit) async {
      _query = '';
      emit(IndexCardsLoading(query: _query));
      try {
        _indexCards.clear();
        // Fetch index cards and add elements to _indexCards
        (await _indexCardRepository.fetchIndexCards(_deckId))
            .forEach(_indexCards.add);
        emit(IndexCardsLoaded(indexCards: _indexCards, query: _query));
      } on Exception catch (e) {
        emit(IndexCardsError(message: e.toString()));
      }
    });
    on<AddIndexCard>((final event, final emit) async {
      try {
        await _indexCardRepository.addIndexCard(event.indexCard);
        add(const FetchIndexCards());
      } on Exception catch (e) {
        emit(IndexCardsError(message: e.toString()));
      }
    });
    on<UpdateSelectedIndexCards>((final event, final emit) async {
      emit(IndexCardSelectionMode(
          indexCardIds: event.indexCardIds, indexCards: _indexCards));
    });
    on<ExitIndexCardSelectionMode>((final event, final emit) async {
      emit(IndexCardsLoaded(indexCards: _indexCards, query: _query));
    });
    on<RemoveIndexCardsById>((final event, final emit) async {
      final bool success = await _indexCardRepository
          .removeIndexCards(event.selectedIndexCardsIds);
      if (success) {
        add(const FetchIndexCards());
      } else {
        emit(IndexCardsError(
            message:
                'Failed to delete index cards ${event.selectedIndexCardsIds}'));
      }
    });
    on<SearchIndexCards>((final event, final emit) async {
      emit(IndexCardsLoading(query: event.query));
      try {
        _query = event.query;
        _indexCards.clear();
        (await _indexCardRepository.searchIndexCards(_deckId, event.query))
            .forEach(_indexCards.add);
        emit(IndexCardsLoaded(indexCards: _indexCards, query: event.query));
      } on Exception catch (e) {
        emit(IndexCardsError(message: e.toString()));
      }
    });
    on<SortIndexCards>((final event, final emit) async {
      try {
        emit(IndexCardsLoading(query: _query));
        _indexCards.sort((final a, final b) {
          if (event.sortAsc) {
            return a.question.compareTo(b.question);
          } else {
            return b.question.compareTo(a.question);
          }
        });
        emit(IndexCardsLoaded(indexCards: _indexCards, query: _query));
      } on Exception catch (e) {
        emit(IndexCardsError(message: e.toString()));
      }
    });
  }
}

/// ################################################################# States

/// The index card state.
abstract class IndexCardState {
  /// Creates a new index card state.
  const IndexCardState();
}

/// The index card initial state.
class IndexCardInitial extends IndexCardState with EquatableMixin {
  /// Creates a new index card initial state.
  const IndexCardInitial();

  @override
  List<Object> get props => [];
}

/// The index card loading state.
class IndexCardsLoading extends IndexCardState with EquatableMixin {
  /// Creates a new index card loading state.
  IndexCardsLoading({required this.query});

  /// The query used to filter the index cards.
  final String query;

  @override
  List<Object> get props => [];
}

/// The index cards loaded state.
class IndexCardsLoaded extends IndexCardState with EquatableMixin {
  /// Creates a new index cards loaded state.
  const IndexCardsLoaded({required this.indexCards, required this.query});

  /// The index card list.
  final List<IndexCard> indexCards;

  /// The query used to filter the index cards.
  final String query;

  @override
  List<Object> get props => [indexCards];
}

/// The index card is selected
class IndexCardSelectionMode extends IndexCardState {
  /// Creates a new index card selected state.
  const IndexCardSelectionMode(
      {required this.indexCards, required this.indexCardIds});

  /// The index card ids.
  final List<int> indexCardIds;

  /// The indexCards in deck
  final List<IndexCard> indexCards;

  /// Check if the card is selected
  bool isThisCardSelected(final int indexCardId) =>
      indexCardIds.contains(indexCardId);
}

/// The index card error state.
class IndexCardsError extends IndexCardState with EquatableMixin {
  /// Creates a new index card error state.
  const IndexCardsError({required this.message});

  /// The error message.
  final String message;

  @override
  List<Object> get props => [message];
}

/// ################################################################# Events

/// The card event.
abstract class IndexCardEvent {
  /// Creates a new card event.
  const IndexCardEvent();
}

/// The fetch index cards event.
class FetchIndexCards extends IndexCardEvent {
  /// Creates a new fetch index cards event.
  const FetchIndexCards();
}

///The event for updating the list of selected IndexCards.
class UpdateSelectedIndexCards extends IndexCardEvent {
  /// Creates a new update selected index cardIds event.
  UpdateSelectedIndexCards({required this.indexCardIds});

  /// The index card ids that are selected.
  List<int> indexCardIds;
}

///The event to exit CardSelectionMode
class ExitIndexCardSelectionMode extends IndexCardEvent {
  ///Creates ExitIndexCardSelectionMode event
  const ExitIndexCardSelectionMode();
}

/// The event for removing index cards.
class RemoveIndexCardsById extends IndexCardEvent {
  /// Creates a new remove cards by id event.
  const RemoveIndexCardsById({required this.selectedIndexCardsIds});

  /// The selcted index card ids list.
  final List<int> selectedIndexCardsIds;
}

/// The event for adding a card.
class AddIndexCard extends IndexCardEvent {
  /// Creates a new add card event.
  const AddIndexCard({required this.indexCard});

  /// The IndexCard to add.
  final IndexCard indexCard;
}

/// Query for searching index cards.
class SearchIndexCards extends IndexCardEvent {
  /// Creates a new search index cards event.
  const SearchIndexCards({required this.query});

  /// The query to search for.
  final String query;
}

/// The event for sorting index cards.
class SortIndexCards extends IndexCardEvent {
  /// Creates a new sort index cards event.
  const SortIndexCards({required this.sortAsc});

  /// Whether to sort ascending.
  final bool sortAsc;
}
