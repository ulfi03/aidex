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
class DeckItemWidget extends StatelessWidget {
  /// Creates a new deck item widget.
  const DeckItemWidget({
    required this.deck,
    super.key,
  });

  /// A key used to identify the deck name widget in tests.
  static const deckNameKey = Key('deck_name');

  /// A key used to identify the cards count widget in tests.
  static const cardsCountKey = Key('cards_count');

  /// The size of the icon.
  static const iconSize = 30.0;

  /// The deck to display.
  final Deck deck;

  @override
  Widget build(final BuildContext context) => GestureDetector(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (final context) =>
                  ItemOnDeckOverviewSelectedRoute(deck: deck),
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
              decoration: BoxDecoration(
                color: mainTheme.colorScheme.background,
                border: Border(
                  left: BorderSide(
                    color: deck.color,
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
                        deck.name,
                        key: deckNameKey,
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
                          key: cardsCountKey,
                          text: TextSpan(children: [
                            TextSpan(
                              text: '${deck.cardsCount}',
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
                                  child: DeleteDeckDialog(deck: deck)));
                        case 'rename':
                          _renameDeck(context, deck, deckOverviewBloc);
                        case 'changeColor':
                          _changeDeckColor(context, deck, deckOverviewBloc);
                      }
                    },
                    icon: Icon(
                      Icons.more_vert,
                      color: mainTheme.colorScheme.onSurface,
                    ),
                    itemBuilder: (final context) => <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
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
      builder: (final context) => StatefulBuilder(
        builder: (final context, final setState) => AlertDialog(
          title: Text('Rename Deck', style: mainTheme.textTheme.titleMedium),
          content: Form(
            key: formKey,
            child: CustomTextFormField(
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
                  deckOverviewBloc
                      .add(RenameDeck(deck: deck, newName: newName));
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Method for changing the color of a deck
  void _changeDeckColor(final BuildContext context, final Deck deck,
      final DeckOverviewBloc deckOverviewBloc) {
    showDialog(
      context: context,
      builder: (final context) => StatefulBuilder(
        builder: (final context, final setState) => AlertDialog(
          title:
              Text('Change Deck Color', style: mainTheme.textTheme.titleMedium),
          content: CustomColorPicker(
            initialPickerColor: deck.color,
            onColorChanged: (final color) {
              setState(() => deck.color = color);
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
                    .add(ChangeDeckColor(deck: deck, color: deck.color));
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
