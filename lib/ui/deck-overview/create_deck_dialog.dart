import 'package:aidex/bloc/deck_overview_bloc.dart';
import 'package:aidex/model/deck.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

/// This widget is used to display the create deck dialog.
class CreateDeckDialog extends StatelessWidget {

  /// Constructor for the [CreateDeckDialog].
  const CreateDeckDialog({super.key});

  @override
  Widget build(final BuildContext context) {
    var pickerColor = const Color(0xFF121212); // Initial color
    final deckNameController = TextEditingController();
    return AlertDialog(
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
              TextFormField(
                autovalidateMode: AutovalidateMode.always,
                controller: deckNameController,
                maxLength: 21,
                validator: (final value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a deck name';
                  }
                  return null;
                },
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
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF20EFC0),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF20EFC0),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          StatefulBuilder(
              builder: (final context, final setState) => ElevatedButton(
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
                            setState(() => pickerColor = color);
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
              )),
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
                onPressed: () async {
                  context.read<DeckOverviewBloc>().add(AddDeck(
                      deck: Deck(
                          name: deckNameController.text,
                          color: pickerColor)));
                  Navigator.pop(context);
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
    );
  }
}
