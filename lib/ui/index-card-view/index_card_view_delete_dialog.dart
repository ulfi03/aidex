import 'package:aidex/bloc/index_card_view_bloc.dart';
import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/ui/components/delete_dialog.dart';
import 'package:aidex/ui/index-card-view/index_card_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A dialog that asks the user, if they want to delete an [IndexCard],
/// from [IndexCardView].
class IndexCardViewDeleteDialog extends DeleteDialog {
  /// Creates a new delete index card dialog.
  const IndexCardViewDeleteDialog({required final int indexCardId, super.key})
      : _indexCardId = indexCardId,
        super(
          objectCategory: 'Index Card',
          deleteMessage: 'Are you sure you want to delete ',
          deleteSubject: 'Index Card $indexCardId',
        );

  final int _indexCardId;

  @override
  void onDelete(final BuildContext context) {
    context
        .read<IndexCardViewBloc>()
        .add(DeleteIndexCard(indexCardId: _indexCardId));
    Navigator.pop(context);
  }
}
