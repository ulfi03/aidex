import 'package:aidex/bloc/deck_overview_bloc.dart';
import 'package:aidex/data/model/deck.dart';
import 'package:aidex/data/repo/deck_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class DeckRepositoryMock extends Mock implements DeckRepository {}

void main() {
  late DeckRepository deckRepository;

  setUp(() {
    deckRepository = DeckRepositoryMock();
    registerFallbackValue(Deck(name: 'deck-fallback', color: Colors.black));
    registerFallbackValue(Colors.black);
  });

  group('DeckOverviewBloc', () {
    blocTest('Emits [DecksLoading, DecksLoaded] on creation',
        setUp: () {
          when(() => deckRepository.fetchDecks())
              .thenAnswer((final _) async => []);
        },
        build: () => DeckOverviewBloc(deckRepository),
        verify: (final _) {
          verify(() => deckRepository.fetchDecks()).called(1);
        },
        expect: () => [isA<DecksLoading>(), isA<DecksLoaded>()]);

    group('On FetchDecks', () {
      blocTest('Reload decks',
          setUp: () {
            when(() => deckRepository.fetchDecks())
                .thenAnswer((final _) async => []);
          },
          build: () => DeckOverviewBloc(deckRepository),
          act: (final bloc) => bloc.add(const FetchDecks()),
          skip: 2,
          // skip the first two states [DecksLoading, DecksLoaded]
          expect: () => [isA<DecksLoading>(), isA<DecksLoaded>()]);

      blocTest('Emit DeckError when an exception occures',
          setUp: () {
            when(() => deckRepository.fetchDecks()).thenThrow(Exception());
          },
          build: () => DeckOverviewBloc(deckRepository),
          act: (final bloc) => bloc.add(const FetchDecks()),
          skip: 2,
          // skip the first two states [DecksLoading, DecksLoaded]
          expect: () => [isA<DecksLoading>(), isA<DecksError>()]);
    });

    group('On AddDeck', () {
      final Deck deckStub = Deck(name: 'Deck 1', color: Colors.black);
      blocTest('Add deck and reload decks',
          setUp: () {
            when(() => deckRepository.addDeck(any()))
                .thenAnswer((final _) async => deckStub);
            when(() => deckRepository.fetchDecks())
                .thenAnswer((final _) async => []);
          },
          build: () => DeckOverviewBloc(deckRepository),
          act: (final bloc) => bloc.add(AddDeck(deck: deckStub)),
          skip: 2,
          // skip the first two states [DecksLoading, DecksLoaded]
          verify: (final _) {
            verify(() => deckRepository.addDeck(any())).called(1);
            verify(() => deckRepository.fetchDecks()).called(2);
          },
          expect: () => [isA<DecksLoading>(), isA<DecksLoaded>()]);

      blocTest('Emit DeckError when an exception occures',
          setUp: () {
            when(() => deckRepository.fetchDecks())
                .thenAnswer((final _) async => []);
            when(() => deckRepository.addDeck(any())).thenThrow(Exception());
          },
          build: () => DeckOverviewBloc(deckRepository),
          act: (final bloc) => bloc
              .add(AddDeck(deck: Deck(name: 'Deck 1', color: Colors.black))),
          skip: 2,
          // skip the first two states [DecksLoading, DecksLoaded]
          expect: () => [isA<DecksError>()]);
    });

    group('On RemoveAllDecks', () {
      blocTest('Remove all decks and reload decks',
          setUp: () {
            when(() => deckRepository.removeAllDecks())
                .thenAnswer((final _) async {});
            when(() => deckRepository.fetchDecks())
                .thenAnswer((final _) async => []);
          },
          build: () => DeckOverviewBloc(deckRepository),
          act: (final bloc) => bloc.add(const RemoveAllDecks()),
          skip: 2,
          // skip the first two states [DecksLoading, DecksLoaded]
          verify: (final _) {
            verify(() => deckRepository.removeAllDecks()).called(1);
            verify(() => deckRepository.fetchDecks()).called(2);
          },
          expect: () => [isA<DecksLoading>(), isA<DecksLoaded>()]);

      blocTest('Emit DeckError when an exception occures',
          setUp: () {
            when(() => deckRepository.fetchDecks())
                .thenAnswer((final _) async => []);
            when(() => deckRepository.removeAllDecks()).thenThrow(Exception());
          },
          build: () => DeckOverviewBloc(deckRepository),
          act: (final bloc) => bloc.add(const RemoveAllDecks()),
          skip: 2,
          // skip the first two states [DecksLoading, DecksLoaded]
          expect: () => [isA<DecksError>()]);
    });

    group('On RenameDeck', () {
      blocTest('Rename deck and reload decks',
          setUp: () {
            when(() => deckRepository.renameDeck(any(), any()))
                .thenAnswer((final _) async {});
            when(() => deckRepository.fetchDecks())
                .thenAnswer((final _) async => []);
          },
          build: () => DeckOverviewBloc(deckRepository),
          act: (final bloc) => bloc.add(RenameDeck(
              deck: Deck(name: 'Deck 1', color: Colors.black),
              newName: 'New name')),
          skip: 2,
          // skip the first two states [DecksLoading, DecksLoaded]
          verify: (final _) {
            verify(() => deckRepository.renameDeck(any(), any())).called(1);
          },
          //expect no state change
          expect: () => []);

      blocTest('Emit DeckError when an exception occures',
          setUp: () {
            when(() => deckRepository.fetchDecks())
                .thenAnswer((final _) async => []);
            when(() => deckRepository.renameDeck(any(), any()))
                .thenThrow(Exception());
          },
          build: () => DeckOverviewBloc(deckRepository),
          act: (final bloc) => bloc.add(RenameDeck(
              deck: Deck(name: 'Deck 1', color: Colors.black),
              newName: 'New name')),
          skip: 2,
          // skip the first two states [DecksLoading, DecksLoaded]
          expect: () => [isA<DecksError>()]);
    });

    group('On ChangeDeckColor', () {
      blocTest('Change deck color and reload decks',
          setUp: () {
            when(() => deckRepository.changeDeckColor(any(), any()))
                .thenAnswer((final _) async {});
            when(() => deckRepository.fetchDecks())
                .thenAnswer((final _) async => []);
          },
          build: () => DeckOverviewBloc(deckRepository),
          act: (final bloc) => bloc.add(ChangeDeckColor(
              deck: Deck(name: 'Deck 1', color: Colors.black),
              color: Colors.red)),
          skip: 2,
          // skip the first two states [DecksLoading, DecksLoaded]
          verify: (final _) {
            verify(() => deckRepository.changeDeckColor(any(), any()))
                .called(1);
          },
          expect: () => []);

      blocTest('Emit DeckError when an exception occures',
          setUp: () {
            when(() => deckRepository.fetchDecks())
                .thenAnswer((final _) async => []);
            when(() => deckRepository.changeDeckColor(any(), any()))
                .thenThrow(Exception());
          },
          build: () => DeckOverviewBloc(deckRepository),
          act: (final bloc) => bloc.add(ChangeDeckColor(
              deck: Deck(name: 'Deck 1', color: Colors.black),
              color: Colors.red)),
          skip: 2,
          // skip the first two states [DecksLoading, DecksLoaded]
          expect: () => [isA<DecksError>()]);
    });
  });
}
