import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/data/repo/index_card_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The business logic component of the IndexCardCreateEdit feature.
class IndexCardEditBloc extends Bloc<IndexCardEditEvent, IndexCardEditState> {
  /// Constructor for the [IndexCardEditBloc].
  IndexCardEditBloc(
      {required final IndexCardRepository indexCardRepository,
      required final IndexCard initialIndexCard})
      : _indexCardRepository = indexCardRepository,
        super(EditingIndexCard(indexCard: initialIndexCard)) {
    on<UpdateIndexCard>((final event, final emit) async {
      emit(UpdatingIndexCard(indexCard: event.indexCard));
      final bool success =
          await _indexCardRepository.updateIndexCard(event.indexCard);
      if (success) {
        emit(IndexCardUpdated(indexCard: event.indexCard));
      } else {
        emit(IndexCardEditError(
            indexCard: event.indexCard, message: 'Failed to save index card!'));
      }
    });
  }

  final IndexCardRepository _indexCardRepository;
}

// ################################################################# Events
/// The events that can be emitted by the IndexCardCreateEditBloc.
abstract class IndexCardEditEvent {}

/// An event to save an edited index card.
class UpdateIndexCard extends IndexCardEditEvent {
  /// Constructor for the [UpdateIndexCard].
  UpdateIndexCard({required this.indexCard});

  /// The index card to be saved.
  final IndexCard indexCard;
}

// ################################################################# States
/// The states that can be emitted by the IndexCardCreateEditBloc.
abstract class IndexCardEditState {
  /// Constructor for the [IndexCardEditState].
  IndexCardEditState({required this.indexCard});

  /// The index card.
  final IndexCard indexCard;
}

/// A state indicating that the index card is being saved.
class UpdatingIndexCard extends IndexCardEditState {
  /// Constructor for the [UpdatingIndexCard].
  /// [indexCard] is the index card being saved.
  UpdatingIndexCard({required super.indexCard});
}

/// A state indicating that the index card is being edited.
class EditingIndexCard extends IndexCardEditState {
  /// Constructor for the [EditingIndexCard].
  EditingIndexCard({required super.indexCard});
}

/// A state indicating that an error occurred while saving the index card.
class IndexCardEditError extends IndexCardEditState {
  /// Constructor for the [IndexCardEditError].
  IndexCardEditError({required super.indexCard, required this.message});

  /// The error message.
  final String message;
}

/// A state indicating that the index card was successfully saved.
class IndexCardUpdated extends IndexCardEditState {
  /// Constructor for the [IndexCardUpdated].
  IndexCardUpdated({required super.indexCard});
}
