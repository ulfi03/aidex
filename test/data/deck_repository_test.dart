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
  });
}
