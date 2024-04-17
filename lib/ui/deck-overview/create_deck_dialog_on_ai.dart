import 'dart:async';
import 'dart:convert';

import 'package:aidex/bloc/deck_overview_bloc.dart';
import 'package:aidex/data/model/deck.dart';
import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/data/repo/deck_repository.dart';
import 'package:aidex/data/repo/index_card_repository.dart';
import 'package:aidex/ui/components/basic_error_dialog.dart';
import 'package:aidex/ui/theme/aidex_theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:http/http.dart' as http;

/// This widget is used to display the create deck dialog.
class CreateDeckDialogOnAI extends StatefulWidget {
  /// Constructor for the [CreateDeckDialogOnAI].
  const CreateDeckDialogOnAI({super.key});

  @override
  CreateDeckDialogOnAIState createState() => CreateDeckDialogOnAIState();
}
/// The state of the [CreateDeckDialogOnAI].
class CreateDeckDialogOnAIState extends State<CreateDeckDialogOnAI> {
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

  /// Variable to disable the button.
  bool isButtonDisabled = false;
  /// Variable to display the loading animation.
  bool isLoading = false;
  /// Variable to store the color selected by the user.
  Color pickerColor = Colors.transparent; // Initial color
  /// Controller for the deck name text field.
  final deckNameController = TextEditingController();
  /// Controller for the file name text field.
  final fileNameController = TextEditingController();
  /// Variable to store the file picker result.
  FilePickerResult? result;

  @override
  Widget build(final BuildContext context) => Stack(
    children: [
      AlertDialog(
        backgroundColor: mainTheme.colorScheme.background,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Create Deck',
              key: showCreateDeckDialogTitleKey,
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
                        'Pick a color',
                        key: pickColorTextKey,
                        style: mainTheme.textTheme.bodyMedium,
                      ),
                      backgroundColor: mainTheme.colorScheme.background,
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
                            style: mainTheme.textTheme.bodyMedium,
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
                  'Color (optional)',
                  key: selectColorTextKey,
                  style: mainTheme.textTheme.bodySmall,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['pdf', 'txt', 'docx'],
                );
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
              ),
              child: Text(
                'Choose a file',
                style: mainTheme.textTheme.bodySmall,
              ),
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
                Visibility(
                  visible: !isLoading,
                  child: TextButton(
                    onPressed: isLoading ? null : () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      key: cancelButtonTextKey,
                      style: mainTheme.textTheme.bodySmall,
                    ),
                  ),
                ),
                ElevatedButton(
                  key: okButtonKey,
                  onPressed: isButtonDisabled ? null : () async {
                    // verifying that all parameters have been set
                    if (result == null) {
                      if (deckNameController.text == '') {
                        await showBasicErrorDialog(
                          context,
                          'Please enter a deck name\nNo file selected',
                        );
                      } else {
                        await showBasicErrorDialog(
                          context,
                          'No file selected',
                        );
                      }
                      return;
                    }
                    if (deckNameController.text == '') {
                      await showBasicErrorDialog(
                        context,
                        'Please enter a deck name',
                      );
                      return;
                    }
                    // disabling the button to prevent multiple clicks
                    setState(() {
                      isButtonDisabled = true;
                      isLoading = true;
                    });
                    // add the deck like normal
                    context.read<DeckOverviewBloc>().add(
                      AddDeck(
                        deck: Deck(
                          name: deckNameController.text,
                          color: pickerColor,
                        ),
                      ),
                    );

                    // get the deck id from the deck we just created
                    final int deckId =
                        await context.read<DeckRepository>().getLastDeckId();
                    print('Last Deck ID: $deckId');

                    // initialising the arrays
                    final List<String> questions = <String>[];
                    final List<String> answers = <String>[];

                    // start of server inquiry
                    print('Now making Server request');
                    final request = http.MultipartRequest(
                      'POST',
                      Uri.parse(
                          'https://aidex-server.onrender.com/create_index_cards_from_files'),
                    );
                    request.fields['user_uuid'] = '1234';
                    request.fields['openai_api_key'] =
                        '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';
                    request.files.add(await http.MultipartFile.fromPath(
                      'file',
                      result!.files.first.path!,
                    ));
                    final response = await request.send();
                    //server response handling
                    final jsonResponse =
                        await response.stream.bytesToString();
                    print(jsonResponse);
                    final serverResponse = jsonDecode(jsonResponse);
                    final serverErrorBoolean = serverResponse['error'];
                    final serverErrorMessage = serverResponse['error_message'];
                    if (serverErrorBoolean != false) {
                      await showBasicErrorDialog(
                        context,
                        'There was an error in the server while creating the index cards. \n Error: $serverErrorMessage',
                      );
                      Navigator.pop(context);
                      return;
                    }
                    final ausgabe = serverResponse['ausgabe'];
                    for (final item in ausgabe) {
                      final frage = item['Frage'];
                      final antwort = item['Antwort'];
                      questions.add(frage);
                      answers.add(antwort);
                      print('Frage: $frage');
                      print('Antwort: $antwort');
                    }

                    for (int i = 0; i < questions.length; i++) {
                      final IndexCard indexCard = IndexCard(
                        deckId: deckId,
                        question: questions[i],
                        answer: '[{"insert":"${answers[i]}\\n"}]',
                      );
                      await context
                          .read<IndexCardRepository>()
                          .addIndexCard(indexCard);
                    }

                    //closing the menu, once everything is done
                    Navigator.pop(context);
                    await showDialog(
                      context: context,
                      builder: (final context) => AlertDialog(
                        title: const Text('Success'),
                        content: const Text('Deck created successfully'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Ok'),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainTheme.colorScheme.primary,
                  ),
                  child: isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(),
                  ) // Display loading animation with fixed size
                      : Text(
                    'Ok',
                    key: okButtonTextKey,
                    style: mainTheme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      if (isLoading)
        const ModalBarrier(
          dismissible: false,
          color: Colors.transparent,
        ),
    ],
  );
}
