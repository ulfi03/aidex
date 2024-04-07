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

  /// Adds an index card.
  Future<void> addIndexCard(final IndexCard indexCard) async =>
      _indexCardProvider.insert(indexCard);

  /// Removes all index cards.
  Future<void> removeAllIndexCards(final int deckId) async =>
      _indexCardProvider.deleteAll(deckId);
}
