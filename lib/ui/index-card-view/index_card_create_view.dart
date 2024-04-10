import 'package:aidex/bloc/index_card_create_bloc.dart';
import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/data/repo/index_card_repository.dart';
import 'package:aidex/ui/components/error_display_widget.dart';
import 'package:aidex/ui/components/rich_text_editor_widget.dart';
import 'package:aidex/ui/index-card-view/index_card_create_edit_body.dart';
import 'package:aidex/ui/theme/aidex_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A page used to create an index card.
class IndexCardCreateViewPage extends StatelessWidget {
  /// Constructor for the [IndexCardCreateViewPage].
  const IndexCardCreateViewPage(
      {required final int deckId, required final String deckName, super.key})
      : _deckId = deckId,
        _deckName = deckName;

  final int _deckId;
  final String _deckName;

  @override
  Widget build(final BuildContext context) => BlocProvider(
      create: (final context) => IndexCardCreateBloc(
          indexCardRepository: context.read<IndexCardRepository>(),
            deckId: _deckId),
      child: IndexCardCreateView(
        deckName: _deckName,
      ));
}

/// The view used to create an index card.
class IndexCardCreateView extends StatelessWidget {
  /// Constructor for the [IndexCardCreateView].
  IndexCardCreateView({required final String deckName, super.key})
      : _deckName = deckName,
        _questionController = TextEditingController(),
        _answerController = RichTextEditorController();

  final String _deckName;
  final TextEditingController _questionController;
  final RichTextEditorController _answerController;

  @override
  Widget build(final BuildContext context) =>
      BlocListener<IndexCardCreateBloc, IndexCardCreateState>(
        listenWhen: (final previous, final current) =>
            current is IndexCardCreated,
        listener: (final context, final state) => Navigator.of(context).pop(),
        child: BlocBuilder<IndexCardCreateBloc, IndexCardCreateState>(
          builder: (final context, final state) => Scaffold(
              appBar: AppBar(
                title: Column(children: <Widget>[
                  Text(_deckName, style: mainTheme.textTheme.titleSmall),
                  Text('Create Index Card',
                      style: mainTheme.textTheme.titleMedium)
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
      final BuildContext context, final IndexCardCreateState state) {
    if (state is IndexCardCreateInitial) {
      return [_getSaveButton(context, state.deckId), _getCancelButton(context)];
    } else {
      return [_getCancelButton(context)];
    }
  }

  IconButton _getSaveButton(final BuildContext context, final int deckId) =>
      IconButton(
          icon: Icon(Icons.save, color: mainTheme.colorScheme.primary),
          onPressed: () => _onSaveNew(context, deckId));

  IconButton _getCancelButton(final BuildContext context) => IconButton(
        icon: Icon(
          Icons.cancel,
          color: mainTheme.colorScheme.primary,
        ),
        onPressed: () => _onCancel(context),
      );

  void _onSaveNew(final BuildContext context, final int deckId) {
    final card = IndexCard(
        question: _questionController.text,
        answer: _answerController.toJson(),
        deckId: deckId);
    context.read<IndexCardCreateBloc>().add(CreateIndexCard(indexCard: card));
  }

  void _onCancel(final BuildContext context) {
    Navigator.of(context).pop();
  }

  Widget _getBody(final IndexCardCreateState state) {
    if (state is IndexCardCreateInitial) {
      return IndexCardCreateEditBody(
          questionController: _questionController,
          answerController: _answerController);
    } else if (state is IndexCardSaving) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is IndexCardCreated) {
      return const SizedBox.shrink();
    } else if (state is IndexCardCreateError) {
      return ErrorDisplayWidget(errorMessage: state.message);
    } else {
      return const ErrorDisplayWidget(errorMessage: 'Something went wrong!');
    }
  }
}
