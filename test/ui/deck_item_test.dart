import 'package:aidex/bloc/deck_overview_bloc.dart';
import 'package:aidex/data/model/deck.dart';
import 'package:aidex/ui/components/custom_buttons.dart';
import 'package:aidex/ui/components/custom_color_picker.dart';
import 'package:aidex/ui/components/delete_dialog.dart';
import 'package:aidex/ui/deck-overview/deck_item_widget.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'utils/ui_test_utils.dart';

class MockDeckOverviewBloc extends MockBloc<DeckEvent, DeckState>
    implements DeckOverviewBloc {}

void main() {
  late DeckOverviewBloc deckOverviewBloc;

  final Deck deckStub =
      Deck(deckId: 1, name: 'Deck 1', color: Colors.red, cardsCount: 3);

  setUp(() {
    deckOverviewBloc = MockDeckOverviewBloc();
    registerFallbackValue(const DeckEvent());
  });

  Future<void> pumpDeckItemWidget(final WidgetTester tester) async {
    await tester.pumpWidget(BlocProvider.value(
        value: deckOverviewBloc,
        child:
            MaterialApp(home: Scaffold(body: DeckItemWidget(deck: deckStub)))));
  }

  group('DeckItemWidget', () {
    testWidgets('Render deck item', (final tester) async {
      when(() => deckOverviewBloc.state)
          .thenReturn(const DecksLoaded(decks: []));
      await pumpDeckItemWidget(tester);
      expect(find.text('Deck 1'), findsOneWidget);
      // render color
      checkColorOfDeck(deckStub.deckId!, deckStub.color);
      // render cards count
      final Finder cardsCountFinder = find.byKey(DeckItemWidget.cardsCountKey);
      final FinderResult<Element> cardsCountElements =
          cardsCountFinder.evaluate();
      expect(cardsCountElements.length, 1);
      final RichText cardsCountRichText1 =
          cardsCountElements.elementAt(0).widget as RichText;
      final String richTextText1 = cardsCountRichText1.text.toPlainText();
      expect(richTextText1, '3 cards');
    });

    testWidgets('Change the name of a deck', (final tester) async {
      await pumpDeckItemWidget(tester);
      await tester.pumpAndSettle();
      // change name of the deck
      //tab on popup menu button for deck options
      await tester.tap(find.byKey(DeckItemWidget.deckOptionsKey));
      await tester.pumpAndSettle();
      //tap on rename button
      await tester.tap(find.byKey(DeckItemWidget.renameDeckMenuEntryKey));
      await tester.pumpAndSettle();
      //enter new name
      await tester.enterText(
          find.byKey(DeckItemWidget.changeDeckNameTextFieldKey), 'Deck 2');
      await tester.pumpAndSettle();
      //tap on ok button
      await tester.tap(find.byKey(OkButton.okButtonKey));
      await tester.pumpAndSettle();
      verify(() => deckOverviewBloc.add(any(
              that: isA<RenameDeck>().having(
                  (final event) => event.deck, 'deck', equals(deckStub)))))
          .called(1);
      //check if the name is changed
      expect(find.text('Deck 2'), findsOneWidget);
    });

    testWidgets('Change the color of a deck', (final tester) async {
      await pumpDeckItemWidget(tester);
      await tester.pumpAndSettle();
      // change color of the deck
      //tab on popup menu button for deck options
      await tester.tap(find.byKey(DeckItemWidget.deckOptionsKey));
      await tester.pumpAndSettle();
      //tap on change color button
      await tester.tap(find.byKey(DeckItemWidget.changeColorDeckMenuEntryKey));
      await tester.pumpAndSettle();
      // select the color 'green'
      await selectColor(tester, CustomColorPicker.availableColors[1]);
      //tap on ok button
      await tester.tap(find.byKey(OkButton.okButtonKey));
      await tester.pumpAndSettle();
      verify(() => deckOverviewBloc.add(any(
              that: isA<ChangeDeckColor>().having(
                  (final event) => event.deck, 'deck', equals(deckStub)))))
          .called(1);
    });

    testWidgets('Delete a deck', (final tester) async {
      await pumpDeckItemWidget(tester);
      await tester.pumpAndSettle();
      // delete the deck
      //tab on popup menu button for deck options
      await tester.tap(find.byKey(DeckItemWidget.deckOptionsKey));
      await tester.pumpAndSettle();
      //tap on delete button
      await tester.tap(find.byKey(DeckItemWidget.deleteDeckMenuEntryKey));
      await tester.pumpAndSettle();
      //tap on delete button
      await tester.tap(find.byKey(DeleteDialog.dialogDeleteButtonKey));
      await tester.pumpAndSettle();
      //check if the deck is deleted
      verify(() => deckOverviewBloc.add(any(
              that: isA<DeleteDeck>().having(
                  (final event) => event.deck, 'deck', equals(deckStub)))))
          .called(1);
    });
  });
}
