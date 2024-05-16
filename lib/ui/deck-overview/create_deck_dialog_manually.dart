import 'package:aidex/bloc/deck_overview_bloc.dart';
import 'package:aidex/data/model/deck.dart';
import 'package:aidex/ui/components/custom_buttons.dart';
import 'package:aidex/ui/components/custom_color_picker.dart';
import 'package:aidex/ui/components/custom_text_form_field.dart';
import 'package:aidex/ui/deck-overview/deck_validators.dart';
import 'package:aidex/ui/theme/aidex_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This widget is used to display the create deck dialog.
class CreateDeckDialogManually extends StatelessWidget {
  /// Constructor for the [CreateDeckDialogManually].
  const CreateDeckDialogManually({super.key});

  /// The key for the dialogMethods Widget title.
  static const Key showCreateDeckDialogTitleKey = Key('DeckDialogTitleKey');

  ///(Key to) TextField to input the deck name.
  static const Key deckNameTextFieldKey = Key('InputTextField_deckName');

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(final BuildContext context) {
    var pickerColor = mainTheme.colorScheme.surface; // Initial color
    final deckNameController = TextEditingController();
    return AlertDialog(
      scrollable: true,
      backgroundColor: mainTheme.colorScheme.background,
      title: Text(
          key: showCreateDeckDialogTitleKey,
          'Create Deck',
          style: mainTheme.textTheme.titleLarge),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Deck Name TextField
          Stack(
            alignment: Alignment.topLeft,
            children: [
              Form(
                key: _formKey,
                child: CustomTextFormField(
                    key: deckNameTextFieldKey,
                    controller: deckNameController,
                    maxLength: deckNameMaxLength,
                    hintText: 'deck name',
                    validator: deckNameValidator),
              ),
            ],
          ),
          CustomColorPicker(
            initialPickerColor: pickerColor,
            onColorChanged: (final color) => pickerColor = color,
            label: 'Color',
          ),
          const SizedBox(height: 8),
          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CancelButton(onPressed: () => Navigator.pop(context)),
              OkButton(onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  context.read<DeckOverviewBloc>().add(AddDeck(
                      deck: Deck(
                          name: deckNameController.text, color: pickerColor)));
                  Navigator.pop(context);
                }
              }),
            ],
          ),
        ],
      ),
    );
  }
}
