import 'package:aidex/bloc/index_card_edit_bloc.dart';
import 'package:aidex/bloc/index_card_view_bloc.dart';
import 'package:aidex/data/model/deck.dart';
import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/ui/index-card-view/index_card_view.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockIndexCardViewBloc
    extends MockBloc<IndexCardViewEvent, IndexCardViewState>
    implements IndexCardViewBloc {}

class FakeIndexCardEditEvent extends Fake implements IndexCardEditEvent {}

void main() {
  late IndexCardViewBloc indexCardViewBloc;

  const int indexCardIdStub = 1;
  final Deck deckStub =
      Deck(deckId: 1, name: 'Deck Name Stub', color: Colors.black);

  setUp(() {
    indexCardViewBloc = MockIndexCardViewBloc();
    registerFallbackValue(FakeIndexCardEditEvent());
  });

  Future<void> pumpIndexCardView(final WidgetTester tester,
      {final bool pumpAndSettle = true}) async {
    await tester.pumpWidget(BlocProvider.value(
        value: indexCardViewBloc,
        child: MaterialApp(
            home: IndexCardView(
          deck: deckStub,
        ))));
    if (pumpAndSettle) {
      await tester.pumpAndSettle();
    }
  }

  group('IndexCardViewPage', () {
    testWidgets('Render initial state', (final tester) async {
      when(() => indexCardViewBloc.state)
          .thenReturn(IndexCardInitial(indexCardId: indexCardIdStub));
      await pumpIndexCardView(tester);
      expect(find.byType(IndexCardView), findsOneWidget);
      // Verify that the deck name is displayed.
      expect(find.text(deckStub.name), findsOneWidget);
      // Verify that the index card id is displayed.
      expect(find.text('Index Card $indexCardIdStub'), findsOneWidget);
      // Verify that the edit index card button is displayed.
      expect(find.byIcon(Icons.edit), findsNothing);
      // Verify that the delete index card button is displayed.
      expect(find.byIcon(Icons.delete), findsNothing);
    });

    testWidgets('Render progress indicator when index card is loading',
        (final tester) async {
      when(() => indexCardViewBloc.state)
          .thenReturn(IndexCardLoading(indexCardId: indexCardIdStub));
      await pumpIndexCardView(tester, pumpAndSettle: false);
      // Verify that the progress indicator is displayed.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Verify that the edit index card button is not displayed.
      expect(find.byIcon(Icons.edit), findsNothing);
      // Verify that the delete index card button is not displayed.
      expect(find.byIcon(Icons.delete), findsNothing);
    });

    testWidgets('Render error message when index card failed to load',
        (final tester) async {
      const errorText = 'error text stub';
      when(() => indexCardViewBloc.state).thenReturn(
          IndexCardError(indexCardId: indexCardIdStub, message: errorText));
      await pumpIndexCardView(tester);
      // Verify that the error message is displayed.
      expect(find.text(errorText), findsOneWidget);
      // Verify that the edit index card button is not displayed.
      expect(find.byIcon(Icons.edit), findsNothing);
      // Verify that the delete index card button is not displayed.
      expect(find.byIcon(Icons.delete), findsNothing);
    });

    testWidgets('Render index card', (final tester) async {
      final indexCard = IndexCard(
        indexCardId: indexCardIdStub,
        question: 'Question Stub',
        answer: r'[{"insert":"Answer Stub\n"}]',
        deckId: 1,
      );
      when(() => indexCardViewBloc.state)
          .thenReturn(IndexCardViewing(indexCard: indexCard));
      await pumpIndexCardView(tester);
      // Verify that the edit index card button is displayed.
      expect(find.byIcon(Icons.edit), findsOneWidget);
      // Verify that the delete index card button is displayed.
      expect(find.byIcon(Icons.delete), findsOneWidget);
      // Verify that the question is displayed.
      expect(find.text(indexCard.question), findsOneWidget);
    });
  });
}
