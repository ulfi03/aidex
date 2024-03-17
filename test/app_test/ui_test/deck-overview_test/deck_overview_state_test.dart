import 'package:aidex/app/model/deck.dart';
import 'package:aidex/ui/deck-overview/deck_overview_state.dart';
import 'package:aidex/ui/deck-overview/deck_overview_widget.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Widget tests ---------------------------------------------------------------
  group('add Decks to DeckOverview', () {
    final newDeck = Deck(name: 'New Deck');
    var widgetStub = const Directionality(
        textDirection: TextDirection.ltr,
        child: MaterialApp(
          home: Scaffold(body: DeckOverviewWidget()),
        ));

    testWidgets('add Deck to empty DeckOverview', (tester) async {
      await tester.pumpWidget(widgetStub);
      DeckOverviewState state = tester.state(find.byType(DeckOverviewWidget));
      state.addDeck(newDeck);
      List<Deck> expectedDecks = [newDeck];
      expect(const ListEquality().equals(state.decks, expectedDecks), true);
    });
  });
  // [potential] golden  tests -------------------------------------------------------------
  //vgl. https://itnext.io/tdd-in-flutter-part-3-testing-your-widgets-c5e87d76a864
}
