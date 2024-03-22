import 'package:aidex/data/provider/deck_provider.dart';
import 'package:aidex/data/repo/deck_repository.dart';
import 'package:aidex/ui/deck-overview/deck_overview_widget.dart';
import 'package:aidex/ui/theme/aidex_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(AIDexApp(
      deckRepository:
          DeckRepository(deckProvider: await DeckProvider.init())));
}

/// The main application widget.
///
/// This widget is the root of the application.
class AIDexApp extends StatelessWidget {
  /// Constructor for the main application widget.
  const AIDexApp({required final DeckRepository deckRepository, super.key})
      : _deckRepository = deckRepository;

  final DeckRepository _deckRepository;

  /// The key for the QuillEditorWidget.
  @override
  Widget build(final BuildContext context) => RepositoryProvider.value(
      value: _deckRepository,
      child: MaterialApp(
        title: 'AIDex',
        theme: mainTheme,
        home: const DeckOverviewPage(),
      ));
}
