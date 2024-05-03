// Dart imports
// Local imports
import 'package:aidex/bloc/learning_function_bloc.dart';
import 'package:aidex/data/model/deck.dart';
import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/data/repo/index_card_repository.dart';
import 'package:aidex/ui/components/rich_text_editor_widget.dart';
// Package imports
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A stateless widget that represents the learning function of the application
class LearningFunction extends StatelessWidget {
  // Declare the repository

  /// Creates a new instance of LearningFunction.
  ///
  /// Requires [key], [cards], [deck], and [indexCardRepository] to be non-null
  LearningFunction({
    required final Key key,
    required this.cards,
    required this.deck, // Add the deck to the constructor
    required this.indexCardRepository, // Add the repository to the constructor
  }) : super(key: key);

  /// A list of index cards.
  final List<IndexCard> cards;

  /// A deck of index cards.
  final Deck deck; // Declare the deck

  /// The current index of the card being viewed.
  final ValueNotifier<int> currentIndex = ValueNotifier<int>(0);

  /// A global key to control the state of the flip card.
  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  /// The repository for index cards.
  final IndexCardRepository indexCardRepository;

  @override
  Widget build(final BuildContext context) => BlocProvider(
        create: (final context) => LearningFunctionBloc(
          indexCardRepository,
          deck.deckId!,
        ),
        child: BlocConsumer<LearningFunctionBloc, LearningFunctionState>(
          listener: (final context, final state) {
            if (state is IndexCardLoaded) {
              currentIndex.value = state.currentIndex;
            }
          },
          builder: (final context, final state) {
            if (state is IndexCardLoading) {
              return const CircularProgressIndicator();
            } else if (state is IndexCardLoaded) {
              return Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: const Opacity(
                      opacity: 0.5, child: Text('Learning Function')),
                ),
                body: Stack(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => cardKey.currentState?.toggleCard(),
                    ),
                    Center(
                      child: ValueListenableBuilder<int>(
                        valueListenable: currentIndex,
                        builder: (final context, final value, final child) =>
                            cards.isEmpty
                                ? const Text('No cards available')
                                : Padding(
                                    padding: const EdgeInsets.only(bottom: 90),
                                    child: FlipCard(
                                      key: ValueKey(value),
                                      fill: Fill.fillFront,
                                      front: Card(
                                          color: const Color(0xFF414141),
                                          child: Align(
                                            child: Text(cards[value].question,
                                                style: const TextStyle(
                                                    fontSize: 36)),
                                          )),
                                      back: Card(
                                          color: const Color(0xFF414141),
                                          child: AbsorbPointer(
                                              child: RichTextEditorWidget(
                                            readonly: true,
                                            controller:
                                                RichTextEditorController(
                                                    contentJson:
                                                        cards[value].answer),
                                          ))),
                                    ),
                                  ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      right: 10,
                      child: Container(
                        color: Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: currentIndex.value > 0
                                        ? const Color(0xFF20EFC0)
                                        : Colors.grey,
                                    width: 2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: currentIndex.value > 0
                                      ? const Color(0xFF20EFC0)
                                      : Colors.grey,
                                  backgroundColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 15),
                                  textStyle: const TextStyle(fontSize: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: currentIndex.value > 0
                                    ? () {
                                        BlocProvider.of<LearningFunctionBloc>(
                                                context)
                                            .add(
                                                const PreviousIndexCardEvent());
                                        if (cardKey.currentState?.isFront ==
                                            false) {
                                          cardKey.currentState?.toggleCard();
                                        }
                                      }
                                    : null,
                                child: const Text('Back'),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: currentIndex.value < cards.length - 1
                                        ? const Color(0xFF20EFC0)
                                        : Colors.grey,
                                    width: 2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor:
                                      currentIndex.value < cards.length - 1
                                          ? const Color(0xFF20EFC0)
                                          : Colors.grey,
                                  backgroundColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 15),
                                  textStyle: const TextStyle(fontSize: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: currentIndex.value < cards.length - 1
                                    ? () {
                                        BlocProvider.of<LearningFunctionBloc>(
                                                context)
                                            .add(const NextIndexCardEvent());
                                        if (cardKey.currentState?.isFront ==
                                            false) {
                                          cardKey.currentState?.toggleCard();
                                        }
                                      }
                                    : null,
                                child: const Text('Next'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Container(); // Return an empty container for unhandled
              // states
            }
          },
        ),
      );
}
