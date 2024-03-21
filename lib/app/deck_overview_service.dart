import 'package:aidex/model/deck.dart';
import 'package:aidex/repo/deck_repository.dart';

/// The deck overview service.
class DeckOverviewService {
  /// Constructor for the [DeckOverviewService].
  DeckOverviewService(this._deckRepository) {
    print('DeckOverviewService()');
  }

  final DeckRepository _deckRepository;

  /// Returns all decks from the database.
  Future<List<Deck>> getDecks() async => _deckRepository.getDecks();

  /// Add deck to the database
  Future<Deck> addDeck(final Deck deck) async => _deckRepository.insert(deck);

  /// Delete deck from the database
  Future<void> deleteDeck(final int id) async => _deckRepository.delete(id);
}
