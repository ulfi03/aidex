import 'dart:async';

import 'package:aidex/ui/components/basic_error_dialog.dart';
import 'package:aidex/ui/theme/aidex_theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
/// This widget is used to display the create deck dialog.
class CreateDeckDialogOnAI extends StatelessWidget {
  /// Constructor for the [CreateDeckDialogOnAI].
  const CreateDeckDialogOnAI({super.key});

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
    final fileNameController = TextEditingController();
     /// The result of the file picker.
    FilePickerResult? result;
    return AlertDialog(
      backgroundColor: mainTheme.colorScheme.background,
      title: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
        key: showCreateDeckDialogTitleKey,
        'Create Deck',
        style: mainTheme.textTheme.titleLarge,
        ),
        const SizedBox(width: 8),
        Padding(
        padding: const EdgeInsets.only(bottom: 2.5),
        child: Text(
          'with AI',
          style: TextStyle(
          fontSize: 12,
          color: mainTheme.colorScheme.primary,
          fontWeight: FontWeight.bold,
          ),
        ),
        ),
      ],
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
            ElevatedButton(
              onPressed: () async {
                result = await FilePicker.platform
                .pickFiles();
                if (result != null) {
                  final selectedFileName = result?.files.first.name;
                  // Set the selected file name to the text field
                  fileNameController.text = selectedFileName!; 
                } else {
                    unawaited(showDialog(
                      context: context,
                      builder: (final context) => AlertDialog(
                          title: const Text('Alert'),
                            content: Text(
                            'No file selected',
                            style: TextStyle(
                              color: mainTheme.colorScheme.error,
                            ),
                            ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                    ));
                  }
              },
              child: const Text('File Chooser'),
            ),
            TextField(
              enabled: false,
              controller: fileNameController,
              decoration: InputDecoration(
              hintText: 'No file selected',
              hintStyle: TextStyle(
                color: mainTheme.colorScheme.error,
                fontSize: 14,
              ),
              ),
            ),
            // Buttons
          const SizedBox(height: 4),
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
                  if (result == null) {
                    if(deckNameController.text == ''){
                      await showBasicErrorDialog(context,
                       'Please enter a deck name\nNo file selected');
                      return;
                    }else{
                    await showBasicErrorDialog(context, 'No file selected');
                    }
                    return;
                  }
                  if (deckNameController.text == '') {
                    await showBasicErrorDialog(context,
                     'Please enter a deck name');
                    return;
                  }
                  

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
