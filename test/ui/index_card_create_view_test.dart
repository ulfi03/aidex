import 'package:aidex/bloc/index_card_create_bloc.dart';
import 'package:aidex/ui/index-card-view/index_card_create_view.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockIndexCardCreateBloc
    extends MockBloc<IndexCardCreateEvent, IndexCardCreateState>
    implements IndexCardCreateBloc {}

class FakeIndexCardCreateEvent extends Fake implements IndexCardCreateEvent {}

void main() {
  late IndexCardCreateBloc indexCardCreateBloc;

  const int deckIdStub = 1;
  const String deckNameStub = 'Deck Name Stub';

  setUp(() {
    indexCardCreateBloc = MockIndexCardCreateBloc();
    registerFallbackValue(FakeIndexCardCreateEvent());
  });

  Future<void> pumpIndexCardCreateView(final WidgetTester tester,
      {final bool pumpAndSettle = true}) async {
    await tester.pumpWidget(BlocProvider.value(
        value: indexCardCreateBloc,
        child: MaterialApp(home: IndexCardCreateView(deckName: deckNameStub))));
    if (pumpAndSettle) {
      await tester.pumpAndSettle();
    }
  }

  group('IndexCardCreateViewPage', () {
    testWidgets('Render initial state', (final tester) async {
      when(() => indexCardCreateBloc.state)
          .thenReturn(IndexCardCreateInitial(deckId: deckIdStub));
      await pumpIndexCardCreateView(tester);
      expect(find.byType(IndexCardCreateView), findsOneWidget);
      // Verify that the deck name is displayed.
      expect(find.text(deckNameStub), findsOneWidget);
      // Verify that the create index card title is displayed.
      expect(find.text('Create Index Card'), findsOneWidget);
      // Verify that the create index card button is displayed.
      expect(find.byIcon(Icons.save), findsOneWidget);
      // Verify that the cancel button is displayed.
      expect(find.byIcon(Icons.cancel), findsOneWidget);
    });

    testWidgets('Render progress indicator when index card is saving',
        (final tester) async {
      when(() => indexCardCreateBloc.state).thenReturn(IndexCardSaving());
      await pumpIndexCardCreateView(tester, pumpAndSettle: false);
      // Verify that the progress indicator is displayed.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Verify that the create index card button is not displayed.
      expect(find.byIcon(Icons.save), findsNothing);
      // Verify that the cancel button is displayed.
      expect(find.byIcon(Icons.cancel), findsOneWidget);
    });

    testWidgets('Render error message when index card failed to save',
        (final tester) async {
      const errorMessage = 'Failed to save new index card!';
      when(() => indexCardCreateBloc.state)
          .thenReturn(IndexCardCreateError(message: errorMessage));
      await pumpIndexCardCreateView(tester);
      // Verify that the error message is displayed.
      expect(find.text(errorMessage), findsOneWidget);
      // Verify that the create index card button is not displayed.
      expect(find.byIcon(Icons.save), findsNothing);
      // Verify that the cancel button is displayed.
      expect(find.byIcon(Icons.cancel), findsOneWidget);
    });

    testWidgets('Cancel the creation of an index card', (final tester) async {
      when(() => indexCardCreateBloc.state)
          .thenReturn(IndexCardCreateInitial(deckId: deckIdStub));
      await pumpIndexCardCreateView(tester);
      // Tap the cancel button.
      await tester.tap(find.byIcon(Icons.cancel));
      await tester.pumpAndSettle();
      // Verify that the index card creation view is closed.
      expect(find.byType(IndexCardCreateView), findsNothing);
      // Verify that no index card was created.
      verifyNever(
          () => indexCardCreateBloc.add(any(that: isA<CreateIndexCard>())));
    });

    testWidgets('Create an index card', (final tester) async {
      when(() => indexCardCreateBloc.state)
          .thenReturn(IndexCardCreateInitial(deckId: deckIdStub));
      await pumpIndexCardCreateView(tester);
      // Tab the save button.
      await tester.tap(find.byIcon(Icons.save));
      await tester.pumpAndSettle();
      // Verify that the index card creation view is closed.
      verify(() => indexCardCreateBloc.add(any(that: isA<CreateIndexCard>())))
          .called(1);
    });
  });
}
