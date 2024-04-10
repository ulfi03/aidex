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
    on<IndexCardLongPressed>((final event, final emit) async {
      emit(IndexCardSelectionMode(
          indexCardId: event.indexCardId, indexCards: indexCards!));
    });
    on<ExitIndexCardSelectionMode>((final event, final emit) async {
      emit(IndexCardsLoaded(indexCards: indexCards!));
    });
    on<RemoveIndexCard>((final event, final emit) async {
      final bool success =
          await _indexCardRepository.removeIndexCard(event.indexCardId);
      if (success) {
        add(const FetchIndexCards());
      } else {
        emit(const IndexCardsError(message: 'Failed to delete index card!'));
      }
    });
    on<RemoveAllIndexCards>((final event, final emit) async {
      try {
        await _indexCardRepository.removeAllIndexCards(_deckId);
        add(const FetchIndexCards());
      } on Exception catch (e) {
        emit(IndexCardsError(message: e.toString()));
      }
    });
  }
}

/// ################################################################# States

/// The index card state.
abstract class IndexCardState extends Equatable {
  /// Creates a new index card state.
  const IndexCardState();
}

/// The index card initial state.
class IndexCardInitial extends IndexCardState {
  /// Creates a new index card initial state.
  const IndexCardInitial();

  @override
  List<Object> get props => [];
}

/// The index card loading state.
class IndexCardsLoading extends IndexCardState {
  /// Creates a new index card loading state.
  const IndexCardsLoading();

  @override
  List<Object> get props => [];
}

/// The index cards loaded state.
class IndexCardsLoaded extends IndexCardState {
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
      {required this.indexCardId, required this.indexCards});

  /// The index card id.
  final int indexCardId;

  /// The indexCards in deck
  final List<IndexCard> indexCards;

  @override
  List<Object> get props => [indexCardId];
}

/// The index card error state.
class IndexCardsError extends IndexCardState {
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

///The event for selecting an index card.
class IndexCardLongPressed extends IndexCardEvent {
  /// Creates a new select card event.
  const IndexCardLongPressed({required this.indexCardId});

  /// The index card id.
  final int indexCardId;
}

class ExitIndexCardSelectionMode extends IndexCardEvent {
  const ExitIndexCardSelectionMode();
}

/// The event for removing a card.
class RemoveIndexCard extends IndexCardEvent {
  /// Creates a new remove card event.
  const RemoveIndexCard({required this.indexCardId});

  /// The index card id.
  final int indexCardId;
}

/// The event for removing all cards.
class RemoveAllIndexCards extends IndexCardEvent {
  /// Creates a new remove all cards event.
  const RemoveAllIndexCards();
}

/// The event for adding a card.
class AddIndexCard extends IndexCardEvent {
  /// Creates a new add card event.
  const AddIndexCard({required this.indexCard});

  /// The IndexCard to add.
  final IndexCard indexCard;
}
