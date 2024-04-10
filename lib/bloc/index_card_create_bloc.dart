import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/data/repo/index_card_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The business logic component of the IndexCardCreate feature.
class IndexCardCreateBloc
    extends Bloc<IndexCardCreateEvent, IndexCardCreateState> {
  /// Constructor for the [IndexCardCreateBloc].
  IndexCardCreateBloc(
      {required final int deckId,
      required final IndexCardRepository indexCardRepository})
      : _indexCardRepository = indexCardRepository,
        super(IndexCardCreateInitial(deckId: deckId)) {
    on<CreateIndexCard>((final event, final emit) async {
      emit(IndexCardSaving());
      final IndexCard savedIndexCard =
          await _indexCardRepository.addIndexCard(event.indexCard);
      if (savedIndexCard.indexCardId! > 0) {
        emit(IndexCardCreated());
      } else {
        emit(IndexCardCreateError(message: 'Failed to save new index card!'));
      }
    });
  }

  final IndexCardRepository _indexCardRepository;
}

// ################################################################# Events
/// The events that can be emitted by the IndexCardCreateBloc.
abstract class IndexCardCreateEvent {}

/// An event to create an index card.
class CreateIndexCard extends IndexCardCreateEvent {
  /// Constructor for the [CreateIndexCard].
  CreateIndexCard({required this.indexCard});

  /// The index card to be created.
  final IndexCard indexCard;
}

// ################################################################# States
/// The states that can be emitted by the IndexCardCreateBloc.
abstract class IndexCardCreateState {}

/// The index card create initial state.
class IndexCardCreateInitial extends IndexCardCreateState {
  /// Constructor for the [IndexCardCreateInitial].
  IndexCardCreateInitial({required this.deckId});

  /// The deck id.
  final int deckId;
}

/// The index card create loading state.
class IndexCardSaving extends IndexCardCreateState {}

/// The index card create success state.
class IndexCardCreated extends IndexCardCreateState {}

/// The index card create failure state.
class IndexCardCreateError extends IndexCardCreateState {
  /// Constructor for the [IndexCardCreateError].
  IndexCardCreateError({required this.message});

  /// The error message.
  final String message;
}
