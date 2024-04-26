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

  /// The index cards of the deck.
  List<IndexCard>? indexCards;

  final IndexCardRepository _indexCardRepository;

  void _initEventHandlers() {
    on<FetchIndexCards>((final event, final emit) async {
      emit(const IndexCardsLoading());
      try {
        indexCards = await _indexCardRepository.fetchIndexCards(_deckId);
        emit(IndexCardsLoaded(indexCards: indexCards!));
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
      event.pushToHistory;
      emit(IndexCardSelectionMode(
          indexCardIds: event.indexCardIds,
          indexCards: indexCards!,
          selectedCardsHistory:
              UpdateSelectedIndexCards.selectedCardIdsHistory));
    });
    on<ExitIndexCardSelectionMode>((final event, final emit) async {
      emit(IndexCardsLoaded(indexCards: indexCards!));
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
  const IndexCardsLoading();

  @override
  List<Object> get props => [];
}

/// The index cards loaded state.
class IndexCardsLoaded extends IndexCardState with EquatableMixin {
  /// Creates a new index cards loaded state.
  const IndexCardsLoaded({required this.indexCards});

  /// The index card list.
  final List<IndexCard> indexCards;

  @override
  List<Object> get props => [indexCards];
}

/// The index card is selected
class IndexCardSelectionMode extends IndexCardState {
  /// Creates a new index card selected state.
  const IndexCardSelectionMode(
      {required this.indexCards,
      required this.indexCardIds,
      required this.selectedCardsHistory});

  /// The index card ids.
  final List<int> indexCardIds;

  /// The indexCards in deck
  final List<IndexCard> indexCards;

  /// The selected cards history (2 Items max)
  final List<List<int>> selectedCardsHistory;

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
class IndexCardEvent {
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

  /// The history of selected index cards
  static final List<List<int>> selectedCardIdsHistory = [];

  /// Push the selected index card ids to history (store only last 2 selections)
  void get pushToHistory {
    if (selectedCardIdsHistory.length == 2) {
      selectedCardIdsHistory.removeAt(0);
    }
    selectedCardIdsHistory.add(indexCardIds);
  }
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
