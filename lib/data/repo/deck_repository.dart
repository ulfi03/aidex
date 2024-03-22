import 'package:aidex/data/provider/deck_provider.dart';

import 'package:aidex/model/deck.dart';

/// The deck repository.
class DeckRepository {
  /// Creates a new deck repository.
  DeckRepository({required final DeckProvider deckProvider})
  : _deckProvider = deckProvider;

  final DeckProvider _deckProvider;

  /// Fetches the decks.
  Future<List<Deck>> fetchDecks() async => _deckProvider.getDecks();

  /// Adds a deck.
  Future<void> addDeck(final Deck deck) async => _deckProvider.insert(deck);

  /// Removes all decks.
   Future<void> removeAllDecks() async => _deckProvider.deleteAll();
}
