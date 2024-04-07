import 'package:aidex/data/model/index_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The business logic component of the IndexCardView feature.
class IndexCardViewBloc extends Bloc<IndexCardEvent, IndexCardState> {
  /// Constructor for the [IndexCardViewBloc].
  IndexCardViewBloc(this._indexCard) : super(IndexCardInitial()) {
    on<ViewIndexCard>((final event, final emit) async {
      emit(IndexCardLoading());
      // TODO: Implement loading the index card from the repository.
      emit(IndexCardViewing());
    });
    on<EditIndexCard>((final event, final emit) {
      emit(IndexCardEditing());
    });
    on<DeleteIndexCard>((final event, final emit) {
      // TODO: Implement deleting the index card from the repository.
    });
    on<SaveIndexCard>((final event, final emit) {
      // TODO: Implement saving the index card to the repository.
      add(ViewIndexCard());
    });
    add(ViewIndexCard());
  }

  final IndexCard _indexCard;
}

// ################################################################# States

/// The states that can be emitted by the IndexCardViewBloc.
abstract class IndexCardState {}

/// The initial state of the IndexCardViewBloc.
class IndexCardInitial extends IndexCardState {}

/// The state when the index card is loading.
class IndexCardLoading extends IndexCardState {}

/// The state when the index card is being viewed.
class IndexCardViewing extends IndexCardState {
  /// Constructor for the [IndexCardViewing].
  IndexCardViewing();
}

/// The state when an error occurred while loading the index card.
class IndexCardError extends IndexCardState {
  /// Constructor for the [IndexCardError].
  IndexCardError(this.message);

  /// The error message.
  final String message;
}

/// The state when the index card is being edited.
class IndexCardEditing extends IndexCardState {
  /// Constructor for the [IndexCardEditing].
  IndexCardEditing();
}

// ################################################################# Events

/// The events that can be processed by the IndexCardViewBloc.
abstract class IndexCardEvent {}

/// The event to view an index card.
class ViewIndexCard extends IndexCardEvent {
  /// Constructor for the [ViewIndexCard].
  ViewIndexCard();
}

/// The event to edit an index card.
class EditIndexCard extends IndexCardEvent {
  /// Constructor for the [EditIndexCard].
  EditIndexCard();
}

/// the event to delete an index card.
class DeleteIndexCard extends IndexCardEvent {
  /// Constructor for the [DeleteIndexCard].
  DeleteIndexCard();
}

/// The event to save an index card.
class SaveIndexCard extends IndexCardEvent {
  /// Constructor for the [SaveIndexCard].
  SaveIndexCard();
}
