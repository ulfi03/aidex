import 'package:flutter/material.dart';
import 'package:aidex/app/model/index_card.dart'; // Ensure you import the IndexCard model

/// A deck is a collection of cards. It has a name and a list of cards.
class Deck {

  /// Constructor for a deck.
  ///
  /// [name] is the name of the deck.
  /// [color] the color of the deck.
  /// [indexCards] the list of index cards in the deck.
  Deck({required this.name, required this.color, required this.indexCards});

  /// The name of the deck.
  final String name;
  /// The color of the deck.
  final Color color;
  /// The list of index cards in the deck.
  final List<IndexCard> indexCards;
}