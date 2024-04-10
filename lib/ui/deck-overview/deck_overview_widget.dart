import 'package:aidex/bloc/deck_overview_bloc.dart';
import 'package:aidex/data/repo/deck_repository.dart';
import 'package:aidex/ui/components/error_display_widget.dart';
import 'package:aidex/ui/deck-overview/create_deck_dialog_on_ai.dart';
import 'package:aidex/ui/deck-overview/create_deck_dialog_on_manual.dart';
import 'package:aidex/ui/deck-overview/create_deck_snackbar_widget.dart';
import 'package:aidex/ui/deck-overview/deck_item_widget.dart';
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

  /// The key for the create deck snackbar.
  static const Key createDeckSnackbarKey = Key('CreateDeckSnackbarKey');

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
  Widget build(final BuildContext context) => GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              key: DeckOverviewPage.deckOverviewTitleKey,
              'All Decks',
              style: mainTheme.textTheme.titleLarge,
            ),
            backgroundColor: mainTheme.colorScheme.surface,
          ),
          backgroundColor: mainTheme.colorScheme.surface,
          body: BlocBuilder<DeckOverviewBloc, DeckState>(
            builder: (final context, final state) {
              if (state is DecksLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(mainTheme
                        .colorScheme.primary),
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
          floatingActionButton:
              const AddButton(key: DeckOverviewPage.addButtonKey),
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
        backgroundColor: mainTheme.colorScheme.primary,
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
            key: DeckOverviewPage.createDeckSnackbarKey,
            onManual: () async {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              await _showCreateDeckDialogOnManual(context);
            },
            onAI: () async {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              await _showCreateDeckDialogOnAI(context);
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
    builder: (final context) => MultiBlocProvider(
      providers: [
        BlocProvider.value(value: deckOverviewBloc),
      ],
      child: const CreateDeckDialogOnAI(),      
    ),
  );
}
