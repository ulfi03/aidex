import 'package:aidex/bloc/deck_overview_bloc.dart';
import 'package:aidex/data/model/deck.dart';
import 'package:aidex/ui/components/custom_buttons.dart';
import 'package:aidex/ui/deck-overview/create_deck_dialog.dart';
import 'package:aidex/ui/deck-overview/create_deck_modal_bottom_sheet.dart';
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
    testWidgets('Render initial state', (final tester) async {
      when(() => deckOverviewBloc.state).thenReturn(const DeckInitial());
      await pumpDeckOverview(tester);
      expect(find.byType(DeckOverview), findsOneWidget);
    });

    testWidgets('Render progress indicator when decks are loading',
        (final tester) async {
      when(() => deckOverviewBloc.state).thenReturn(const DecksLoading());
      await pumpDeckOverview(tester);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Render no decks found', (final tester) async {
      when(() => deckOverviewBloc.state)
          .thenReturn(const DecksLoaded(decks: []));
      await pumpDeckOverview(tester);
      expect(find.text('No decks found, create one!'), findsOneWidget);
    });

    testWidgets('Render loaded decks', (final tester) async {
      final decks = <Deck>[
        Deck(name: 'Deck 1', color: Colors.black),
        Deck(name: 'Deck 2', color: Colors.black),
      ];
      when(() => deckOverviewBloc.state).thenReturn(DecksLoaded(decks: decks));
      await pumpDeckOverview(tester);
      expect(find.byType(DeckItemWidget), findsNWidgets(2));
    });

    testWidgets('Render error message when decks failed to load',
        (final tester) async {
      const errorText = 'error text stub';
      when(() => deckOverviewBloc.state)
          .thenReturn(const DecksError(message: errorText));
      await pumpDeckOverview(tester);
      expect(find.text(errorText), findsOneWidget);
    });
  });

  group('CreateDeckModalBottomSheet', () {
    setUp(() => when(() => deckOverviewBloc.state)
        .thenReturn(const DecksLoaded(decks: [])));

    Future<void> prepareModalButtomSheet(final WidgetTester tester) async {
      await pumpDeckOverview(tester);
      await tester.tap(find.byKey(DeckOverviewPage.addButtonKey));
      await tester.pumpAndSettle();
    }

    testWidgets('Show CreateDeckModalBottomSheet', (final tester) async {
      await prepareModalButtomSheet(tester);
      expect(find.bySubtype<CreateDeckModalBottomSheet>(), findsOneWidget);
    });

    testWidgets('Verify displayed content on CreateDeckModalBottomSheet',
        (final tester) async {
      await prepareModalButtomSheet(tester);
      expect(find.byKey(CreateDeckModalBottomSheet.modalBottomSheetTitleKey),
          findsOneWidget);
      expect(find.text('Create Deck'), findsOneWidget);
      expect(find.byKey(CreateDeckModalBottomSheet.createManuallyButtonKey),
          findsOneWidget);
      expect(find.text('Create manually'), findsOneWidget);
      expect(find.byKey(CreateDeckModalBottomSheet.createAITitleKey),
          findsOneWidget);
      expect(find.text('Create with AI'), findsOneWidget);
    });

    testWidgets('Open "Create Deck manually" dialog', (final tester) async {
      await prepareModalButtomSheet(tester);
      await tester
          .tap(find.byKey(CreateDeckModalBottomSheet.createManuallyButtonKey));
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
      await tester
          .tap(find.byKey(CreateDeckModalBottomSheet.createManuallyButtonKey));
      await tester.pumpAndSettle();
      expect(find.byType(CreateDeckDialog), findsOneWidget);
    }

    testWidgets('Return to DeckOverview by pressing "Cancel")',
        (final tester) async {
      await prepareCreateDeckDialog(tester);
      await tester.tap(find.byKey(CancelButton.cancelButtonKey));
      await tester.pumpAndSettle();
      expect(find.byType(DeckOverview), findsOneWidget);
      expect(find.byType(CreateDeckDialog), findsNothing);
      expect(find.bySubtype<CreateDeckModalBottomSheet>(), findsNothing);
    });

    testWidgets('Create deck by pressing "OK"', (final tester) async {
      await prepareCreateDeckDialog(tester);
      await tester.enterText(
          find.byKey(CreateDeckDialog.deckNameTextFieldKey), 'Deck 1');
      await tester.tap(find.byKey(OkButton.okButtonKey));
      await tester.pumpAndSettle();
      expect(find.byType(DeckOverview), findsOneWidget);
      verify(() => deckOverviewBloc.add(any(
          that: isA<AddDeck>().having((final addDeck) => addDeck.deck.name,
              'deck.name', equals('Deck 1'))))).called(1);
    });
  });
}
