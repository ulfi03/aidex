import 'package:flutter/material.dart';

/// A deck is a collection of cards. It has a name and a list of cards.
class Deck {

  /// Constructor for a deck.
  ///
  /// [name] is the name of the deck.
  /// [color] the color of the deck.
  Deck({required this.name, required this.color});

  /// The name of the deck.
  final String name;
  /// The color of the deck.
  final Color color;
}
