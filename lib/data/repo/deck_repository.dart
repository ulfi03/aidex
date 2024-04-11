import 'package:aidex/data/model/deck.dart';
import 'package:aidex/data/provider/deck_provider.dart';

/// The deck repository.
class DeckRepository {
  /// Creates a new deck repository.
  DeckRepository({required final DeckProvider deckProvider})
      : _deckProvider = deckProvider;

  final DeckProvider _deckProvider;
  /// Returns the id of the last deck.
  Future<int> getLastDeckId() async => _deckProvider.getLastDeckId();
  /// Fetches the decks.
  Future<List<Deck>> fetchDecks() async => _deckProvider.getDecks();
  /// Fetches a deck by its id.
  Future<Deck?> fetchDeckById(final int deckId) async =>
      _deckProvider.getDeck(deckId);

  /// Adds a deck.
  Future<Deck> addDeck(final Deck deck) async => _deckProvider.insert(deck);

  /// Deletes a deck.
  Future<void> deleteDeck(final Deck deck) async =>
      _deckProvider.delete(deck.deckId!);

  /// Removes all decks.
  Future<void> removeAllDecks() async => _deckProvider.deleteAll();
}
