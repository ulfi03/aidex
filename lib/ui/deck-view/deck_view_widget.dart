import 'package:flutter/material.dart';
import '../../app/model/deck.dart';

class DeckViewWidget extends StatelessWidget {
  final Deck deck;

  const DeckViewWidget({super.key, required this.deck});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(deck.name),
      ),
      body: Center(
        child: Text("Content of ${deck.name}"),
      ),
    );
  }
}
