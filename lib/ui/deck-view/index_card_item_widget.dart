import 'package:aidex/bloc/index_cards_overview_bloc.dart';
import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/ui/theme/aidex_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A widget used to display an index card item.
///
/// It displays the title of the index card.
///
/// The [IndexCardItemWidget] requires an [indexCard] to be provided.
///
/// The [indexCard] represents the index card to be displayed.
///
/// This widget is used in 'DeckViewWidget' to display
/// the viewed decks index cards.
///
/// The [key] is used to identify the widget in the widget tree.
class IndexCardItemWidget extends StatelessWidget {
  /// Constructor for the [IndexCardItemWidget].
  const IndexCardItemWidget(
      {required this.indexCard,
      required final IndexCardState state,
      required this.onTap,
      super.key})
      : _state = state;

  /// The index card to be displayed.
  final IndexCard indexCard;

  /// The state of the index card.
  final IndexCardState _state;

  /// The function to be called when the widget is tapped.
  final Function(BuildContext context) onTap;

  /// The key to access the widgets container
  static const containerKey = Key('index_card_item_container');

  /// The key to access the widgets check icon
  static const checkIconKey = Key('index_card_item_check_icon');

  /// updateSelection function manages the selection of the index card.
  /// > adds an index card to the selected index cards list if it isn't selected
  /// > removes index card from the selected index cards list if it was selected
  /// -> after one of these operations on the selected index cards list
  /// > update the selected index cards list in the bloc
  void updateSelection(final BuildContext context) {
    final List<int> selectedIndexCardIds =
        (_state is IndexCardSelectionMode) ? _state.indexCardIds : [];
    if (!selectedIndexCardIds.contains(indexCard.indexCardId)) {
      selectedIndexCardIds.add(indexCard.indexCardId!);
    } else {
      selectedIndexCardIds.remove(indexCard.indexCardId);
    }
    context.read<IndexCardOverviewBloc>().add(
          UpdateSelectedIndexCards(indexCardIds: selectedIndexCardIds),
        );
  }

  @override
  Widget build(final BuildContext context) {
    final iconSize = MediaQuery.of(context).size.width / 4;

    return GestureDetector(
      onTap: (_state is IndexCardSelectionMode)
          ? () => updateSelection(context)
          : () => onTap(context),
      onLongPress: (_state is IndexCardSelectionMode)
          ? () => {}
          : () => updateSelection(context),
      child: Container(
        key: containerKey,
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 32,
          vertical: MediaQuery.of(context).size.width / 64,
        ),
        decoration: BoxDecoration(
          color: () {
            if (_state is IndexCardSelectionMode) {
              return (_state.isThisCardSelected(indexCard.indexCardId!))
                  ? mainTheme.colorScheme.onSurfaceVariant
                  : mainTheme.colorScheme.surface;
            } else {
              return mainTheme.colorScheme.surface;
            }
          }(),
          // Set the background color from the deck
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            if (_state is IndexCardSelectionMode)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Icon(
                  key: checkIconKey,
                  (_state.isThisCardSelected(indexCard.indexCardId!))
                      ? Icons.check_circle_outline
                      : Icons.circle_outlined,
                  size: iconSize * 0.25,
                  color: mainTheme.colorScheme.primary,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.library_books_outlined,
                size: iconSize * 0.4,
                color: mainTheme.colorScheme.primary,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  indexCard.question,
                  textAlign: TextAlign.start,
                  style: mainTheme.textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
