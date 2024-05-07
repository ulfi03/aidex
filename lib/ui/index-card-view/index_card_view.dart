import 'package:aidex/bloc/index_card_view_bloc.dart';
import 'package:aidex/data/model/deck.dart';
import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/data/repo/index_card_repository.dart';
import 'package:aidex/ui/components/app_bar_components.dart';
import 'package:aidex/ui/components/custom_flip_card.dart';
import 'package:aidex/ui/components/error_display_widget.dart';
import 'package:aidex/ui/routes.dart';
import 'package:aidex/ui/theme/aidex_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A route used to display the selected index card.
class IndexCardViewPage extends StatelessWidget {
  /// Constructor for the [IndexCardViewPage].
  const IndexCardViewPage(
      {required final int indexCardId, required final Deck deck, super.key})
      : _indexCardId = indexCardId,
        _deck = deck;

  final int _indexCardId;
  final Deck _deck;

  @override
  Widget build(final BuildContext context) => BlocProvider(
        create: (final context) => IndexCardViewBloc(
          indexCardId: _indexCardId,
          indexCardRepository: context.read<IndexCardRepository>(),
        ),
        child: IndexCardView(
          deck: _deck,
        ),
      );
}

/// a widget that displays an index card with a field for a question and a field
/// for an answer. The answer is displayed in a readonly rich text editor.
class IndexCardView extends StatelessWidget {
  /// Constructor for the [IndexCardView].s
  const IndexCardView({required final Deck deck, super.key}) : _deck = deck;

  final Deck _deck;

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
                      Text(_deck.name, style: mainTheme.textTheme.titleSmall),
                      Text(
                        'Index Card ${state.indexCardId}',
                        style: mainTheme.textTheme.titleMedium,
                      ),
                    ]),
                    actions: _getActions(context, state),
                    bottom: AppBarBottomWidget(color: _deck.color),
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
            builder: (final context) =>
                IndexCardEditRoute(initialIndexCard: indexCard, deck: _deck)))
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
      return CustomFlipCard(card: state.indexCard);
    } else if (state is IndexCardLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is IndexCardError) {
      return ErrorDisplayWidget(errorMessage: state.message);
    } else {
      return const ErrorDisplayWidget(errorMessage: 'Something went wrong!');
    }
  }
}
