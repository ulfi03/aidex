import 'package:aidex/app/model/deck.dart';
import 'package:aidex/ui/deck-overview/deck_item_widget.dart';
import 'package:aidex/ui/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const deckName = 'Initial Deck';
  final deckStub = Deck(name: deckName, color: Colors.black);

  ///To create a DeckItemWidget, it needs a route beforehand
  final directionalWidgetAncestor = MaterialPageRoute(
      builder: (final context) =>
          ItemOnDeckOverviewSelectedRoute(deck: deckStub));

  /// initialze the DeckItemWidget with a correct route
  final widgetStub = MaterialApp(
    home: Scaffold(
      body: DeckItemWidget(deck: deckStub),
    ),
    onGenerateRoute: (final settings) {
      if (settings.name == '/deck-view') {
        return directionalWidgetAncestor;
      }
      return null;
    },
  );

  testWidgets('deck_item has correct Deck title', (final tester) async {
    await tester.pumpWidget(widgetStub);
    final widgetTitle = find.byKey(DeckItemWidget.deckNameKey);
    expect(widgetTitle, findsOneWidget);
  });
}
