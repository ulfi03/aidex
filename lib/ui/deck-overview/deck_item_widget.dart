import 'package:aidex/app/model/deck.dart';
import 'package:aidex/ui/routes.dart';
import 'package:flutter/material.dart';

/// A widget used to display a deck item.
///
/// This widget is used to display a deck item.
///
/// It displays the name of the deck and an icon.
///
/// The [DeckItemWidget] requires a [deck] to be provided.
///
/// The [deck] is the deck to be displayed.
///
/// This snippet can be used in the `DeckOverviewWidget` to display the
/// deck items.
///
/// ```dart
/// ListView.builder(
///   itemCount: decks.length,
///   itemBuilder: (context, index) {
///     return DeckItemWidget(deck: decks[index]);
///   },
/// );
/// ```
///
/// {@category Widget}
class DeckItemWidget extends StatelessWidget {
  /// Constructor for the [DeckItemWidget].
  ///
  /// The [key] is used to identify the widget in the widget tree.
  ///
  /// The [deck] is the deck to be displayed.
  const DeckItemWidget({required this.deck, required this.onDelete, super.key});

  /// The deck to be displayed.
  final Deck deck;

  /// Callback function to handle deck deletion.
  final VoidCallback onDelete;

  @override
  Widget build(final BuildContext context) {
    final iconSize = MediaQuery.of(context).size.width / 4;

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (final context)
            => ItemOnDeckOverviewSelectedRoute(deck: deck),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 32,
          vertical: MediaQuery.of(context).size.width / 64,
        ),
        width: iconSize * 1.7,
        height: iconSize * 0.8,
        decoration: BoxDecoration(
          color: const Color(0xFF121212),
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
                Icons.layers,
                size: iconSize * 0.4,
                color: const Color(0xFF20EFC0),
              ),
            ),
            Expanded(
                child: Align(
                  alignment: const Alignment(-1.2, -0.5),
                  child: Text(
                    deck.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
            ),
                    PopupMenuButton<String>(
                      color: const Color(0xFF414141),
                      icon: const Icon(Icons.more_vert, color: Colors.white, size: 20), 
                      onSelected: (final value) async {
                        if (value == 'delete') {
                          await showDialog(
                            context: context,
                            builder: (final context) => AlertDialog(
                              backgroundColor: const Color(0xFF414141),
                                title: const Text('Confirm Deletion', style: TextStyle(color: Colors.white)),
                                content: const Text('Are you sure you want to delete this deck? This action cannot be reversed.', style: TextStyle(color: Colors.white)),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context); // Close the dialog
                                    },
                                    child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                        onDelete();
                                        Navigator.pop(context); // Close the dialog
                                    },
                                    child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                          );
                        }
                      },
                      itemBuilder: (final context) => <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: ListTile(
                            leading: Icon(Icons.delete, size: 17, color: Colors.white),
                            title: Text(
                              'Delete Deck',
                              style: TextStyle(fontSize: 14, color: Colors.white),
                            ),
                            dense: true, // Add this line to reduce the height
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
  }
}
