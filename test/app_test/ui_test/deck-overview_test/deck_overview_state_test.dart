import 'package:aidex/app/model/deck.dart';
import 'package:aidex/ui/deck-overview/create_deck_snackbar_widget.dart';
import 'package:aidex/ui/deck-overview/deck_overview_state.dart';
import 'package:aidex/ui/deck-overview/deck_overview_widget.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Widget tests --------------------------------------------------------------

  /// Startup widget showing empty DeckOverview
  const widgetStub = Directionality(
      textDirection: TextDirection.ltr,
      child: MaterialApp(
        home: Scaffold(body: DeckOverviewWidget()),
      ));

  group('add Decks to DeckOverview', () {
    final newDeck = Deck(name: 'New Deck', color: Colors.black);

    testWidgets('add Deck to DeckOverview', (final tester) async {
      await tester.pumpWidget(widgetStub);

      /// DeckoverviewState instance is needed to call addDeck
      final DeckOverviewState state =
          tester.state(find.byType(DeckOverviewWidget));

      final expectedDecks = <Deck>[newDeck];

      state.addDeck(newDeck);

      expect(const ListEquality().equals(state.decks, expectedDecks), true);
    });

    testWidgets('add multiple Decks to DeckOverview', (final tester) async {
      await tester.pumpWidget(widgetStub);

      /// DeckoverviewState instance is needed to call addDeck
      final DeckOverviewState state =
          tester.state(find.byType(DeckOverviewWidget));

      final List<Deck> expectedDecks = [
        Deck(name: 'Deck 1', color: Colors.black),
        Deck(name: 'Deck 2', color: Colors.black),
      ];

      for (var i = 0; i < expectedDecks.length; i++) {
        state.addDeck(expectedDecks[i]);
      }

      expect(const ListEquality().equals(state.decks, expectedDecks), true);
    });

    testWidgets(
        'if decks exceed visible UI can you scroll down to the last item?',
        (final tester) async {
      await tester.pumpWidget(widgetStub);

      /// DeckoverviewState instance is needed to call addDeck
      final DeckOverviewState state =
          tester.state(find.byType(DeckOverviewWidget));
      for (var i = 0; i < 500; i++) {
        state.addDeck(Deck(name: 'myDeck $i', color: Colors.black));
      }
      await tester.pumpAndSettle();

      ///Get the scrollable Type of the SingleChildScrollView for scrolling
      final scrollableFinder = find.byType(Scrollable);

      final lastDeckName = state.decks[state.decks.length - 1].name;

      ///Statement scrollUntilVisible scrolls to
      final findLastDeck = find.text(lastDeckName);

      ///scrollUntilVisible scrolls the widget until it finds "findLastDeck"
      await tester.scrollUntilVisible(findLastDeck, 100,
          scrollable: scrollableFinder);
      await tester.pumpAndSettle();

      /// tap on the last Deck to verify if it is visible
      await tester.tap(findLastDeck);
      await tester.pumpAndSettle();

      /// lastDecks content shows up after the tap -> tap was successful
      final verifyOnTapSuccessful = find.text('Content of $lastDeckName');
      expect(verifyOnTapSuccessful, findsOneWidget);
    });
  });

  group('showCreateDeckDialog', () {
    /// Helper function to navigate the widgets until CreateDeckDialog shows up
    Future<void> navigateToCreateDeckDialog(final WidgetTester tester) async {
      /// initialize Startup widget
      await tester.pumpWidget(widgetStub);

      /// tap on FloatingActionButton to show CreateDeckSnackbarWidget
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      /// tap on "Create manually" to show CreateDeckDialog
      await tester
          .tap(find.byKey(CreateDeckSnackbarWidget.createManuallyButtonKey));
      await tester.pumpAndSettle();
    }

    /// Constants to check the crucial elements of the CreateDeckDialog widget
    final widgetTitle =
        find.byKey(DeckOverviewState.showCreateDeckDialogTitleKey);
    final hintText = find.text('deck name');
    final errorTextOnEmptyInput = find.text('Please enter a deck name');
    final selectColorText = find.byKey(DeckOverviewState.selectColorTextKey);
    final cancelButtonTextKey =
        find.byKey(DeckOverviewState.cancelButtonTextKey);
    final okButtonTextKey = find.byKey(DeckOverviewState.okButtonTextKey);
    final colorPickerButton =
        find.byKey(DeckOverviewState.initiateColorPickerButtonKey);

    testWidgets('Check content on CreateDeckDialog', (final tester) async {
      await navigateToCreateDeckDialog(tester);
      expect(widgetTitle, findsOneWidget);
      expect(hintText, findsOneWidget);
      expect(errorTextOnEmptyInput, findsOneWidget);
      expect(selectColorText, findsOneWidget);
      expect(cancelButtonTextKey, findsOneWidget);
      expect(okButtonTextKey, findsOneWidget);
    });

    testWidgets('write deck name in text-field', (final tester) async {
      await navigateToCreateDeckDialog(tester);
      await tester.enterText(
          find.byKey(DeckOverviewState.deckNameTextFieldKey), 'Deck 1');
      await tester.pumpAndSettle();
      final deckNameBorder = tester
          .widget<TextField>(find.byKey(DeckOverviewState.deckNameTextFieldKey))
          .decoration;
      final borderColor = deckNameBorder?.focusedBorder?.borderSide.color;

      ///errorTextOnEmptyInput disappears
      expect(errorTextOnEmptyInput, findsNothing);

      ///Border Color of TextField changes to green
      expect(borderColor, const Color(0xFF20EFC0));
    });

    testWidgets('Cancel-Button brings you back to inital DeckOverview',
        (final tester) async {
      await navigateToCreateDeckDialog(tester);
      await tester.tap(find.byKey(DeckOverviewState.cancelButtonTextKey));
      await tester.pumpAndSettle();

      ///expected to display initial DeckOverview
      expect(
          find.byKey(DeckOverviewState.deckOverviewTitleKey), findsOneWidget);
    });

    testWidgets(
        'Ok-Button -> DeckOverview and inserts a deck if deckName not empty',
        (final tester) async {
      await navigateToCreateDeckDialog(tester);
      const deckName = 'my newDeck';
      await tester.enterText(
          find.byKey(DeckOverviewState.deckNameTextFieldKey), deckName);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(DeckOverviewState.okButtonTextKey));
      await tester.pumpAndSettle();

      ///expected to display DeckOverview
      expect(
          find.byKey(DeckOverviewState.deckOverviewTitleKey), findsOneWidget);

      ///expected to display newDeck in DeckOverview
      expect(find.text(deckName), findsOneWidget);
    });

    testWidgets('Ok-Button stays in widget if you do not put a deckName',
        (final tester) async {
      await navigateToCreateDeckDialog(tester);
      await tester.tap(find.byKey(DeckOverviewState.okButtonTextKey));
      await tester.pumpAndSettle();

      ///stay in CreateDeckDialog
      ///-> expect to find same elements as 'Check content on CreateDeckDialog'
      expect(widgetTitle, findsOneWidget);
      expect(hintText, findsOneWidget);
      expect(errorTextOnEmptyInput, findsOneWidget);
      expect(selectColorText, findsOneWidget);
      expect(cancelButtonTextKey, findsOneWidget);
      expect(okButtonTextKey, findsOneWidget);
    });

    testWidgets(
        'Color-Button -> ColorPicker changes to selcted color '
        '+ creates Deck with selected color (for all available colors)',
        (final tester) async {
      int defaultLength = 1;

      ///iterate through all available colors
      for (int i = 0; i < defaultLength; i++) {
        await navigateToCreateDeckDialog(tester);
        await tester.enterText(
            find.byKey(DeckOverviewState.deckNameTextFieldKey), 'Deck $i');
        await tester.tap(colorPickerButton);
        await tester.pumpAndSettle();

        ///expected to tap into ColorPicker
        expect(find.byKey(DeckOverviewState.pickColorTextKey), findsOneWidget);

        ///ColorPickerElement+availableColors
        final colorPicker = find.byType(BlockPicker);
        final colorPickerColors =
            tester.widget<BlockPicker>(colorPicker).availableColors;
        defaultLength = colorPickerColors.length;

        ///select button for current color
        final inkWellButton = find
            .descendant(of: colorPicker, matching: find.byType(InkWell))
            .at(i);
        await tester.tap(inkWellButton);
        await tester.pumpAndSettle();

        ///confirm selected color
        await tester
            .tap(find.byKey(DeckOverviewState.colorPickerSelectButtonKey));
        await tester.pumpAndSettle();

        ///get color of "Color(optional)" Button
        final colorButton = tester
            .widget<ElevatedButton>(
                find.byKey(DeckOverviewState.initiateColorPickerButtonKey))
            .style
            ?.backgroundColor
            ?.resolve(<MaterialState>{});

        ///expected Button 'Color(optional)' to change to selected color
        expect(colorButton, colorPickerColors[i]);

        ///create Deck with selected color
        await tester.tap(find.byKey(DeckOverviewState.okButtonTextKey));
        await tester.pumpAndSettle();

        ///instanze of DeckOverviewState to reference decks
        final DeckOverviewState state =
            tester.state(find.byType(DeckOverviewWidget));

        ///expected deck is created with selected color matching the name
        expect(state.decks[i].color, colorPickerColors[i]);
        expect(state.decks[i].name, 'Deck $i');
      }
    });
  });
}
