import 'package:aidex/bloc/index_card_view_bloc.dart';
import 'package:aidex/bloc/index_cards_overview_bloc.dart';
import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/ui/components/delete_dialog.dart';
import 'package:aidex/ui/deck-view/index_cards_overview_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A dialog that asks the user, if they want to delete an (or multiple) [IndexCard]/s, from [IndexCardOverview].
class DeleteIndexCardsDialog extends DeleteDialog {
  /// Creates a new delete index card dialog.
  const DeleteIndexCardsDialog({required this.indexCardIds, super.key})
      : super(
          objectCategory:
              indexCardIds.length > 1 ? 'Index Cards' : 'Index Card',
          deleteMessage: 'Are you sure you want to delete ',
          deleteSubject: '${indexCardIds.length} '
              '${indexCardIds.length > 1 ? 'Index Cards' : 'Index Card'}',
        );

  /// The selected index cards to be deleted.
  final List<int> indexCardIds;

  @override
  void onDelete(final BuildContext context) {
    if (context.read<IndexCardOverviewBloc?>() != null &&
        context.read<IndexCardOverviewBloc>().state is IndexCardSelectionMode) {
      context
          .read<IndexCardOverviewBloc>()
          .add(RemoveIndexCardsById(selectedIndexCardsIds: indexCardIds));
      context
          .read<IndexCardOverviewBloc>()
          .add(const ExitIndexCardSelectionMode());
    } else if (context.read<IndexCardViewBloc?>() != null &&
        context.read<IndexCardViewBloc>().state is IndexCardViewing) {
      context
          .read<IndexCardViewBloc>()
          .add(DeleteIndexCard(indexCardId: indexCardIds.first));
    }
    Navigator.pop(context);
  }
}
