import 'package:aidex/bloc/index_cards_overview_bloc.dart';
import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/data/repo/index_card_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class IndexCardRepositoryMock extends Mock implements IndexCardRepository {}

void main() {
  late IndexCardRepository indexCardRepository;
  const int deckId = 0;
  final IndexCard indexCardStub = IndexCard(
      indexCardId: 0,
      question: 'question-fallback',
      answer: 'answer-fallback',
      deckId: deckId);

  setUp(() {
    indexCardRepository = IndexCardRepositoryMock();
    registerFallbackValue(indexCardStub);
  });

  group('IndexCardOverviewBloc', () {
    blocTest('Emits [IndexCardsLoading, IndexCardsLoaded] on creation',
        setUp: () {
          when(() => indexCardRepository.fetchIndexCards(deckId))
              .thenAnswer((final _) async => []);
        },
        build: () => IndexCardOverviewBloc(indexCardRepository, deckId),
        verify: (final _) {
          verify(() => indexCardRepository.fetchIndexCards(deckId)).called(1);
        },
        expect: () => [isA<IndexCardsLoading>(), isA<IndexCardsLoaded>()]);

    group('On FetchIndexCards', () {
      blocTest('Reload indexCards',
          setUp: () {
            when(() => indexCardRepository.fetchIndexCards(deckId))
                .thenAnswer((final _) async => []);
          },
          build: () => IndexCardOverviewBloc(indexCardRepository, deckId),
          act: (final bloc) => bloc.add(const FetchIndexCards()),
          skip: 2,
          // skip the first two states [IndexCardsLoading, IndexCardsLoaded]
          expect: () => [isA<IndexCardsLoading>(), isA<IndexCardsLoaded>()]);

      blocTest('Emit IndexCardError when an exception occurs',
          setUp: () {
            when(() => indexCardRepository.fetchIndexCards(deckId))
                .thenThrow(Exception());
          },
          build: () => IndexCardOverviewBloc(indexCardRepository, deckId),
          act: (final bloc) => bloc.add(const FetchIndexCards()),
          skip: 2,
          // skip the first two states [IndexCardsLoading, IndexCardsLoaded]
          expect: () => [isA<IndexCardsLoading>(), isA<IndexCardsError>()]);
    });

    group('On AddIndexCard', () {
      blocTest('Add indexCard and reload indexCards',
          setUp: () {
            when(() => indexCardRepository.addIndexCard(any())).thenAnswer(
                (final _) async => IndexCard(
                    deckId: deckId,
                    question: 'question-1',
                    answer: 'answer-1'));
            when(() => indexCardRepository.fetchIndexCards(deckId))
                .thenAnswer((final _) async => []);
          },
          build: () => IndexCardOverviewBloc(indexCardRepository, deckId),
          act: (final bloc) => bloc.add(AddIndexCard(
              indexCard: IndexCard(
                  question: 'question-1', answer: 'answer-1', deckId: deckId))),
          skip: 2,
          // skip the first two states [IndexCardsLoading, IndexCardsLoaded]
          verify: (final _) {
            verify(() => indexCardRepository.addIndexCard(any())).called(1);
            verify(() => indexCardRepository.fetchIndexCards(deckId)).called(2);
          },
          expect: () => [isA<IndexCardsLoading>(), isA<IndexCardsLoaded>()]);

      blocTest('Emit IndexCardError when an exception occurs',
          setUp: () {
            when(() => indexCardRepository.fetchIndexCards(deckId))
                .thenAnswer((final _) async => []);
            when(() => indexCardRepository.addIndexCard(any()))
                .thenThrow(Exception());
          },
          build: () => IndexCardOverviewBloc(indexCardRepository, deckId),
          act: (final bloc) => bloc.add(AddIndexCard(
              indexCard: IndexCard(
                  question: 'question-1', answer: 'answer-1', deckId: deckId))),
          skip: 2,
          // skip the first two states [IndexCardsLoading, IndexCardsLoaded]
          expect: () => [isA<IndexCardsError>()]);
    });

    group('On UpdateSelectedIndexCards', () {
      blocTest('Update SelectedIndexCards -> trigger IndexCardSelectionMode',
          setUp: () {
            when(() => indexCardRepository.fetchIndexCards(deckId))
                .thenAnswer((final _) async => []);
          },
          build: () => IndexCardOverviewBloc(indexCardRepository, deckId),
          act: (final bloc) => bloc.add(UpdateSelectedIndexCards(
              indexCardIds: [indexCardStub.indexCardId!])),
          skip: 2,
          // skip the first two states [IndexCardsLoading, IndexCardsLoaded]
          expect: () => [isA<IndexCardSelectionMode>()]);
    });

    group('On ExitIndexCardSelectionMode', () {
      blocTest('ExitIndexCardSelectionMode -> trigger IndexCardsLoaded',
          setUp: () {
            when(() => indexCardRepository.fetchIndexCards(deckId))
                .thenAnswer((final _) async => []);
          },
          build: () => IndexCardOverviewBloc(indexCardRepository, deckId),
          act: (final bloc) => bloc.add(const ExitIndexCardSelectionMode()),
          expect: () => [isA<IndexCardsLoading>(), isA<IndexCardsLoaded>()]);
    });

    group('On RemoveIndexCardsById', () {
      blocTest('Remove an indexCard and reload indexCards',
          setUp: () {
            when(() => indexCardRepository.removeIndexCards(any()))
                .thenAnswer((final _) async => true);
            when(() => indexCardRepository.fetchIndexCards(deckId))
                .thenAnswer((final _) async => []);
          },
          build: () => IndexCardOverviewBloc(indexCardRepository, deckId),
          act: (final bloc) => bloc.add(RemoveIndexCardsById(
              selectedIndexCardsIds: [indexCardStub.indexCardId!])),
          skip: 2,
          // skip the first two states [IndexCardsLoading, IndexCardsLoaded]
          verify: (final _) {
            verify(() => indexCardRepository
                .removeIndexCards([indexCardStub.indexCardId!])).called(1);
            verify(() => indexCardRepository.fetchIndexCards(deckId)).called(2);
          },
          expect: () => [isA<IndexCardsLoading>(), isA<IndexCardsLoaded>()]);

      blocTest('Emit IndexCardError when deletion unsuccessful',
          setUp: () {
            when(() => indexCardRepository.removeIndexCards(any()))
                .thenAnswer((final _) async => false);
            when(() => indexCardRepository.fetchIndexCards(deckId))
                .thenAnswer((final _) async => [indexCardStub]);
          },
          build: () => IndexCardOverviewBloc(indexCardRepository, deckId),
          act: (final bloc) => bloc.add(RemoveIndexCardsById(
              selectedIndexCardsIds: [indexCardStub.indexCardId!])),
          skip: 2,
          // skip the first two states [IndexCardsLoading, IndexCardsLoaded]
          expect: () => [isA<IndexCardsError>()]);
    });
  });
}
