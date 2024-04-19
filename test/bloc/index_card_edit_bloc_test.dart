import 'package:aidex/bloc/index_card_edit_bloc.dart';
import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/data/repo/index_card_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class IndexCardRepositoryMock extends Mock implements IndexCardRepository {}

void main() {
  late IndexCardRepository indexCardRepository;

  final IndexCard indexCardStub = IndexCard(
    indexCardId: 1,
    deckId: 3,
    question: 'question',
    answer: r'[{"insert":"Answer Stub\n"}]',
  );

  setUp(() {
    indexCardRepository = IndexCardRepositoryMock();
  });

  group('IndexCardEditBloc', () {
    blocTest('Has initial state EditingIndexCard',
        build: () => IndexCardEditBloc(
            indexCardRepository: indexCardRepository,
            initialIndexCard: indexCardStub),
        verify: (final bloc) {
          expect(bloc.state, isA<EditingIndexCard>());
        },
        expect: () => []);

    group('On UpdateIndexCard', () {
      blocTest('Emits [UpdatingIndexCard, IndexCardUpdated] on success',
          setUp: () {
            when(() => indexCardRepository.updateIndexCard(indexCardStub))
                .thenAnswer((final _) async => true);
          },
          build: () => IndexCardEditBloc(
              indexCardRepository: indexCardRepository,
              initialIndexCard: indexCardStub),
          act: (final bloc) =>
              bloc.add(UpdateIndexCard(indexCard: indexCardStub)),
          expect: () => [isA<UpdatingIndexCard>(), isA<IndexCardUpdated>()]);

      blocTest('Emits [UpdatingIndexCard, IndexCardEditError] on failure',
          setUp: () {
            when(() => indexCardRepository.updateIndexCard(indexCardStub))
                .thenAnswer((final _) async => false);
          },
          build: () => IndexCardEditBloc(
              indexCardRepository: indexCardRepository,
              initialIndexCard: indexCardStub),
          act: (final bloc) =>
              bloc.add(UpdateIndexCard(indexCard: indexCardStub)),
          expect: () => [isA<UpdatingIndexCard>(), isA<IndexCardEditError>()]);

      blocTest('Emits [UpdatingIndexCard, IndexCardEditError] on exception',
          setUp: () {
            when(() => indexCardRepository.updateIndexCard(indexCardStub))
                .thenThrow(Exception());
          },
          build: () => IndexCardEditBloc(
              indexCardRepository: indexCardRepository,
              initialIndexCard: indexCardStub),
          act: (final bloc) =>
              bloc.add(UpdateIndexCard(indexCard: indexCardStub)),
          expect: () => [isA<UpdatingIndexCard>(), isA<IndexCardEditError>()]);
    });
  });
}
