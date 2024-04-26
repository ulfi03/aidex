import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/data/repo/index_card_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The business logic component of the IndexCardView feature.
class IndexCardViewBloc extends Bloc<IndexCardEvent, IndexCardViewState> {
  /// Constructor for the [IndexCardViewBloc].
  IndexCardViewBloc(
      {required final int indexCardId,
      required final IndexCardRepository indexCardRepository})
      : _indexCardRepository = indexCardRepository,
        super(IndexCardInitial(indexCardId: indexCardId)) {
    // event handlers
    on<FetchIndexCard>((final event, final emit) async {
      emit(IndexCardLoading(indexCardId: indexCardId));
      final IndexCard? indexCard =
          await _indexCardRepository.fetchIndexCard(event.indexCardId);
      if (indexCard == null) {
        emit(IndexCardError(
            indexCardId: indexCardId, message: 'Failed to load index card!'));
      } else {
        emit(IndexCardViewing(indexCard: indexCard));
      }
    });
    on<DeleteIndexCard>((final event, final emit) async {
      final bool success =
          await _indexCardRepository.removeIndexCards([event.indexCardId]);
      if (success) {
        emit(IndexCardDeleted(indexCardId: indexCardId));
      } else {
        emit(IndexCardError(
            indexCardId: indexCardId, message: 'Failed to delete index card!'));
      }
    });
    // initial
    add(FetchIndexCard(indexCardId: indexCardId));
  }

  final IndexCardRepository _indexCardRepository;
}

// ################################################################# States

/// The states that can be emitted by the IndexCardViewBloc.
abstract class IndexCardViewState {
  /// Constructor for the [IndexCardViewState].
  IndexCardViewState({required this.indexCardId});

  /// The index card id.
  final int indexCardId;
}

/// The state when the index card is being loaded.
class IndexCardInitial extends IndexCardViewState {
  /// Constructor for the [IndexCardInitial].
  IndexCardInitial({required super.indexCardId});
}

/// The state when the index card is being loaded.
class IndexCardLoading extends IndexCardViewState {
  /// Constructor for the [IndexCardLoading].
  IndexCardLoading({required super.indexCardId});
}

/// The state when the index card is being viewed.
class IndexCardViewing extends IndexCardViewState {
  /// Constructor for the [IndexCardViewing].
  IndexCardViewing({required this.indexCard})
      : super(indexCardId: indexCard.indexCardId!);

  /// The index card to view.
  final IndexCard indexCard;
}

/// The state when an error occurred while loading the index card.
class IndexCardError extends IndexCardViewState {
  /// Constructor for the [IndexCardError].
  IndexCardError({
    required this.message,
    required super.indexCardId,
  });

  /// The error message.
  final String message;
}

/// The state when the index card was deleted.
class IndexCardDeleted extends IndexCardViewState {
  /// Constructor for the [IndexCardDeleted].
  IndexCardDeleted({required super.indexCardId});
}

// ################################################################# Events

/// The events that can be processed by the IndexCardViewBloc.
abstract class IndexCardEvent {}

/// The event to load the index card.
class FetchIndexCard extends IndexCardEvent {
  /// Constructor for the [FetchIndexCard].
  FetchIndexCard({required this.indexCardId});

  /// The index card id.
  final int indexCardId;
}

/// the event to delete an index card.
class DeleteIndexCard extends IndexCardEvent {
  /// Constructor for the [DeleteIndexCard].
  DeleteIndexCard({required this.indexCardId});

  /// The index card id.
  final int indexCardId;
}
