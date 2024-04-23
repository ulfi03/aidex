import 'package:aidex/bloc/index_card_edit_bloc.dart';
import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/ui/index-card-view/index_card_edit_view.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockIndexCardEditBloc
    extends MockBloc<IndexCardEditEvent, IndexCardEditState>
    implements IndexCardEditBloc {}

class FakeIndexCardEditEvent extends Fake implements IndexCardEditEvent {}

void main() {
  late IndexCardEditBloc indexCardEditBloc;

  final indexCardStub = IndexCard(
    indexCardId: 1,
    question: 'Question Stub',
    answer: r'[{"insert":"Answer Stub\n"}]',
    deckId: 1,
  );

  const String deckNameStub = 'Deck Name Stub';

  setUp(() {
    indexCardEditBloc = MockIndexCardEditBloc();
    registerFallbackValue(FakeIndexCardEditEvent());
  });

  Future<void> pumpIndexCardEditView(final WidgetTester tester,
      {final bool pumpAndSettle = true}) async {
    await tester.pumpWidget(BlocProvider.value(
        value: indexCardEditBloc,
        child: MaterialApp(
            home: IndexCardEditView(
          deckName: deckNameStub,
          initialIndexCard: indexCardStub,
        ))));
    if (pumpAndSettle) {
      await tester.pumpAndSettle();
    }
  }

  group('IndexCardEditViewPage', () {
    testWidgets('Render initial state', (final tester) async {
      when(() => indexCardEditBloc.state)
          .thenReturn(EditingIndexCard(indexCard: indexCardStub));
      await pumpIndexCardEditView(tester);
      expect(find.byType(IndexCardEditView), findsOneWidget);
      // Verify that the deck name is displayed.
      expect(find.text(deckNameStub), findsOneWidget);
      // Verify that the edit index card title is displayed.
      expect(find.text('Index Card ${indexCardStub.indexCardId!}'),
          findsOneWidget);
      // Verify that the save index card button is displayed.
      expect(find.byIcon(Icons.save), findsOneWidget);
      // Verify that the cancel button is displayed.
      expect(find.byIcon(Icons.cancel), findsOneWidget);
      // Verify that the question text field is displayed.
      expect(find.text(indexCardStub.question), findsOneWidget);
    });

    testWidgets('Render progress indicator when index card is updating',
        (final tester) async {
      when(() => indexCardEditBloc.state)
          .thenReturn(UpdatingIndexCard(indexCard: indexCardStub));
      await pumpIndexCardEditView(tester, pumpAndSettle: false);
      // Verify that the progress indicator is displayed.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Verify that the save index card button is not displayed.
      expect(find.byIcon(Icons.save), findsNothing);
      // Verify that the cancel button is displayed.
      expect(find.byIcon(Icons.cancel), findsOneWidget);
    });

    testWidgets('Render error message when index card failed to update',
        (final tester) async {
      const errorMessage = 'Failed to update index card!';
      when(() => indexCardEditBloc.state).thenReturn(
          IndexCardEditError(message: errorMessage, indexCard: indexCardStub));
      await pumpIndexCardEditView(tester);
      // Verify that the error message is displayed.
      expect(find.text(errorMessage), findsOneWidget);
      // Verify that the save index card button is not displayed.
      expect(find.byIcon(Icons.save), findsNothing);
      // Verify that the cancel button is displayed.
      expect(find.byIcon(Icons.cancel), findsOneWidget);
    });

    testWidgets('Cancel the update of an index card', (final tester) async {
      when(() => indexCardEditBloc.state)
          .thenReturn(EditingIndexCard(indexCard: indexCardStub));
      await pumpIndexCardEditView(tester);
      // Tap the cancel button.
      await tester.tap(find.byIcon(Icons.cancel));
      await tester.pumpAndSettle();
      // Verify that the index card edit view is closed.
      expect(find.byType(IndexCardEditView), findsNothing);
    });

    testWidgets('Update an index card', (final tester) async {
      when(() => indexCardEditBloc.state)
          .thenReturn(EditingIndexCard(indexCard: indexCardStub));
      await pumpIndexCardEditView(tester);
      // Tap the save button.
      await tester.tap(find.byIcon(Icons.save));
      await tester.pumpAndSettle();
      // Verify that the index card was updated.
      verify(() => indexCardEditBloc.add(any(that: isA<UpdateIndexCard>())))
          .called(1);
    });
  });
}
