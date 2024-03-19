import 'package:aidex/app/model/deck.dart';
import 'package:aidex/ui/deck-overview/create_deck_snackbar_widget.dart';
import 'package:aidex/ui/deck-overview/deck_item_widget.dart';
import 'package:aidex/ui/deck-overview/deck_overview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

/// The state of the DeckOverviewWidget.
/// This class is responsible for the logic of the DeckOverviewWidget.
/// It contains the list of decks and the logic to add a deck to the list.
/// It also contains the logic to show a dialog to create a deck.
class DeckOverviewState extends State<DeckOverviewWidget> {
  /// The key for the dialog title.
  static const Key showCreateDeckDialogTitleKey = Key('DeckDialogTitleKey');

  /// The list of decks.
  List<Deck> decks = [];

  /// A boolean to check if the add button is visible.
  bool isAddButtonVisible = true;

  /// Add a [deck] to the list of decks.
  void addDeck(final Deck deck) {
    setState(() {
      decks.add(deck);
    });
  }

  /// Show a dialog to create a deck.
  Future<void> showCreateDeckDialog(final BuildContext context) async {
    await showDialog(
      context: context,
      builder: (final context) {
        var pickerColor = const Color(0xFF121212); // Initial color
        var deckName = '';
        return StatefulBuilder(
            builder: (final context, final setState) => SizedBox(
                  child: AlertDialog(
                    backgroundColor: const Color(0xFF414141),
                    title: const Text(
                      key: showCreateDeckDialogTitleKey,
                      'Create Deck',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          alignment: Alignment.topLeft,
                          children: [
                            TextField(
                              onChanged: (final value) {
                                setState(() {
                                  deckName = value;
                                });
                              },
                              maxLength: 21,
                              cursorColor: const Color(0xFF20EFC0),
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'deck name',
                                hintStyle: const TextStyle(
                                  color: Colors.white54,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                errorText: deckName.isEmpty
                                    ? 'Please enter a deck name'
                                    : null,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xFF20EFC0),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 8,
                              bottom: 27,
                              child: Text(
                                '${deckName.length}/21',
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (final context) => AlertDialog(
                                title: const Text(
                                  'Pick a color',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: const Color(0xFF414141),
                                content: SingleChildScrollView(
                                  child: BlockPicker(
                                    pickerColor: pickerColor,
                                    onColorChanged: (final color) {
                                      setState(() {
                                        pickerColor = color;
                                      });
                                    },
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'Select',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: pickerColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Color (optional)',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (deckName.isEmpty) {
                                  return;
                                }
                                addDeck(Deck(
                                  name: deckName,
                                  color: pickerColor,
                                ));
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF20EFC0),
                              ),
                              child: const Text(
                                'Ok',
                                style: TextStyle(
                                  color: Color(0xFF414141),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ));
      },
    );
  }

  @override
  Widget build(final BuildContext context) => GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'All Decks',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            backgroundColor: const Color(0xFF121212),
          ),
          backgroundColor: const Color(0xFF121212),
          body: SingleChildScrollView(
            child: Wrap(
              children: decks
                  .map((final deck) => DeckItemWidget(deck: deck))
                  .toList(),
            ),
          ),
          floatingActionButton: Visibility(
              visible: isAddButtonVisible,
              child: FloatingActionButton(
                onPressed: () async {
                  setState(() {
                    isAddButtonVisible = false;
                  });
                  await ScaffoldMessenger.of(context)
                      .showSnackBar(
                        SnackBar(
                          backgroundColor: const Color(0xFF414141),
                          content: CreateDeckSnackbarWidget(
                            onManual: () {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              showCreateDeckDialog(context);
                            },
                            onAI: () {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              // Handle AI deck creation here
                            },
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          duration: const Duration(days: 365),
                        ),
                      )
                      .closed
                      .then((final value) => {
                            ScaffoldMessenger.of(context).clearSnackBars(),
                            setState(() {
                              isAddButtonVisible = true;
                            })
                          });
                },
                backgroundColor: const Color(0xFF20EFC0),
                child: const Icon(Icons.add),
              )),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniStartFloat,
        ),
      );
}
