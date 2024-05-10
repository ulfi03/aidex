import 'package:aidex/data/model/deck.dart';
import 'package:aidex/data/provider/deck_provider.dart';
import 'package:aidex/data/repo/deck_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class DeckProviderMock extends Mock implements DeckProvider {}

void main() {
  late DeckProvider deckProvider;

  setUp(() {
    deckProvider = DeckProviderMock();
  });

  group('DeckRepository', () {
    test('Fetch decks', () async {
      final expectedDecks = [
        Deck(name: 'Deck 1', color: Colors.black),
        Deck(name: 'Deck 2', color: Colors.black),
        Deck(name: 'Deck 3', color: Colors.black)
      ];
      when(() => deckProvider.getDecks())
          .thenAnswer((final _) async => expectedDecks);
      final DeckRepository repository =
          DeckRepository(deckProvider: deckProvider);
      final decks = await repository.fetchDecks();
      expect(decks, expectedDecks);
    });

    test('Add deck', () async {
      final deck = Deck(name: 'Deck 1', color: Colors.black);
      when(() => deckProvider.insert(deck)).thenAnswer((final _) async => deck);
      final DeckRepository repository =
          DeckRepository(deckProvider: deckProvider);
      await repository.addDeck(deck);
      verify(() => deckProvider.insert(deck)).called(1);
    });

    test('Remove all decks', () async {
      when(() => deckProvider.deleteAll()).thenAnswer((final _) async => 1);
      final DeckRepository repository =
          DeckRepository(deckProvider: deckProvider);
      await repository.removeAllDecks();
      verify(() => deckProvider.deleteAll()).called(1);
    });

    test('Rename deck', () async {
      final deck = Deck(deckId: 1, name: 'Deck 1', color: Colors.black);
      const String newName = 'New name';
      when(() => deckProvider.renameDeck(deck.deckId!, newName))
          .thenAnswer((final _) async => 1);
      final DeckRepository repository =
          DeckRepository(deckProvider: deckProvider);
      await repository.renameDeck(deck, newName);
      verify(() => deckProvider.renameDeck(deck.deckId!, newName)).called(1);
    });

    test('Rename deck throws exception', () async {
      final deck = Deck(deckId: 1, name: 'Deck 1', color: Colors.black);
      const String newName = 'New name';
      when(() => deckProvider.renameDeck(deck.deckId!, newName))
          .thenAnswer((final _) async => 0);
      final DeckRepository repository =
          DeckRepository(deckProvider: deckProvider);
      expect(() async => repository.renameDeck(deck, newName),
          throwsA(isA<Exception>()));
    });

    test('Change deck color', () async {
      final deck = Deck(deckId: 1, name: 'Deck 1', color: Colors.black);
      when(() => deckProvider.changeDeckColor(deck.deckId!, Colors.red.value))
          .thenAnswer((final _) async => 1);
      final DeckRepository repository =
          DeckRepository(deckProvider: deckProvider);
      await repository.changeDeckColor(deck, Colors.red);
      verify(() => deckProvider.changeDeckColor(deck.deckId!, Colors.red.value))
          .called(1);
    });

    test('Change deck color throws exception', () async {
      final deck = Deck(deckId: 1, name: 'Deck 1', color: Colors.black);
      when(() => deckProvider.changeDeckColor(deck.deckId!, Colors.red.value))
          .thenAnswer((final _) async => 0);
      final DeckRepository repository =
          DeckRepository(deckProvider: deckProvider);
      expect(() async => repository.changeDeckColor(deck, Colors.red),
          throwsA(isA<Exception>()));
    });
  });
}
