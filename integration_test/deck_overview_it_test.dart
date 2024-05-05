import 'package:aidex/data/model/deck.dart';
import 'package:aidex/data/repo/deck_repository.dart';
import 'package:aidex/ui/components/custom_buttons.dart';
import 'package:aidex/ui/components/custom_color_picker.dart';
import 'package:aidex/ui/components/delete_dialog.dart';
import 'package:aidex/ui/deck-overview/create_deck_dialog_manually.dart';
import 'package:aidex/ui/deck-overview/create_deck_modal_bottom_sheet.dart';
import 'package:aidex/ui/deck-overview/deck_item_widget.dart';
import 'package:aidex/ui/deck-overview/deck_overview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

import '../test/ui/utils/ui_test_utils.dart';

class MockDeckRepository extends Mock implements DeckRepository {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late DeckRepository deckRepository;

  setUp(() {
    deckRepository = MockDeckRepository();
    registerFallbackValue(Deck(name: 'deck-fallback', color: Colors.black));
  });

  Future<void> pumpDeckOverviewWidget(final WidgetTester tester) async {
    await tester.pumpWidget(RepositoryProvider.value(
        value: deckRepository,
        child: const MaterialApp(home: DeckOverviewPage())));

    await tester.pumpAndSettle();
  }

  group('Integrate DeckOverviewBloc with DeckOverview', () {
    testWidgets('Fetch decks on start and render DeckOverview',
        (final tester) async {
      // Stub the fetchDecks method to return an empty list
      when(() => deckRepository.fetchDecks()).thenAnswer((final _) async => []);

      await pumpDeckOverviewWidget(tester);

      verify(() => deckRepository.fetchDecks()).called(1);
      expect(find.byType(DeckOverviewPage), findsOneWidget);
    });

    testWidgets('Display a list of decks', (final tester) async {
      final decks = <Deck>[
        Deck(deckId: 1, name: 'Deck 1', color: Colors.black),
        Deck(deckId: 2, name: 'Deck 2', color: Colors.black),
      ];

      // Stub the fetchDecks method to return a list of decks
      when(() => deckRepository.fetchDecks())
          .thenAnswer((final _) async => decks);

      await pumpDeckOverviewWidget(tester);

      expect(find.byType(DeckItemWidget), findsNWidgets(decks.length));
    });

    testWidgets('Add deck', (final tester) async {
      final decks = <Deck>[
        Deck(deckId: 1, name: 'Deck 1', color: Colors.black),
        Deck(deckId: 2, name: 'Deck 2', color: Colors.black),
      ];
      final Color colorOfDeckToAdd = CustomColorPicker.availableColors[1];
      final deckToAdd =
          Deck(deckId: 3, name: 'Deck 3', color: colorOfDeckToAdd);
      // Stub the fetchDecks method to return a list of decks
      when(() => deckRepository.fetchDecks())
          .thenAnswer((final _) async => decks);
      when(() => deckRepository.addDeck(any())).thenAnswer((final _) async {
        decks.add(deckToAdd);
        return deckToAdd;
      });

      await pumpDeckOverviewWidget(tester);

      final addDeckButton = find.byKey(DeckOverviewPage.addButtonKey);
      expect(addDeckButton, findsOneWidget);
      await tester.tap(addDeckButton);
      await tester.pumpAndSettle();

      final createDeckModalBottomSheet =
          find.byKey(DeckOverviewPage.createDeckModalBottomSheetKey);
      expect(createDeckModalBottomSheet, findsOneWidget);
      final manualCreateButton =
          find.byKey(CreateDeckModalBottomSheet.createManuallyButtonKey);
      expect(manualCreateButton, findsOneWidget);
      await tester.tap(manualCreateButton);
      await tester.pumpAndSettle();

      final createDeckDialog = find.byType(CreateDeckDialogManually);
      expect(createDeckDialog, findsOneWidget);
      // enter deck name
      final deckNameField =
          find.byKey(CreateDeckDialogManually.deckNameTextFieldKey);
      expect(deckNameField, findsOneWidget);
      await tester.enterText(deckNameField, 'Deck 3');
      await tester.pumpAndSettle();

      await selectColor(tester, colorOfDeckToAdd);

      // tap ok button
      final okButton = find.byKey(OkButton.okButtonKey);
      expect(okButton, findsOneWidget);
      await tester.tap(okButton);
      await tester.pumpAndSettle();

      // verify that the deck was added
      verify(() => deckRepository.addDeck(any(
          that: isA<Deck>().having(
              (final deck) => deck.name, 'name', equals('Deck 3'))))).called(1);

      /// Verify that the deck was added to the list of decks
      expect(find.byType(DeckItemWidget), findsNWidgets(3));
      expect(find.text('Deck 3'), findsOneWidget);
      checkColorOfDeck(deckToAdd.deckId!, colorOfDeckToAdd);
    });

    testWidgets('Delete deck', (final tester) async {
      final decks = <Deck>[
        Deck(
            deckId: 1,
            name: 'Deck 1',
            color: CustomColorPicker.availableColors[1]),
        Deck(
            deckId: 2,
            name: 'Deck 2',
            color: CustomColorPicker.availableColors[2]),
      ];
      when(() => deckRepository.fetchDecks())
          .thenAnswer((final _) async => decks);
      await pumpDeckOverviewWidget(tester);
      await tester.pumpAndSettle();
      // delete the deck
      //tab on popup menu button for deck options

      final Finder deckItemFinder =
          find.byKey(DeckItemWidget.deckItemWidgetKey(2));
      final Finder deckOptionsFinder = find.descendant(
          of: deckItemFinder,
          matching: find.byKey(DeckItemWidget.deckOptionsKey));
      await tester.tap(deckOptionsFinder);
      await tester.pumpAndSettle();
      //tap on delete button
      await tester.tap(find.byKey(DeckItemWidget.deleteDeckMenuEntryKey));
      await tester.pumpAndSettle();
      //tap on delete button
      await tester.tap(find.byKey(DeleteDialog.dialogDeleteButtonKey));
      await tester.pumpAndSettle();

      // verify that the deck was deleted
      verify(() => deckRepository.deleteDeck(any(
          that: isA<Deck>()
              .having((final event) => event.deckId, 'deckId', 2)))).called(1);
    });
  });
}
