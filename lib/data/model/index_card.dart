/// IndexCard model
class IndexCard {
  /// Create IndexCard object
  IndexCard(this.indexCardId,
      {required this.title, required this.contentJson, required this.deckId});

  /// Create IndexCard object from map
  IndexCard.fromMap(final Map<String, dynamic> map) {
    indexCardId = map[columnIndexCardId];
    title = map[columnTitle];
    contentJson = map[columnContentJson];
    deckId = map[columnDeckId];
  }

  /// The name of the index card table.
  static const String tableIndexCard = 'index_card';

  /// The name of the index card id column.
  static const String columnIndexCardId = 'index_card_id';

  /// The name of the index card title column.
  static const String columnTitle = 'title';

  /// The name of the content column.
  static const String columnContentJson = 'content_json';

  /// The name of the deck id column.
  static const String columnDeckId = 'deck_id';

  /// The id of the index card.
  int? indexCardId;

  /// The title of the index card.
  late String title;

  /// The content of the index card in JSON format.
  late String contentJson;

  /// The id of the deck the index card belongs to.
  late int deckId;

  /// Converts the index card to a map.
  Map<String, Object?> toMap() => <String, Object?>{
        columnTitle: title,
        columnContentJson: contentJson,
        columnDeckId: deckId,
        if (indexCardId != null) columnIndexCardId: indexCardId
      };
}
