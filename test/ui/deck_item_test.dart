import 'package:aidex/bloc/deck_overview_bloc.dart';
import 'package:aidex/data/model/deck.dart';
import 'package:aidex/ui/deck-overview/deck_item_widget.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDeckOverviewBloc extends MockBloc<DeckEvent, DeckState>
    implements DeckOverviewBloc {}

void main() {
  late DeckOverviewBloc deckOverviewBloc;

  final Deck deckStub =
      Deck(name: 'Deck 1', color: Colors.black, cardsCount: 3);

  setUp(() {
    deckOverviewBloc = MockDeckOverviewBloc();
  });

  Future<void> pumpDeckItemWidget(final WidgetTester tester) async {
    await tester.pumpWidget(BlocProvider.value(
        value: deckOverviewBloc,
        child: MaterialApp(
            home: Scaffold(
                body: DeckItemWidget(deck: deckStub, key: UniqueKey())))));
  }

  group('DeckItemWidget', () {
    testWidgets('Render deck item', (final tester) async {
      when(() => deckOverviewBloc.state)
          .thenReturn(const DecksLoaded(decks: []));
      await pumpDeckItemWidget(tester);
      expect(find.text('Deck 1'), findsOneWidget);
    });

    testWidgets('Render cards count', (final tester) async {
      await pumpDeckItemWidget(tester);
      await tester.pumpAndSettle();
      // check cards count of each deck
      final Finder cardsCountFinder = find.byKey(DeckItemWidget.cardsCountKey);
      final FinderResult<Element> cardsCountElements =
          cardsCountFinder.evaluate();
      expect(cardsCountElements.length, 1);
      final RichText cardsCountRichText1 =
          cardsCountElements.elementAt(0).widget as RichText;
      final String richTextText1 = cardsCountRichText1.text.toPlainText();
      expect(richTextText1, '3 cards');
    });
  });
}
