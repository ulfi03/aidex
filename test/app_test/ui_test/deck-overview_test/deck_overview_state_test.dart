import 'package:aidex/app/model/deck.dart';
import 'package:aidex/ui/deck-overview/create_deck_snackbar_widget.dart';
import 'package:aidex/ui/deck-overview/deck_overview_state.dart';
import 'package:aidex/ui/deck-overview/deck_overview_widget.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Widget tests --------------------------------------------------------------
  group('add Decks to DeckOverview', () {
    final newDeck = Deck(name: 'New Deck', color: Colors.black);
    final newDeckCopy = Deck(name: 'New Deck', color: Colors.black);
    const widgetStub = Directionality(
        textDirection: TextDirection.ltr,
        child: MaterialApp(
          home: Scaffold(body: DeckOverviewWidget()),
        ));

    testWidgets('add Deck to DeckOverview', (final tester) async {
      await tester.pumpWidget(widgetStub);
      final DeckOverviewState state =
          tester.state(find.byType(DeckOverviewWidget));
      final expectedDecks = <Deck>[newDeck];
      state.addDeck(newDeck);
      expect(const ListEquality().equals(state.decks, expectedDecks), true);
    });

    testWidgets('add multiple Decks to DeckOverview', (final tester) async {
      await tester.pumpWidget(widgetStub);
      final DeckOverviewState state =
          tester.state(find.byType(DeckOverviewWidget));
      final List<Deck> expectedDecks = [
        Deck(name: 'Deck 1', color: Colors.black),
        Deck(name: 'Deck 2', color: Colors.black),
      ];

      for (var i = 0; i < expectedDecks.length; i++) {
        state.addDeck(expectedDecks[i]);
      }
      expect(const ListEquality().equals(state.decks, expectedDecks), true);
    });

    testWidgets('add the same Deck twice', (final tester) async {
      await tester.pumpWidget(widgetStub);
      final DeckOverviewState state =
          tester.state(find.byType(DeckOverviewWidget))
            ..addDeck(newDeck)
            ..addDeck(newDeckCopy);
      expect(state.decks.length == 1, true);
    });
    //Maybe a test that adds a lot of decks to see if the UI can handle it
  });
  group('showCreateDeckDialog', () {
    const widgetStub = Directionality(
        textDirection: TextDirection.ltr,
        child: MaterialApp(
          home: Scaffold(body: DeckOverviewWidget()),
        ));
    Future<void> navigateToCreateDeckDialog(final WidgetTester tester) async {
      await tester.pumpWidget(widgetStub);
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester
          .tap(find.byKey(CreateDeckSnackbarWidget.createManuallyButtonKey));
      await tester.pumpAndSettle();
    }

    testWidgets('Check content on CreateDeckDialog', (final tester) async {
      await navigateToCreateDeckDialog(tester);
      final widgetTitle =
          find.byKey(DeckOverviewState.showCreateDeckDialogTitleKey);
      final hintText = find.text('deck name');
      final errorTextOnEmptyInput = find.text('Please enter a deck name');
      expect(widgetTitle, findsOneWidget);
      expect(hintText, findsOneWidget);
      expect(errorTextOnEmptyInput, findsOneWidget);
    });
  });
  // [potential] golden  tests -------------------------------------------------
  //vgl. https://itnext.io/tdd-in-flutter-part-3-testing-your-widgets-c5e87d76a864
}
