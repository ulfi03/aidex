import 'package:aidex/bloc/index_cards_overview_bloc.dart';
import 'package:aidex/data/model/deck.dart';
import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/data/repo/index_card_repository.dart';
import 'package:aidex/ui/deck-view/index_card_item_widget.dart';
import 'package:aidex/ui/deck-view/index_cards_overview_widget.dart';
import 'package:aidex/ui/theme/aidex_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

class MockIndexCardRepository extends Mock implements IndexCardRepository {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late IndexCardRepository indexCardRepository;

  final deckStub = Deck(name: 'Deck1', color: Colors.black, deckId: 0);

  setUp(() {
    indexCardRepository = MockIndexCardRepository();
  });

  Future<void> pumpIndexCardOverviewWithRepos(final WidgetTester tester) async {
    await tester.pumpWidget(
      RepositoryProvider.value(
        value: indexCardRepository,
        child: BlocProvider.value(
            value: IndexCardOverviewBloc(indexCardRepository, deckStub.deckId!),
            child: MaterialApp(
              home: IndexCardOverview(deck: deckStub),
              theme: mainTheme,
            )),
      ),
    );
  }

  // Helper variables --------------------------------------------------
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

  final findSelectAllButtonUnchecked =
      find.byKey(IndexCardOverview.selectAllButtonUncheckedKey);
  final findSelectAllButtonChecked =
      find.byKey(IndexCardOverview.selectAllButtonCheckedKey);
  final findDeleteButtonVisibility =
      find.byKey(IndexCardOverview.deleteButtonKey);

  // Helper functions --------------------------------------------------
  Finder findIndexCardItemWidgetAt(final int i) =>
      find.byType(IndexCardItemWidget).at(i);

  Container getIndexCardWidgetContainerAt(
      final WidgetTester tester, final int i) {
    final containerFinder = find.byKey(IndexCardItemWidget.containerKey).at(i);
    return tester.widget<Container>(containerFinder);
  }

  Color? getIndexCardWidgetColorAt(final WidgetTester tester, final int i) =>
      (getIndexCardWidgetContainerAt(tester, i).decoration! as BoxDecoration)
          .color;

  Icon getIndexCardWidgetCheckIconAt(final WidgetTester tester, final int i) {
    final checkIconFinder = find.byKey(IndexCardItemWidget.checkIconKey).at(i);
    return tester.widget<Icon>(checkIconFinder);
  }

  Visibility getVisiblityDeleteButton(final WidgetTester tester) =>
      tester.widget<Visibility>(findDeleteButtonVisibility);

  testWidgets(
      'tap selectAllButton -> select all IndexCards, '
      'tap again -> deselect all IndexCards', (final tester) async {
    /// Index of the card that initiates the selection mode
    const int selectedCardIndex = 0;

    /// Setup indexCardOverview
    when(() => indexCardRepository.fetchIndexCards(deckStub.deckId!))
        .thenAnswer((final _) async => indexCardsStub);

    await pumpIndexCardOverviewWithRepos(tester);
    await tester.pumpAndSettle();

    /// initiate IndexCardSelectionMode
    await tester.longPress(findIndexCardItemWidgetAt(selectedCardIndex));
    await tester.pumpAndSettle();

    /// [selectedCardIndex] IndexCard is selected
    ///   -> Color of selected IndexCard changes
    expect(getIndexCardWidgetColorAt(tester, selectedCardIndex),
        mainTheme.colorScheme.onSurfaceVariant);

    ///  -> CheckIcon is checked
    expect(getIndexCardWidgetCheckIconAt(tester, selectedCardIndex).icon,
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

    ///deleteButton is visible (because one IndexCard is selected)
    expect(getVisiblityDeleteButton(tester).visible, true);

    ///selectAll
    await tester.tap(findSelectAllButtonUnchecked);
    await tester.pumpAndSettle();

    /// -> selectAllButton is checked
    expect(findSelectAllButtonChecked, findsOneWidget);

    /// -> all IndexCards are selected
    for (int i = 0; i < indexCardsStub.length; i++) {
      expect(getIndexCardWidgetColorAt(tester, i),
          mainTheme.colorScheme.onSurfaceVariant);
      expect(getIndexCardWidgetCheckIconAt(tester, i).icon,
          Icons.check_circle_outline);
    }

    ///deleteButton is visible (because all IndexCards are selected)
    expect(getVisiblityDeleteButton(tester).visible, true);

    ///deselect all
    await tester.tap(findSelectAllButtonChecked);
    await tester.pumpAndSettle();

    /// -> selectAllButton is unChecked
    expect(findSelectAllButtonUnchecked, findsOneWidget);

    /// -> all IndexCards are not selected
    for (int i = 0; i < indexCardsStub.length; i++) {
      expect(
          getIndexCardWidgetColorAt(tester, i), mainTheme.colorScheme.surface);
      expect(
          getIndexCardWidgetCheckIconAt(tester, i).icon, Icons.circle_outlined);
    }

    ///deleteButton is not visible (because no IndexCard is selected)
    expect(getVisiblityDeleteButton(tester).visible, false);
  });
}
