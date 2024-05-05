import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/data/repo/index_card_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// [LearningFunctionBloc] is a bloc that manages the learning functions.
/// It extends the Bloc class from the flutter_bloc package, with
/// [LearningFunctionEvent] as the event type and [LearningFunctionState] as
///  the state type.
class LearningFunctionBloc
    extends Bloc<LearningFunctionEvent, LearningFunctionState> {
  /// Creates a new learning function bloc.
  LearningFunctionBloc(this._indexCardRepository, final int deckId)
      : super(const LearningFunctionInitial()) {
    _initEventHandlers();
    add(LoadIndexCardsEvent(deckId: deckId));
  }

  /// [_indexCardRepository] is a private final field of type
  /// [IndexCardRepository].
  /// It is used to fetch index cards.
  final IndexCardRepository _indexCardRepository;

  /// [_indexCards] is a private field of type List<IndexCard>.
  /// It is used to store the index cards fetched from the repository.
  List<IndexCard> _indexCards = [];

  /// [_currentIndex] is a private field of type int.
  /// It is used to keep track of the current index of the loaded card.
  int _currentIndex = 0;

  /// [_initEventHandlers] is a private method that initializes the event
  /// handlers for the bloc.
  /// It defines the behavior of the bloc when a [PreviousIndexCardEvent]
  /// or a [NextIndexCardEvent] is dispatched.
  void _initEventHandlers() {
    on<LoadIndexCardsEvent>((final event, final emit) async {
      emit(const IndexCardLoading());
      try {
        _indexCards = await _indexCardRepository.fetchIndexCards(event.deckId);
        if (_indexCards.isNotEmpty) {
          emit(IndexCardLoaded(
              indexCard: _indexCards[_currentIndex],
              cardsCount: _indexCards.length,
              currentIndex: _currentIndex));
        } else {
          emit(const IndexCardError(message: 'No index cards found'));
        }
      } on Exception catch (e) {
        if (kDebugMode) {
          print(e);
        }
        emit(const IndexCardError(message: 'Failed to load index cards'));
      }
    });

    on<PreviousIndexCardEvent>((final event, final emit) async {
      if (_currentIndex > 0) {
        _currentIndex--;
        emit(IndexCardLoaded(
            indexCard: _indexCards[_currentIndex],
            cardsCount: _indexCards.length,
            currentIndex: _currentIndex));
      }
    });

    on<NextIndexCardEvent>((final event, final emit) async {
      if (_currentIndex < _indexCards.length - 1) {
        _currentIndex++;
        emit(IndexCardLoaded(
            indexCard: _indexCards[_currentIndex],
            cardsCount: _indexCards.length,
            currentIndex: _currentIndex));
      }
    });
  }
}

// ################################################################# States

/// [LearningFunctionState] is an abstract class that represents the different
/// states
/// for the [LearningFunctionBloc].
abstract class LearningFunctionState extends Equatable {
  /// define const constructor for [LearningFunctionState]
  const LearningFunctionState();
}

/// [LearningFunctionInitial] is a state that represents the initial state of
class LearningFunctionInitial extends LearningFunctionState {
  /// define const constructor for [LearningFunctionInitial]
  const LearningFunctionInitial();

  @override
  List<Object> get props => [];
}

/// [IndexCardLoading] is a state that represents the loading state of
/// index cards.
class IndexCardLoading extends LearningFunctionState {
  /// define const constructor for [IndexCardLoading]
  const IndexCardLoading();

  @override
  List<Object> get props => [];
}

/// [IndexCardLoaded] is a state that represents the loaded state of index cards
class IndexCardLoaded extends LearningFunctionState {
  /// define const constructor for [IndexCardLoaded]
  const IndexCardLoaded(
      {required this.indexCard,
      required this.cardsCount,
      required this.currentIndex});

  /// The loaded index card.
  final IndexCard indexCard;

  /// the count of the cards.
  final int cardsCount;

  /// The current index of the loaded card.
  final int currentIndex;

  @override
  List<Object> get props => [indexCard, currentIndex];
}

/// [IndexCardError] is a state that represents the error state of index cards.
/// It takes a [String] message as a parameter.
class IndexCardError extends LearningFunctionState {
  /// define const constructor for [IndexCardError]
  const IndexCardError({required this.message});

  /// The error message.
  final String message;

  @override
  List<Object> get props => [message];
}

// ################################################################# Events

/// [LearningFunctionEvent] is an abstract class that represents the different
///  events
/// for the [LearningFunctionBloc].
abstract class LearningFunctionEvent {
  /// define const constructor for [LearningFunctionEvent]
  const LearningFunctionEvent();
}

/// [LoadIndexCardsEvent] is an event that triggers the loading of index cards.
class LoadIndexCardsEvent extends LearningFunctionEvent {
  /// define const constructor for [LoadIndexCardsEvent]
  const LoadIndexCardsEvent({required this.deckId});

  /// The id of the deck.
  final int deckId;
}

/// [PreviousIndexCardEvent] is an event that triggers the loading of the
///  previous index card.
class PreviousIndexCardEvent extends LearningFunctionEvent {
  /// define const constructor for [PreviousIndexCardEvent]
  const PreviousIndexCardEvent();
}

/// [NextIndexCardEvent] is an event that triggers the loading of the next
///  index card.
class NextIndexCardEvent extends LearningFunctionEvent {
  /// define const constructor for [NextIndexCardEvent]
  const NextIndexCardEvent();
}
