import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/data/provider/index_card_provider.dart';
import 'package:aidex/data/repo/index_card_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class IndexCardProviderMock extends Mock implements IndexCardProvider {}

void main() {
  late IndexCardProvider indexCardProvider;
  const int deckId = 0;

  setUp(() {
    indexCardProvider = IndexCardProviderMock();
  });

  group('IndexCardRepository', () {
    test('Fetch indexCards', () async {
      final expectedIndexCards = [
        IndexCard(question: 'question-1', answer: 'answer-1', deckId: deckId),
        IndexCard(question: 'question-2', answer: 'answer-2', deckId: deckId),
        IndexCard(question: 'question-3', answer: 'answer-3', deckId: deckId)
      ];
      when(() => indexCardProvider.getIndexCards(deckId))
          .thenAnswer((final _) async => expectedIndexCards);
      final IndexCardRepository repository =
          IndexCardRepository(indexCardProvider: indexCardProvider);
      final indexCards = await repository.fetchIndexCards(deckId);
      expect(indexCards, expectedIndexCards);
    });

    test('Fetch indexCard', () async {
      final expectedIndexCard =
          IndexCard(question: 'question-1', answer: 'answer-1', deckId: deckId);
      when(() => indexCardProvider.getIndexCard(1))
          .thenAnswer((final _) async => expectedIndexCard);
      final IndexCardRepository repository =
          IndexCardRepository(indexCardProvider: indexCardProvider);
      final indexCard = await repository.fetchIndexCard(1);
      expect(indexCard, expectedIndexCard);
    });

    test('Add indexCard', () async {
      final indexCard =
          IndexCard(question: 'question-1', answer: 'answer-1', deckId: deckId);
      when(() => indexCardProvider.insert(indexCard))
          .thenAnswer((final _) async => indexCard);
      final IndexCardRepository repository =
          IndexCardRepository(indexCardProvider: indexCardProvider);
      await repository.addIndexCard(indexCard);
      verify(() => indexCardProvider.insert(indexCard)).called(1);
    });

    test('Update indexCard', () async {
      final indexCard =
      IndexCard(question: 'question-1', answer: 'answer-1', deckId: deckId);
      when(() => indexCardProvider.update(indexCard))
          .thenAnswer((final _) async => 1);
      final IndexCardRepository repository =
      IndexCardRepository(indexCardProvider: indexCardProvider);
      await repository.updateIndexCard(indexCard);
      verify(() => indexCardProvider.update(indexCard)).called(1);
    });

    test('Remove indexCards', () async {
      final List<int> indexCardIds = [1, 2, 3];
      when(() => indexCardProvider.delete(indexCardIds))
          .thenAnswer((final _) async => indexCardIds.length);
      final IndexCardRepository repository =
          IndexCardRepository(indexCardProvider: indexCardProvider);
      expect(await repository.removeIndexCards(indexCardIds), true);
      verify(() => indexCardProvider.delete(indexCardIds)).called(1);
    });

    test('Search indexCards', () async {
      final expectedIndexCards = [
        IndexCard(question: 'question-1', answer: 'answer-1', deckId: deckId),
        IndexCard(question: 'question-2', answer: 'answer-2', deckId: deckId),
        IndexCard(question: 'question-3', answer: 'answer-3', deckId: deckId)
      ];
      when(() => indexCardProvider.searchIndexCards(deckId, 'query'))
          .thenAnswer((final _) async => expectedIndexCards);
      final IndexCardRepository repository =
      IndexCardRepository(indexCardProvider: indexCardProvider);
      final indexCards = await repository.searchIndexCards(deckId, 'query');
      expect(indexCards, expectedIndexCards);
    });
  });
}
