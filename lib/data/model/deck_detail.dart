import 'package:aidex/data/model/deck.dart';
import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/data/model/learning_function.dart';
import 'package:aidex/data/provider/index_card_provider.dart';
import 'package:aidex/data/repo/index_card_repository.dart';
import 'package:flutter/material.dart';

class DeckDetail extends StatefulWidget {
  final Deck deck;
  final IndexCardProvider indexCardProvider;

  DeckDetail({Key? key, required this.deck, required this.indexCardProvider})
      : super(key: key);

  @override
  _DeckDetailState createState() => _DeckDetailState();
}

class _DeckDetailState extends State<DeckDetail> {
  late Future<List<IndexCard>> _cardsFuture;
  late IndexCardRepository _indexCardRepository;

  @override
  void initState() {
    super.initState();
    _indexCardRepository =
        IndexCardRepository(indexCardProvider: widget.indexCardProvider);
    _cardsFuture = _indexCardRepository.fetchIndexCards(widget.deck.deckId!);
  }

  @override
  Widget build(final BuildContext context) => FutureBuilder<List<IndexCard>>(
        future: _cardsFuture,
        builder: (final context, final snapshot) {
          if (snapshot.hasData) {
            return ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (final context) => LearningFunction(
                      key: const Key('cards'),
                      cards: snapshot.data!,
                      deck: widget.deck,
                    ),
                  ),
                );
              },
              child: const Text('Start Learning'),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        },
      );
}
