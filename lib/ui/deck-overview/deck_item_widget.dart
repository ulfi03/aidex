import 'package:aidex/bloc/deck_overview_bloc.dart';
import 'package:aidex/data/model/deck.dart';
import 'package:aidex/ui/components/custom_buttons.dart';
import 'package:aidex/ui/components/custom_text_form_field.dart';
import 'package:aidex/ui/components/icons.dart';
import 'package:aidex/ui/deck-overview/deck_validators.dart';
import 'package:aidex/ui/deck-overview/delete_deck_dialog.dart';
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

  /// The deck to display.
  final Deck deck;

  @override
  Widget build(final BuildContext context) {
    final iconSize = MediaQuery.of(context).size.width / 12;
    return GestureDetector(
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
            color: deck.color,
            border: Border.all(
              color: mainTheme.colorScheme.onBackground,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            margin: const EdgeInsets.all(8),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: mainTheme.colorScheme.surface,
                        ),
                        width: iconSize * 1.25,
                        height: iconSize * 1.25),
                    aiDexLogo,
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
                          ?.copyWith(color: mainTheme.colorScheme.onBackground),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: '${deck.cardsCount}',
                          style: mainTheme.textTheme.bodySmall
                              ?.copyWith(color: mainTheme.colorScheme.primary),
                        ),
                        TextSpan(
                          text: ' cards',
                          style: mainTheme.textTheme.bodySmall?.copyWith(
                              color: mainTheme.colorScheme.onBackground),
                        ),
                      ]),
                    ),
                  ],
                )),
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  onSelected: (final value) async {
                    final DeckOverviewBloc deckOverviewBloc =
                        context.read<DeckOverviewBloc>();
                    if (value == 'delete') {
                      await showDialog(
                          context: context,
                          builder: (final context) => BlocProvider.value(
                              value: deckOverviewBloc,
                              child: DeleteDeckDialog(deck: deck)));
                    } else if (value == 'rename') {
                      _renameDeck(context, deck, deckOverviewBloc);
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
                  ],
                  color: mainTheme.colorScheme.background,
                ),
              ],
            ),
          )),
    );
  }

  void _renameDeck(final BuildContext context, final Deck deck,
      final DeckOverviewBloc deckOverviewBloc) {
    final TextEditingController textController =
        TextEditingController(text: deck.name);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (final context) => StatefulBuilder(
        builder: (final context, final setState) => AlertDialog(
          title: const Text('Rename Deck'),
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
}
