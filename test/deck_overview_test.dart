import 'package:aidex/bloc/deck_overview_bloc.dart';
import 'package:aidex/data/repo/deck_repository.dart';
import 'package:aidex/model/deck.dart';
import 'package:aidex/ui/deck-overview/create_deck_dialog.dart';
import 'package:aidex/ui/deck-overview/deck_item_widget.dart';
import 'package:aidex/ui/deck-overview/deck_overview_widget.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDeckRepository extends Mock implements DeckRepository {}

class MockDeckOverviewBloc extends MockBloc<DeckEvent, DeckState>
    implements DeckOverviewBloc {}

void main() {
  // Widget tests --------------------------------------------------------------

  group('DeckOverview unit test', () {
    late final DeckRepository deckRepository;

    setUp(() {
      deckRepository = MockDeckRepository();
    });

    testWidgets('renders DeckOverview for state DeckInitial',
        (final tester) async {
      final deckOverviewBloc = MockDeckOverviewBloc();
      when(() => deckOverviewBloc.state).thenReturn(const DeckInitial());

      await tester.pumpWidget(BlocProvider.value(
          value: deckOverviewBloc,
          child: const MaterialApp(home: DeckOverviewPage())));

      expect(find.byType(DeckOverviewPage), findsOneWidget);
    });

    testWidgets('render progress indicator for state DecksLoading',
        (final tester) async {
      final deckOverviewBloc = MockDeckOverviewBloc();
      when(() => deckOverviewBloc.state).thenReturn(const DecksLoading());

      await tester.pumpWidget(BlocProvider.value(
          value: deckOverviewBloc,
          child: const MaterialApp(home: DeckOverviewPage())));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('render fetched decks for state DecksLoaded',
        (final tester) async {
      final deckOverviewBloc = MockDeckOverviewBloc();
      final decks = <Deck>[
        Deck(name: 'Deck 1', color: Colors.black),
        Deck(name: 'Deck 2', color: Colors.black),
      ];
      when(() => deckOverviewBloc.state).thenReturn(DecksLoaded(decks: decks));

      await tester.pumpWidget(BlocProvider.value(
          value: deckOverviewBloc,
          child: const MaterialApp(home: DeckOverviewPage())));

      expect(find.byType(DeckItemWidget), findsNWidgets(2));
    });

    testWidgets('render error message for state DecksError',
        (final tester) async {
      final deckOverviewBloc = MockDeckOverviewBloc();
      const errorText = 'error text stub';
      when(() => deckOverviewBloc.state)
          .thenReturn(const DecksError(message: errorText));

      await tester.pumpWidget(BlocProvider.value(
          value: deckOverviewBloc,
          child: const MaterialApp(home: DeckOverviewPage())));

      expect(find.text(errorText), findsOneWidget);
    });



    testWidgets('renders DeckOverview with Decks', (final tester) async {
      final decks = <Deck>[
        Deck(name: 'Deck 1', color: Colors.black),
        Deck(name: 'Deck 2', color: Colors.black),
      ];

      when(() => deckRepository.fetchDecks())
          .thenAnswer((final _) async => decks);

      await tester.pumpWidget(RepositoryProvider.value(
          value: deckRepository,
          child: const MaterialApp(home: DeckOverviewPage())));

      expect(find.byType(DeckOverviewPage), findsOneWidget);
      expect(find.text('Deck 1'), findsOneWidget);
      expect(find.text('Deck 2'), findsOneWidget);
    });

    testWidgets('add Deck to DeckOverview', (final tester) async {
      final decks = <Deck>[
        Deck(name: 'Deck 1', color: Colors.black),
      ];

      when(() => deckRepository.fetchDecks())
          .thenAnswer((final _) async => decks);

      await tester.pumpWidget(RepositoryProvider.value(
          value: deckRepository,
          child: const MaterialApp(home: DeckOverviewPage())));

      expect(find.byType(DeckOverviewPage), findsOneWidget);
      expect(find.text('Deck 1'), findsOneWidget);

      final newDeck = Deck(name: 'New Deck', color: Colors.black);

      when(() => deckRepository.addDeck(newDeck))
          .thenAnswer((final _) async => newDeck);

      await tester.tap(find.byKey(CreateDeckDialog.okButtonTextKey));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key('deck_name_input')), 'New Deck');
      await tester.tap(find.byKey(const Key('create_deck_button')));
      await tester.pumpAndSettle();

      expect(find.text('New Deck'), findsOneWidget);
    });

    testWidgets('add Deck to DeckOverview', (final tester) async {});

    testWidgets('add multiple Decks to DeckOverview', (final tester) async {});

    testWidgets(
        'if decks exceed visible UI can you scroll down to the last item?',
        (final tester) async {});
  });

  group('showCreateDeckDialog', () {});

  testWidgets('Cancel-Button brings you back to inital DeckOverview',
      (final tester) async {});

  testWidgets(
      'Ok-Button -> DeckOverview and inserts a deck if deckName not empty',
      (final tester) async {});

  testWidgets('Ok-Button stays in widget if you do not put a deckName',
      (final tester) async {});
}
