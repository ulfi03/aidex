import 'dart:ui';

import 'package:aidex/data/model/deck.dart';
import 'package:aidex/data/repo/deck_repository.dart';
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
    on<DeleteDeck>((final event, final emit) async {
      try {
        await _deckRepository.deleteDeck(event.deck);
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
    on<RenameDeck>((final event, final emit) async {
      try {
        await _deckRepository.renameDeck(event.deck, event.newName);
      } on Exception catch (e) {
        emit(DecksError(message: e.toString()));
      }
    });
    on<ChangeDeckColor>((final event, final emit) async {
      try {
        await _deckRepository.changeDeckColor(event.deck, event.color);
      } on Exception catch (e) {
        emit(DecksError(message: e.toString()));
      }
    });
  }
}

// ################################################################# States

/// The deck state.
abstract class DeckState extends Equatable {
  /// Creates a new deck state.
  const DeckState();
}

/// The deck initial state.
class DeckInitial extends DeckState {
  /// Creates a new deck initial state.
  const DeckInitial();

  @override
  List<Object> get props => [];
}

/// The deck loading state.
class DecksLoading extends DeckState {
  /// Creates a new deck loading state.
  const DecksLoading();

  @override
  List<Object> get props => [];
}

/// The deck loaded state.
class DecksLoaded extends DeckState {
  /// Creates a new deck loaded state.
  const DecksLoaded({required this.decks});

  /// The decks.
  final List<Deck> decks;

  @override
  List<Object> get props => [decks];
}

/// The deck error state.
class DecksError extends DeckState {
  /// Creates a new deck error state.
  const DecksError({required this.message});

  /// The error message.
  final String message;

  @override
  List<Object> get props => [message];
}

// ################################################################# Events

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

/// Represents an event for deleting a deck.
class DeleteDeck extends DeckEvent {
  /// Creates a new delete deck event.
  const DeleteDeck({required this.deck});

  /// The deck to delete.
  final Deck deck;
}

/// [RenameDeck] is an event triggered when a deck needs to be renamed.
///
/// It requires a [Deck] object that needs to be renamed and a [String]
/// representing the new name.
class RenameDeck extends DeckEvent {
  /// Creates a [RenameDeck] event.
  ///
  /// Requires the [Deck] to be renamed and the new name as a [String].
  const RenameDeck({required this.deck, required this.newName});

  /// The [Deck] that needs to be renamed.
  final Deck deck;

  /// The new name for the deck.
  final String newName;
}

/// [ChangeDeckColor] is an event triggered when a deck's color needs to be
class ChangeDeckColor extends DeckEvent {
  /// Creates a [ChangeDeckColor] event.
  const ChangeDeckColor({required this.deck, required this.color});

  /// The deck to change the color of.
  final Deck deck;

  /// The new color for the deck.
  final Color color;
}
