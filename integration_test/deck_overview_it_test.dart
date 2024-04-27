import 'package:aidex/data/model/deck.dart';
import 'package:aidex/data/repo/deck_repository.dart';
import 'package:aidex/ui/components/custom_buttons.dart';
import 'package:aidex/ui/deck-overview/create_deck_dialog.dart';
import 'package:aidex/ui/deck-overview/create_deck_modal_bottom_sheet.dart';
import 'package:aidex/ui/deck-overview/deck_item_widget.dart';
import 'package:aidex/ui/deck-overview/deck_overview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDeckRepository extends Mock implements DeckRepository {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late DeckRepository deckRepository;

  setUp(() {
    deckRepository = MockDeckRepository();
    registerFallbackValue(Deck(name: 'deck-fallback', color: Colors.black));
  });

  group('Integrate DeckOverviewBloc with DeckOverview', () {
    testWidgets('Fetch decks on start and render DeckOverview',
        (final tester) async {
      // Stub the fetchDecks method to return an empty list
      when(() => deckRepository.fetchDecks()).thenAnswer((final _) async => []);

      await tester.pumpWidget(RepositoryProvider.value(
          value: deckRepository,
          child: const MaterialApp(home: DeckOverviewPage())));

      await tester.pumpAndSettle();

      verify(() => deckRepository.fetchDecks()).called(1);
      expect(find.byType(DeckOverviewPage), findsOneWidget);
    });

    testWidgets('Display a list of decks', (final tester) async {
      final decks = <Deck>[
        Deck(name: 'Deck 1', color: Colors.black),
        Deck(name: 'Deck 2', color: Colors.black),
      ];

      // Stub the fetchDecks method to return a list of decks
      when(() => deckRepository.fetchDecks())
          .thenAnswer((final _) async => decks);

      await tester.pumpWidget(RepositoryProvider.value(
          value: deckRepository,
          child: const MaterialApp(home: DeckOverviewPage())));

      await tester.pumpAndSettle();

      expect(find.byType(DeckItemWidget), findsNWidgets(decks.length));
    });

    testWidgets('Add deck', (final tester) async {
      final decks = <Deck>[
        Deck(name: 'Deck 1', color: Colors.black),
        Deck(name: 'Deck 2', color: Colors.black),
      ];

      // Stub the fetchDecks method to return a list of decks
      when(() => deckRepository.fetchDecks())
          .thenAnswer((final _) async => decks);
      when(() => deckRepository.addDeck(any())).thenAnswer((final _) async {
        decks.add(Deck(name: 'Deck 3', color: Colors.black));
      });

      await tester.pumpWidget(RepositoryProvider.value(
          value: deckRepository,
          child: const MaterialApp(home: DeckOverviewPage())));
      await tester.pumpAndSettle();

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

      final createDeckDialog = find.byType(CreateDeckDialog);
      expect(createDeckDialog, findsOneWidget);
      // enter deck name
      final deckNameField = find.byKey(CreateDeckDialog.deckNameTextFieldKey);
      expect(deckNameField, findsOneWidget);
      await tester.enterText(deckNameField, 'Deck 3');
      await tester.pumpAndSettle();

      // select color
      final openColorPickerButton =
          find.byKey(CreateDeckDialog.colorPickerButtonKey);
      expect(openColorPickerButton, findsOneWidget);
      await tester.tap(openColorPickerButton);
      await tester.pumpAndSettle();

      // expect block picker to be visible
      final blockPicker = find.byType(BlockPicker);
      expect(blockPicker, findsOneWidget);

      // find container childs of block picker
      final blackContainer = find.descendant(
          of: blockPicker,
          matching: find.byWidgetPredicate((final widget) =>
              (widget is Container) &&
              (widget.decoration is BoxDecoration) &&
              (widget.decoration! as BoxDecoration).color == Colors.black));
      expect(blackContainer, findsOneWidget);
      final inkWell =
          find.descendant(of: blackContainer, matching: find.byType(InkWell));
      expect(inkWell, findsOneWidget);
      await tester.ensureVisible(inkWell);
      // tap black color
      await tester.tap(inkWell);
      await tester.pumpAndSettle();

      // press color picker 'Select' button
      final selectColorButton =
          find.byKey(CreateDeckDialog.colorPickerSelectButtonKey);
      expect(selectColorButton, findsOneWidget);
      await tester.tap(selectColorButton);
      await tester.pumpAndSettle();

      // tap ok button
      final createDeckOkButton = find.byKey(OkButton.okButtonKey);
      expect(createDeckOkButton, findsOneWidget);
      await tester.tap(createDeckOkButton);
      await tester.pumpAndSettle();

      // verify that the deck was added
      verify(() => deckRepository.addDeck(any(
          that: isA<Deck>().having(
              (final deck) => deck.name, 'name', equals('Deck 3'))))).called(1);
      expect(find.byType(DeckItemWidget), findsNWidgets(3));
    });
  });
}
