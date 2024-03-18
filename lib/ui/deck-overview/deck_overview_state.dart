import 'package:aidex/ui/deck-overview/deck_item_widget.dart';
import 'package:flutter/material.dart';
import '../../app/model/deck.dart';
import '../../ui/deck-overview/create_deck_snackbar_widget.dart';
import 'deck_overview_widget.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class DeckOverviewState extends State<DeckOverviewWidget> {
  List<Deck> decks = [];
  bool isAddButtonVisible = true;

  void addDeck(String name, Color color) {
    setState(() {
      decks.add(Deck(name: name, color: color));
    });
  }

  void showCreateDeckDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Color pickerColor = const Color(0xFF121212); // Initial color
        String deckName = '';
        return StatefulBuilder(builder: (context, setState) {
          return SizedBox(
            child: AlertDialog(
              backgroundColor: const Color(0xFF414141),
              title: const Text(
                'Create Deck',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Deck Name TextField
                  Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            deckName = value;
                          });
                        },
                        maxLength: 21,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'deck name',
                          hintStyle: const TextStyle(
                            color: Colors.white54,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          errorText: deckName.isEmpty
                              ? 'Please enter a deck name'
                              : null,
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
                        builder: (BuildContext context) {
                          return AlertDialog(
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
                                onColorChanged: (color) {
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
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pickerColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
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
                          addDeck(deckName, pickerColor);
                          Navigator.of(context).pop();
                        },
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
          );
        });
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
