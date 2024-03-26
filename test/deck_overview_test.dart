import 'package:aidex/bloc/deck_overview_bloc.dart';
import 'package:aidex/model/deck.dart';
import 'package:aidex/ui/deck-overview/create_deck_dialog.dart';
import 'package:aidex/ui/deck-overview/create_deck_snackbar_widget.dart';
import 'package:aidex/ui/deck-overview/deck_item_widget.dart';
import 'package:aidex/ui/deck-overview/deck_overview_widget.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDeckOverviewBloc extends MockBloc<DeckEvent, DeckState>
    implements DeckOverviewBloc {}

void main() {
  // Widget tests --------------------------------------------------------------

  late DeckOverviewBloc deckOverviewBloc;

  setUp(() {
    deckOverviewBloc = MockDeckOverviewBloc();
    registerFallbackValue(const DeckEvent());
  });

  Future<void> pumpDeckOverview(final WidgetTester tester) async {
    await tester.pumpWidget(BlocProvider.value(
        value: deckOverviewBloc,
        child: const MaterialApp(home: DeckOverview())));
  }

  group('DeckOverview', () {
    testWidgets('render initial state', (final tester) async {
      when(() => deckOverviewBloc.state).thenReturn(const DeckInitial());
      await pumpDeckOverview(tester);
      expect(find.byType(DeckOverview), findsOneWidget);
    });

    testWidgets('render progress indicator when decks are loading',
        (final tester) async {
      when(() => deckOverviewBloc.state).thenReturn(const DecksLoading());
      await pumpDeckOverview(tester);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('render loaded decks', (final tester) async {
      final decks = <Deck>[
        Deck(name: 'Deck 1', color: Colors.black),
        Deck(name: 'Deck 2', color: Colors.black),
      ];
      when(() => deckOverviewBloc.state).thenReturn(DecksLoaded(decks: decks));
      await pumpDeckOverview(tester);
      expect(find.byType(DeckItemWidget), findsNWidgets(2));
    });

    testWidgets('render error message when decks failed to load',
        (final tester) async {
      const errorText = 'error text stub';
      when(() => deckOverviewBloc.state)
          .thenReturn(const DecksError(message: errorText));
      await pumpDeckOverview(tester);
      expect(find.text(errorText), findsOneWidget);
    });
  });

  group('CreateDeckSnackbar', () {
    setUp(() => when(() => deckOverviewBloc.state)
        .thenReturn(const DecksLoaded(decks: [])));

    Future<void> prepareSnackbar(final WidgetTester tester) async {
      await pumpDeckOverview(tester);
      await tester.tap(find.byKey(DeckOverviewPage.addButtonKey));
      await tester.pumpAndSettle();
    }

    testWidgets('Show CreateDeckSnackbar', (final tester) async {
      await prepareSnackbar(tester);
      expect(find.bySubtype<SnackBar>(), findsOneWidget);
    });

    testWidgets('Verify displayed content on CreateDeckSnackbar',
        (final tester) async {
      await prepareSnackbar(tester);
      expect(find.byKey(CreateDeckSnackbar.snackbarTitleKey), findsOneWidget);
      expect(find.text('Create Deck'), findsOneWidget);
      expect(find.byKey(CreateDeckSnackbar.createManuallyButtonKey),
          findsOneWidget);
      expect(find.text('Create manually'), findsOneWidget);
      expect(find.byKey(CreateDeckSnackbar.createAITitleKey), findsOneWidget);
      expect(find.text('Create with AI'), findsOneWidget);
    });

    testWidgets('Open "Create Deck manually" dialog', (final tester) async {
      await prepareSnackbar(tester);
      await tester.tap(find.byKey(CreateDeckSnackbar.createManuallyButtonKey));
      await tester.pumpAndSettle();
      expect(find.byType(CreateDeckDialog), findsOneWidget);
    });
  });

  group('CreateDeckDialog', () {
    setUp(() => when(() => deckOverviewBloc.state)
        .thenReturn(const DecksLoaded(decks: [])));

    Future<void> prepareCreateDeckDialog(final WidgetTester tester) async {
      await pumpDeckOverview(tester);
      await tester.tap(find.byKey(DeckOverviewPage.addButtonKey));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(CreateDeckSnackbar.createManuallyButtonKey));
      await tester.pumpAndSettle();
      expect(find.byType(CreateDeckDialog), findsOneWidget);
    }

    testWidgets('Return to DeckOverview by pressing "Cancel")',
        (final tester) async {
      await prepareCreateDeckDialog(tester);
      await tester.tap(find.byKey(CreateDeckDialog.cancelButtonTextKey));
      await tester.pumpAndSettle();
      expect(find.byType(DeckOverview), findsOneWidget);
      expect(find.byType(CreateDeckDialog), findsNothing);
      expect(find.bySubtype<SnackBar>(), findsNothing);
    });

    testWidgets('Create deck by pressing "OK', (final tester) async {
      await prepareCreateDeckDialog(tester);
      await tester.enterText(
          find.byKey(CreateDeckDialog.deckNameTextFieldKey), 'Deck 1');
      await tester.tap(find.byKey(CreateDeckDialog.okButtonKey));
      await tester.pumpAndSettle();
      expect(find.byType(DeckOverview), findsOneWidget);
      verify(() => deckOverviewBloc.add(any(
          that: isA<AddDeck>().having((final addDeck) => addDeck.deck.name,
              'deck.name', equals('Deck 1'))))).called(1);
    });
  });
}
