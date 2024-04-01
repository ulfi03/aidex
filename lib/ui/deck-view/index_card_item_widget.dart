import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/ui/routes.dart';
import 'package:aidex/ui/theme/aidex_theme.dart';
import 'package:flutter/material.dart';

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
  const IndexCardItemWidget({required this.indexCard, super.key});

  /// The index card to be displayed.
  final IndexCard indexCard;

  @override
  Widget build(final BuildContext context) {
    final iconSize = MediaQuery.of(context).size.width / 4;

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (final context) =>
                ItemOnDeckViewWidgetSelectedRoute(indexCard: indexCard),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 32,
          vertical: MediaQuery.of(context).size.width / 64,
        ),
        decoration: BoxDecoration(
          color: mainTheme.colorScheme.onSurfaceVariant,
          // Set the background color from the deck
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                child: Align(
                  alignment: const Alignment(-1.2, -0.5),
                  child: Text(
                    indexCard.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
