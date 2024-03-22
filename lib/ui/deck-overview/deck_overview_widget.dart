import 'package:aidex/bloc/DeckOverviewBloc.dart';
import 'package:aidex/data/repo/deck_repository.dart';
import 'package:aidex/model/deck.dart';
import 'package:aidex/ui/deck-overview/create_deck_snackbar_widget.dart';
import 'package:aidex/ui/deck-overview/deck_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

/// This widget is used to display the deck overview.
class DeckOverviewPage extends StatelessWidget {
  /// Constructor for the [DeckOverviewPage].
  const DeckOverviewPage({super.key});

  @override
  Widget build(final BuildContext context) => BlocProvider(
      create: (final context) =>
          DeckOverviewBloc(context.read<DeckRepository>()),
      child: const _DeckOverview());
}

class _DeckOverview extends StatefulWidget {
  const _DeckOverview();

  @override
  _DeckOverviewState createState() => _DeckOverviewState();
}

class _DeckOverviewState extends State<_DeckOverview> {
  bool _isAddButtonVisible = true;

  Future<void> showCreateDeckDialog(final BuildContext context) async {
    //final deckOverviewBloc = BlocProvider.of<DeckOverviewBloc>(context);
    final deckOverviewBloc = context.read<DeckOverviewBloc>();
    await showDialog(
      context: context,
      builder: (final context) {
        var pickerColor = const Color(0xFF121212); // Initial color
        final deckNameController = TextEditingController();

        final dialog = AlertDialog(
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
                    controller: deckNameController,
                    maxLength: 21,
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
                      errorText: deckNameController.text.isEmpty
                          ? 'Please enter a deck name'
                          : null,
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFF20EFC0),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    bottom: 27,
                    child: Text(
                      '${deckNameController.text.length}/21',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
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
                      deckOverviewBloc.add(AddDeck(
                          deck: Deck(
                              name: deckNameController.text,
                              color: pickerColor)));
                      Navigator.of(context).pop();
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

        return dialog;
      },
    );
  }

  /// Get the deck overview widget.
  Widget getDeckOverview(final BuildContext context) => GestureDetector(
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
              child: BlocBuilder<DeckOverviewBloc, DeckState>(
            builder: (final context, final state) {
              if (state is DecksLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF20EFC0)),
                  ),
                );
              } else if (state is DecksLoaded) {
                print('decks loaded in widget');
                return Column(
                  children: state.decks
                      .map((final deck) => DeckItemWidget(deck: deck))
                      .toList(),
                );
              } else if (state is DecksError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: Text(
                    'Something went wrong!',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              }
            },
          )),
          floatingActionButton: Visibility(
              visible: _isAddButtonVisible,
              child: FloatingActionButton(
                onPressed: () async {
                  setState(() {
                    _isAddButtonVisible = false;
                  });
                  await ScaffoldMessenger.of(context)
                      .showSnackBar(
                        SnackBar(
                          backgroundColor: const Color(0xFF414141),
                          content: CreateDeckSnackbarWidget(
                            onManual: () {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              showCreateDeckDialog(context);
                            },
                            onAI: () async {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              context
                                  .read<DeckOverviewBloc>()
                                  .add(const RemoveAllDecks());
                              // Handle AI deck creation here
                            },
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          duration: const Duration(days: 365),
                        ),
                      )
                      .closed
                      .then((final value) => {
                            ScaffoldMessenger.of(context).clearSnackBars(),
                            setState(() {
                              _isAddButtonVisible = true;
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

  @override
  Widget build(final BuildContext context) => BlocProvider(
        create: (final context) =>
            DeckOverviewBloc(context.read<DeckRepository>()),
        child: getDeckOverview(context),
      );
}
