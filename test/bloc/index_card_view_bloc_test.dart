import 'package:aidex/bloc/index_card_view_bloc.dart';
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

  group('IndexCardViewBloc', () {
    blocTest('Emits [IndexCardLoading, IndexCardViewing] on creation',
        setUp: () {
          when(() => indexCardRepository
                  .fetchIndexCard(indexCardStub.indexCardId!))
              .thenAnswer((final _) async => indexCardStub);
        },
        build: () => IndexCardViewBloc(
            indexCardId: indexCardStub.indexCardId!,
            indexCardRepository: indexCardRepository),
        expect: () => [isA<IndexCardLoading>(), isA<IndexCardViewing>()]);

    group('On FetchIndexCard', () {
      blocTest('Emits [IndexCardLoading, IndexCardError] on failure',
          setUp: () {
            when(() => indexCardRepository
                    .fetchIndexCard(indexCardStub.indexCardId!))
                .thenAnswer((final _) async => null);
          },
          build: () => IndexCardViewBloc(
              indexCardId: indexCardStub.indexCardId!,
              indexCardRepository: indexCardRepository),
          act: (final bloc) =>
              bloc.add(FetchIndexCard(indexCardId: indexCardStub.indexCardId!)),
          skip: 2,
          expect: () => [isA<IndexCardLoading>(), isA<IndexCardError>()]);

      blocTest('Emits [IndexCardLoading, IndexCardViewing] on success',
          setUp: () {
            when(() => indexCardRepository
                    .fetchIndexCard(indexCardStub.indexCardId!))
                .thenAnswer((final _) async => indexCardStub);
          },
          build: () => IndexCardViewBloc(
              indexCardId: indexCardStub.indexCardId!,
              indexCardRepository: indexCardRepository),
          act: (final bloc) =>
              bloc.add(FetchIndexCard(indexCardId: indexCardStub.indexCardId!)),
          skip: 2,
          expect: () => [isA<IndexCardLoading>(), isA<IndexCardViewing>()]);
    });

    group('On DeleteIndexCard', () {
      blocTest('Emits [IndexCardDeleted] on success',
          setUp: () {
            when(() => indexCardRepository
                    .fetchIndexCard(indexCardStub.indexCardId!))
                .thenAnswer((final _) async => indexCardStub);
            when(() => indexCardRepository
                    .removeIndexCard(indexCardStub.indexCardId!))
                .thenAnswer((final _) async => true);
          },
          build: () => IndexCardViewBloc(
              indexCardId: indexCardStub.indexCardId!,
              indexCardRepository: indexCardRepository),
          act: (final bloc) => bloc
              .add(DeleteIndexCard(indexCardId: indexCardStub.indexCardId!)),
          skip: 2,
          expect: () => [isA<IndexCardDeleted>()]);

      blocTest('Emits [IndexCardError] on failure',
          setUp: () {
            when(() => indexCardRepository
                    .fetchIndexCard(indexCardStub.indexCardId!))
                .thenAnswer((final _) async => indexCardStub);
            when(() => indexCardRepository
                    .removeIndexCard(indexCardStub.indexCardId!))
                .thenAnswer((final _) async => false);
          },
          build: () => IndexCardViewBloc(
              indexCardId: indexCardStub.indexCardId!,
              indexCardRepository: indexCardRepository),
          act: (final bloc) => bloc
              .add(DeleteIndexCard(indexCardId: indexCardStub.indexCardId!)),
          skip: 2,
          expect: () => [isA<IndexCardError>()]);
    });
  });
}
