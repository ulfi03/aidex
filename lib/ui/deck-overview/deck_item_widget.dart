import 'package:aidex/bloc/deck_overview_bloc.dart';
import 'package:aidex/data/model/deck.dart';
import 'package:aidex/ui/deck-overview/delete_deck_dialog.dart';
import 'package:aidex/ui/routes.dart';
import 'package:aidex/ui/theme/aidex_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A widget that represents a deck item.
class DeckItemWidget extends StatelessWidget {
  /// Creates a new deck item widget.
  const DeckItemWidget({
    required this.deck,
    super.key,
  });

  /// A key used to identify the deck name widget in tests.
  static const deckNameKey = Key('deck_name');

  /// The deck to display.
  final Deck deck;

  @override
  Widget build(final BuildContext context) {
    final iconSize = MediaQuery.of(context).size.width / 4;

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (final context) =>
                ItemOnDeckOverviewSelectedRoute(deck: deck),
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
          color: deck.color,
          border: Border.all(
            color: mainTheme.colorScheme.onBackground,
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
                color: mainTheme.colorScheme.primary,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Align(
                  alignment: const Alignment(-1.2, -0.5),
                  child: Text(
                    deck.name,
                    key: deckNameKey,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        color: mainTheme.colorScheme.onBackground),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (final value) async {
                final DeckOverviewBloc deckOverviewBloc =
                    context.read<DeckOverviewBloc>();
                if (value == 'delete') {
                  await showDialog(
                      context: context,
                      builder: (final context) => BlocProvider.value(
                          value: deckOverviewBloc,
                          child: DeleteDeckDialog(deck: deck)));
                } else if (value == 'rename') {
                  _renameDeck(context, deck, deckOverviewBloc);
                }
              },
              icon: Icon(
                Icons.more_vert,
                color: mainTheme.colorScheme.onSurface,
              ),
              itemBuilder: (final context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(
                      Icons.delete,
                      color: mainTheme.colorScheme.primary,
                    ),
                    title: Text(
                      'Delete Deck',
                      style: mainTheme.textTheme.titleSmall,
                    ),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'rename',
                  child: ListTile(
                    leading: Icon(
                      Icons.edit,
                      color: mainTheme.colorScheme.primary,
                    ),
                    title: Text(
                      'Rename Deck',
                      style: mainTheme.textTheme.titleSmall,
                    ),
                  ),
                ),
              ],
              color: mainTheme.colorScheme.background,
            ),
          ],
        ),
      ),
    );
  }

  void _renameDeck(final BuildContext context, final Deck deck,
      final DeckOverviewBloc deckOverviewBloc) {
    final TextEditingController textController =
        TextEditingController(text: deck.name);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (final context) => StatefulBuilder(
        builder: (final context, final setState) => AlertDialog(
          title: const Text('Rename Deck'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: textController,
              maxLength: 21,
              decoration: InputDecoration(
                labelText: 'New name',
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                counterText: '${textController.text.length}/21',
              ),
              onChanged: (final text) {
                setState(() {}); // update counterText
              },
              validator: (final value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a new name';
                }
                if (!RegExp(r'^[a-zA-Z0-9 ]*$').hasMatch(value)) {
                  return 'Only a-z, A-Z, 0-9\nand spaces allowed';
                }
                return null;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, // This is the color of the text
                backgroundColor:
                    Colors.transparent, // This is the background color
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor:
                    const Color(0xFF20EFC0), // This is the background color
              ),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final newName = textController.text;
                  deckOverviewBloc
                      .add(RenameDeck(deck: deck, newName: newName));
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Ok'),
            ),
          ],
        ),
      ),
    );
  }
}
