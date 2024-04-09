import 'package:aidex/bloc/index_card_edit_bloc.dart';
import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/data/repo/index_card_repository.dart';
import 'package:aidex/ui/components/error_display_widget.dart';
import 'package:aidex/ui/components/rich_text_editor_widget.dart';
import 'package:aidex/ui/index-card-view/index_card_create_edit_body.dart';
import 'package:aidex/ui/theme/aidex_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A view used to create or edit an index card.
class IndexCardEditViewPage extends StatelessWidget {
  /// Constructor for the [IndexCardEditViewPage].
  const IndexCardEditViewPage(
      {required final String deckName,
      required final IndexCard initialIndexCard,
      super.key})
      : _initialIndexCard = initialIndexCard,
        _deckName = deckName;

  final IndexCard _initialIndexCard;
  final String _deckName;

  @override
  Widget build(final BuildContext context) => BlocProvider(
        create: (final context) => IndexCardEditBloc(
            indexCardRepository: context.read<IndexCardRepository>(),
            initialIndexCard: _initialIndexCard),
        child: IndexCardEditView(
          initialIndexCard: _initialIndexCard,
          deckName: _deckName,
        ),
      );
}

/// A view used to create or edit an index card.
class IndexCardEditView extends StatelessWidget {
  /// Constructor for the [IndexCardEditView].
  IndexCardEditView(
      {required final String deckName,
      required final IndexCard initialIndexCard,
      super.key})
      : _deckName = deckName,
        _questionController =
            TextEditingController(text: initialIndexCard.question),
        _answerController =
            RichTextEditorController(contentJson: initialIndexCard.answer);

  final String _deckName;
  final TextEditingController _questionController;
  final RichTextEditorController _answerController;

  @override
  Widget build(final BuildContext context) =>
      BlocListener<IndexCardEditBloc, IndexCardEditState>(
        listenWhen: (final previous, final current) =>
            current is IndexCardUpdated,
        listener: (final context, final state) => Navigator.of(context).pop(),
        child: BlocBuilder<IndexCardEditBloc, IndexCardEditState>(
          builder: (final context, final state) => Scaffold(
              appBar: AppBar(
                title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(_deckName, style: mainTheme.textTheme.titleSmall),
                      Text(
                        'Index Card ${state.indexCard.indexCardId!}',
                        style: mainTheme.textTheme.titleMedium,
                      )
                    ]),
                actions: _getActions(context, state),
                bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(1),
                    child: Divider(
                      color: mainTheme.colorScheme.primary,
                      height: 1,
                    )),
              ),
              body: _getBody(state)),
        ),
      );

  List<Widget> _getActions(
      final BuildContext context, final IndexCardEditState state) {
    if (state is EditingIndexCard) {
      return [
        _getSaveButton(
            context, state.indexCard.indexCardId!, state.indexCard.deckId),
        _getCancelButton(context)
      ];
    } else {
      return [_getCancelButton(context)];
    }
  }

  IconButton _getSaveButton(final BuildContext context, final int indexCardId,
          final int deckId) =>
      IconButton(
        icon: Icon(Icons.save, color: mainTheme.colorScheme.primary),
        onPressed: () => _onSave(context, indexCardId, deckId),
      );

  IconButton _getCancelButton(final BuildContext context) => IconButton(
        icon: Icon(
          Icons.cancel,
          color: mainTheme.colorScheme.primary,
        ),
        onPressed: () => _onCancel(context),
      );

  void _onSave(
      final BuildContext context, final int indexCardId, final int deckId) {
    final card = IndexCard(
        indexCardId: indexCardId,
        question: _questionController.text,
        answer: _answerController.toJson(),
        deckId: deckId);
    context.read<IndexCardEditBloc>().add(UpdateIndexCard(indexCard: card));
  }

  void _onCancel(final BuildContext context) {
    Navigator.of(context).pop();
  }

  Widget _getBody(final IndexCardEditState state) {
    if (state is EditingIndexCard) {
      return IndexCardCreateEditBody(
          questionController: _questionController,
          answerController: _answerController);
    } else if (state is UpdatingIndexCard) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is IndexCardUpdated) {
      return const SizedBox.shrink();
    } else if (state is IndexCardEditError) {
      return ErrorDisplayWidget(errorMessage: state.message);
    } else {
      return const ErrorDisplayWidget(errorMessage: 'Something went wrong!');
    }
  }
}
