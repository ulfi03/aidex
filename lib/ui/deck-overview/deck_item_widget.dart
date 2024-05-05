import 'package:aidex/bloc/deck_overview_bloc.dart';
import 'package:aidex/data/model/deck.dart';
import 'package:aidex/ui/components/custom_buttons.dart';
import 'package:aidex/ui/components/custom_color_picker.dart';
import 'package:aidex/ui/components/custom_text_form_field.dart';
import 'package:aidex/ui/components/icons.dart';
import 'package:aidex/ui/deck-overview/deck_delete_dialog.dart';
import 'package:aidex/ui/deck-overview/deck_validators.dart';
import 'package:aidex/ui/routes.dart';
import 'package:aidex/ui/theme/aidex_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A widget that represents a deck item.
class DeckItemWidget extends StatefulWidget {
  /// Creates a deck item widget.
  DeckItemWidget({
    required this.deck,
  }) : super(key: deckItemWidgetKey(deck.deckId!));

  /// A key used to identify the deck name widget in tests.
  static const deckNameKey = Key('deck_name');

  /// A key used to identify the cards count widget in tests.
  static const cardsCountKey = Key('cards_count');

  /// A key used to identify the color indicator widget in tests.
  static const colorIndicatorKey = Key('color_indicator');

  /// A key used to identify the deck options widget in tests.
  static const deckOptionsKey = Key('deck_options');

  /// A key used to identify the delete deck menu entry widget in tests.
  static const deleteDeckMenuEntryKey = Key('delete_deck_menu_entry');

  /// A key used to identify the rename deck menu entry widget in tests.
  static const renameDeckMenuEntryKey = Key('rename_deck_menu_entry');

  /// A key used to identify the change color deck menu entry widget in tests.
  static const changeColorDeckMenuEntryKey =
      Key('change_color_deck_menu_entry');

  /// A key used to identify the change deck name widget in tests.
  static const changeDeckNameTextFieldKey = Key('change_deck_name');

  /// Returns the key of a deck item widget.
  static Key deckItemWidgetKey(final int deckId) =>
      Key('DeckItemWidgetKey$deckId');

  /// The deck to display.
  final Deck deck;

  @override
  State<StatefulWidget> createState() => _DeckItemWidgetState();
}

/// A widget that represents a deck item.
class _DeckItemWidgetState extends State<DeckItemWidget> {
  /// The size of the icon.
  static const iconSize = 30.0;

  @override
  Widget build(final BuildContext context) => GestureDetector(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (final context) =>
                  ItemOnDeckOverviewSelectedRoute(deck: widget.deck),
            ),
          ).then((final value) =>
              context.read<DeckOverviewBloc>().add(const FetchDecks()));
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: mainTheme.colorScheme.onSurfaceVariant,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
              key: DeckItemWidget.colorIndicatorKey,
              decoration: BoxDecoration(
                color: mainTheme.colorScheme.background,
                border: Border(
                  left: BorderSide(
                    color: widget.deck.color,
                    width: 10,
                  ),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular((iconSize * 1.25) / 2),
                            color: mainTheme.colorScheme.surface,
                          ),
                          width: iconSize * 1.25,
                          height: iconSize * 1.25),
                      const AIDexLogo(width: iconSize, height: iconSize),
                    ],
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.deck.name,
                        key: DeckItemWidget.deckNameKey,
                        textAlign: TextAlign.center,
                        style: mainTheme.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            color:
                                mainTheme.colorScheme.surface.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8)),
                        child: RichText(
                          key: DeckItemWidget.cardsCountKey,
                          text: TextSpan(children: [
                            TextSpan(
                              text: '${widget.deck.cardsCount}',
                              style: mainTheme.textTheme.bodySmall?.copyWith(
                                  color: mainTheme.colorScheme.primary,
                                  fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                                text: ' cards',
                                style: mainTheme.textTheme.bodySmall)
                          ]),
                        ),
                      ),
                    ],
                  )),
                  PopupMenuButton<String>(
                    key: DeckItemWidget.deckOptionsKey,
                    padding: EdgeInsets.zero,
                    onSelected: (final value) async {
                      final DeckOverviewBloc deckOverviewBloc =
                          context.read<DeckOverviewBloc>();
                      switch (value) {
                        case 'delete':
                          await showDialog(
                              context: context,
                              builder: (final context) => BlocProvider.value(
                                  value: deckOverviewBloc,
                                  child: DeleteDeckDialog(deck: widget.deck)));
                        case 'rename':
                          _renameDeck(context, widget.deck, deckOverviewBloc);
                        case 'changeColor':
                          _changeDeckColor(
                              context, widget.deck, deckOverviewBloc);
                      }
                    },
                    icon: Icon(
                      Icons.more_vert,
                      color: mainTheme.colorScheme.onSurface,
                    ),
                    itemBuilder: (final context) => <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        key: DeckItemWidget.deleteDeckMenuEntryKey,
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
                        key: DeckItemWidget.renameDeckMenuEntryKey,
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
                      // popupmenu item for changing the color of a deck
                      PopupMenuItem<String>(
                        key: DeckItemWidget.changeColorDeckMenuEntryKey,
                        value: 'changeColor',
                        child: ListTile(
                          leading: Icon(
                            Icons.color_lens,
                            color: mainTheme.colorScheme.primary,
                          ),
                          title: Text(
                            'Change Color',
                            style: mainTheme.textTheme.titleSmall,
                          ),
                        ),
                      ),
                    ],
                    color: mainTheme.colorScheme.background,
                  ),
                ],
              )),
        ),
      );

  void _renameDeck(final BuildContext context, final Deck deck,
      final DeckOverviewBloc deckOverviewBloc) {
    final TextEditingController textController =
        TextEditingController(text: deck.name);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (final context) => AlertDialog(
        title: Text('Rename Deck', style: mainTheme.textTheme.titleMedium),
        content: Form(
          key: formKey,
          child: CustomTextFormField(
            key: DeckItemWidget.changeDeckNameTextFieldKey,
            controller: textController,
            maxLength: 21,
            hintText: 'New name',
            validator: deckNameValidator,
          ),
        ),
        actions: <Widget>[
          CancelButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          OkButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final newName = textController.text;
                deckOverviewBloc.add(RenameDeck(deck: deck, newName: newName));
                setState(() => deck.name = newName);
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  // Method for changing the color of a deck
  void _changeDeckColor(final BuildContext context, final Deck deck,
      final DeckOverviewBloc deckOverviewBloc) {
    showDialog(
      context: context,
      builder: (final context) {
        Color selectedColor = deck.color;
        return StatefulBuilder(
          builder: (final context, final setColorPickerState) => AlertDialog(
            title: Text('Change Deck Color',
                style: mainTheme.textTheme.titleMedium),
            content: CustomColorPicker(
              initialPickerColor: deck.color == const Color(0x00000000)
                  ? mainTheme.colorScheme.surface
                  : deck.color,
              onColorChanged: (final color) {
                setColorPickerState(() => selectedColor = color);
              },
              label: 'Color',
            ),
            actions: <Widget>[
              CancelButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              OkButton(
                onPressed: () {
                  deckOverviewBloc
                      .add(ChangeDeckColor(deck: deck, color: selectedColor));
                  setState(() => deck.color = selectedColor);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
