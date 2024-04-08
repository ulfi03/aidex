import 'package:aidex/bloc/index_card_view_bloc.dart';
import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/data/repo/deck_repository.dart';
import 'package:aidex/data/repo/index_card_repository.dart';
import 'package:aidex/ui/components/rich_text_editor_widget.dart';
import 'package:aidex/ui/theme/aidex_theme.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A route used to display the selected index card.
class IndexCardViewPage extends StatelessWidget {
  /// Constructor for the [IndexCardViewPage].
  const IndexCardViewPage(
      {required final IndexCard initialIndexCard, super.key})
      : _initialIndexCard = initialIndexCard;

  /// The index card to be displayed.
  final IndexCard _initialIndexCard;

  @override
  Widget build(final BuildContext context) => BlocProvider(
        create: (final context) => IndexCardViewBloc(
            initialIndexCard: _initialIndexCard,
            indexCardRepository: context.read<IndexCardRepository>(),
            deckRepository: context.read<DeckRepository>()),
        child: IndexCardView(
          initialIndexCard: _initialIndexCard,
        ),
      );
}

/// a widget that displays an index card with a field for a question and a field
/// for an answer. The answer is displayed in a readonly rich text editor.
class IndexCardView extends StatelessWidget {
  /// Constructor for the [IndexCardView].s
  IndexCardView({required final IndexCard initialIndexCard, super.key})
      : _editQuestionController =
            TextEditingController(text: initialIndexCard.question),
        _editAnswerController = RichTextEditorController(),
        _flipCardController = FlipCardController() {
    _editAnswerController.fromJson(initialIndexCard.answer);
  }

  final TextEditingController _editQuestionController;
  final RichTextEditorController _editAnswerController;
  final FlipCardController _flipCardController;

  @override
  Widget build(final BuildContext context) =>
      BlocListener<IndexCardViewBloc, IndexCardState>(
        listenWhen: (final previous, final current) =>
            current is IndexCardDeleted,
        listener: (final context, final state) => Navigator.pop(context),
        child: BlocBuilder<IndexCardViewBloc, IndexCardState>(
            builder: (final context, final state) => Scaffold(
                appBar: AppBar(
                  title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(state.deckName,
                            style: mainTheme.textTheme.titleSmall),
                        Text('Index Card ${state.indexCardId}'),
                      ]),
                  actions: _getActions(context, state),
                ),
                body: _getBody(state))),
      );

  // ################################################################# Actions

  List<Widget> _getActions(
      final BuildContext context, final IndexCardState state) {
    if (state is IndexCardViewing) {
      return [
        IconButton(
          icon: Icon(
            Icons.edit,
            color: mainTheme.colorScheme.primary,
          ),
          onPressed: () => _onEdit(context, state.indexCard),
        ),
        IconButton(
          icon: Icon(
            Icons.delete,
            color: mainTheme.colorScheme.primary,
          ),
          onPressed: () => _onDelete(context, state.indexCard),
        )
      ];
    } else if (state is IndexCardEditing) {
      return [
        IconButton(
          icon: Icon(Icons.save, color: mainTheme.colorScheme.primary),
          onPressed: () => _onSave(
              context, state.indexCard.indexCardId!, state.indexCard.deckId),
        ),
        IconButton(
          icon: Icon(
            Icons.cancel,
            color: mainTheme.colorScheme.primary,
          ),
          onPressed: () => _onCancel(context, state.indexCard),
        ),
      ];
    } else {
      return [];
    }
  }

  void _onEdit(final BuildContext context, final IndexCard card) {
    context.read<IndexCardViewBloc>().add(EditIndexCard(indexCard: card));
  }

  void _onDelete(final BuildContext context, final IndexCard card) {
    context.read<IndexCardViewBloc>().add(DeleteIndexCard(indexCard: card));
  }

  void _onSave(
      final BuildContext context, final int indexCardId, final int deckId) {
    final card = IndexCard(
        indexCardId: indexCardId,
        question: _editQuestionController.text,
        answer: _editAnswerController.toJson(),
        deckId: deckId);
    context.read<IndexCardViewBloc>().add(SaveIndexCard(indexCard: card));
  }

  void _onCancel(final BuildContext context, final IndexCard card) {
    context.read<IndexCardViewBloc>().add(ViewIndexCard(indexCard: card));
  }

  // ################################################################# Body

  Widget _getBody(final IndexCardState state) {
    if (state is IndexCardViewing) {
      return _getView(state.indexCard);
    } else if (state is IndexCardEditing) {
      return _getEditView(state.indexCard);
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  Widget _getView(final IndexCard card) => Container(
      constraints: const BoxConstraints.expand(),
      child: FlipCard(
          controller: _flipCardController,
          fill: Fill.fillFront,
          // The side to initially display.
          front: Card(
              color: mainTheme.colorScheme.primary.withOpacity(0.5),
              child: Align(
                child: Text(card.question),
              )),
          back: Card(
              color: mainTheme.colorScheme.secondary.withOpacity(0.5),
              child: AbsorbPointer(
                  child: RichTextEditorWidget(
                readonly: true,
                contentJson: card.answer,
              )))));

  Widget _getEditView(final IndexCard card) => Column(
        children: <Widget>[
          // display deck name
          Align(
              alignment: Alignment.centerLeft,
              child: Text('Deck: ${card.deckId}',
                  style: const TextStyle(fontWeight: FontWeight.bold))),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Question',
            ),
            controller: _editQuestionController,
          ),
          const Align(alignment: Alignment.centerLeft, child: Text('Answer')),
          Expanded(
            child: RichTextEditorWidget(
              controller: _editAnswerController,
              readonly: false,
              contentJson: card.answer,
            ),
          ),
        ],
      );
}
