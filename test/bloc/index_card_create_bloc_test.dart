import 'package:aidex/bloc/index_card_create_bloc.dart';
import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/data/repo/index_card_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class IndexCardRepositoryMock extends Mock implements IndexCardRepository {}

void main() {
  late IndexCardRepository indexCardRepository;

  const int deckIdStub = 3;
  final IndexCard indexCardStub = IndexCard(
    indexCardId: 1,
    deckId: deckIdStub,
    question: 'question',
    answer: r'[{"insert":"Answer Stub\n"}]',
  );

  setUp(() {
    indexCardRepository = IndexCardRepositoryMock();
  });

  group('IndexCardCreateBloc', () {
    blocTest('Has inital state IndexCardCreateInitial',
        build: () => IndexCardCreateBloc(
            deckId: deckIdStub, indexCardRepository: indexCardRepository),
        verify: (final bloc) {
          expect(bloc.state, isA<IndexCardCreateInitial>());
        },
        expect: () => []);

    group('On CreateIndexCard', () {
      blocTest('Emits [IndexCardSaving, IndexCardCreated] on success',
          setUp: () {
            when(() => indexCardRepository.addIndexCard(indexCardStub))
                .thenAnswer((final _) async => indexCardStub);
          },
          build: () => IndexCardCreateBloc(
              deckId: deckIdStub, indexCardRepository: indexCardRepository),
          act: (final bloc) =>
              bloc.add(CreateIndexCard(indexCard: indexCardStub)),
          expect: () => [isA<IndexCardSaving>(), isA<IndexCardCreated>()]);

      blocTest('Emits [IndexCardSaving, IndexCardCreateError] on exception',
          setUp: () {
            when(() => indexCardRepository.addIndexCard(indexCardStub))
                .thenThrow(Exception());
          },
          build: () => IndexCardCreateBloc(
              deckId: deckIdStub, indexCardRepository: indexCardRepository),
          act: (final bloc) =>
              bloc.add(CreateIndexCard(indexCard: indexCardStub)),
          expect: () => [isA<IndexCardSaving>(), isA<IndexCardCreateError>()]);

      blocTest(
          'Emits [IndexCardSaving, IndexCardCreateError] when no id is assigned to index card',
          setUp: () {
            when(() => indexCardRepository.addIndexCard(indexCardStub))
                .thenAnswer((final _) async =>
                    IndexCard(question: '', answer: '', deckId: 0));
          },
          build: () => IndexCardCreateBloc(
              deckId: deckIdStub, indexCardRepository: indexCardRepository),
          act: (final bloc) =>
              bloc.add(CreateIndexCard(indexCard: indexCardStub)),
          expect: () => [isA<IndexCardSaving>(), isA<IndexCardCreateError>()]);

      blocTest(
          'Emits [IndexCardSaving, IndexCardCreateError] when an id of "0" is assigned to the created index card',
          setUp: () {
            when(() => indexCardRepository.addIndexCard(indexCardStub))
                .thenAnswer((final _) async => IndexCard(
                    indexCardId: 0, question: '', answer: '', deckId: 0));
          },
          build: () => IndexCardCreateBloc(
              deckId: deckIdStub, indexCardRepository: indexCardRepository),
          act: (final bloc) =>
              bloc.add(CreateIndexCard(indexCard: indexCardStub)),
          expect: () => [isA<IndexCardSaving>(), isA<IndexCardCreateError>()]);
    });
  });
}
