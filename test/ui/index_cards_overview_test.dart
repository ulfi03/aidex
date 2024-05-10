import 'package:aidex/bloc/index_cards_overview_bloc.dart';
import 'package:aidex/data/model/deck.dart';
import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/data/repo/index_card_repository.dart';
import 'package:aidex/ui/components/delete_dialog.dart';
import 'package:aidex/ui/deck-view/card_serach_bar.dart';
import 'package:aidex/ui/deck-view/index_card_item_widget.dart';
import 'package:aidex/ui/deck-view/index_cards_overview_widget.dart';
import 'package:aidex/ui/index-card-view/index_card_create_view.dart';
import 'package:aidex/ui/index-card-view/index_card_view.dart';
import 'package:aidex/ui/theme/aidex_theme.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockIndexCardRepository extends Mock implements IndexCardRepository {}

class MockIndexCardOverviewBloc extends MockBloc<IndexCardEvent, IndexCardState>
    implements IndexCardOverviewBloc {}

class SortIndexCardsFake extends SortIndexCards implements Fake {
  SortIndexCardsFake() : super(sortAsc: true);
}

class SearchIndexCardsFake extends SearchIndexCards implements Fake {
  SearchIndexCardsFake() : super(query: 'query');
}

class IndexCardEventFake extends IndexCardEvent implements Fake {}

void main() {
  final deckStub = Deck(name: 'Deck1', color: Colors.black, deckId: 0);

  const List<String> answerContentStub = ['answer-1', 'answer-2', 'answer-3'];
  final List<IndexCard> indexCardsStub = [
    IndexCard(
        indexCardId: 0,
        question: 'question-1',
        answer: '[{"insert":"${answerContentStub[0]}\\n"}]',
        deckId: deckStub.deckId!),
    IndexCard(
        indexCardId: 1,
        question: 'question-2',
        answer: '[{"insert":"${answerContentStub[1]}\\n"}]',
        deckId: deckStub.deckId!),
    IndexCard(
        indexCardId: 2,
        question: 'question-3',
        answer: '[{"insert":"${answerContentStub[2]}\\n"}]',
        deckId: deckStub.deckId!)
  ];

  // Widget tests --------------------------------------------------------------

  late IndexCardRepository indexCardRepositoryMock;
  late IndexCardOverviewBloc indexCardOverviewBloc;

  setUp(() {
    indexCardRepositoryMock = MockIndexCardRepository();
    indexCardOverviewBloc = MockIndexCardOverviewBloc();
    registerFallbackValue(IndexCardEventFake());
    registerFallbackValue(SortIndexCardsFake());
    registerFallbackValue(SearchIndexCardsFake());
  });

  Future<void> pumpIndexCardOverview(final WidgetTester tester) async {
    await tester.pumpWidget(BlocProvider.value(
        value: indexCardOverviewBloc,
        child: MaterialApp(home: IndexCardOverview(deck: deckStub))));
  }

  Future<void> pumpIndexCardOverviewWithRepos(final WidgetTester tester) async {
    await tester.pumpWidget(
      RepositoryProvider.value(
        value: indexCardRepositoryMock,
        child: BlocProvider.value(
            value: indexCardOverviewBloc,
            child: MaterialApp(home: IndexCardOverview(deck: deckStub))),
      ),
    );
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
          .thenReturn(IndexCardsLoading(query: ''));
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
          .thenReturn(IndexCardsLoaded(indexCards: indexCards, query: ''));
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
          .thenReturn(const IndexCardsLoaded(indexCards: [], query: '')));

      final getSearchbar = find.byType(CardSearchBar);
      final getAddCardButton = find.byType(AddCardButton);
      final getSortButton = find.byKey(CardSearchBar.sortButtonKey);

      testWidgets('All Elements loaded', (final tester) async {
        await pumpIndexCardOverview(tester);
        await tester.pumpAndSettle();
        expect(getSearchbar, findsOneWidget);
        expect(getAddCardButton, findsOneWidget);

        /// if deck is empty IndexCardsOverview displays 'Content of [deckName]'
        expect(find.text('No index cards found, create one!'), findsOneWidget);
      });

      group('Query functionalities', () {
        /// Initialize Widget with IndexCards to sort them
        setUp(() => when(() => indexCardOverviewBloc.state).thenReturn(
            IndexCardsLoaded(indexCards: indexCardsStub, query: '')));
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
          // Helper variables --------------------------------------------------
          final findDeleteButtonVisibility =
              find.byKey(IndexCardOverview.deleteButtonKey);
          final findSelectAllButtonUnchecked =
              find.byKey(IndexCardOverview.selectAllButtonUncheckedKey);

          // Helper functions --------------------------------------------------
          Finder findIndexCardItemWidgetAt(final int i) =>
              find.byType(IndexCardItemWidget).at(i);

          Container getIndexCardWidgetContainerAt(
              final WidgetTester tester, final int i) {
            final containerFinder =
                find.byKey(IndexCardItemWidget.containerKey).at(i);
            return tester.widget<Container>(containerFinder);
          }

          Color? getIndexCardWidgetColorAt(
                  final WidgetTester tester, final int i) =>
              (getIndexCardWidgetContainerAt(tester, i).decoration!
                      as BoxDecoration)
                  .color;

          Icon getIndexCardWidgetCheckIconAt(
              final WidgetTester tester, final int i) {
            final checkIconFinder =
                find.byKey(IndexCardItemWidget.checkIconKey).at(i);
            return tester.widget<Icon>(checkIconFinder);
          }

          Visibility getVisibilityDeleteButton(final WidgetTester tester) =>
              tester.widget<Visibility>(findDeleteButtonVisibility);

          // Tests ------------------------------------------------------------
          /// Index of the card that is tapped/longPressed
          const int selectedCardIndex = 0;

          testWidgets('''
              Tab on IndexCard -> IndexCardViewPage of tabbed IndexCard is shown
              ''', (final tester) async {
            when(() => indexCardRepositoryMock.fetchIndexCard(
                    indexCardsStub[selectedCardIndex].indexCardId!))
                .thenAnswer(
                    (final _) async => indexCardsStub[selectedCardIndex]);
            when(() => indexCardOverviewBloc.state).thenReturn(
                IndexCardsLoaded(indexCards: indexCardsStub, query: ''));

            await pumpIndexCardOverviewWithRepos(tester);
            await tester.pumpAndSettle();
            expect(find.byType(IndexCardItemWidget), findsNWidgets(3));
            await tester.tap(findIndexCardItemWidgetAt(selectedCardIndex));
            await tester.pumpAndSettle();
            expect(find.byType(IndexCardViewPage), findsOneWidget);
          });

          group('IndexCardSelectionMode', () {
            setUp(() {
              when(() =>
                      indexCardRepositoryMock.fetchIndexCards(deckStub.deckId!))
                  .thenAnswer((final _) async => indexCardsStub);
            });

            /// states which Cards are selected
            final List<int> selectedCardIndices = [
              indexCardsStub[selectedCardIndex].indexCardId!
            ];

            testWidgets(
                'LongPress on selectedCardIndex -> UpdateSelectedIndexCards',
                (final tester) async {
              when(() => indexCardOverviewBloc.state).thenReturn(
                  IndexCardsLoaded(indexCards: indexCardsStub, query: ''));
              await pumpIndexCardOverviewWithRepos(tester);
              await tester.pumpAndSettle();
              await tester
                  .longPress(findIndexCardItemWidgetAt(selectedCardIndex));
              verify(() => indexCardOverviewBloc
                  .add(any(that: isA<UpdateSelectedIndexCards>()))).called(1);
            });

            testWidgets('IndexCardsOverview is IndexCardSelectionMode',
                (final tester) async {
              when(() => indexCardOverviewBloc.state).thenReturn(
                  IndexCardSelectionMode(
                      indexCardIds: selectedCardIndices,
                      indexCards: indexCardsStub));
              await pumpIndexCardOverviewWithRepos(tester);
              await tester.pumpAndSettle();

              /// Amount of IndexCards stays the same
              expect(find.byType(IndexCardItemWidget), findsNWidgets(3));

              /// [selectedCardIndex] IndexCard is selected
              ///   -> Color of selected IndexCard changes
              expect(getIndexCardWidgetColorAt(tester, selectedCardIndex),
                  mainTheme.colorScheme.onSurfaceVariant);

              ///  -> CheckIcon is checked
              expect(
                  getIndexCardWidgetCheckIconAt(tester, selectedCardIndex).icon,
                  Icons.check_circle_outline);

              ///All other IndexCards are not selected
              for (int i = 0; i < indexCardsStub.length; i++) {
                if (i != selectedCardIndex) {
                  expect(getIndexCardWidgetColorAt(tester, i),
                      mainTheme.colorScheme.surface);
                  expect(getIndexCardWidgetCheckIconAt(tester, i).icon,
                      Icons.circle_outlined);
                }
              }

              /// AppBar changes
              ///   -> DeleteButton appears
              expect(getVisibilityDeleteButton(tester).visible, true);

              /// ->selectAllButton appears (unchecked)
              expect(findSelectAllButtonUnchecked, findsOneWidget);
            });
            testWidgets('click arrow_back_button -> ExitIndexCardSelectionMode',
                (final tester) async {
              when(() => indexCardOverviewBloc.state).thenReturn(
                  IndexCardSelectionMode(
                      indexCardIds: selectedCardIndices,
                      indexCards: indexCardsStub));
              await pumpIndexCardOverviewWithRepos(tester);
              await tester.pumpAndSettle();
              await tester
                  .tap(find.byKey(IndexCardOverview.arrowBackButtonKey));
              verify(() => indexCardOverviewBloc
                  .add(any(that: isA<ExitIndexCardSelectionMode>()))).called(1);
            });

            testWidgets('If no IndexCard is selected hide deleteButton',
                (final tester) async {
              when(() => indexCardOverviewBloc.state).thenReturn(
                  IndexCardSelectionMode(
                      indexCardIds: [], indexCards: indexCardsStub));
              await pumpIndexCardOverviewWithRepos(tester);
              await tester.pumpAndSettle();

              ///deleteButton is not visible
              expect(getVisibilityDeleteButton(tester).visible, false);

              ///all IndexCards are not selected
              for (int i = 0; i < indexCardsStub.length; i++) {
                expect(getIndexCardWidgetColorAt(tester, i),
                    mainTheme.colorScheme.surface);
                expect(getIndexCardWidgetCheckIconAt(tester, i).icon,
                    Icons.circle_outlined);
              }

              ///selectAllButton is unChecked
              expect(findSelectAllButtonUnchecked, findsOneWidget);
            });

            testWidgets(
                'Press deleteButton '
                '-> DeleteIndexCardDialog '
                '-> Delete '
                '-> RemoveSelectedIndexCards is called', (final tester) async {
              when(() => indexCardOverviewBloc.state).thenReturn(
                  IndexCardSelectionMode(
                      indexCardIds: selectedCardIndices,
                      indexCards: indexCardsStub));
              await pumpIndexCardOverviewWithRepos(tester);
              await tester.pumpAndSettle();
              await tester.tap(findDeleteButtonVisibility);
              await tester.pumpAndSettle();
              await tester.tap(find.byKey(DeleteDialog.dialogDeleteButtonKey));
              await tester.pumpAndSettle();
              verify(() => indexCardOverviewBloc
                  .add(any(that: isA<RemoveIndexCardsById>()))).called(1);
              verify(() => indexCardOverviewBloc
                  .add(any(that: isA<ExitIndexCardSelectionMode>()))).called(1);
            });
          });

          /// test the search functionality
          testWidgets('SearchBar', (final tester) async {
            const String queryStub = 'question-1';
            when(() => indexCardOverviewBloc.state).thenReturn(
                IndexCardsLoaded(indexCards: indexCardsStub, query: queryStub));
            await pumpIndexCardOverviewWithRepos(tester);
            await tester.pumpAndSettle();
            // enter search query
            await tester.enterText(getSearchbar, queryStub);
            await tester.pumpAndSettle();
            verify(() => indexCardOverviewBloc.add(any<SearchIndexCards>()))
                .called(2);
          });
        });
      });
    });
  });
}
