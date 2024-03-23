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

  @override
  Widget build(final BuildContext context) => BlocProvider(
      create: (final context) =>
          DeckOverviewBloc(context.read<DeckRepository>()),
      child: const _DeckOverview());
}

class _DeckOverview extends StatelessWidget {
  const _DeckOverview();

  @override
  Widget build(final BuildContext context) => BlocProvider(
        create: (final context) =>
            DeckOverviewBloc(context.read<DeckRepository>()),
        child: _getDeckOverview(context),
      );
}

Widget _getDeckOverview(final BuildContext context) {
  var isAddButtonVisible = true;
  return GestureDetector(
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
      body: BlocBuilder<DeckOverviewBloc, DeckState>(
        builder: (final context, final state) {
          if (state is DecksLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF20EFC0)),
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
            // show error with error icon
            return ErrorDisplayWidget(errorMessage: state.message);
          } else {
            return const ErrorDisplayWidget(
                errorMessage: 'Something went wrong!');
          }
        },
      ),
      floatingActionButton: StatefulBuilder(
        builder: (final context, final setState) => Visibility(
            visible: isAddButtonVisible,
            child: FloatingActionButton(
              onPressed: () async {
                setState(() {
                  isAddButtonVisible = false;
                });
                await ScaffoldMessenger.of(context)
                    .showSnackBar(
                      SnackBar(
                        backgroundColor: const Color(0xFF414141),
                        content: CreateDeckSnackbarWidget(
                          onManual: () async {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            await _showCreateDeckDialog(context);
                          },
                          onAI: () async {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
                            isAddButtonVisible = true;
                          })
                        });
              },
              backgroundColor: const Color(0xFF20EFC0),
              child: const Icon(Icons.add),
            )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
    ),
  );
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
