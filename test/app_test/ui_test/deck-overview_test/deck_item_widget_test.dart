import 'package:aidex/app/model/deck.dart';
import 'package:aidex/ui/deck-overview/deck_item_widget.dart';
import 'package:aidex/ui/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Widget tests -------------------------------------------------------------
  // Widget initializers
  const String deckName = 'Initial Deck';
  final deckStub = Deck(name: deckName);
  var directionalWidgetAncestor = MaterialPageRoute(
      builder: (BuildContext context) =>
          ItemOnDeckOverviewSelectedRoute(deck: deckStub));
  var widgetStub = MaterialApp(
    home: Scaffold(
      body: DeckItemWidget(deck: deckStub),
    ),
    onGenerateRoute: (settings) {
      if (settings.name == '/deck-view') {
        return directionalWidgetAncestor;
      }
      return null;
    },
  );

  testWidgets('deck_item has correct Deck title', (tester) async {
    await tester.pumpWidget(widgetStub);
    final widgetTitle = find.byKey(DeckItemWidget.deckNameKey);
    expect(widgetTitle, findsOneWidget);
  });

  // [potential] golden  tests -------------------------------------------------------------
  //vgl. https://itnext.io/tdd-in-flutter-part-3-testing-your-widgets-c5e87d76a864
}
