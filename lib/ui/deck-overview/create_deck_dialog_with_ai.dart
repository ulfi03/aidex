import 'package:aidex/bloc/create_deck_dialog_with_ai_bloc.dart';
import 'package:aidex/bloc/deck_overview_bloc.dart';
import 'package:aidex/data/model/deck.dart';
import 'package:aidex/ui/components/basic_error_dialog.dart';
import 'package:aidex/ui/components/custom_buttons.dart';
import 'package:aidex/ui/theme/aidex_theme.dart';
import 'package:aidex/ui/utilities.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

/// This widget is used to display the create deck dialog.
class CreateDeckDialogWithAi extends StatefulWidget {
  /// Constructor for the [CreateDeckDialogWithAi].
  const CreateDeckDialogWithAi({super.key});

  @override
  State<StatefulWidget> createState() => CreateDeckDialogWithAiState();
}

/// This widget is used to display the create deck dialog.
class CreateDeckDialogWithAiState extends State<CreateDeckDialogWithAi> {
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

  /// Controller for the deck name text field.
  final deckNameController = TextEditingController();

  /// Controller for the file name text field.
  final fileNameController = TextEditingController();

  /// Variable to store the color selected by the user.
  Color pickerColor = Colors.transparent; // Initial color

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
                    ).then((final result) async {
                      if (result != null) {
                        final selectedFileName = result.files.first.name;
                        // Set the selected file name to the text field
                        fileNameController.text = selectedFileName;
                      } else {
                        await showDialog(
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
                        );
                      }
                      return result;
                    });
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
                BlocListener<CreateDeckDialogWithAiBloc,
                        CreateDeckDialogOnAiState>(
                    listener: (final context, final state) async {
                      if (state is CreateDeckDialogOnAiSuccess) {
                        Navigator.pop(context);
                        context
                            .read<DeckOverviewBloc>()
                            .add(const FetchDecks());
                        await showDialog(
                          context: context,
                          builder: (final context) => AlertDialog(
                            title: const Text('Success'),
                            content: const Text('Deck created successfully'),
                            actions: [
                              OkButton(onPressed: () {
                                Navigator.pop(context);
                              }),
                            ],
                          ),
                        );
                      } else if (state is CreateDeckDialogOnAiFailure) {
                        await showBasicErrorDialog(
                          context,
                          state.message,
                        ).then((final _) => context
                            .read<CreateDeckDialogWithAiBloc>()
                            .add(ResetCreateDeckDialogOnAi()));
                      }
                    },
                    child: BlocBuilder<CreateDeckDialogWithAiBloc,
                        CreateDeckDialogOnAiState>(
                      builder: (final context, final state) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Visibility(
                            visible: state is! CreateDeckDialogOnAiLoading,
                            child: CancelButton(
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          ElevatedButton(
                            key: okButtonKey,
                            onPressed: _getOnPressed(context, state),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mainTheme.colorScheme.primary,
                            ),
                            child: state is CreateDeckDialogOnAiLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(),
                                  ) // Display loading animation with fixed size
                                : Text(
                                    'Create',
                                    key: okButtonTextKey,
                                    style: mainTheme.textTheme.bodySmall,
                                  ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          BlocBuilder<CreateDeckDialogWithAiBloc, CreateDeckDialogOnAiState>(
              builder: (final context, final state) {
            if (state is CreateDeckDialogOnAiLoading) {
              return const ModalBarrier(
                dismissible: false,
                color: Colors.transparent,
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
        ],
      );

  /// Validates the deck.
  ValidationResult _validateDeck() {
    // verifying that all parameters have been set
    if (result == null) {
      if (deckNameController.text == '') {
        return ValidationResult.error(
            'Please enter a deck name\nNo file selected');
      } else {
        return ValidationResult.error('No file selected');
      }
    }
    if (deckNameController.text == '') {
      return ValidationResult.error('Please enter a deck name');
    }
    return ValidationResult.success();
  }

  /// Handles the onPressed event of the create deck button.
  void Function()? _getOnPressed(
      final BuildContext context, final CreateDeckDialogOnAiState state) {
    if (state is CreateDeckDialogOnAiInitial) {
      return () async {
        final ValidationResult validationResult = _validateDeck();
        if (!validationResult.isValid) {
          await showBasicErrorDialog(
            context,
            validationResult.message,
          );
        } else {
          context.read<CreateDeckDialogWithAiBloc>().add(
                CreateDeckWithAi(
                  deck: Deck(
                    name: deckNameController.text,
                    color: pickerColor,
                  ),
                  filepath: result!.files.first.path!,
                ),
              );
        }
      };
    } else {
      return null;
    }
  }
}
