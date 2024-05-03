import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/data/repo/index_card_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// [LearningFunctionState] is an abstract class that represents the different
/// states
/// for the [LearningFunctionBloc].
abstract class LearningFunctionState extends Equatable {
  const LearningFunctionState();
}

/// [IndexCardLoading] is a state that represents the loading state of
/// index cards.
class IndexCardLoading extends LearningFunctionState {
  const IndexCardLoading();

  @override
  List<Object> get props => [];
}

/// [IndexCardLoaded] is a state that represents the loaded state of index cards
class IndexCardLoaded extends LearningFunctionState {
  const IndexCardLoaded({required this.indexCard, required this.currentIndex});

  /// The loaded index card.
  final IndexCard indexCard;

  /// The current index of the loaded card.
  final int currentIndex;

  @override
  List<Object> get props => [indexCard, currentIndex];
}

/// [LearningFunctionEvent] is an abstract class that represents the different
///  events
/// for the [LearningFunctionBloc].
abstract class LearningFunctionEvent {
  const LearningFunctionEvent();
}

/// [PreviousIndexCardEvent] is an event that triggers the loading of the
///  previous index card.
class PreviousIndexCardEvent extends LearningFunctionEvent {
  const PreviousIndexCardEvent();
}

/// [NextIndexCardEvent] is an event that triggers the loading of the next
///  index card.
class NextIndexCardEvent extends LearningFunctionEvent {
  const NextIndexCardEvent();
}

/// [LearningFunctionBloc] is a bloc that manages the learning functions.
/// It extends the Bloc class from the flutter_bloc package, with
/// [LearningFunctionEvent] as the event type and [LearningFunctionState] as
///  the state type.
class LearningFunctionBloc
    extends Bloc<LearningFunctionEvent, LearningFunctionState> {
  /// Constructor for [LearningFunctionBloc]. It takes an [IndexCardRepository]
  ///  and a deckId as parameters.
  /// The constructor also calls the [_initEventHandlers] method and the
  /// [loadIndexCards] method.
  LearningFunctionBloc(this._indexCardRepository, final int deckId)
      : super(const IndexCardLoading()) {
    _initEventHandlers();
    loadIndexCards(deckId); // call loadIndexCards method here
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
    on<PreviousIndexCardEvent>((final event, final emit) async {
      if (_currentIndex > 0) {
        _currentIndex--;
        emit(IndexCardLoaded(
            indexCard: _indexCards[_currentIndex],
            currentIndex: _currentIndex));
      }
    });

    on<NextIndexCardEvent>((final event, final emit) async {
      if (_currentIndex < _indexCards.length - 1) {
        _currentIndex++;
        emit(IndexCardLoaded(
            indexCard: _indexCards[_currentIndex],
            currentIndex: _currentIndex));
      }
    });
  }

  /// [loadIndexCards] is a method that loads index cards from the repository.
  /// It takes a deckId as a parameter.
  Future<void> loadIndexCards(final int deckId) async {
    _indexCards = await _indexCardRepository.fetchIndexCards(deckId);
    if (_indexCards.isNotEmpty) {
      emit(IndexCardLoaded(
          indexCard: _indexCards[_currentIndex], currentIndex: _currentIndex));
    }
  }
}
