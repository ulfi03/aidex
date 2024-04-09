import 'package:aidex/bloc/index_card_view_bloc.dart';
import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/data/repo/index_card_repository.dart';
import 'package:aidex/ui/components/error_display_widget.dart';
import 'package:aidex/ui/components/rich_text_editor_widget.dart';
import 'package:aidex/ui/routes.dart';
import 'package:aidex/ui/theme/aidex_theme.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A route used to display the selected index card.
class IndexCardViewPage extends StatelessWidget {
  /// Constructor for the [IndexCardViewPage].
  const IndexCardViewPage(
      {required final int indexCardId,
      required final String deckName,
      super.key})
      : _indexCardId = indexCardId,
        _deckName = deckName;

  final int _indexCardId;
  final String _deckName;

  @override
  Widget build(final BuildContext context) => BlocProvider(
        create: (final context) => IndexCardViewBloc(
          indexCardId: _indexCardId,
          indexCardRepository: context.read<IndexCardRepository>(),
        ),
        child: IndexCardView(
          deckName: _deckName,
        ),
      );
}

/// a widget that displays an index card with a field for a question and a field
/// for an answer. The answer is displayed in a readonly rich text editor.
class IndexCardView extends StatelessWidget {
  /// Constructor for the [IndexCardView].s
  const IndexCardView({required final String deckName, super.key})
      : _deckName = deckName;

  final String _deckName;

  @override
  Widget build(final BuildContext context) =>
      BlocListener<IndexCardViewBloc, IndexCardViewState>(
          listenWhen: (final previous, final current) =>
              current is IndexCardDeleted,
          listener: (final context, final state) => Navigator.pop(context),
          child: BlocBuilder<IndexCardViewBloc, IndexCardViewState>(
              builder: (final context, final state) => Scaffold(
                  appBar: AppBar(
                    title: Column(children: <Widget>[
                      Text(_deckName, style: mainTheme.textTheme.titleSmall),
                      Text(
                        'Index Card ${state.indexCardId}',
                        style: mainTheme.textTheme.titleMedium,
                      ),
                    ]),
                    actions: _getActions(context, state),
                  ),
                  body: _getBody(state))));

  // ################################################################# Actions

  List<Widget> _getActions(
      final BuildContext context, final IndexCardViewState state) {
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
          onPressed: () => _onDelete(context, state.indexCardId),
        )
      ];
    } else {
      return [];
    }
  }

  void _onEdit(final BuildContext context, final IndexCard indexCard) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (final context) => IndexCardEditRoute(
                initialIndexCard: indexCard, deckName: _deckName)))
        .then((final value) => context
            .read<IndexCardViewBloc>()
            .add(FetchIndexCard(indexCardId: indexCard.indexCardId!)));
  }

  void _onDelete(final BuildContext context, final int indexCardId) {
    context
        .read<IndexCardViewBloc>()
        .add(DeleteIndexCard(indexCardId: indexCardId));
  }

// ################################################################# Body

  Widget _getBody(final IndexCardViewState state) {
    if (state is IndexCardInitial || state is IndexCardDeleted) {
      return const SizedBox.shrink();
    } else if (state is IndexCardViewing) {
      return _getView(state.indexCard);
    } else if (state is IndexCardLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is IndexCardError) {
      return ErrorDisplayWidget(errorMessage: state.message);
    } else {
      return const ErrorDisplayWidget(errorMessage: 'Something went wrong!');
    }
  }

  Widget _getView(final IndexCard card) => Container(
      constraints: const BoxConstraints.expand(),
      child: FlipCard(
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
                controller: RichTextEditorController(contentJson: card.answer),
              )))));
}
