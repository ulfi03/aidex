import 'dart:convert';

/// IndexCard model
class IndexCard {
  /// Create IndexCard object
  IndexCard(
      {required this.question,
      required this.answer,
      required this.deckId,
      this.indexCardId});

  /// Create IndexCard object from map
  IndexCard.fromMap(final Map<String, dynamic> map) {
    indexCardId = map[columnIndexCardId];
    question = map[columnQuestion];
    answer = map[columnAnswer];
    deckId = map[columnDeckId];
  }

  /// The name of the index card table.
  static const String tableIndexCard = 'index_card';

  /// The name of the index card id column.
  static const String columnIndexCardId = 'index_card_id';

  /// The name of the index card title column.
  static const String columnQuestion = 'question';

  /// The name of the content column.
  static const String columnAnswer = 'answer';

  /// The name of the deck id column.
  static const String columnDeckId = 'deck_id';

  /// The id of the index card.
  int? indexCardId;

  /// The title of the index card.
  late String question;

  /// The content of the index card in JSON format.
  late String answer;

  /// The id of the deck the index card belongs to.
  late int deckId;

  /// Converts the index card to a map.
  Map<String, Object?> toMap() => <String, Object?>{
        columnQuestion: question,
        columnAnswer: answer,
        columnDeckId: deckId,
        if (indexCardId != null) columnIndexCardId: indexCardId
      };

  /// Parses the JSON string and sets the answer field.
  void parseAnswerFromJson(String jsonString) {
    Map<String, dynamic> jsonObject = jsonDecode(jsonString);
    answer = jsonObject['insert'].trim();
  }
}
