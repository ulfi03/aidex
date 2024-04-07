import 'package:aidex/bloc/index_cards_overview_bloc.dart';
import 'package:aidex/data/model/deck.dart';
import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/ui/deck-view/index_card_item_widget.dart';
import 'package:aidex/ui/deck-view/index_cards_overview_widget.dart';
import 'package:aidex/ui/indexCard-view/index_card_view_widget.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockIndexCardOverviewBloc extends MockBloc<IndexCardEvent, IndexCardState>
    implements IndexCardOverviewBloc {}

void main() {
  final deckStub = Deck(name: 'Deck1', color: Colors.black, deckId: 0);

  // Widget tests --------------------------------------------------------------

  late IndexCardOverviewBloc indexCardOverviewBloc;

  setUp(() {
    indexCardOverviewBloc = MockIndexCardOverviewBloc();
    registerFallbackValue(const IndexCardEvent());
  });

  Future<void> pumpIndexCardOverview(final WidgetTester tester) async {
    await tester.pumpWidget(BlocProvider.value(
        value: indexCardOverviewBloc,
        child: MaterialApp(home: IndexCardOverview(deck: deckStub))));
  }

  group('IndexCardOverview', () {
    testWidgets('Render initial state', (final tester) async {
      when(() => indexCardOverviewBloc.state)
          .thenReturn(const IndexCardInitial());
      await pumpIndexCardOverview(tester);
      expect(find.byType(IndexCardOverview), findsOneWidget);
    });

    testWidgets('Render progress indicator when IndexCards are loading',
        (final tester) async {
      when(() => indexCardOverviewBloc.state)
          .thenReturn(const IndexCardsLoading());
      await pumpIndexCardOverview(tester);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Render loaded IndexCards', (final tester) async {
      final indexCards = <IndexCard>[
        IndexCard(
            question: 'question-1',
            answer: 'answer-1',
            deckId: deckStub.deckId!),
        IndexCard(
            question: 'question-2',
            answer: 'answer-2',
            deckId: deckStub.deckId!)
      ];
      when(() => indexCardOverviewBloc.state)
          .thenReturn(IndexCardsLoaded(indexCards: indexCards));
      await pumpIndexCardOverview(tester);
      expect(find.byType(IndexCardItemWidget), findsNWidgets(2));
    });

    testWidgets('Render error message when index cards failed to load',
        (final tester) async {
      const errorText = 'error text stub';
      when(() => indexCardOverviewBloc.state)
          .thenReturn(const IndexCardsError(message: errorText));
      await pumpIndexCardOverview(tester);
      expect(find.text(errorText), findsOneWidget);
    });

    group('IndexCardOverview Elements', () {
      setUp(() => when(() => indexCardOverviewBloc.state)
          .thenReturn(const IndexCardsLoaded(indexCards: [])));

      final indexCards = [
        IndexCard(
            question: 'question-1',
            answer: 'answer-1',
            deckId: deckStub.deckId!),
        IndexCard(
            question: 'question-2',
            answer: 'answer-2',
            deckId: deckStub.deckId!),
        IndexCard(
            question: 'question-3',
            answer: 'answer-3',
            deckId: deckStub.deckId!)
      ];
      final getSearchbar = find.byType(CardSearchBar);
      final getAddCardButton = find.byType(AddCardButton);
      final getSortButton = find.byKey(SearchBarState.sortButtonKey);

      testWidgets('All Elements loaded', (final tester) async {
        await pumpIndexCardOverview(tester);
        expect(getSearchbar, findsOneWidget);
        expect(getAddCardButton, findsOneWidget);

        /// if deck is empty IndexCardsOverview displays 'Content of [deckName]'
        expect(find.text('Content of ${deckStub.name}'), findsOneWidget);
      });

      group('Query functionalities', () {
        /// Initialize Widget with IndexCards to sort them
        setUp(() => when(() => indexCardOverviewBloc.state)
            .thenReturn(IndexCardsLoaded(indexCards: indexCards)));
        //testWidgets('SearchBar', (final tester) async {});
        testWidgets('SortButton', (final tester) async {
          await pumpIndexCardOverview(tester);
          expect((tester.widget(getSortButton) as IconButton).icon,
              SearchBarState.unsortedIcon);
          await tester.tap(getSortButton);
          await tester.pumpAndSettle();
          expect((tester.widget(getSortButton) as IconButton).selectedIcon,
              SearchBarState.sortedIcon);
        });
      });
      group('IndexCards functionalities', () {
        final indexCardStub = IndexCard(
            question: 'What is the answer to life the universe and everything',
            answer: '42!',
            deckId: deckStub.deckId!);
        group('without pre-initialized-IndexCards', () {
          testWidgets('AddCardButton', (final tester) async {
            ///Mock the state change when AddCardButton is pressed
            whenListen(
              indexCardOverviewBloc,
              Stream.fromIterable([
                IndexCardsLoaded(indexCards: [
                  indexCardStub,
                ]),
              ]),
            );
            await pumpIndexCardOverview(tester);
            expect(find.byType(IndexCardItemWidget), findsNothing);
            await tester.tap(getAddCardButton);
            await tester.pumpAndSettle();
            expect(find.byType(IndexCardItemWidget), findsOneWidget);
            verify(() => indexCardOverviewBloc.add(any(
                that: isA<AddIndexCard>().having(
                    (final addIndexCard) => addIndexCard.indexCard.question,
                    'indexCard.question',
                    equals('What is the answer '
                        'to life the universe and everything'))))).called(1);
          });
        });

        group('with pre-initialized-IndexCards', () {
          setUp(() => when(() => indexCardOverviewBloc.state)
              .thenReturn(IndexCardsLoaded(indexCards: [indexCardStub])));

          testWidgets(
              'Tab on IndexCard -> IndexCardItemWidget of tabbed IndexCard',
              (final tester) async {
            await pumpIndexCardOverview(tester);
            expect(find.byType(IndexCardItemWidget), findsOneWidget);
            await tester.tap(find.byType(IndexCardItemWidget));
            await tester.pumpAndSettle();
            expect(find.byType(IndexCardViewWidget), findsOneWidget);
            expect(find.text(indexCardStub.question), findsOneWidget);
            expect(find.text('''
              Question: ${indexCardStub.question} \n
              Answer: ${indexCardStub.answer}
              '''), findsOneWidget);
          });
        });
      });
    });
  });
}
