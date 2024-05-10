import 'package:flutter/material.dart';

/// A deck is a collection of cards. It has a name and a list of cards.
class Deck {
  /// Constructor for a deck.
  ///
  /// [name] is the name of the deck.
  /// [color] the color of the deck.
  /// [deckId] the id of the deck.
  Deck(
      {required this.name,
      required this.color,
      this.cardsCount = 0,
      this.deckId});

  /// Creates a deck from a map.
  Deck.fromMap(final Map<String, dynamic> map) {
    deckId = map[columnDeckId];
    name = map[columnName];
    color = Color(map[columnColor]);
    cardsCount = map[cardsCountAlias];
  }

  /// The name of the deck table.
  static const String tableDeck = 'deck';

  /// The name of the deck id column.
  static const String columnDeckId = 'deck_id';

  /// The name of the name column.
  static const String columnName = 'name';

  /// The name of the color column.
  static const String columnColor = 'color';

  /// The name of the card count alias.
  static const String cardsCountAlias = 'cardCount';

  /// The id of the deck.
  int? deckId;

  /// The name of the deck.
  late String name;

  /// The color of the deck.
  late Color color;

  /// The number of cards within this deck.
  late int cardsCount;

  /// Converts the deck to a map.
  Map<String, Object?> toMap() {
    final map = <String, Object?>{
      columnName: name,
      columnColor: color.value,
    };
    if (deckId != null) {
      map[columnDeckId] = deckId;
    }
    return map;
  }
}
