import 'package:aidex/app/model/deck.dart';
import 'package:aidex/ui/deck-view/deck_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Widget tests -------------------------------------------------------------
  // Widget initializers
  final Deck initDeck = Deck(name: 'my Deck', color: Colors.white);
  final widgetStub = MaterialApp(
    home: Scaffold(
      body: DeckViewWidget(deck: initDeck),
    ),
  );

  testWidgets('Deck-name is DeckViewWidget title', (final tester) async {
    await tester.pumpWidget(widgetStub);

    final deckViewTitle = find.text(initDeck.name);
    expect(deckViewTitle, findsOneWidget);
  });

  testWidgets('Deck-name is included in DeckViewWidget content',
      (final tester) async {
    await tester.pumpWidget(widgetStub);

    final deckViewContent = find.text('Content of ${initDeck.name}');
    expect(deckViewContent, findsOneWidget);
  });
}
