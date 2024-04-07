import 'package:aidex/data/provider/deck_provider.dart';
import 'package:aidex/data/provider/index_card_provider.dart';
import 'package:aidex/data/repo/deck_repository.dart';
import 'package:aidex/data/repo/index_card_repository.dart';
import 'package:aidex/ui/deck-overview/deck_overview_widget.dart';
import 'package:aidex/ui/theme/aidex_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    runApp(AIDexApp(
        deckRepository: DeckRepository(deckProvider: await DeckProvider.init()),
        indexCardRepository: IndexCardRepository(
            indexCardProvider: await IndexCardProvider.init())));
  } on Exception catch (e) {
    print(e);
  }
}

/// The main application widget.
///
/// This widget is the root of the application.
class AIDexApp extends StatelessWidget {
  /// Constructor for the main application widget.
  const AIDexApp(
      {required final DeckRepository deckRepository,
      required final IndexCardRepository indexCardRepository,
      super.key})
      : _deckRepository = deckRepository,
        _indexCardRepository = indexCardRepository;

  final DeckRepository _deckRepository;
  final IndexCardRepository _indexCardRepository;

  /// The key for the QuillEditorWidget.
  @override
  Widget build(final BuildContext context) => MultiRepositoryProvider(
          providers: [
            RepositoryProvider<DeckRepository>.value(value: _deckRepository),
            RepositoryProvider<IndexCardRepository>.value(
                value: _indexCardRepository)
          ],
          child: MaterialApp(
            title: 'AIDex',
            theme: mainTheme,
            home: const DeckOverviewPage(),
          ));
}
