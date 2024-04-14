import 'package:aidex/bloc/index_cards_overview_bloc.dart';
import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/ui/components/error_display_widget.dart';
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
      {required this.indexCard, required this.onTap, super.key});

  /// The index card to be displayed.
  final IndexCard indexCard;

  /// The function to be called when the widget is tapped.
  final Function(BuildContext context) onTap;

  /// onLongPress function triggers selectedIndexCard
  void onSelected(final BuildContext context, final IndexCardState state) {
    final List<int> selectedIndexCardIds =
        (state is IndexCardSelectionMode) ? state.indexCardIds : [];
    //Philosophy in question: Business logic in UI?
    if (!selectedIndexCardIds.contains(indexCard.indexCardId)) {
      selectedIndexCardIds.add(indexCard.indexCardId!);
    } else {
      selectedIndexCardIds.remove(indexCard.indexCardId);
    }
    context.read<IndexCardOverviewBloc>().add(
          ManageSelectedIndexCards(indexCardIds: selectedIndexCardIds),
        );
  }

  @override
  Widget build(final BuildContext context) {
    final iconSize = MediaQuery.of(context).size.width / 4;

    return BlocBuilder<IndexCardOverviewBloc, IndexCardState>(
        builder: (final context, final state) {
      if (state is IndexCardSelectionMode || state is IndexCardsLoaded) {
        return GestureDetector(
          onTap: () {
            if (state is IndexCardSelectionMode) {
              onSelected(context, state);
            } else {
              onTap(context);
            }
          },
          onLongPress: () => onSelected(context, state),
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 32,
              vertical: MediaQuery.of(context).size.width / 64,
            ),
            decoration: BoxDecoration(
              color: () {
                if (state is IsThisCardSelected) {
                  return (state.isThisCardSelected(indexCard.indexCardId!))
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
                if (state is IsThisCardSelected)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Icon(
                      (state.isThisCardSelected(indexCard.indexCardId!))
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
                      style: TextStyle(
                          fontSize: 16, color: mainTheme.colorScheme.onSurface),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return const ErrorDisplayWidget(errorMessage: 'Something went wrong!');
      }
    });
  }
}
