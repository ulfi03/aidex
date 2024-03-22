import 'package:aidex/data/repo/deck_repository.dart';
import 'package:aidex/model/deck.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The deck business logic component.
class DeckOverviewBloc extends Bloc<DeckEvent, DeckState> {
  /// Creates a new deck business logic component.
  DeckOverviewBloc(this._deckRepository) : super(const DeckInitial()) {
    _initEventHandlers();
    add(const FetchDecks());
  }

  final DeckRepository _deckRepository;

  void _initEventHandlers() {
    on<FetchDecks>((final event, final emit) async {
      emit(const DecksLoading());
      try {
        final decks = await _deckRepository.fetchDecks();
        emit(DecksLoaded(decks: decks));
        print('Decks loaded in bloc');
      } on Exception catch (e) {
        emit(DecksError(message: e.toString()));
      }
    });
    on<AddDeck>((final event, final emit) async {
      try {
        await _deckRepository.addDeck(event.deck);
        add(const FetchDecks());
      } on Exception catch (e) {
        emit(DecksError(message: e.toString()));
      }
    });
    on<RemoveAllDecks>((final event, final emit) async {
      try {
        await _deckRepository.removeAllDecks();
        add(const FetchDecks());
      } on Exception catch (e) {
        emit(DecksError(message: e.toString()));
      }
    });
  }
}

/// ################################################################# States

/// The deck state.
abstract class DeckState {
  /// Creates a new deck state.
  const DeckState();
}

/// The deck initial state.
class DeckInitial extends DeckState {
  /// Creates a new deck initial state.
  const DeckInitial();
}

/// The deck loading state.
class DecksLoading extends DeckState {
  /// Creates a new deck loading state.
  const DecksLoading();

}

/// The deck loaded state.
class DecksLoaded extends DeckState {
  /// Creates a new deck loaded state.
  const DecksLoaded({required this.decks});

  /// The decks.
  final List<Deck> decks;

}

/// The deck error state.
class DecksError extends DeckState {
  /// Creates a new deck error state.
  const DecksError({required this.message});

  /// The error message.
  final String message;

}

/// ################################################################# Events

/// The deck event.
class DeckEvent {
  /// Creates a new deck event.
  const DeckEvent();
}

/// The fetch decks event.
class FetchDecks extends DeckEvent {
  /// Creates a new fetch decks event.
  const FetchDecks();
}

/// The event for removing all decks.
class RemoveAllDecks extends DeckEvent {
  /// Creates a new remove all decks event.
  const RemoveAllDecks();
}

/// The event for adding a deck.
class AddDeck extends DeckEvent {
  /// Creates a new add deck event.
  const AddDeck({required this.deck});

  /// The deck to add.
  final Deck deck;
}
