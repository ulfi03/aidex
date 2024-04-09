import 'package:aidex/bloc/deck_overview_bloc.dart';
import 'package:aidex/data/model/deck.dart';
import 'package:aidex/ui/theme/aidex_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
/// This widget is used to display the create deck dialog.
class CreateDeckDialog extends StatelessWidget {
  /// Constructor for the [CreateDeckDialog].
  const CreateDeckDialog({super.key});

  /// The key for the dialogMethods Widget title.
  static const Key showCreateDeckDialogTitleKey = Key('DeckDialogTitleKey');

  /// The key for the color picker button.
  static const Key colorPickerButtonKey = Key('ColorPickerButton');

  /// Widget Title of color picker.
  static const Key pickColorTextKey = Key('PickColorText');

  /// Button to select a color from the color picker.
  static const Key colorPickerSelectButtonKey = Key('ColorPickerSelectButton');

  ///(Key to) Button text for the button to select a color the created deck.
  static const Key selectColorTextKey = Key('SelectColorText');

  ///(Key to) Button text for the button to cancel the deck creation.
  static const Key cancelButtonTextKey = Key('CancelButtonText');

  ///(Key to) Button text for the button to confirm the deck creation.
  static const Key okButtonTextKey = Key('OkButtonTextKey');

  ///(Key to) TextField to input the deck name.
  static const Key deckNameTextFieldKey = Key('InputTextField_deckName');

  ///(Key to) Button to add the deck.
  static const Key okButtonKey = Key('OkButtonKey');

  @override
  Widget build(final BuildContext context) {
    var pickerColor = Colors.transparent; // Initial color
    final deckNameController = TextEditingController();
    return AlertDialog(
      backgroundColor: mainTheme.colorScheme.background,
      title: Text(
        key: showCreateDeckDialogTitleKey,
        'Create Deck',
        style: mainTheme.textTheme.titleLarge 
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Deck Name TextField
          Stack(
            alignment: Alignment.topLeft,
            children: [
              TextFormField(
                key: deckNameTextFieldKey,
                autovalidateMode: AutovalidateMode.always,
                controller: deckNameController,
                maxLength: 21,
                validator: (final value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a deck name';
                  }
                  return null;
                },
                cursorColor: mainTheme.colorScheme.primary,
                style: mainTheme.textTheme.bodySmall,
                decoration: InputDecoration(
                  hintText: 'deck name',
                  hintStyle: TextStyle(
                    color: mainTheme.colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: mainTheme.colorScheme.primary,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: mainTheme.colorScheme.primary,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          StatefulBuilder(
              builder: (final context, final setState) => ElevatedButton(
                key: colorPickerButtonKey,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (final context) => AlertDialog(
                          title: Text(
                            key: pickColorTextKey,
                            'Pick a color',
                            style: mainTheme.textTheme.bodyMedium
                          ),
                          backgroundColor: mainTheme.
                          colorScheme.background,
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
                              key: colorPickerSelectButtonKey,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Select',
                                style: mainTheme.textTheme.bodyMedium
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
                    child: Text(
                      key: selectColorTextKey,
                      'Color (optional)',
                      style: mainTheme.textTheme.bodySmall
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
                child: Text(
                  key: cancelButtonTextKey,
                  'Cancel',
                  style: mainTheme.textTheme.bodySmall
                ),
              ),
              ElevatedButton(key: okButtonKey,
                onPressed: () async {
                  context.read<DeckOverviewBloc>().add(AddDeck(
                      deck: Deck(
                          name: deckNameController.text, color: pickerColor)));
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainTheme.colorScheme.primary,
                ),
                child: Text(
                  key: okButtonTextKey,
                  'Ok',
                  style: mainTheme.textTheme.bodySmall
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
