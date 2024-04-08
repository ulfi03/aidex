import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/data/repo/deck_repository.dart';
import 'package:aidex/data/repo/index_card_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The business logic component of the IndexCardView feature.
class IndexCardViewBloc extends Bloc<IndexCardEvent, IndexCardState> {
  /// Constructor for the [IndexCardViewBloc].
  IndexCardViewBloc(
      {required final IndexCard initialIndexCard,
      required final IndexCardRepository indexCardRepository,
      required final DeckRepository deckRepository})
      : _indexCardRepository = indexCardRepository,
        super(IndexCardInitial(indexCardId: initialIndexCard.indexCardId!)) {
    // event handlers
    on<ViewIndexCard>((final event, final emit) async {
      if (_deckName == null) {
        final deck = await deckRepository.fetchDeckById(event.indexCard.deckId);
        _deckName = deck!.name;
      }
      emit(IndexCardViewing(indexCard: event.indexCard, deckName: _deckName!));
    });
    on<EditIndexCard>((final event, final emit) {
      emit(IndexCardEditing(indexCard: event.indexCard, deckName: _deckName!));
    });
    on<DeleteIndexCard>((final event, final emit) async {
      final bool success = await _indexCardRepository
          .removeIndexCard(event.indexCard.indexCardId!);
      if (success) {
        emit(IndexCardDeleted(deckId: event.indexCard.deckId));
      } else {
        emit(IndexCardError(
            indexCardId: event.indexCard.indexCardId!,
            deckName: _deckName!,
            message: '''
            Failed to delete index card with id ${event.indexCard.indexCardId}
            from deck $_deckName!
                '''));
      }
    });
    on<SaveIndexCard>((final event, final emit) async {
      emit(SavingIndexCard(
          indexCardId: event.indexCard.indexCardId!, deckName: _deckName!));
      final IndexCard savedIndexCard =
          await _indexCardRepository.addIndexCard(event.indexCard);
      add(ViewIndexCard(indexCard: savedIndexCard));
    });
    // initial
    add(ViewIndexCard(indexCard: initialIndexCard));
  }

  String? _deckName;
  final IndexCardRepository _indexCardRepository;
}

// ################################################################# States

/// The states that can be emitted by the IndexCardViewBloc.
abstract class IndexCardState {
  /// Constructor for the [IndexCardState].
  IndexCardState({required this.indexCardId, required this.deckName});

  /// The index card id.
  final int indexCardId;

  /// The deck name.
  final String deckName;
}

/// The initial state of the IndexCardViewBloc.
class IndexCardInitial extends IndexCardState {
  /// Constructor for the [IndexCardInitial].
  IndexCardInitial({required super.indexCardId}) : super(deckName: '');
}

/// The state when the index card is loading.
class SavingIndexCard extends IndexCardState {
  /// Constructor for the [SavingIndexCard].
  SavingIndexCard({required super.indexCardId, required super.deckName});
}

/// The state when the index card is being viewed.
class IndexCardViewing extends IndexCardState {
  /// Constructor for the [IndexCardViewing].
  IndexCardViewing({required this.indexCard, required super.deckName})
      : super(indexCardId: indexCard.indexCardId!);

  /// The index card to view.
  final IndexCard indexCard;
}

/// The state when an error occurred while loading the index card.
class IndexCardError extends IndexCardState {
  /// Constructor for the [IndexCardError].
  IndexCardError({
    required super.indexCardId,
    required super.deckName,
    required this.message,
  });

  /// The error message.
  final String message;
}

/// The state when the index card is being edited.
class IndexCardEditing extends IndexCardState {
  /// Constructor for the [IndexCardEditing].
  IndexCardEditing({
    required this.indexCard,
    required super.deckName,
  }) : super(indexCardId: indexCard.indexCardId!);

  /// The index card to edit.
  final IndexCard indexCard;
}

/// The state when the index card was deleted.
class IndexCardDeleted extends IndexCardState {
  /// Constructor for the [IndexCardDeleted].
  IndexCardDeleted({required this.deckId})
      : super(indexCardId: -1, deckName: '');

  /// The deck id.
  final int deckId;
}

// ################################################################# Events

/// The events that can be processed by the IndexCardViewBloc.
abstract class IndexCardEvent {}

/// The event to view an index card.
class ViewIndexCard extends IndexCardEvent {
  /// Constructor for the [ViewIndexCard].
  ViewIndexCard({required this.indexCard});

  /// The index card id.
  final IndexCard indexCard;
}

/// The event to edit an index card.
class EditIndexCard extends IndexCardEvent {
  /// Constructor for the [EditIndexCard].
  EditIndexCard({required this.indexCard});

  /// The index card to edit.
  final IndexCard indexCard;
}

/// the event to delete an index card.
class DeleteIndexCard extends IndexCardEvent {
  /// Constructor for the [DeleteIndexCard].
  DeleteIndexCard({required this.indexCard});

  /// The index card.
  final IndexCard indexCard;
}

/// The event to save an index card.
class SaveIndexCard extends IndexCardEvent {
  /// Constructor for the [SaveIndexCard].
  SaveIndexCard({required this.indexCard});

  /// The index card to save.
  final IndexCard indexCard;
}
