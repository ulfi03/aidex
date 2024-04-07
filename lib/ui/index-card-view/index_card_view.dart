import 'package:aidex/bloc/index_card_view_bloc.dart';
import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/ui/components/rich_text_editor_widget.dart';
import 'package:aidex/ui/theme/aidex_theme.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A route used to display the selected index card.
class IndexCardViewPage extends StatelessWidget {
  /// Constructor for the [IndexCardViewPage].
  const IndexCardViewPage({required this.card, super.key});

  /// The index card to be displayed.
  final IndexCard card;

  @override
  Widget build(final BuildContext context) => BlocProvider(
        create: (final context) => IndexCardViewBloc(card),
        child: IndexCardView(card: card),
      );
}

/// a widget that displays an index card with a field for a question and a field
/// for an answer. The answer is displayed in a readonly rich text editor.
class IndexCardView extends StatelessWidget {
  /// Constructor for the [IndexCardView].s
  IndexCardView({required final IndexCard card, super.key})
      : _card = card,
        _editQuestionController = TextEditingController(text: card.title),
        _editAnswerController = RichTextEditorController(),
        _flipCardController = FlipCardController() {
    _editAnswerController.fromJson(card.contentJson);
  }

  IndexCard _card;
  final TextEditingController _editQuestionController;
  final RichTextEditorController _editAnswerController;
  final FlipCardController _flipCardController;

  @override
  Widget build(final BuildContext context) =>
      BlocBuilder<IndexCardViewBloc, IndexCardState>(
          builder: (final context, final state) => Scaffold(
              appBar: AppBar(
                title: Text('Index Card ${_card.indexCardId}'),
                actions: _getActions(context, state),
              ),
              body: _getBody(state)));

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
          onPressed: () => _onEdit(context),
        ),
        IconButton(
          icon: Icon(
            Icons.delete,
            color: mainTheme.colorScheme.primary,
          ),
          onPressed: () => _onDelete(context),
        )
      ];
    } else if (state is IndexCardEditing) {
      return [
        IconButton(
          icon: Icon(Icons.save, color: mainTheme.colorScheme.primary),
          onPressed: () => _onSave(context),
        ),
        IconButton(
          icon: Icon(
            Icons.cancel,
            color: mainTheme.colorScheme.primary,
          ),
          onPressed: () => _onCancel(context),
        ),
      ];
    } else {
      return [];
    }
  }

  void _onEdit(final BuildContext context) {
    context.read<IndexCardViewBloc>().add(EditIndexCard());
  }

  void _onDelete(final BuildContext context) {
    context.read<IndexCardViewBloc>().add(DeleteIndexCard());
  }

  void _onSave(final BuildContext context) {
    context.read<IndexCardViewBloc>().add(SaveIndexCard());
    this._card = IndexCard(_card.indexCardId,
        title: _editQuestionController.text,
        contentJson: _editAnswerController.toJson(),
        deckId: _card.deckId);
  }

  void _onCancel(final BuildContext context) {
    context.read<IndexCardViewBloc>().add(ViewIndexCard());
  }

  // ################################################################# Body

  Widget _getBody(final IndexCardState state) {
    if (state is IndexCardViewing) {
      return _getView();
    } else if (state is IndexCardEditing) {
      return _getEditView();
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  Widget _getView() => Container(
      constraints: const BoxConstraints.expand(),
      child: FlipCard(
          controller: _flipCardController,
          fill: Fill.fillFront,
          // The side to initially display.
          front: Card(
              color: mainTheme.colorScheme.primary.withOpacity(0.5),
              child: Align(
                child: Text(_card.title),
              )),
          back: Card(
              color: mainTheme.colorScheme.secondary.withOpacity(0.5),
              child: AbsorbPointer(
                  child: RichTextEditorWidget(
                readonly: true,
                contentJson: _card.contentJson,
              )))));

  Widget _getEditView() => Column(
        children: <Widget>[
          // display deck name
          Align(
              alignment: Alignment.centerLeft,
              child: Text('Deck: ${_card.deckId}',
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
              contentJson: _card.contentJson,
            ),
          ),
        ],
      );
}
