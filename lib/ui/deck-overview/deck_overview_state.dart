import 'package:aidex/ui/deck-overview/deck_item_widget.dart';
import 'package:flutter/material.dart';

import '../../app/model/deck.dart';
import '../../ui/deck-overview/create_deck_snackbar_widget.dart';
import 'deck_overview_widget.dart';

class DeckOverviewState extends State<DeckOverviewWidget> {
  static const Key showCreateDeckDialogTitleKey = Key("DeckDialogTitleKey");
  List<Deck> decks = [];
  bool isAddButtonVisible = true;

  void addDeck(Deck newDeck) {
    setState(() {
      decks.add(newDeck);
    });
  }

  void showCreateDeckDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String deckName = '';
        return SizedBox(
          child: AlertDialog(
            backgroundColor: const Color(0xFF414141),
            // Set background color to #414141
            title: const Text(
              key: showCreateDeckDialogTitleKey,
              'Create Deck',
              style: TextStyle(
                color: Colors.white, // Set text color to white
                fontSize: 18,
              ),
            ),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              deckName = value;
                            });
                          },
                          maxLength: 21, // Set maximum length to 21 characters
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'deck name',
                            hintStyle: const TextStyle(
                              color: Colors
                                  .white54, // Set hint text color to a lighter shade of white
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(
                                    0xFF20EFC0), // Set border color to #20EFC0
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFF20EFC0),
                                // Set border color to #20EFC0 when focused
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFF20EFC0),
                                // Set border color to #20EFC0 when enabled
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            errorText: deckName.isEmpty
                                ? 'Please enter a deck name'
                                : null, // Show error if deckName is empty
                          ),
                        ),
                        Positioned(
                          right: 8,
                          // Adjust the left position of the character count
                          bottom: 27,
                          // Adjust the bottom position of the character count
                          child: Text(
                            '${deckName.length}/21',
                            // Display character count
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12, // Set font size to 12
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Add spacing between TextField and Row
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
                              color: Colors.white, // Set text color to white
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (deckName.isEmpty) {
                              return; // Don't close the dialog if deckName is empty
                            }
                            addDeck(Deck(name: deckName));
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                                0xFF20EFC0), // Set button background color to #20EFC0
                          ),
                          child: const Text(
                            'Ok',
                            style: TextStyle(
                              color: Colors.white, // Set text color to white
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
            direction: Axis.horizontal,
            children: decks.map((deck) => DeckItemWidget(deck: deck)).toList(),
          ),
        ),
        floatingActionButton: Visibility(
            visible: isAddButtonVisible,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  isAddButtonVisible = false;
                });
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                      SnackBar(
                        backgroundColor: const Color(0xFF414141),
                        content: CreateDeckSnackbarWidget(
                          onManual: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            showCreateDeckDialog(context);
                          },
                          onAI: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            // Handle AI deck creation here
                          },
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                        ),
                        duration: const Duration(days: 365),
                      ),
                    )
                    .closed
                    .then((value) => {
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
}
