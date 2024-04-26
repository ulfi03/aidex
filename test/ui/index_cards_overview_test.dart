import 'package:aidex/bloc/index_cards_overview_bloc.dart';
import 'package:aidex/data/model/deck.dart';
import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/data/repo/deck_repository.dart';
import 'package:aidex/data/repo/index_card_repository.dart';
import 'package:aidex/ui/deck-view/card_serach_bar.dart';
import 'package:aidex/ui/deck-view/index_card_item_widget.dart';
import 'package:aidex/ui/deck-view/index_cards_overview_widget.dart';
import 'package:aidex/ui/index-card-view/index_card_create_view.dart';
import 'package:aidex/ui/index-card-view/index_card_view.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockIndexCardRepository extends Mock implements IndexCardRepository {}

class MockDeckRepository extends Mock implements DeckRepository {}

class MockIndexCardOverviewBloc extends MockBloc<IndexCardEvent, IndexCardState>
    implements IndexCardOverviewBloc {}

class SortIndexCardsFake extends SortIndexCards implements Fake {
  SortIndexCardsFake() : super(sortAsc: true);
}

class SearchIndexCardsFake extends SearchIndexCards implements Fake {
  SearchIndexCardsFake() : super(query: 'query');
}

void main() {
  final deckStub = Deck(name: 'Deck1', color: Colors.black, deckId: 0);

  // Widget tests --------------------------------------------------------------

  late IndexCardRepository indexCardRepositoryMock;
  late DeckRepository deckRepositoryMock;
  late IndexCardOverviewBloc indexCardOverviewBloc;

  setUp(() {
    indexCardRepositoryMock = MockIndexCardRepository();
    deckRepositoryMock = MockDeckRepository();
    indexCardOverviewBloc = MockIndexCardOverviewBloc();
    registerFallbackValue(const IndexCardEvent());
    registerFallbackValue(SortIndexCardsFake());
    registerFallbackValue(SearchIndexCardsFake());
  });

  Future<void> pumpIndexCardOverview(final WidgetTester tester) async {
    await tester.pumpWidget(BlocProvider.value(
        value: indexCardOverviewBloc,
        child: MaterialApp(home: IndexCardOverview(deck: deckStub))));
  }

  Future<void> pumpIndexCardOverviewWithRepos(final WidgetTester tester) async {
    await tester.pumpWidget(MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: indexCardRepositoryMock),
        RepositoryProvider.value(value: deckRepositoryMock),
      ],
      child: BlocProvider.value(
          value: indexCardOverviewBloc,
          child: MaterialApp(home: IndexCardOverview(deck: deckStub))),
    ));
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
      final getSortButton = find.byKey(CardSearchBar.sortButtonKey);

      testWidgets('All Elements loaded', (final tester) async {
        await pumpIndexCardOverview(tester);
        await tester.pumpAndSettle();
        expect(getSearchbar, findsOneWidget);
        expect(getAddCardButton, findsOneWidget);

        /// if deck is empty IndexCardsOverview displays 'Content of [deckName]'
        expect(find.text('No index cards found!'), findsOneWidget);
      });

      group('Query functionalities', () {
        /// Initialize Widget with IndexCards to sort them
        setUp(() => when(() => indexCardOverviewBloc.state)
            .thenReturn(IndexCardsLoaded(indexCards: indexCards)));
        //testWidgets('SearchBar', (final tester) async {});
        testWidgets('SortButton', (final tester) async {
          await pumpIndexCardOverview(tester);
          expect((tester.widget(getSortButton) as IconButton).icon,
              CardSearchBar.unsortedIcon);
          await tester.tap(getSortButton);
          await tester.pumpAndSettle();
          verify(() => indexCardOverviewBloc.add(any<SortIndexCards>()))
              .called(1);
          expect((tester.widget(getSortButton) as IconButton).selectedIcon,
              CardSearchBar.sortedIcon);
        });
      });
      group('IndexCards functionalities', () {
        const String answerContentStub = '42!';
        final indexCardStub = IndexCard(
            indexCardId: 1,
            question: 'What is the answer to life the universe and everything',
            answer: '[{"insert":"$answerContentStub\\n"}]',
            deckId: deckStub.deckId!);
        group('without pre-initialized-IndexCards', () {
          testWidgets('AddCardButton', (final tester) async {
            await pumpIndexCardOverviewWithRepos(tester);
            expect(find.byType(IndexCardItemWidget), findsNothing);
            await tester.tap(getAddCardButton);
            await tester.pumpAndSettle();
            expect(find.byType(IndexCardCreateViewPage), findsOneWidget);
          });
        });

        group('with pre-initialized-IndexCards', () {
          setUp(() {
            when(() => indexCardRepositoryMock
                    .fetchIndexCard(indexCardStub.indexCardId!))
                .thenAnswer((final _) async => indexCardStub);
            when(() => indexCardOverviewBloc.state)
                .thenReturn(IndexCardsLoaded(indexCards: [indexCardStub]));
          });

          testWidgets('''
              Tab on IndexCard -> IndexCardViewPage of tabbed IndexCard is shown
              ''', (final tester) async {
            await pumpIndexCardOverviewWithRepos(tester);
            await tester.pumpAndSettle();
            expect(find.byType(IndexCardItemWidget), findsOneWidget);
            await tester.tap(find.byType(IndexCardItemWidget));
            await tester.pumpAndSettle();
            expect(find.byType(IndexCardViewPage), findsOneWidget);
          });

          /// test the search functionality
          testWidgets('SearchBar', (final tester) async {
            await pumpIndexCardOverviewWithRepos(tester);
            await tester.pumpAndSettle();
            // enter search query
            await tester.enterText(getSearchbar, 'question-1');
            await tester.pumpAndSettle();
            verify(() => indexCardOverviewBloc.add(any<SearchIndexCards>()))
                .called(2);
          });
        });
      });
    });
  });
}
