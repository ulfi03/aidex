import 'package:aidex/bloc/index_cards_overview_bloc.dart';
import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/ui/components/icons.dart';
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
      required final int ordinalNo,
      super.key})
      : _ordinalNo = ordinalNo,
        _state = state;

  /// The ordinal number of the index card.
  final int _ordinalNo;

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
  Widget build(final BuildContext context) => GestureDetector(
        onTap: (_state is IndexCardSelectionMode)
            ? () => updateSelection(context)
            : () => onTap(context),
        onLongPress: (_state is IndexCardSelectionMode)
            ? () => {}
            : () => updateSelection(context),
        child: _buildContent(context),
      );

  Widget _buildContent(final BuildContext context) => Container(
        key: containerKey,
        height: 65,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 5,
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
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(alignment: Alignment.centerLeft, children: [
          Row(
            children: [
              // insert check icon if the state is IndexCardSelectionMode
              if (_state is IndexCardSelectionMode) _insertCheckIcon(_state),
              _buildCardIcon(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 25),
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
          Positioned(
              right: 0,
              bottom: 0,
              child: Text('$_ordinalNo',
                  style: mainTheme.textTheme.bodySmall!.copyWith(
                      color: mainTheme.colorScheme.onSurfaceVariant))),
        ]),
      );

  Widget _insertCheckIcon(final IndexCardSelectionMode state) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Icon(
          key: checkIconKey,
          (state.isThisCardSelected(indexCard.indexCardId!))
              ? Icons.check_circle_outline
              : Icons.circle_outlined,
          color: mainTheme.colorScheme.primary,
        ),
      );

  Widget _buildCardIcon() => Stack(alignment: Alignment.center, children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: mainTheme.colorScheme.background,
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        const RotationTransition(
          turns: AlwaysStoppedAnimation(15 / 360),
          child: IndexCardIcon(size: 30),
        ),
      ]);
}
