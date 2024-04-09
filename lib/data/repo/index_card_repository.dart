import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/data/provider/index_card_provider.dart';

/// The index card repository.
class IndexCardRepository {
  /// Creates a new index card repository.
  IndexCardRepository({required final IndexCardProvider indexCardProvider})
      : _indexCardProvider = indexCardProvider;

  final IndexCardProvider _indexCardProvider;

  /// Fetches the index cards.
  Future<List<IndexCard>> fetchIndexCards(final int deckId) async =>
      _indexCardProvider.getIndexCards(deckId);

  /// Fetches an index card.
  Future<IndexCard?> fetchIndexCard(final int indexCardId) async =>
      _indexCardProvider.getIndexCard(indexCardId);

  /// Adds an index card.
  Future<IndexCard> addIndexCard(final IndexCard indexCard) async =>
      _indexCardProvider.insert(indexCard);

  /// Updates an index card.
  Future<bool> updateIndexCard(final IndexCard indexCard) async {
    final int count = await _indexCardProvider.update(indexCard);
    return count == 1;
  }

  /// Removes all index cards.
  Future<void> removeAllIndexCards(final int deckId) async =>
      _indexCardProvider.deleteAll(deckId);

  /// Removes an index card.
  Future<bool> removeIndexCard(final int indexCardId) async {
    final rowsAffected = await _indexCardProvider.delete(indexCardId);
    return rowsAffected == 1;
  }
}
