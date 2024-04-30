import 'package:aidex/bloc/deck_overview_bloc.dart';
import 'package:aidex/data/repo/deck_repository.dart';
import 'package:aidex/ui/components/error_display_widget.dart';
import 'package:aidex/ui/deck-overview/create_deck_dialog_on_ai.dart';
import 'package:aidex/ui/deck-overview/create_deck_dialog_on_manual.dart';
import 'package:aidex/ui/deck-overview/create_deck_modal_bottom_sheet.dart';
import 'package:aidex/ui/deck-overview/deck_item_widget.dart';
import 'package:aidex/ui/deck-overview/delete_all_decks_dialog.dart';
import 'package:aidex/ui/theme/aidex_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This widget is used to display the deck overview.
class DeckOverviewPage extends StatelessWidget {
  /// Constructor for the [DeckOverviewPage].
  const DeckOverviewPage({super.key});

  /// The key for the deckOverviewWidget title.
  static const Key deckOverviewTitleKey = Key('DeckOverviewTitleKey');

  /// The key for the add button.
  static const Key addButtonKey = Key('AddButtonKey');

  /// The key for the createDeckModalBottomSheet.
  static const Key createDeckModalBottomSheetKey =
      Key('CreateDeckModalBottomSheetKey');

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
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'All Decks',
            style: mainTheme.textTheme.titleLarge,
          ),
          backgroundColor: mainTheme.colorScheme.surface,
          actions: [
            IconButton(
              icon: Icon(Icons.delete_sweep,
              color: mainTheme.colorScheme.primary),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (final context) => const DeleteAllDecksDialog(),
                );
              },
            ),
          ],
        ),
        backgroundColor: mainTheme.colorScheme.surface,
        body: BlocBuilder<DeckOverviewBloc, DeckState>(
          builder: (final context, final state) {
            if (state is DecksLoading) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      mainTheme.colorScheme.primary),
                ),
              );
            } else if (state is DecksLoaded) {
              if (state.decks.isEmpty) {
                return Center(
                    child: Text(
                  'No decks found, create one!',
                  style: mainTheme.textTheme.bodyMedium,
                ));
              } else {
                return SingleChildScrollView(
                    padding: EdgeInsets.only(
                        bottom: mainTheme.floatingActionButtonTheme
                                .sizeConstraints!.maxHeight *
                            2),
                    child: Column(
                      children: state.decks
                          .map((final deck) => Padding(
                              padding: const EdgeInsets.all(5),
                              child: DeckItemWidget(deck: deck)))
                          .toList(),
                    ));
              }
            } else if (state is DecksError) {
              return ErrorDisplayWidget(errorMessage: state.message);
            } else {
              return const ErrorDisplayWidget(
                  errorMessage: 'Something went wrong!');
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          key: DeckOverviewPage.addButtonKey,
          onPressed: () => onAddButtonPressed(context),
          backgroundColor: mainTheme.colorScheme.primary,
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      );
}

/// Handles the add button pressed event.
Future<void> onAddButtonPressed(final BuildContext deckOverviewContext) async {
  await showModalBottomSheet(
      context: deckOverviewContext,
      backgroundColor: mainTheme.colorScheme.background,
      builder: (final context) => CreateDeckModalBottomSheet(
            key: DeckOverviewPage.createDeckModalBottomSheetKey,
            onManual: () async {
              Navigator.pop(context);
              await _showCreateDeckDialogOnManual(deckOverviewContext);
            },
            onAI: () async {
               Navigator.pop(context);
              await _showCreateDeckDialogOnAI(deckOverviewContext);
            },
          ));
}

Future<void> _showCreateDeckDialogOnManual(final BuildContext context) async {
  final deckOverviewBloc = context.read<DeckOverviewBloc>();
  await showDialog(
    context: context,
    builder: (final context) => BlocProvider.value(
      value: deckOverviewBloc,
      child: const CreateDeckDialogOnManual(),      
    ),
  );
}
Future<void> _showCreateDeckDialogOnAI(final BuildContext context) async {
  final deckOverviewBloc = context.read<DeckOverviewBloc>();
  await showDialog(
    context: context,
    builder: (final context) => BlocProvider.value(
      value: deckOverviewBloc,
      child: const CreateDeckDialogOnAI(),      
    ),
  );
}