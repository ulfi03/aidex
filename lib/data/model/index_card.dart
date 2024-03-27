/// IndexCard model
class IndexCard {
  /// Create IndexCard object
  IndexCard(this.indexCardId,
      {required this.title, required this.contentJson, required this.deckId});

  /// The id of the index card.
  final int indexCardId;

  /// The title of the index card.
  final String title;

  /// The content of the index card in JSON format.
  final String contentJson;

  /// The id of the deck the index card belongs to.
  final String deckId;
}
