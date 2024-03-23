import 'package:aidex/bloc/deck_overview_bloc.dart';
import 'package:aidex/data/repo/deck_repository.dart';
import 'package:aidex/ui/components/error_display_widget.dart';
import 'package:aidex/ui/deck-overview/create_deck_dialog.dart';
import 'package:aidex/ui/deck-overview/create_deck_snackbar_widget.dart';
import 'package:aidex/ui/deck-overview/deck_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This widget is used to display the deck overview.
class DeckOverviewPage extends StatelessWidget {
  /// Constructor for the [DeckOverviewPage].
  const DeckOverviewPage({super.key});

  /// The key for the deckOverviewWidget title.
  static const Key deckOverviewTitleKey = Key('DeckOverviewTitleKey');

  @override
  Widget build(final BuildContext context) => BlocProvider(
      create: (final context) =>
          DeckOverviewBloc(context.read<DeckRepository>()),
      child: const DeckOverview());
}

/// This widget is used to display the deck overview.
class DeckOverview extends StatelessWidget {
  /// Constructor for the [DeckOverview].
  const DeckOverview({super.key});

  @override
  Widget build(final BuildContext context) => BlocProvider(
        create: (final context) =>
            DeckOverviewBloc(context.read<DeckRepository>()),
        child: _getDeckOverview(context),
      );

  Widget _getDeckOverview(final BuildContext context) => GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              key: DeckOverviewPage.deckOverviewTitleKey,
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
          body: BlocBuilder<DeckOverviewBloc, DeckState>(
            builder: (final context, final state) {
              if (state is DecksLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF20EFC0)),
                  ),
                );
              } else if (state is DecksLoaded) {
                return SingleChildScrollView(
                  child: Wrap(
                    children: state.decks
                        .map((final deck) => DeckItemWidget(deck: deck))
                        .toList(),
                  ),
                );
              } else if (state is DecksError) {
                return ErrorDisplayWidget(errorMessage: state.message);
              } else {
                return const ErrorDisplayWidget(
                    errorMessage: 'Something went wrong!');
              }
            },
          ),
          floatingActionButton: const AddButton(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniEndFloat,
        ),
      );
}

/// This widget is used to display the add button.
class AddButton extends StatefulWidget {
  ///
  const AddButton({super.key});

  @override
  AddButtonState createState() => AddButtonState();
}

/// The state of the add button.
class AddButtonState extends State<AddButton> {
  bool _isAddButtonVisible = true;

  @override
  Widget build(final BuildContext context) => Visibility(
      visible: _isAddButtonVisible,
      child: FloatingActionButton(
        onPressed: () => onAddButtonPressed(context),
        backgroundColor: const Color(0xFF20EFC0),
        child: const Icon(Icons.add),
      ));

  /// Handles the add button pressed event.
  Future<void> onAddButtonPressed(final BuildContext context) async {
    setState(() {
      _isAddButtonVisible = false;
    });
    await ScaffoldMessenger.of(context)
        .showSnackBar(
          CreateDeckSnackbar(
            onManual: () async {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              await _showCreateDeckDialog(context);
            },
            onAI: () async {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              context.read<DeckOverviewBloc>().add(const RemoveAllDecks());
              // Handle AI deck creation here
            },
          ),
        )
        .closed
        .then((final value) => {
              ScaffoldMessenger.of(context).clearSnackBars(),
              setState(() {
                _isAddButtonVisible = true;
              })
            });
  }
}

Future<void> _showCreateDeckDialog(final BuildContext context) async {
  final deckOverviewBloc = context.read<DeckOverviewBloc>();
  await showDialog(
    context: context,
    builder: (final context) => BlocProvider.value(
      value: deckOverviewBloc,
      child: const CreateDeckDialog(),
    ),
  );
}
